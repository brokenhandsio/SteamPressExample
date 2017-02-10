var editingPost = false;
var allowEditingOfSlugUrl = true;
var originalSlugUrl = "";
var originalTitle = "";

$('#inputTitle').on('input',function(e){
  if (allowEditingOfSlugUrl) {
    var title = $('#inputTitle').val();
    var slugUrl = slugify(title);
    $('#inputSlugUrl').val(slugUrl);
    if (editingPost) {
      if (title != originalTitle) {
        $('#blog-post-edit-title-warning').fadeIn();
      }
      else {
        $('#blog-post-edit-title-warning').fadeOut();
      }
    }
  }
});

$(function() {
  if ($("#edit-post-data").length) {
    editingPost = true;
    originalSlugUrl = $("#edit-post-data").data("originalSlugUrl");
    originalTitle = $("#edit-post-data").data("originalTitle");
    console.log("Original slug was " + originalSlugUrl);
    console.log("Original title was " + originalTitle);
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
  console.log("Will keep the original slug " + originalSlugUrl);
  allowEditingOfSlugUrl = false;
  $('#inputSlugUrl').val(originalSlugUrl);
  $('#blog-post-edit-title-warning').alert('close')
}
