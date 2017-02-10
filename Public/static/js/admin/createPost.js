var editing = false
var originalSlugUrl = ""
var originalTitle = ""

$('#inputTitle').on('input',function(e){
  var title = $('#inputTitle').val()
  var slugUrl = slugify(title)
  $('#inputSlugUrl').val(slugUrl)
  if (editing) {
    if (title != originalTitle) {
      console.log("Slugs different")
      $('#blog-post-edit-title-warning').fadeIn()
    }
    else {
      $('#blog-post-edit-title-warning').fadeOut()
    }
  }
});

$(function() {
  if ($("#edit-post-data").length) {
    editing = true
    originalSlugUrl = $("#edit-post-data").data("originalSlugUrl")
    originalTitle = $("#edit-post-data").data("originalTitle")
    console.log("Original slug was " + originalSlugUrl)
    console.log("Original title was " + originalTitle)
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
