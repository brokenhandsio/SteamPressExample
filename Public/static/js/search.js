var term = $("#search-data").data("searchTerm");

if(term.length !== 0){
    $('.blog-post').each(function(){
        var search_value = term;
        var search_regexp = new RegExp(search_value, "gi");
        $(this).html($(this).html().replace(search_regexp, "<span class = 'highlight'>" + term + "</span>"));
    });
}
