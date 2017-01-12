# SteamPress Example

This is an example site for using [SteamPress](https://github.com/brokenhandsio/SteamPress) with your Vapor website. You can also just use it as your blog! This example site uses Bootstrap 4 for styling so should be fairly easy to make it look how you want. It also uses Markdown to render the blog posts, and has Syntax hightlighting for code (obviously!).

This site also provides a good example for all the Leaf files you will need, and the parameters they are given, as well as what you need to send to SteamPress to be create users and posts etc.

To try out:

```bash
git clone https://github.com/brokenhandsio/SteamPressExample.git
vapor build
vapor run serve
```

This will crete a site at http://localhost:8080. The blog can be found at http://localhost:8080/blog/ and you can login at http://localhost:8080/blog/admin/. The first time you visit the login a user will be created and the details printed to the console.

## WARNING

This site uses the in-memory database so you can get up and running quickly without having to configure a DB on your machine - obviously if you plan to use this site for your blog you should change to something more permanent so you don't lose all your posts when you restart the app!
