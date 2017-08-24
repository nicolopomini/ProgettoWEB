/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function registerAttempt()
{
    var validForm = true;
    
    var field = document.getElementById("Email");
    var fieldError = document.getElementById("EmailError");
    var fieldRegex = /[^a-zA-Z0-9\@\.\-\_]/g;
    
    if(!isEmpty(field.value))
    {
        if(!isValidString(fieldRegex,field.value))
        {
            validForm = false;
            fieldError.innerHTML = "The Email field cannot contain invalid characters";
            field.setAttribute("style","border: 1px solid red");
        }
        else
        {
            if(document.getElementById("EmailError").innerHTML == "")
            {
                fieldError.innerHTML = "";
                field.setAttribute("style","border: 1px solid #ccc");
            }
            else
            {
                validForm = false;
                fieldError.innerHTML = "The typed email is already in use";
                field.setAttribute("style","border: 1px solid red");
            }
        }
    }
    else
    {
        validForm = false;
        fieldError.innerHTML = "The Email field cannot be empty";
        field.setAttribute("style","border: 1px solid red");
    }
    
    
    field = document.getElementById("Password");
    fieldError = document.getElementById("PasswordError");
    fieldRegex = /[^a-zA-Z0-9\-\_]/g;
    
    if(!isEmpty(field.value))
    {
        if(!isValidString(fieldRegex,field.value))
        {
            validForm = false;
            fieldError.innerHTML = "The Password field cannot contain invalid characters";
            field.setAttribute("style","border: 1px solid red");
        }
        else 
        {
            if(field.value.length >= 8)
            {
                fieldError.innerHTML = "";
                field.setAttribute("style","border: 1px solid #ccc");
            }
            else
            {
                validForm = false;
                fieldError.innerHTML = "The Password field has to be at least 8 characters long";
                field.setAttribute("style","border: 1px solid red");
            }
        }
    }
    else
    {
        validForm = false;
        fieldError.innerHTML = "The Password field cannot be empty";
        field.setAttribute("style","border: 1px solid red");
    }
    
    
    var field = document.getElementById("Name");
    var fieldError = document.getElementById("NameError");
    var fieldRegex = /[^a-zA-Z\ ]/g;
    
    if(!isEmpty(field.value))
    {
        if(!isValidString(fieldRegex,field.value))
        {
            validForm = false;
            fieldError.innerHTML = "The Name field cannot contain invalid characters";
            field.setAttribute("style","border: 1px solid red");
        }
        else
        {
            fieldError.innerHTML = "";
            field.setAttribute("style","border: 1px solid #ccc");
        } 
    }
    else
    {
        validForm = false;
        fieldError.innerHTML = "The Name field cannot be empty";
        field.setAttribute("style","border: 1px solid red");
    }
    
    
    var field = document.getElementById("Surname");
    var fieldError = document.getElementById("SurnameError");
    var fieldRegex = /[^a-zA-Z\ ]/g;
    
    if(!isEmpty(field.value))
    {
        if(!isValidString(fieldRegex,field.value))
        {
            validForm = false;
            fieldError.innerHTML = "The Surname field cannot contain invalid characters";
            field.setAttribute("style","border: 1px solid red");
        }
        else
        {
            fieldError.innerHTML = "";
            field.setAttribute("style","border: 1px solid #ccc");
        } 
    }
    else
    {
        validForm = false;
        fieldError.innerHTML = "The Surname field cannot be empty";
        field.setAttribute("style","border: 1px solid red");
    }
    
    var field = document.getElementById("Address");
    var fieldError = document.getElementById("AddressError");
    var fieldRegex = /[^a-zA-Z0-9\,\ ]/g;
    
    if(!isEmpty(field.value))
    {
        if(!isValidString(fieldRegex,field.value))
        {
            validForm = false;
            fieldError.innerHTML = "The Address field cannot contain invalid characters";
            field.setAttribute("style","border: 1px solid red");
        }
        else
        {
            fieldError.innerHTML = "";
            field.setAttribute("style","border: 1px solid #ccc");
        }
    }
    else
    {
        validForm = false;
        fieldError.innerHTML = "The Address field cannot be empty";
        field.setAttribute("style","border: 1px solid red");
    }
    
    if(validForm)
    {
        var form = document.getElementById("registerForm");
        form.submit();
    }
}

function isValidString(regex, s)
{
    var sanitizedString = s.replace(regex,"");
    return sanitizedString == s;
}

function isEmpty(s)
{
    var sanitizedString = s.replace(/ /g,"");
    return sanitizedString == "";
}

function isUniqueEmail()
{
    var xhttp;
    var input;
    input = document.getElementById("Email");
    var label;
    label = document.getElementById("EmailError");
    xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200)
        {
            label.innerHTML = this.responseText;
            if(label.innerHTML == "")
            {
                input.setAttribute("style","border: 1px solid #ccc");
            }
            else
            {
                input.setAttribute("style","border: 1px solid red");
            }
        }
    };
    xhttp.open("POST", "UniqueEmail", true);
    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    var toSearch = encodeURIComponent(input.value);
    xhttp.send("Email="+toSearch);
}

function goBack()
{
    window.history.back();
}