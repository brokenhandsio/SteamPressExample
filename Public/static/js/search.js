var term = $("#search-data").data("searchTerm");

if(term.length !== 0){
    var options = {
        "separateWordSearch": false,
        
    };
    $('.card-body').mark(term, options);
}
