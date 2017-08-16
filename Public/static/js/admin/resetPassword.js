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

$("#inputPassword").blur(function() {
    var password = $("#inputPassword").val();
    if (isValidPassword(password)) {
        $("#inputPassword").removeClass("is-invalid");
        $("#inputPassword").addClass("is-valid");
    }
    else {
        $("#inputPassword").removeClass("is-valid");
        $("#inputPassword").addClass("is-invalid");
    }
});

$("#inputConfirmPassword").blur(function() {
    var password = $("#inputPassword").val();
    var confirm = $("#inputConfirmPassword").val();
    if (password == confirm) {
        $("#inputConfirmPassword").removeClass("is-invalid");
        $("#inputConfirmPassword").addClass("is-valid");
    }
    else {
        $("#inputConfirmPassword").removeClass("is-valid");
        $("#inputConfirmPassword").addClass("is-invalid");
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
