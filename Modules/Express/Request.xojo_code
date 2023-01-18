#tag Class
Protected Class Request
Inherits SSLSocket
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Event
		Sub Connected()
		  // A connection has been made to one of the sockets.
		  // The request's data will be read, and when that's complete, the DataAvailable event will occur.
		  
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub DataAvailable()
		  // Data has been received..
		  
		  // Increment the data received counter.
		  DataReceivedCount = DataReceivedCount + 1
		  
		  // Update the LastConnect timestamp.
		  // This is used to determine if a keep-alive or WebSocket connection has timed out.
		  LastConnect = DateTime.Now
		  
		  // If this socket is servicing an active Websocket...
		  If WSStatus = "Active" Then
		    
		    // Get the incoming message.
		    WSMessageGet
		    
		    // If the socket has been closed...
		    If Self.IsConnected = False Then
		      Return
		    End If
		    
		    // Hand the message off to the app's RequestHandler.
		    App.RequestHandler(Self, Self.Response)
		    
		    Return
		    
		  End If
		  
		  // If this is a new request...
		  If DataReceivedCount = 1 Then
		    
		    // Prepare the request for processing.
		    Prepare
		    
		    // If the content being uploaded (based on the Content-Length header)
		    // is too large...
		    If ContentLength > MaxEntitySize Then
		      Response.Status = "413 Request Entity Too Large"
		      Response.Content = "Error 413: Request Entity Too Large"
		      ResponseReturn
		      Return
		    End If
		    
		  End If
		  
		  // Get the request data.
		  DataGet
		  
		  // Get the body from the data.
		  BodyGet
		  
		  // Get the length of the content that has been received.
		  Var contentReceivedLength As Integer = Body.Bytes
		  
		  // If the content that has actually been uploaded is too large...
		  // This prevents a client from spoofing of the Content-Length header
		  // and sending large entities.
		  If contentReceivedLength > MaxEntitySize Then
		    Response.Status = "413 Request Entity Too Large"
		    Response.Content = "Error 413: Request Entity Too Large"
		    ResponseReturn
		    Return
		  End If
		  
		  // If we haven't received all of the content...
		  If contentReceivedLength < ContentLength Then
		    // Continue receiving data...
		    Return
		  End If
		  
		  // If the body is not the expected length we have a problem
		  If contentReceivedLength <> ContentLength Then
		    System.Log System.LogLevelCritical, CurrentMethodName + " Body.Bytes: " + body.Bytes.ToString + " - Content-Length: " + ContentLength.ToString
		    Response.Status = "400 Bad Request"
		    Response.Content = "Error 400: Bad Request. The length of the request's content differs from the Content-Length header."
		    ResponseReturn
		    Return
		  End If
		  
		  // If the app is using threads...
		  If Multithreading Then
		    
		    // Hand the request off to a RequestThread instance for processing.
		    RequestThread = New Express.RequestThread
		    RequestThread.RequestWR = New WeakRef( Self )
		    RequestThread.Start
		    Return
		    
		  End If
		  
		  // Process the request immediately, on the primary thread...
		  Process
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Error(err As RuntimeException)
		  // An error occurred with the socket.
		  // Typically, this will be a 102 error, where the client has closed the connection.
		  If err.ErrorNumber <> 102 Then
		    System.DebugLog "Socket " + SocketID.ToString + " Error: " + err.ErrorNumber.ToString
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub SendComplete(UserAborted As Boolean)
		  #Pragma Unused UserAborted
		  
		  // The response has been sent back to the client.
		  
		  // If persistent connections are disabled...
		  If KeepAlive = False Then
		    // Close the connection.
		    Close
		  End If
		  
		  // If this was a multipart form...
		  If ContentType.Split("multipart/form-data").LastIndex = 1 Then
		    // Close the connection.
		    Close
		  End If
		  
		  // Reset the socket's properties.
		  Reset
		  
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub BodyGet()
		  // Gets the request body.
		  
		  // Split the data into headers and the body.
		  Var requestParts() As String = Data.Split(EndOfLine.Windows + EndOfLine.Windows)
		  
		  // We no longer need the data that was received, so clear it.
		  Data = ""
		  
		  // If we were unable to split the data into a header and body...
		  If requestParts.LastIndex < 0 Then
		    Return
		  End If
		  
		  // If request parts contains two rows
		  // Normally this would be the header and the body split
		  // Remove the header part.
		  If requestParts.LastIndex >= 1 Then
		    requestParts.RemoveAt(0)
		  End If
		  
		  // If what should be the body is not = Content-Length, don't set the body value
		  If requestParts(0).Bytes <> ContentLength Then
		    Return
		  End If
		  
		  // Merge the remaining parts to form the entire request body.
		  Body = String.FromArray(requestParts, EndOfLine.Windows + EndOfLine.Windows)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BodyProcess()
		  // Evaluates the request body to create dictionaries representing any POST variables 
		  // and/or files that have been sent.
		  
		  // Create the POST and Files dictionaries.
		  POST = New Dictionary
		  Files = New Dictionary
		  
		  // If there is no data in the request body...
		  If Body = "" Then
		    Return
		  End If
		  
		  // Get the content type.
		  ContentType = Headers.Lookup("Content-Type", "")
		  
		  // If the content is form-url encoded...
		  If ContentType.BeginsWith("application/x-www-form-urlencoded") Then
		    URLEncodedFormHandle
		    Return
		  End If
		  
		  // If this is a multipart form...
		  If ContentType.BeginsWith("multipart/form-data") Then
		    MultipartFormHandle
		    Return
		  End If
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  // Closes the socket and resets custom properties.
		  
		  'Express.EventLog( "Socket " + SocketID.ToString + ": Close", Express.LogLevel.Debug )
		  
		  Reset
		  
		  Path = ""
		  
		  WSStatus = "Inactive"
		  
		  Super.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Server As Express.Server)
		  // Associate this request (socket) with its server.
		  Self.Server = Server // Converts this instance value to a weakref internally.
		  
		  // Inherit properties from the server.
		  Multithreading = Server.Multithreading
		  SSLEnabled = Server.Secure
		  SSLConnectionType = Server.ConnectionType
		  CertificateFile = Server.CertificateFile
		  CertificatePassword = Server.CertificatePassword
		  MaxEntitySize = Server.MaxEntitySize
		  KeepAlive = Server.KeepAlive
		  
		  // Call the overridden superclass constructor.
		  Super.Constructor
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ContentLengthGet()
		  // Get the Content-Length header.
		  If Headers.HasKey("Content-Length") Then
		    ContentLength = Headers.Value("Content-Length")
		  Else
		    ContentLength = 0
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CookiesDictionaryCreate()
		  // Creates a dictionary representing the request cookies.
		  // The cookies are delivered as a request header, like this:
		  // Cookie: x=12; y=124
		  
		  // Create the dictionary.
		  Cookies = New Dictionary
		  
		  // If no cookies were sent...
		  If Headers.HasKey("Cookie") = False Then
		    Return
		  End If
		  
		  // Get the cookie header value as a string.
		  Var cookiesRaw As String = Headers.Value("Cookie")
		  
		  // Create an array of cookies.
		  Var cookiesRawArray() As String = cookiesRaw.Split("; ")
		  
		  // Loop over the cookies...
		  For i As Integer = 0 To cookiesRawArray.LastIndex
		    Var thisCookie As String = cookiesRawArray(i)
		    Var key As String = Express.URLDecode(thisCookie.NthField("=", 1))
		    Var value As String = Express.URLDecode(thisCookie.NthField("=", 2))
		    Cookies.Value(key) = value
		  Next i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DataGet()
		  // Gets the request data.
		  Data = ReadAll(Encodings.UTF8)
		  Data = Data.DefineEncoding(Encodings.UTF8)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Dump() As String
		  Var html As String
		  
		  html = html + "<p>Method: " + Method + "</p>" + EndOfLine.Windows
		  html = html + "<p>Path: " + Path + "</p>" + EndOfLine.Windows
		  
		  html = html + "<p>Path Components: " + EndOfLine.Windows
		  html = html + "<ul>" + EndOfLine.Windows
		  If PathComponents.LastIndex > -1 Then
		    For i As Integer = 0 to PathComponents.LastIndex
		      html = html + "<li>" + i.ToString + ". " + PathComponents(i) + "</li>"+ EndOfLine.Windows
		    Next i
		  Else
		    html = html + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  html = html + "</ul>" + EndOfLine.Windows
		  html = html + "</p>" + EndOfLine.Windows
		  
		  html = html + "<p>HTTP Version: " + HTTPVersion + "</p>" + EndOfLine.Windows
		  html = html + "<p>Remote Address: " + RemoteAddress + "</p>" + EndOfLine.Windows
		  html = html + "<p>Socket ID: " + SocketID.ToString + "</p>" + EndOfLine.Windows
		  
		  html = html + "<p>Headers: " + EndOfLine.Windows
		  html = html + "<ul>" + EndOfLine.Windows
		  If Headers.KeyCount > 0 Then
		    For Each key As Variant in Headers.Keys
		      html = html + "<li>" + key + "=" + Headers.Value(key) + "</li>"+ EndOfLine.Windows
		    Next key
		  Else
		    html = html + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  html = html + "</ul>" + EndOfLine.Windows
		  html = html + "</p>" + EndOfLine.Windows
		  
		  html = html + "<p>Cookies: " + EndOfLine.Windows
		  html = html + "<ul>" + EndOfLine.Windows
		  If Cookies.KeyCount > 0 Then
		    For Each key As Variant in Cookies.Keys
		      HTML = html + "<li>" + Key + "=" + Cookies.Value(key) + "</li>"+ EndOfLine.Windows
		    Next key
		  Else
		    html = html + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  html = html + "</ul>" + EndOfLine.Windows
		  html = html + "</p>" + EndOfLine.Windows
		  
		  html = html + "<p>GET Params: " + EndOfLine.Windows
		  html = html + "<ul>" + EndOfLine.Windows
		  If GET.KeyCount > 0 Then
		    For Each key As Variant in GET.Keys
		      html = html + "<li>" + key + "=" + GET.Value(key) + "</li>"+ EndOfLine.Windows
		    Next key
		  Else
		    html = html + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  html = html + "</ul>" + EndOfLine.Windows
		  html = html + "</p>" + EndOfLine.Windows
		  
		  html = html + "<p>POST Params: " + EndOfLine.Windows
		  html = html + "<ul>" + EndOfLine.Windows
		  If POST.KeyCount > 0 Then
		    For Each key As Variant in POST.Keys
		      HTML = html + "<li>" + key + "=" + POST.Value(key) + "</li>"+ EndOfLine.Windows
		    Next key
		  Else
		    html = html + "<li>None</li>"+ EndOfLine.Windows
		  End If
		  html = html + "</ul>" + EndOfLine.Windows
		  html = html + "</p>" + EndOfLine.Windows
		  
		  html = html + "<p>Body:<br /><br />" 
		  If Body <> "" Then
		    html = html + Body
		  Else
		    html = html + "None"
		  End If
		  html = html + Body + "</p>" + EndOfLine.Windows
		  
		  Return html
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GETDictionaryCreate()
		  // Creates a dictionary representing the URL params.
		  // When multiple values are passed for the same key, the dictionary entry is treated as an array of strings.
		  // Example: a=1&b=2&a=3&b=4&a=5&c=678
		  
		  // Create the dictionary.
		  GET = New Dictionary
		  
		  // Split the Params string into an array of strings.
		  // Example: a=123&b=456&c=999
		  Var GETParams() As String = URLParams.Split( "&" )
		  
		  // Loop over the URL params to create the GET dictionary.
		  For i As Integer = 0 To GETParams.LastIndex
		    
		    Var thisParam As String = GETParams( i )
		    Var key As String = thisParam.NthField( "=", 1 )
		    Var value As String = thisParam.NthField( "=", 2 )
		    value = URLDecode(value) 
		    
		    // If the key does not already exist in the GET dictionary...
		    If Not Get.HasKey(key) Then
		      GET.Value(key) = URLDecode(value)
		    Else
		      
		      Var temp() As String
		      
		      // Get the existing value from the GET dictionary.
		      Var existingValue As Variant = GET.Value(key)
		      
		      // If that value is already an array...
		      If existingValue.IsArray Then
		        // Set the temp array to the existing array.
		        temp = GET.Value(key)
		      Else
		        // Add the first element to the temp array.
		        temp.Add(existingValue) 
		      End If
		      
		      // Append the new value to the temp array.
		      temp.Add(value)
		      
		      // Update the GET dictionary.
		      GET.Value(key) = temp
		      
		    End If
		    
		  Next i
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HeadersDictionaryCreate()
		  // Creates a dictionary representing the request headers.
		  // Not that "header 0" is actually the method, path, etc.
		  
		  // Create the dictionary.
		  Headers = New Dictionary
		  
		  // If no additional headers are available...
		  If HeadersRawArray.LastIndex < 1 Then
		    Return
		  End If
		  
		  // Loop over the other header array elements to create the request headers dictionary.
		  For i As Integer = 1 To HeadersRawArray.LastIndex
		    
		    Var thisHeader As String = HeadersRawArray(i)
		    Var key As String = thisHeader.NthField(": ", 1)
		    Var value As String = thisHeader.NthField(": ", 2)
		    Headers.Value(key) = value
		    
		  Next i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HTTPVersionGet()
		  // Get the HTP version from the first HeadersRawArray element.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  // Get the first header.
		  Var header As String = HeadersRawArray(0)
		  
		  // Get the HTTP version that was used to make the request.
		  HTTPVersion = header.NthField(" ", 3).NthField("/", 2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub KeepAliveGet()
		  // If we're willing to keep connections open...
		  If KeepAlive = True Then
		    
		    // Inspect the Connection header to determine the connection type that has been requested.
		    If Headers.Lookup("Connection", "close") = "close" Then
		      KeepAlive = False
		    Else
		      KeepAlive = True
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
		Sub MapToFile(useETags As Boolean = True)
		  // Attempts to map a request to a static file.
		  
		  // Assume that the requested resource will not be found.
		  'Response.Set404Response(Headers, Path)
		  Response.Status = "404"
		  
		  // Create a folder item based on the location of the static files.
		  Var f As FolderItem = StaticPath
		  
		  // Create a folder item for the file that was requested...
		  For Each pathComponent As String In PathComponents
		    
		    // If this is a blank component...
		    // This might happen if the request is for a subfolder.
		    // Example: http://127.0.0.1:64003/sub/
		    If pathComponent = "" Then
		      Exit
		    End If
		    
		    // Try to add the URL-decoded path component.
		    Try
		      f = f.Child(DecodeURLComponent( pathComponent ))
		    Catch e As NilObjectException
		      Return
		    Catch e As UnsupportedFormatException
		      Return
		    End Try
		    
		    // If the path is no longer valid...
		    If f = Nil Then
		      Return
		    End If
		    
		  Next pathComponent
		  
		  // If the requested resource is a directory...
		  If f.IsFolder Then
		    
		    // Loop over the index filenames to see if any exist...
		    For Each indexFilename As String In IndexFilenames
		      
		      // Add this index document to the FolderItem...
		      f = f.Child(indexFilename)
		      
		      // If the FolderItem exists...
		      If f.Exists Then
		        Exit
		      End If
		      
		      // Remove the default document from the FolderItem.
		      f = f.Parent
		      
		    Next indexFilename
		    
		  End If
		  
		  // If the folder item exists and it is not a directory...
		  If f.Exists And f.IsFolder = False Then
		    
		    // If we're using ETags...
		    If useETags Then
		      
		      // Generate the current Etag for the file.
		      Const quote As String = """"
		      Var currentEtag As String 
		      currentEtag = MD5(f.NativePath)
		      currentEtag = EncodeHex(currentEtag)
		      currentEtag = currentEtag + "-" + f.ModificationDateTime.SecondsFrom1970.ToString
		      currentEtag = currentEtag.NthField(".", 1)
		      
		      // Get any Etag that the client sent in the request.
		      Var clientEtag As String = Headers.Lookup("If-None-Match", "")
		      
		      // If the client has the current resource...
		      If clientEtag = currentEtag Then
		        // Return the "Not Modified" status.
		        Response.Status = "304"
		        Return
		      End If
		      
		      // Add an Etag header. (rfc says the string must have quotes "")
		      Response.Headers.Value("ETag") = quote + currentEtag +  quote
		      
		    End If
		    
		    // Update the response status.
		    Response.Status = "200"
		    
		    // Get the file's contents.
		    Response.Content = FileRead(f)
		    
		    // Set the encoding of the content.
		    Response.Content = Response.Content.DefineEncoding(Encodings.UTF8)
		    
		    // Get the file's extension.
		    Var extension As String = f.Name.NthField( ".", f.Name.CountFields( "."))
		    
		    // Map the file extension to a mime type, and use that as the content type.
		    Response.Headers.Value("Content-Type") = MimeTypeGet(extension)
		    
		    // Set the Content-Length
		    Response.Headers.Value("Content-Length") = Response.Content.Bytes.ToString
		    
		    // If XojoScript is available and enabled...
		    #If XojoScriptAvailable Then
		      If XojoScriptEnabled then
		        XojoScriptsParse
		      End If
		    #Endif
		    
		  End If
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MethodGet()
		  // Get the method from the first HeadersRawArray element.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  
		  // Get the first header.
		  Var header As String = HeadersRawArray(0)
		  
		  // Get the request method.
		  Method = header.NthField(" ", 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MultipartFormHandle()
		  // Split the content type at the boundary.
		  Var contentTypeParts() As String = ContentType.Split("boundary=")
		  
		  // If the content does not have a boundary...
		  If contentTypeParts.LastIndex < 1 Then
		    Return
		  End If
		  
		  // Get the boundary.
		  Var boundary As String = contentTypeParts(1)
		  
		  // Split the content into parts based on the boundary.
		  Var parts() As String = Body.Split("--" + boundary)
		  
		  // Loop over the parts, skipping the header...
		  Var lastPartsIndex As Integer = parts.LastIndex
		  For i As Integer = 1 To lastPartsIndex
		    
		    // Split the part into its header and content.
		    Var partComponents() As String = parts(i).Split(EndOfLine.Windows + EndOfLine.Windows)
		    
		    // If this part has no content...
		    If partComponents.LastIndex < 1 Then
		      Continue
		    End If
		    
		    // Get the part content.
		    Var partContent As String = partComponents(1)
		    
		    // Additional info about the part will be stored in these vars.
		    Var fieldname As String
		    Var filename As String
		    Var fileContentType As String
		    Var fieldIsAFile As Boolean = False
		    
		    // Split the part headers into an array.
		    // Example Header...
		    // Content-Disposition: form-data; name="file1"; filename="woot.png"
		    // Content-Type: image/png
		    Var partHeaders() As String = partComponents(0).Split(EndOfLine.Windows)
		    
		    // Loop over the part headers...
		    For Each partHeader As String In partHeaders
		      
		      // If this part header is empty...
		      If partHeader = "" Then
		        Continue
		      End If
		      
		      Var headerName As String = partHeader.NthField(": ", 1)
		      Var headerValue As String = partHeader.NthField(": ", 2)
		      
		      If headerName = "Content-Type" Then
		        fileContentType = headerValue
		        Continue
		      End If
		      
		      If headerName = "Content-Disposition" Then
		        
		        // Split the disposition into its parts.
		        Var dispositionParts() As String = headerValue.Split("; ")
		        
		        // Loop over the disposition parts to get the field name and file name.
		        For Each dispPart As String In dispositionParts
		          
		          // Split the disposition part into name / value pairs.
		          Var nameValue() As String = dispPart.Split("=")
		          
		          If nameValue.LastIndex < 0 Then
		            Continue
		          End If
		          
		          // If this is a field name...
		          If nameValue(0) = "name" Then
		            Fieldname = nameValue(1).ReplaceAll("""", "")
		          End If
		          
		          // If this is a file name...
		          If nameValue(0) = "filename" Then
		            fieldIsAFile = True
		            filename = nameValue(1).ReplaceAll("""", "")
		          End If
		          
		        Next dispPart
		        
		      End If
		      
		    Next partHeader
		    
		    // If we could not get a field name from the part...
		    If fieldname = "" Then
		      Continue
		    End If
		    
		    // If this is a file...
		    If fieldIsAFile Then
		      Var fileDictionary As New Dictionary
		      fileDictionary.Value("ContentType") = fileContentType
		      fileDictionary.Value("Content") = partContent
		      fileDictionary.Value("Filename") = filename
		      fileDictionary.Value("ContentLength") = partContent.Length
		      Files.Value(fieldname) = fileDictionary
		    Else
		      POST.Value(fieldname) = partContent
		    End If
		    
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PathComponentsGet()
		  // Create the path components by splitting the Path.
		  PathComponents = Path.Split("/")
		  
		  // Remove the first component, because it's a blank that appears before the first /.
		  If PathComponents.LastIndex > -1 Then
		    PathComponents.RemoveAt(0)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PathGet()
		  // Get the path from the first HeadersRawArray element.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  // Get the first header.
		  Var header As String = HeadersRawArray(0)
		  
		  // Get the request path.
		  Path = header.NthField(" ", 2).NthField("?", 1)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PathItemsGet()
		  // Creates a dictionary representing the path components.
		  
		  
		  // Create the dictionary.
		  PathItems = New Dictionary
		  
		  // If there are path components...
		  Var lastPathComponentsIndex As Integer = PathComponents.LastIndex
		  
		  If lastPathComponentsIndex > -1 Then
		    
		    For i As Integer = 0 To lastPathComponentsIndex
		      PathItems.Value(i) = PathComponents(i)
		    Next i
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Prepare()
		  // Prepares a new request for processing.
		  // This is called once per request, when the first batch of data is received via the DataAvailable event.
		  
		  // Split the request into two parts: headers and the request entity.
		  Var requestParts() As String = Lookahead(Encodings.UTF8).Split(EndOfLine.Windows + EndOfLine.Windows)
		  
		  // If the request is valid...
		  If requestParts.LastIndex > -1 Then
		    
		    // Get the headers as a string.
		    HeadersRaw = requestParts(0)
		    
		    // Split the headers into an array of strings.
		    HeadersRawArray = HeadersRaw.Split(EndOfLine.Windows)
		    
		  End If
		  
		  // Get the method.
		  MethodGet
		  
		  // Get the path.
		  PathGet
		  
		  // Get the protocol.
		  ProtocolGet
		  
		  // Get the path components.
		  PathComponentsGet
		  
		  // Build the path item dictionary.
		  PathItemsGet
		  
		  // Get the URL params.
		  URLParamsGet
		  
		  // Get the HTTP version.
		  HTTPVersionGet
		  
		  // Create the headers dictionary.
		  HeadersDictionaryCreate
		  
		  // Get the connection type.
		  KeepAliveGet
		  
		  // Get the content-length header.
		  ContentLengthGet
		  
		  // Create the cookies dictionary.
		  CookiesDictionaryCreate
		  
		  // Create the GET dictionary.
		  GETDictionaryCreate
		  
		  // Create a response instance.
		  Response = New Response(Self)
		  
		  // Evaluate the request to determine if the response content should be compressed.
		  ResponseCompressDefault
		  
		  // Set the default resources folder and index filenames.
		  // These are used by the "MapToFile" method.
		  StaticPath = App.ExecutableFile.Parent.Child("htdocs")
		  System.Log System.LogLevelDebug, "StaticPath = " + StaticPath.NativePath
		  IndexFilenames = Array("index.html", "index.htm")
		  
		  // Initlialize the Custom dictionary.
		  Custom = New Dictionary
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Process()
		  // Processes a request.
		  // This method will be called:
		  // By a RequestThread's Run event handler, if multithreading is enabled.
		  // By the DataAvailable event handler, if multithreading is disabled.
		  
		  // Create the POST and Files dictionaries.
		  BodyProcess
		  
		  // Hand the request off to the RequestHandler.
		  App.RequestHandler(Self, Self.Response)
		  
		  // Return the response.
		  ResponseReturn
		  
		  // Reset the data received counter. 
		  DataReceivedCount = 0
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProtocolGet()
		  // Get the protocol from the first HeadersRawArray element.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  // Get the first header.
		  Var header As String = HeadersRawArray(0)
		  
		  // Get the protocol that was used to make the request.
		  Protocol = header.NthField(" ", 3).NthField("/", 1)
		  ProtocolVersion = header.NthField(" ", 3).NthField("/", 2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reset()
		  // Resets socket properties after a request has been processed.
		  // Note that these properties are not reset because they are used 
		  // to service WebSockets: Custom, Path
		  
		  Body = ""
		  ContentType = ""
		  Cookies = Nil
		  Data = ""
		  Files = Nil
		  GET = Nil
		  Headers = Nil
		  HeadersRaw = ""
		  HeadersRawArray = Nil
		  Method = ""
		  PathComponents = Nil
		  POST = Nil
		  Response = Nil
		  Session = Nil
		  StaticPath = Nil
		  URLParams = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResourceNotFound()
		  // Set's the response status to 404 "Not Found" and content to the AloeExpress
		  // Standard404Content (constant) HTML.
		  
		  
		  // Set the response content.
		  Response.Content = NotFoundContent
		  Response.Content = Response.Content.ReplaceAll("[[ServerType]]", "Xojo/" + XojoVersionString + "+ AloeExpress/" + Express.VERSION_STRING)
		  Response.Content = Response.Content.ReplaceAll("[[Host]]", Headers.Lookup("Host", ""))
		  Response.Content = Response.Content.ReplaceAll("[[Path]]", Path)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ResponseCompressDefault()
		  // Evaluates the request to determine if the response should be compressed.
		  
		  // If the request did not include an "Accept-Encoding" header.
		  If Headers.HasKey("Accept-Encoding") = False Then
		    Return
		  End If
		  
		  // Get the "Accept-Encoding" header.
		  Var acceptEncoding As String = Headers.Lookup("Accept-Encoding", "")
		  
		  // Split the header value to see if "gzip" is specified.
		  Var acceptEncodingParts() As String = AcceptEncoding.Split("gzip")
		  
		  // If gzip is accepted...
		  If acceptEncodingParts.LastIndex > 0 Then
		    // By default, the response will be compressed.
		    Response.Compress = True
		  End If
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResponseReturn()
		  
		  // If the socket is still connected...
		  If IsConnected Then
		    
		    // Try to write the response.
		    Try
		      
		      // Return the response.
		      Write Response.Get
		      
		    Catch e As RunTimeException
		      
		      Var typeInfo As Introspection.TypeInfo = Introspection.GetType(e)
		      
		      System.DebugLog "ResponseReturn Exception: Socket " + SocketID.ToString _
		      + ", Last Error: " + LastErrorCode.ToString _
		      + ", Exception Type: " + typeInfo.Name
		      
		    End Try
		    
		  End If
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SessionGet(AssignNewID As Boolean=True)
		  // Gets a session for the request and associates it with the Session property.
		  Session = Server.SessionEngine.SessionGet(Self, AssignNewID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SessionTerminate()
		  If Session <> Nil Then
		    Server.SessionEngine.SessionTerminate(Session)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub URLEncodedFormHandle()
		  // Split the content string into an array of strings.
		  // Example: a=123&b=456&c=999
		  Var POSTParams() As String = Body.Split("&")
		  
		  If POSTParams.Count > 0 Then
		    
		    // Loop over the array to create the POST dictionary.
		    Var lastPostParamIndex As Integer = POSTParams.LastIndex
		    
		    For i As Integer = 0 To lastPostParamIndex
		      Var thisParam As String = POSTParams(i)
		      Var key As String = thisParam.NthField("=", 1)
		      Var value As String = thisParam.NthField("=", 2)
		      POST.Value(Key) = URLDecode(value)
		    Next i
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub URLParamsGet()
		  // Get the parameters from the first HeadersRawArray element.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  // Note that it is also possible for a parameter to include a question mark in it.
		  // Example: GET /?a=1234?format%3D1500w&MaxHeight=50 HTTP/1.1
		  
		  // Get the first header.
		  Var header As String = HeadersRawArray(0)
		  
		  // Split the header on ?s.
		  Var URLParamParts() As String = header.Split("?")
		  
		  // Remove the first element, which should be the method and path.
		  URLParamParts.RemoveAt(0)
		  
		  // Recombine the URL parameters.
		  URLParams = String.FromArray(URLParamParts, "?")
		  
		  // Split the string based on a space and get the first element.
		  // Remember that NthField is 1-based.
		  URLParams = URLParams.NthField(" ", 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WSConnectionClose()
		  
		  If server.WebSockets.Count > 0 Then
		    Var myIndex As Integer = Server.WebSockets.IndexOf(Self)
		    
		    If myIndex > -1 Then
		      Server.WebSockets.RemoveAt(myIndex)
		    End If
		    
		  End If
		  
		  // Close the connection.
		  Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WSHandshake()
		  // Performs an opening WebSocket handshake.
		  
		  // If this isn't the WebSocket version that we're supporting...
		  If Headers.Lookup("Sec-WebSocket-Version", "") <> "13" Then
		    Response.Status = "400 Bad Request"
		    Return
		  End If
		  
		  // Create the SecWebSocketKey for the response.
		  Var secWebSocketKey As String = Headers.Value("Sec-WebSocket-Key") 
		  secWebSocketKey = secWebSocketKey + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
		  secWebSocketKey = Crypto.Hash(secWebSocketKey, Crypto.HashAlgorithms.SHA1)
		  secWebSocketKey = EncodeBase64(secWebSocketKey, 0)
		  
		  // Return the handshake response.
		  Response.Status = "101 Switching Protocols"
		  Response.Headers.Value("Upgrade") = "WebSocket"
		  Response.Headers.Value("Connection") = "Upgrade"
		  Response.Headers.Value("Sec-WebSocket-Accept") = secWebSocketKey
		  
		  // Update the WS status.
		  WSStatus = "Active"
		  
		  // Register the socket as a WebSocket.
		  Server.WebSockets.Add(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WSMessageGet()
		  // Processes a WebSocket message.
		  
		  // Get the data.
		  DataGet
		  
		  // Convert the message to a memoryblock.
		  Var dataRaw As MemoryBlock = Data
		  dataRaw.LittleEndian = False
		  
		  // We'll use a pointer to get specific bytes from the memoryblock.
		  Var dataPtr As Ptr = dataRaw
		  
		  // Get the first byte.
		  Var firstByte As UInteger = dataPtr.Byte(0)
		  
		  // Is this the last message in the series?
		  Var finBit As UInteger = firstByte And &b10000000
		  #Pragma Unused FinBit
		  
		  // Get the reserved extension bits.
		  Var RSV1 As Integer = firstByte And &b01000000
		  Var RSV2 As Integer = firstByte And &b00100000
		  Var RSV3 As Integer = firstByte And &b00010000
		  #Pragma Unused RSV1
		  #Pragma Unused RSV2
		  #Pragma Unused RSV3
		  
		  // Get the OpCode.
		  Var opCode As UInteger = firstByte And &b00001111
		  
		  // If the client is closing the connection...
		  If opCode = 8 Then
		    WSConnectionClose
		    Return
		  End If
		  
		  // Get the second byte from the frame.
		  Var secondByte As UInteger = dataPtr.Byte(1)
		  
		  // Is the payload masked?
		  Var maskedBit As UInteger = secondByte And &b10000000
		  #Pragma Unused MaskedBit
		  
		  // Get the payload size.
		  Var payloadSize As UInteger = secondByte And &b01111111
		  Var maskKeyStartingByte As UInteger
		  If payloadSize < 126 Then
		    maskKeyStartingByte = 2
		  ElseIf payloadSize = 126 Then
		    payloadSize = dataRaw.UInt16Value(2)
		    maskKeyStartingByte = 4
		  ElseIf payloadSize = 127 Then
		    payloadSize = dataRaw.UInt64Value(2)
		    maskKeyStartingByte = 10
		  End If
		  
		  // Get the masking key.
		  Var maskKey() As UInteger
		  For i As Integer = 0 to 3
		    maskKey.Add(DataPtr.Byte(maskKeyStartingByte + i))
		  Next i
		  
		  // Determine where the data bytes start.
		  Var dataStartingByte As UInteger = maskKeyStartingByte + 4
		  
		  // Get the masked data...
		  Var dataMasked() As UInteger
		  For i As Integer = 0 to payloadSize - 1
		    dataMasked.Add(dataPtr.Byte(dataStartingByte + i))
		  Next i
		  
		  // Unmask the data and store it in the Request body...
		  Body = ""
		  For i As Integer = 0 to payloadSize - 1
		    Body = Body + Chr(dataMasked(i) XOR maskKey(i Mod 4))
		  Next i
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WSMessageSend(message As String)
		  // Sends a WebSocket (text) message to a client.
		  
		  // Get the message length.
		  Var messageLength As UInteger = message.Length
		  
		  // If the entire message can be sent in a single frame...
		  If messageLength < 126 Then
		    Var mb As New MemoryBlock( 2 )
		    mb.Byte( 0 ) = 129
		    mb.Byte( 1 ) = messageLength
		    Write(mb.StringValue( 0, 2 ) + message)
		    Return
		  End If
		  
		  // Due to its length, the message needs to be sent in multiple frames...
		  If messageLength >= 126 and messageLength < 65535 Then
		    Var mb As New MemoryBlock( 4 )
		    mb.Byte( 0 ) = 129
		    mb.Byte( 1 ) = 126
		    mb.Byte( 2 ) = Bitwise.ShiftRight(messageLength, 8) And 255
		    mb.Byte( 3 ) = messageLength And 255
		    Write(mb.StringValue( 0, 4 ) + message)
		    Return
		  End If
		  
		  If messageLength >= 65535 Then
		    Var mb As New MemoryBlock( 10 )
		    mb.Byte( 0 ) = 129
		    mb.Byte( 1 ) = 127
		    mb.Byte( 2 ) = Bitwise.ShiftRight(messageLength, 56) And 255
		    mb.Byte( 3 ) = Bitwise.ShiftRight(messageLength, 48) And 255
		    mb.Byte( 4 ) = Bitwise.ShiftRight(messageLength, 40) And 255
		    mb.Byte( 5 ) = Bitwise.ShiftRight(messageLength, 32) And 255
		    mb.Byte( 6 ) = Bitwise.ShiftRight(messageLength, 24) And 255
		    mb.Byte( 7 ) = Bitwise.ShiftRight(messageLength, 16) And 255
		    mb.Byte( 8 ) = Bitwise.ShiftRight(messageLength, 8) And 255
		    mb.Byte( 9 ) =  messageLength And 255
		    Write(mb.StringValue( 0, 10 ) + message)
		    Return
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XojoScriptsParse()
		  // Determine the number of scripts in the content.
		  Var scripts() As String = Response.Content.Split("<xojoscript>")
		  
		  // If there are no scripts in the content.
		  If scripts.LastIndex = 0 Then
		    Return
		  End If
		  
		  // Create an instance of the XojoScript evaluator.
		  Var evaluator As New XSProcessor
		  
		  // Loop over the XojoScript blocks...
		  Var lastScriptsIndex As Integer = scripts.LastIndex
		  For x As Integer = 0 To lastScriptsIndex
		    
		    // Get the next XojoScript block.
		    evaluator.Source = Express.BlockGet(Response.Content, "<xojoscript>", "</xojoscript>", 0)
		    
		    // Run the XojoScript.
		    evaluator.Run
		    
		    // Replace the block with the result.
		    Response.Content = Express.BlockReplace(Response.Content, "<xojoscript>", "</xojoscript>", 0, evaluator.Result)
		    
		  Next x
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Body As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ContentLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		ContentType As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Cookies As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Custom As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Data As String
	#tag EndProperty

	#tag Property, Flags = &h0
		DataReceivedCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Files As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		GET As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Headers As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		HeadersRaw As String
	#tag EndProperty

	#tag Property, Flags = &h0
		HeadersRawArray() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		HTTPVersion As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IndexFilenames() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		KeepAlive As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		LastConnect As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		MaxEntitySize As Integer = 1048576
	#tag EndProperty

	#tag Property, Flags = &h0
		Method As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Multithreading As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Path As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PathComponents() As String
	#tag EndProperty

	#tag Property, Flags = &h0
		PathItems As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		POST As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Protocol As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ProtocolVersion As String
	#tag EndProperty

	#tag Property, Flags = &h0
		RequestThread As Express.RequestThread
	#tag EndProperty

	#tag Property, Flags = &h0
		Response As Express.Response
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If Self.ServerRef <> Nil And Self.ServerRef.Value <> Nil And ServerRef.Value IsA Express.Server Then
			    Return Express.Server(Self.ServerRef.Value)
			  End If
			  
			  Return Nil
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value = Nil Then
			    Self.ServerRef = Nil
			    Return
			  End If
			  
			  Self.ServerRef = New WeakRef(value)
			End Set
		#tag EndSetter
		Server As Express.Server
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private ServerRef As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h0
		Session As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		SocketID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		StaticPath As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		URLParams As String
	#tag EndProperty

	#tag Property, Flags = &h0
		WSStatus As String = "Inactive"
	#tag EndProperty

	#tag Property, Flags = &h0
		XojoScriptEnabled As Boolean = True
	#tag EndProperty


	#tag Constant, Name = NotFoundContent, Type = String, Dynamic = False, Default = \"<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html>\n<head>\n<title>404 Not Found</title>\n</head>\n<body>\n<h1>Not Found</h1>\n<p>The requested URL [[Path]] was not found on this server.</p>\n<hr>\n<address>[[ServerType]] at [[Host]]</address>\n</body>\n</html>", Scope = Public
	#tag EndConstant

	#tag Constant, Name = XojoScriptAvailable, Type = Boolean, Dynamic = False, Default = \"True", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="SSLConnectionType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="SSLConnectionTypes"
			EditorType="Enum"
			#tag EnumValues
				"1 - SSLv23"
				"3 - TLSv1"
				"4 - TLSv11"
				"5 - TLSv12"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLEnabled"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeepAlive"
			Visible=true
			Group="Behavior"
			InitialValue="3"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CertificatePassword"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLConnected"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLConnecting"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BytesAvailable"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BytesLeftToSend"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastErrorCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Address"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SocketID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Method"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Path"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="URLParams"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HTTPVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Body"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Multithreading"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Data"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HeadersRaw"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaxEntitySize"
			Visible=false
			Group="Behavior"
			InitialValue="1048576"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ContentType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DataReceivedCount"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ContentLength"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="XojoScriptEnabled"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="WSStatus"
			Visible=false
			Group="Behavior"
			InitialValue="Inactive"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Protocol"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ProtocolVersion"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
