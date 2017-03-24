$("#create-post-form").on('submit', function() {
    var title = $("#inputTitle").val();
    var contents = $("#inputPostContents").val();

    if (!title) {
        alert("Please enter a title");
        return false;
    }

    if (!contents) {
        alert("Please enter some contents");
        return false;
    }
    return true;
});


var editingPost = false;
var published = false;
var allowEditingOfSlugUrl = true;
var originalSlugUrl = "";
var originalTitle = "";

$(function() {
    var simplemde = new SimpleMDE({
        element: $("#inputPostContents")[0],
        spellChecker: false,
        forceSync: true,
        placeholder: "Write your blog post here",
        autosave: {
            enabled: true,
            uniqueId: "SteamPress-Create-Post",
            delay: 1000,
        },
        promptURLs: true,
    });
    // SimpleMDE has been initialised so we need to turn off validation for the
    // underlying text area
    $('#inputPostContents').removeAttr('required');
});

$('#inputTitle').on('input',function(e){
  if (allowEditingOfSlugUrl) {
    var title = $('#inputTitle').val();
    var slugUrl = slugify(title);
    $('#inputSlugUrl').val(slugUrl);
    if (editingPost && published) {
      if (title != originalTitle) {
        $('#blog-post-edit-title-warning').fadeIn();
      }
      else {
        $('#blog-post-edit-title-warning').fadeOut();
      }
    }
  }
});

$.ajax({
  url: "/blog/api/tags/",
  type: 'GET',
  contentType: 'application/json; charset=utf-8'
}).then(function (response) {
    var dataToReturn = [];
    for (var i=0; i < response.length; i++) {
        var tagToTransform = response[i];
        var newTag = {id: tagToTransform["name"], text: tagToTransform["name"]};
        dataToReturn.push(newTag);
    }
    $("#inputTags").select2({
    placeholder: "Select Tags for the Blog Post",
    tags: true,
    tokenSeparators: [','],
    data: dataToReturn
  });
});

$('#cancel-edit-button').click(function(){
    return confirm('Are you sure you want to cancel? You will lose any unsaved work');
});

$('#keep-original-slug-url-link').click(function(){
    keepPostOriginalSlugUrl();
});

$(function() {
  if ($("#edit-post-data").length) {
    editingPost = true;
    originalSlugUrl = $("#edit-post-data").data("originalSlugUrl");
    originalTitle = $("#edit-post-data").data("originalTitle");
    published = $("#edit-post-data").data("publishedPost");
  }
});

function slugify(text)
{
  return text.toString().toLowerCase()
    .replace(/\s+/g, '-')           // Replace spaces with -
    .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
    .replace(/\-\-+/g, '-')         // Replace multiple - with single -
    .replace(/^-+/, '')             // Trim - from start of text
    .replace(/-+$/, '');            // Trim - from end of text
}

function keepPostOriginalSlugUrl() {
  allowEditingOfSlugUrl = false;
  $('#inputSlugUrl').val(originalSlugUrl);
  $('#blog-post-edit-title-warning').alert('close')
}
