(function() {
  "use strict";
  window.addEventListener("load", function() {
    var form = document.getElementById("reset-password-form");
    form.addEventListener("submit", function(event) {
      if (form.checkValidity() == false) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add("was-validated");
    }, false);
  }, false);
}());

$("#reset-password-form").on('submit', function() {
    var password = $("#inputPassword").val();
    var confirmPassword = $("#inputConfirmPassword").val();

    if (!isValidPassword(password) || password != confirmPassword) {
        return false;
    }

    return true;
});

$("#inputPassword").blur(function() {
    var password = $("#inputPassword").val();
    if (isValidPassword(password)) {
        $("#inputPassword").removeClass("is-invalid");
        $("#password-feedback").hide();
    }
    else {
        $("#inputPassword").removeClass("is-valid");
    }
});

$("#inputConfirmPassword").blur(function() {
    var password = $("#inputPassword").val();
    var confirm = $("#inputConfirmPassword").val();
    if (password == confirm) {
        $("#inputConfirmPassword").removeClass("is-invalid");
        $("#confirm-password-feedback").hide();
    }
    else {
        $("#inputConfirmPassword").addClass("is-invalid");
        $("#confirm-password-feedback").show();
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
