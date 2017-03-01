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

var data = [{ id: 'enhancement', text: 'enhancement' }, { id: 'bug', text: 'bug' }, { id: 'duplicate', text: 'duplicate' }, { id: 'invalid', text: 'invalid' }];

$(function() {
  $("#inputTags").select2({
    tags: true,
    tokenSeparators: [','],
    data: data,
    placeholder: "Select Tags for the Blog Post",
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
