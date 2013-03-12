# Add a class that behaves similar to FormData, a class included natively on modern browsers
class window.FormDataCompatibility
  constructor: ->
    this.fields = {}
    this.boundary = this.generateBoundary()
    this.contentType = "multipart/form-data; boundary=#{this.boundary}"
    this.CRLF = "\r\n"
    if typeof form isnt "undefined"
      i = 0
      while i < form.elements.length
        e = form.elements[i]     
        # If not set, the element's name is auto-generated
        name = (if (e.name isnt null and e.name isnt "") then e.name else @getElementNameByIndex(i))
        @append name, e
        i++

  getElementNameByIndex: (index)->
    "___form_element__" + index

  append: (key, value)->
    @fields[key] = value

  setContentTypeHeader: (xhr)->
    xhr.setRequestHeader("Content-Type", @contentType)

  getContentType: ->
    @contentType

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
    part = undefined
    if typeof value is "string"
      part = "Content-Disposition: form-data; name=\"" + key + "\"" + @CRLF
      part += "Content-Type: text/plain; charset=utf-8" + @CRLF + @CRLF
      part += unescape(encodeURIComponent(value)) + @CRLF # UTF-8 encoded like in real FormData
    else if typeof value is typeof File
      part = "Content-Disposition: form-data; name=\"" + key + "\"; filename=\"" + value.fileName + "\"" + @CRLF
      part += "Content-Type: " + value.type + @CRLF + @CRLF
      part += value.getAsBinary() + @CRLF
    else if typeof value is typeof HTMLInputElement
      unless value.type is "file"
      
        # Unsupported
        part = "Content-Disposition: form-data; name=\"" + key + "\"" + @CRLF
        part += "Content-Type: text/plain; charset=utf-8" + @CRLF + @CRLF
        part += unescape(encodeURIComponent(value.value)) + @CRLF # UTF-8 encoded like in real FormData

    return part
