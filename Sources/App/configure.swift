import FluentPostgreSQL
import Vapor
import Leaf
import Authentication
import LeafErrorMiddleware
import SteampressFluentPostgres
import VaporSecurityHeaders
import LeafMarkdown

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())
    try services.register(LeafProvider())
    try services.register(AuthenticationProvider())
    let feedInformation = FeedInformation(title: "The SteamPress Blog", description: "SteamPress is an open-source blogging engine written for Vapor in Swift", copyright: "Released under the MIT licence", imageURL: "https://user-images.githubusercontent.com/9938337/29742058-ed41dcc0-8a6f-11e7-9cfc-680501cdfb97.png")
    try services.register(SteamPressFluentPostgresProvider(blogPath: "blog", feedInformation: feedInformation, postsPerPage: 5))
    
    services.register { worker in
        return LeafErrorMiddleware(environment: worker.environment)
    }
    
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    let disqusName = Environment.get("BLOG_DISQUS_NAME") ?? "*"
    
    var cspBuilder = ContentSecurityPolicy()
        .defaultSrc(sources: CSPKeywords.none)
        .scriptSrc(sources: CSPKeywords.`self`, "https://www.google-analytics.com/", "https://static.brokenhands.io", "https://cdn.jsdelivr.net/", "https://connect.facebook.net/", "https://publish.twitter.com", "cdn.syndication.twimg.com", "platform.twitter.com", "https://platform.linkedin.com", "https://ajax.googleapis.com/", "https://code.jquery.com/", "https://cdnjs.cloudflare.com/", "https://stackpath.bootstrapcdn.com", "https://\(disqusName).disqus.com/", "https://*.disquscdn.com/", "https://disqus.com/")
        .styleSrc(sources: CSPKeywords.`self`, "https://use.fontawesome.com", "https://cdn.jsdelivr.net/", "*.twimg.com", "platform.twitter.com", "https://stackpath.bootstrapcdn.com/", "https://*.disquscdn.com/", "https://cdnjs.cloudflare.com/ajax/libs/select2/ https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css")
        .imgSrc(sources: CSPKeywords.`self`, "data:", "https://static.brokenhands.io", "https://www.facebook.com", "cdn.syndication.twimg.com", "syndication.twitter.com", "*.twimg.com", "platform.twitter.com", "https://referrer.disqus.com/", "https://*.disquscdn.com/", "https://www.google-analytics.com/")
        .connectSrc(sources: CSPKeywords.`self`, "https://links.services.disqus.com/")
        .fontSrc(sources: "https://maxcdn.bootstrapcdn.com/", "https://use.fontawesome.com/")
        .set(value: "child-src https://disqus.com/ syndication.twitter.com platform.twitter.com www.facebook.com staticxx.facebook.com; manifest-src 'self'")
        .formAction(sources: CSPKeywords.`self`)
        .baseUri(sources: CSPKeywords.`self`)
        .requireSriFor(values: "script style")
    
    if env == .production || env == .testing {
        cspBuilder = cspBuilder.upgradeInsecureRequests().blockAllMixedContent()
    }
    
    if let reportURI = Environment.get("CSP_REPORT_URI") {
        cspBuilder = cspBuilder.reportUri(uri: reportURI)
    }
    
    let referrerPolicy = ReferrerPolicyConfiguration(.strictOriginWhenCrossOrigin)
    
    let securityHeadersFactory = SecurityHeadersFactory()
        .with(server: ServerConfiguration(value: "brokenhands.io"))
        .with(contentSecurityPolicy: ContentSecurityPolicyConfiguration(value: cspBuilder))
        .with(referrerPolicy: referrerPolicy)
    services.register(securityHeadersFactory.build())
    
    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(SecurityHeaders.self)
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(LeafErrorMiddleware.self)
    middlewares.use(BlogRememberMeMiddleware.self)
    middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)
    
    // Limit the DB connections for Heroku
    services.register(DatabaseConnectionPoolConfig(maxConnections: 2))
    
    // Configure a database
    var databases = DatabasesConfig()
    let databaseConfig: PostgreSQLDatabaseConfig
    if let url = Environment.get("DATABASE_URL") {
        databaseConfig = PostgreSQLDatabaseConfig(url: url, transport: .unverifiedTLS)!
    } else if let url = Environment.get("DB_POSTGRESQL") {
        databaseConfig = PostgreSQLDatabaseConfig(url: url)!
    } else {
        let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
        let username = Environment.get("DATABASE_USER") ?? "steampress"
        let password = Environment.get("DATABASE_PASSWORD") ?? "password"
        let databaseName: String
        let databasePort: Int
        if (env == .testing) {
            databaseName = "steampress-test"
            if let testPort = Environment.get("DATABASE_PORT") {
                databasePort = Int(testPort) ?? 5433
            } else {
                databasePort = 5433
            }
        } else {
            databaseName = Environment.get("DATABASE_DB") ?? "steampress"
            databasePort = 5432
        }
        
        databaseConfig = PostgreSQLDatabaseConfig(
            hostname: hostname,
            port: databasePort,
            username: username,
            database: databaseName,
            password: password)
    }
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: BlogTag.self, database: .psql)
    migrations.add(model: BlogUser.self, database: .psql)
    migrations.add(model: BlogPost.self, database: .psql)
    migrations.add(model: BlogPostTagPivot.self, database: .psql)
    migrations.add(migration: BlogAdminUser.self, database: .psql)
    services.register(migrations)
    
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
    config.prefer(BCryptDigest.self, for: PasswordVerifier.self)
    
    var tags = LeafTagConfig.default()
    tags.use(Markdown(), as: "markdown")
    let paginatorTag = PaginatorTag(paginationLabel: "Blog Posts")
    tags.use(paginatorTag, as: PaginatorTag.name)
    services.register(tags)
}
