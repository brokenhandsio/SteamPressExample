$("#reset-password-form").on('submit', function() {
    var password = $("#inputPassword").val();
    var confirm = $("#inputConfirmPassword").val();

    if (!isValidPassword(password)) {
        alert("Please enter a valid password");
        return false;
    }

    if (password != confirm) {
        alert("Please ensure your passwords match")
        return false;
    }
    return true;
});

$("#inputPassword").blur(function() {
    var password = $("#inputPassword").val();
    if (isValidPassword(password)) {
        $("#reset-password-password-group").removeClass("has-danger");
        $("#reset-password-password-group").addClass("has-success");
        $("#inputPassword").removeClass("form-control-danger");
        $("#inputPassword").addClass("form-control-success");
    }
    else {
        $("#reset-password-password-group").removeClass("has-success");
        $("#reset-password-password-group").addClass("has-danger");
        $("#inputPassword").removeClass("form-control-success");
        $("#inputPassword").addClass("form-control-danger");
    }
});

$("#inputConfirmPassword").blur(function() {
    var password = $("#inputPassword").val();
    var confirm = $("#inputConfirmPassword").val();
    if (password == confirm) {
        $("#reset-password-confirm-password-group").removeClass("has-danger");
        $("#reset-password-confirm-password-group").addClass("has-success");
        $("#inputConfirmPassword").removeClass("form-control-danger");
        $("#inputConfirmPassword").addClass("form-control-success");
    }
    else {
        $("#reset-password-confirm-password-group").removeClass("has-success");
        $("#reset-password-confirm-password-group").addClass("has-danger");
        $("#inputConfirmPassword").removeClass("form-control-success");
        $("#inputConfirmPassword").addClass("form-control-danger");
    }
});

function isValidPassword(password) {
    if (!password) {
        return false;
    }

    if (password.length < 8) {
        return false;
    }

    var anUpperCase = /[A-Z]/;
    var aLowerCase = /[a-z]/;
    var aNumber = /[0-9]/;
    var aSpecial = /[!|@|#|$|%|^|&|*|(|)|-|_|']/;

    var complexity = 0;
    for(var i=0; i<password.length; i++){
        if(anUpperCase.test(password[i]))
            complexity++;
        else if(aLowerCase.test(password[i]))
            complexity++;
        else if(aNumber.test(password[i]))
            complexity++;
        else if(aSpecial.test(password[i]))
            complexity++;
    }

    if (complexity < 3) {
        return false;
    }
    else {
        return true;
    }
}
