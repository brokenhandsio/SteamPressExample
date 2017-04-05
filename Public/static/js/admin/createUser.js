var editing = false;

$(function() {
  editing = $("#edit-user-data").data("editingPage");
});

$('#cancel-edit-button').click(function(){
    return confirm('Are you sure you want to cancel? You will lose any unsaved work');
});

$("#create-user-form").on('submit', function() {
    var name = $("#inputName").val();
    var username = $("#inputUsername").val();
    var password = $("#inputPassword").val();
    var confirm = $("#inputConfirmPassword").val();

    if (!isValidName(name)) {
        alert("Please enter a valid name");
        return false;
    }

    if (!isValidUsername(username)) {
        alert("Please enter a valid username");
        return false;
    }

    if (!editing) {
        if (!isValidPassword(password)) {
            alert("Please enter a valid password");
            return false;
        }

        if (password != confirm) {
            alert("Please ensure your passwords match")
            return false;
        }
    }
    return true;
});

$("#inputName").blur(function() {
    var name = $("#inputName").val();
    if (isValidName(name)) {
        $("#create-user-name-group").removeClass("has-danger");
        $("#create-user-name-group").addClass("has-success");
        $("#inputName").removeClass("form-control-danger");
        $("#inputName").addClass("form-control-success");
    }
    else {
        $("#create-user-name-group").removeClass("has-success");
        $("#create-user-name-group").addClass("has-danger");
        $("#inputName").removeClass("form-control-success");
        $("#inputName").addClass("form-control-danger");
    }
});

$("#inputUsername").blur(function() {
    var username = $("#inputUsername").val();
    if (isValidUsername(username)) {
        $("#create-user-username-group").removeClass("has-danger");
        $("#create-user-username-group").addClass("has-success");
        $("#inputUsername").removeClass("form-control-danger");
        $("#inputUsername").addClass("form-control-success");
    }
    else {
        $("#create-user-username-group").removeClass("has-success");
        $("#create-user-username-group").addClass("has-danger");
        $("#inputUsername").removeClass("form-control-success");
        $("#inputUsername").addClass("form-control-danger");
    }
});

$("#inputPassword").blur(function() {
    var password = $("#inputPassword").val();
    if (editing && !password) {
        return;
    }
    if (isValidPassword(password)) {
        $("#create-user-password-group").removeClass("has-danger");
        $("#create-user-password-group").addClass("has-success");
        $("#inputPassword").removeClass("form-control-danger");
        $("#inputPassword").addClass("form-control-success");
    }
    else {
        $("#create-user-password-group").removeClass("has-success");
        $("#create-user-password-group").addClass("has-danger");
        $("#inputPassword").removeClass("form-control-success");
        $("#inputPassword").addClass("form-control-danger");
    }
});

$("#inputConfirmPassword").blur(function() {
    var password = $("#inputPassword").val();
    var confirm = $("#inputConfirmPassword").val();
    if (editing && !password && !confirm) {
        return;
    }
    if (password == confirm) {
        $("#create-user-confirm-password-group").removeClass("has-danger");
        $("#create-user-confirm-password-group").addClass("has-success");
        $("#inputConfirmPassword").removeClass("form-control-danger");
        $("#inputConfirmPassword").addClass("form-control-success");
    }
    else {
        $("#create-user-confirm-password-group").removeClass("has-success");
        $("#create-user-confirm-password-group").addClass("has-danger");
        $("#inputConfirmPassword").removeClass("form-control-success");
        $("#inputConfirmPassword").addClass("form-control-danger");
    }
});

function isValidName(name) {
    if (name) {
        if (name.length > 64) {
            return false;
        }
        if (/^[a-zA-Z \-.,']+$/.test(name)) {
            return true;
        }
        return false;
    }
    return false;
}

function isValidUsername(username) {
    if (username) {
        if (username.length > 64) {
            return false;
        }
        if (/^[a-z0-9\-.]+$/.test(username)) {
            return true;
        }
        return false;
    }
    return false;
}

function isValidPassword(password) {
    if (editing && !password) {
        return true;
    }

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
