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
        $("#inputName").removeClass("is-invalid");
    }
    else {
        $("#inputName").addClass("is-invalid");
    }
});

$("#username").on('change keyup paste',function(){
    $(this).val($(this).val().toLowerCase());
})

$("#inputUsername").blur(function() {
    var username = $("#inputUsername").val();
    if (isValidUsername(username)) {
        $("#inputUsername").removeClass("is-invalid");
    }
    else {
        $("#inputUsername").addClass("is-invalid");
    }
});

$("#inputPassword").blur(function() {
    var password = $("#inputPassword").val();
    if (editing && !password) {
        return;
    }
    if (isValidPassword(password)) {
        $("#inputPassword").removeClass("is-invalid");
        $("#password-feedback").hide();
    }
    else {
        $("#inputPassword").addClass("is-invalid");
        $("#password-feedback").show();
    }
});

$("#inputConfirmPassword").blur(function() {
    var password = $("#inputPassword").val();
    var confirm = $("#inputConfirmPassword").val();
    if (editing && !password && !confirm) {
        return;
    }
    if (password == confirm) {
        $("#inputConfirmPassword").removeClass("is-invalid");
    }
    else {
        $("#inputConfirmPassword").addClass("is-invalid");
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
        if (/^[a-z0-9\-.]+$/.test(username.toLowerCase())) {
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
