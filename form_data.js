window.FormDataCompatibility = (function() {

  function FormDataCompatibility() {
    this.fields = {};
    this.boundary = this.generateBoundary();
    this.contentType = "multipart/form-data; boundary=" + this.boundary;
    this.CRLF = "\r\n";
  }

  FormDataCompatibility.prototype.append = function(key, value) {
    return this.fields[key] = value;
  };

  FormDataCompatibility.prototype.setContentTypeHeader = function(xhr) {
    return xhr.setRequestHeader("Content-Type", this.contentType);
  };

  FormDataCompatibility.prototype.contentType = function() {
    var contentType;
    return contentType = "multipart/form-data; boundary=" + this.boundary;
  };

  FormDataCompatibility.prototype.generateBoundary = function() {
    return "AJAX--------------" + ((new Date).getTime());
  };

  FormDataCompatibility.prototype.buildBody = function() {
    var body, key, parts, value, _ref;
    parts = [];
    _ref = this.fields;
    for (key in _ref) {
      value = _ref[key];
      parts.push(this.buildPart(key, value));
    }
    body = "--" + this.boundary + this.CRLF;
    body += parts.join("--" + this.boundary + this.CRLF);
    body += "--" + this.boundary + "--" + this.CRLF;
    return body;
  };

  FormDataCompatibility.prototype.buildPart = function(key, value) {
    var part;
    if (typeof value === "string") {
      part = "Content-Disposition: form-data; name=\"" + key + "\"" + this.CRLF + this.CRLF;
      part += value + this.CRLF;
    } else {
      part = "Content-Disposition: form-data; name=\"" + key + "\"; filename=\"" + value.fileName + "\"" + this.CRLF;
      part += "Content-Type: " + value.type + this.CRLF + this.CRLF;
      part += value.getAsBinary() + this.CRLF;
    }
    return part;
  };

  return FormDataCompatibility;

})();
