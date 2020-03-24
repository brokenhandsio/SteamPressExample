var editing = false;

$(function() {
  editing = $("#edit-user-data").data("editingPage");
});

$('#cancel-edit-button').click(function(){
    return confirm('Are you sure you want to cancel? You will lose any unsaved work');
});

$("#create-user-form").on('submit', function() {
    var name = $("#name").val();
    var username = $("#username").val();
    var password = $("#password").val();
    var confirm = $("#confirmPassword").val();

    if (!isValidName(name)) {
        alert("Please enter a valid name");
        return false;
    }

    if (!isValidUsername(username)) {
        alert("Please enter a valid username");
        return false;
    }

    if (!editing || password !== "") {
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

$("#name").blur(function() {
    var name = $("#name").val();
    if (isValidName(name)) {
        $("#name").removeClass("is-invalid");
    }
    else {
        $("#name").addClass("is-invalid");
    }
});

$("#username").on('change keyup paste',function(){
    $(this).val($(this).val().toLowerCase());
})

$("#username").blur(function() {
    var username = $("#username").val();
    if (isValidUsername(username)) {
        $("#username").removeClass("is-invalid");
    }
    else {
        $("#username").addClass("is-invalid");
    }
});

$("#password").blur(function() {
    var password = $("#password").val();
    if (editing && !password) {
        return;
    }
    if (isValidPassword(password)) {
        $("#password").removeClass("is-invalid");
        $("#password-feedback").hide();
    }
    else {
        $("#password").addClass("is-invalid");
        $("#password-feedback").show();
    }
});

$("#confirmPassword").blur(function() {
    var password = $("#password").val();
    var confirm = $("#confirmPassword").val();
    if (editing && !password && !confirm) {
        return;
    }
    if (password == confirm) {
        $("#confirmPassword").removeClass("is-invalid");
    }
    else {
        $("#confirmPassword").addClass("is-invalid");
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
