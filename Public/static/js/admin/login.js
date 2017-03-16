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
        $("#login-username-group").removeClass("has-danger");
        $("#inputUsername").removeClass("form-control-danger");
    }
    else {
        $("#login-username-group").addClass("has-danger");
        $("#inputUsername").addClass("form-control-danger");
    }
});

$("#inputPassword").blur(function() {
    var password = $("#inputPassword").val();
    if (password) {
        $("#login-password-group").removeClass("has-danger");
        $("#inputPassword").removeClass("form-control-danger");
    }
    else {
        $("#login-password-group").addClass("has-danger");
        $("#inputPassword").addClass("form-control-danger");
    }
});
