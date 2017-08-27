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

    return true;
}
