$("#login-form").on('submit', function() {
    var username = $("#inputUsername").val();
    var password = $("#inputPassword").val();

    if (!username) {
        alert("Please enter a username");
        return false;
    }

    if (!password) {
        alert("Please enter a password");
        return false;
    }
    return true;
});

$("#inputUsername").blur(function() {
    var username = $("#inputUsername").val();
    if (username) {
        $("#inputUsername").removeClass("is-invalid");
    }
    else {
        $("#inputUsername").addClass("is-invalid");
    }
});

$("#inputPassword").blur(function() {
    var password = $("#inputPassword").val();
    if (password) {
        $("#inputPassword").removeClass("is-invalid");
    }
    else {
        $("#inputPassword").addClass("is-invalid");
    }
});
