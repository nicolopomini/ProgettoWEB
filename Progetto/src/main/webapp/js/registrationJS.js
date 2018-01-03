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
            toggleVisibility("EmailError", true);
            field.setAttribute("style","border: 1px solid red");
        }
        else
        {
            if(document.getElementById("EmailError").innerHTML == "")
            {
                toggleVisibility("EmailError", false);
                fieldError.innerHTML = "";
                field.setAttribute("style","border: 1px solid #ccc");
            }
            else
            {
                validForm = false;
                fieldError.innerHTML = "La email inserita è già in uso";
                toggleVisibility("EmailError", true);
                field.setAttribute("style","border: 1px solid red");
            }
        }
    }
    else
    {
        validForm = false;
        fieldError.innerHTML = "Il campo email non può essere vuoto";
        toggleVisibility("EmailError", true);
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
            fieldError.innerHTML = "Il campo password contiene caratteri invalidi";
            toggleVisibility("PasswordError", true);
            field.setAttribute("style","border: 1px solid red");
        }
        else 
        {
            if(field.value.length >= 8)
            {
                toggleVisibility("PasswordError", false);
                fieldError.innerHTML = "";
                field.setAttribute("style","border: 1px solid #ccc");
            }
            else
            {
                validForm = false;
                fieldError.innerHTML = "La password deve essere lunga almeno 8 caratteri";
                toggleVisibility("PasswordError", true);
                field.setAttribute("style","border: 1px solid red");
            }
        }
    }
    else
    {
        validForm = false;
        fieldError.innerHTML = "Il campo password non può essere vuoto";
        toggleVisibility("PasswordError", true);
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
            fieldError.innerHTML = "Il campo nome contiene caratteri invalidi";
            toggleVisibility("NameError", true);
            field.setAttribute("style","border: 1px solid red");
        }
        else
        {
            toggleVisibility("NameError", false);
            fieldError.innerHTML = "";
            field.setAttribute("style","border: 1px solid #ccc");
        } 
    }
    else
    {
        validForm = false;
        fieldError.innerHTML = "Il campo nome non può essere vuoto";
        toggleVisibility("NameError", true);
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
            fieldError.innerHTML = "Il campo cognome contiene caratteri invalidi";
            toggleVisibility("SurnameError", true);
            field.setAttribute("style","border: 1px solid red");
        }
        else
        {
            toggleVisibility("SurnameError", false);
            fieldError.innerHTML = "";
            field.setAttribute("style","border: 1px solid #ccc");
        } 
    }
    else
    {
        validForm = false;
        fieldError.innerHTML = "Il campo cognome non può essere vuoto";
        toggleVisibility("SurnameError", true);
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
            fieldError.innerHTML = "Il campo indirizzo contiene caratteri invalidi";
            toggleVisibility("AddressError", true);
            field.setAttribute("style","border: 1px solid red");
        }
        else
        {
            toggleVisibility("AddressError", false);
            fieldError.innerHTML = "";
            field.setAttribute("style","border: 1px solid #ccc");
        }
    }
    else
    {
        validForm = false;
        fieldError.innerHTML = "Il campo indirizzo non può essere vuoto";
        toggleVisibility("AddressError", true);
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
                toggleVisibility("EmailError", false);
                input.setAttribute("style","border: 1px solid #ccc");
            }
            else
            {
                toggleVisibility("EmailError", true);
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

function toggleVisibility(id, visible)
{
    var elem = document.getElementById(id);
    if(visible){
        document.getElementById(id).setAttribute("class","alert alert-danger");
    }else{
       document.getElementById(id).setAttribute("class","alert alert-danger collapse");
    }
}