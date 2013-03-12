FormDataCompatibility
=====================

This class partially implements some of what the [FormData interface](https://developer.mozilla.org/en/XMLHttpRequest/FormData) does which is now a part of modern browsers and will build up a mulipart HTTP POST request. Allowing you to use similar code for browsers that do not support the FormData interface.

Standard form data usage may look something like:

    xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function(){
        if (xhr.readyState == 4){
          alert('complete');
        }
    };
    xhr.open("POST", queryString, true);

    var data = new FormData();
    data.append('title', 'My File');
    data.append('file', fileObject);

    xhr.send(data);


To add support for older browsers you could do something like:



    xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function(){
        if (xhr.readyState == 4){
          alert('complete');
        }
    };
    xhr.open("POST", queryString, true);

    if(typeof(FormData) == 'undefined'){
      // This browser does not have native FormData support. Use the FormDataCompatibility
      // class which implements the needed fucncitonlity foro building multi part HTTP POST requests
      var data = new FormDataCompatibility();
    } else {
      var data = new FormData();
    }

    data.append('title', 'My File');
    data.append('file', fileObject);

    if(typeof(FormData) == 'undefined'){
      // This browser does not have native FormData support so manually set the multipart
      // header and use the sendAsBinary function to send a string of the  POST body
      data.setContentTypeHeader(xhr);
      xhr.sendAsBinary(data.buildBody());
    } else {
      // This browser has native FormData support so just call send with the FormData
      // and let the browser construct the POST
      xhr.send(data);
    }

Like the standard FormData, a FormDataCompatibility object may be created by passing a form as a parameter:

    form = document.getElementById(formId);
    data = new FormDataCompatibility(form);

This is equivalent to calling append() for every input field in the form. However, please be aware that input fields of type "file" are not supported in this version.

Contributors
------------
[Matthew Fawcett](https://github.com/mattfawcett): Original code  
[Ignacio M. Bataller](https://github.com/uavster): Passing a form as a parameter to the constructor

Some of the code comes from http://igstan.ro/posts/2009-01-11-ajax-file-upload-with-pure-javascript.html
