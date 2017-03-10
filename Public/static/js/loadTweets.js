$(function () {
    $('a', $('.post-contents')).each(function () {
        var link = this;
        var url = $(link).attr('href');
        if (url.indexOf('https://twitter.com') === 0 && url.indexOf('status') > 0) {
            $.ajax({
                url: 'https://publish.twitter.com/oembed?url=' + url + '&align=center',
                crossDomain: true,
                dataType: 'jsonp'
            })
            .done(function (data) {
                $(link).after(data.html).remove();
            });
        };
    });
});
