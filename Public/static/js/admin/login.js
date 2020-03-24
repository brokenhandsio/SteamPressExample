$("#login-form").on('submit', function() {
    var username = $("#username").val();
    var password = $("#password").val();

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

$("#username").blur(function() {
    var username = $("#username").val();
    if (username) {
        $("#username").removeClass("is-invalid");
    }
    else {
        $("#username").addClass("is-invalid");
    }
});

$("#password").blur(function() {
    var password = $("#password").val();
    if (password) {
        $("#password").removeClass("is-invalid");
    }
    else {
        $("#password").addClass("is-invalid");
    }
});
