# Add a class that behaves similar to FormData, a class included natively on modern browsers
class window.FormDataCompatibility
  constructor: ->
    this.fields = {}
    this.boundary = this.generateBoundary()
    this.contentType = "multipart/form-data; boundary=#{this.boundary}"
    this.CRLF = "\r\n"

  append: (key, value)->
    @fields[key] = value

  setContentTypeHeader: (xhr)->
    xhr.setRequestHeader("Content-Type", @contentType)

  contentType: ->
    contentType = "multipart/form-data; boundary=#{@boundary}"


  generateBoundary: ->
    "AJAX--------------#{(new Date).getTime()}"

  buildBody: ->
    parts = []
    parts.push this.buildPart key, value for key, value of @fields
    body = "--#{@boundary}#{@CRLF}"
    body += parts.join("--#{@boundary}#{@CRLF}")
    body += "--#{@boundary}--#{@CRLF}"

    return body

  buildPart: (key, value)->
    if typeof(value) == "string"
      part = "Content-Disposition: form-data; name=\"#{key}\"#{@CRLF}#{@CRLF}"
      part += value + @CRLF
    else
      part  = "Content-Disposition: form-data; name=\"#{key}\"; filename=\"#{value.fileName}\"#{@CRLF}"
      part += "Content-Type: #{value.type}#{@CRLF}#{@CRLF}"
      part += value.getAsBinary() + @CRLF

    return part
