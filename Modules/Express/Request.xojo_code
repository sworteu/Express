#tag Class
Protected Class Request
Inherits SSLSocket
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Event
		Sub Connected()
		  // A connection has been made to one of the sockets.
		  // The request's data will be read, and when that's complete, the DataAvailable event will occur.
		  // We are implementing this to prevent it be handled by the user.
		End Sub
	#tag EndEvent

	#tag Event
		Sub DataAvailable()
		  /// Data has been received.
		  
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
		  
		  // Is the server using threads?
		  If Multithreading Then
		    
		    // Hand the request off to a RequestThread instance for processing.
		    RequestThread = New Express.RequestThread
		    RequestThread.Request = Self
		    RequestThread.Start
		    Return
		    
		  End If
		  
		  // Process the request immediately, on the primary thread.
		  Process
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub Error(err As RuntimeException)
		  /// An error occurred with the socket.
		  ///
		  /// Typically, this will be a 102 error, where the client has closed the connection.
		  
		  Select Case err.ErrorNumber
		    
		  Case 102
		    
		    System.DebugLog "Socket " + SocketID.totext + ": Disconnected / LostConnection"
		    
		    If Multithreading And (Me.RequestThread <> Nil) And (Me.RequestThread.ThreadState <> Thread.ThreadStates.NotRunning) Then
		      System.DebugLog "Socket " + SocketID.totext + ": Killing RequestThread"
		      Me.RequestThread.Stop
		    End If
		    
		    Me.Close
		    
		  Else
		    
		    System.DebugLog "Socket " + SocketID.ToString + " Error: " + err.ErrorNumber.ToString
		    
		  End Select
		  
		  If err.ErrorNumber <> 102 Then
		    
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub SendComplete(UserAborted As Boolean)
		  /// The response has been sent back to the client.
		  
		  #Pragma Unused UserAborted
		  
		  // If persistent connections are disabled...
		  If KeepAlive = False Then
		    // Close the connection.
		    Close
		    Return
		  End If
		  
		  // If this was a multipart form...
		  If ContentType.Split("multipart/form-data").LastIndex = 1 Then
		    // Close the connection.
		    Close
		    Return
		  End If
		  
		  // Reset the socket's properties.
		  Reset
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21, Description = 4765747320746865207265717565737420626F64792E
		Private Sub BodyGet()
		  /// Gets the request body.
		  
		  // Split the data into headers and the body.
		  Var requestParts() As String = Data.Split(EndOfLine.Windows + EndOfLine.Windows)
		  
		  // We no longer need the data that was received, so clear it.
		  Data = ""
		  
		  // If we were unable to split the data into a header and body...
		  If requestParts.LastIndex < 0 Then
		    Return
		  End If
		  
		  // If request parts contains two rows - Normally this would be the header and the body split.
		  // Remove the header part.
		  If requestParts.LastIndex >= 1 Then
		    requestParts.RemoveAt(0)
		  End If
		  
		  // If what should be the body is not = Content-Length, don't set the body value.
		  If requestParts(0).Bytes <> ContentLength Then
		    Return
		  End If
		  
		  // Merge the remaining parts to form the entire request body.
		  Body = String.FromArray(requestParts, EndOfLine.Windows + EndOfLine.Windows)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4576616C756174657320746865207265717565737420626F647920746F206372656174652064696374696F6E617269657320726570726573656E74696E6720616E7920504F5354207661726961626C657320616E642F6F722066696C657320746861742068617665206265656E2073656E742E
		Private Sub BodyProcess()
		  /// Evaluates the request body to create dictionaries representing any POST variables 
		  /// and/or files that have been sent.
		  
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

	#tag Method, Flags = &h0, Description = 436C6F7365732074686520736F636B657420616E642072657365747320637573746F6D2070726F706572746965732E
		Sub Close()
		  /// Closes the socket and resets custom properties.
		  
		  System.DebugLog "Socket " + SocketID.totext + ": Close"
		  
		  Reset
		  
		  Path = ""
		  
		  WSStatus = "Inactive"
		  
		  Super.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44656661756C7420636F6E7374727563746F722E
		Sub Constructor(server As Express.Server)
		  /// Default constructor.
		  
		  // Associate this request (socket) with its server.
		  Self.Server = server
		  
		  // Inherit properties from the server.
		  Multithreading = server.Multithreading
		  SSLEnabled = server.Secure
		  SSLConnectionType = server.ConnectionType
		  CertificateFile = server.CertificateFile
		  CertificatePassword = server.CertificatePassword
		  MaxEntitySize = server.MaxEntitySize
		  KeepAlive = server.KeepAlive
		  
		  // Call the overridden superclass constructor.
		  Super.Constructor
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 476574732074686520436F6E74656E742D4C656E677468206865616465722E
		Sub ContentLengthGet()
		  /// Gets the Content-Length header.
		  
		  If Headers.HasKey("Content-Length") Then
		    ContentLength = Headers.Value("Content-Length")
		  Else
		    ContentLength = 0
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4372656174657320616E20696E7465726E616C2064696374696F6E61727920726570726573656E74696E6720746865207265717565737420636F6F6B6965732E
		Private Sub CookiesDictionaryCreate()
		  /// Creates an internal dictionary representing the request cookies.
		  ///
		  /// The cookies are delivered as a request header, like this:
		  /// Cookie: x=12; y=124
		  
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

	#tag Method, Flags = &h21, Description = 4765747320746865207265717565737420646174612E
		Private Sub DataGet()
		  /// Gets the request data.
		  
		  Data = ReadAll(Encodings.UTF8)
		  Data = Data.DefineEncoding(Encodings.UTF8)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44756D70732074686973207265717565737420617320616E2048544D4C20737472696E672E
		Function Dump() As String
		  /// Dumps this request as an HTML string.
		  
		  Var html() As String
		  
		  html.Add("<p>Method: " + Method + "</p>")
		  html.Add("<p>Path: " + Path + "</p>")
		  html.Add("<p>Path Components: ")
		  html.Add("<ul>")
		  If PathComponents.Count > 0 Then
		    For i As Integer = 0 to PathComponents.LastIndex
		      html.Add("<li>" + i.ToString + ". " + PathComponents(i) + "</li>")
		    Next i
		  Else
		    html.Add("<li>None</li>")
		  End If
		  html.Add("</ul>")
		  html.Add("</p>")
		  
		  html.Add("<p>HTTP Version: " + HTTPVersion + "</p>")
		  html.Add("<p>Remote Address: " + RemoteAddress + "</p>")
		  html.Add("<p>Socket ID: " + SocketID.ToString + "</p>")
		  
		  html.Add("<p>Headers: ")
		  html.Add("<ul>")
		  
		  If Headers.KeyCount > 0 Then
		    For Each key As Variant in Headers.Keys
		      html.Add("<li>" + key + "=" + Headers.Value(key) + "</li>")
		    Next key
		  Else
		    html.Add("<li>None</li>")
		  End If
		  html.Add("</ul>" )
		  html.Add("</p>" )
		  
		  html.Add("<p>Cookies: " )
		  html.Add("<ul>" )
		  If Cookies.KeyCount > 0 Then
		    For Each key As Variant in Cookies.Keys
		      html.Add("<li>" + Key + "=" + Cookies.Value(key) + "</li>")
		    Next key
		  Else
		    html.Add("<li>None</li>")
		  End If
		  html.Add("</ul>" )
		  html.Add("</p>" )
		  
		  html.Add("<p>GET Params: " )
		  html.Add("<ul>" )
		  If GET.KeyCount > 0 Then
		    For Each key As Variant in GET.Keys
		      html.Add("<li>" + key + "=" + GET.Value(key) + "</li>")
		    Next key
		  Else
		    html.Add("<li>None</li>")
		  End If
		  html.Add("</ul>" )
		  html.Add("</p>" )
		  
		  html.Add("<p>POST Params: " )
		  html.Add("<ul>" )
		  If POST.KeyCount > 0 Then
		    For Each key As Variant in POST.Keys
		      html.Add("<li>" + key + "=" + POST.Value(key) + "</li>")
		    Next key
		  Else
		    html.Add("<li>None</li>")
		  End If
		  html.Add("</ul>" )
		  html.Add("</p>" )
		  
		  html.Add("<p>Body:<br /><br />" )
		  If Body <> "" Then
		    html.Add(Body)
		  Else
		    html.Add("None")
		  End If
		  html.Add(Body + "</p>" )
		  
		  Return String.FromArray(html, EndOfLine.Windows)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4372656174657320616E20696E7465726E616C2064696374696F6E61727920726570726573656E74696E67207468652055524C20706172616D732E
		Private Sub GETDictionaryCreate()
		  /// Creates an internal dictionary representing the URL params.
		  ///
		  /// When multiple values are passed for the same key, the dictionary entry is treated as an array of strings.
		  /// Example: 
		  ///  a=1&b=2&a=3&b=4&a=5&c=678
		  
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

	#tag Method, Flags = &h21, Description = 4372656174657320616E20696E7465726E616C2064696374696F6E61727920726570726573656E74696E6720746865207265717565737420686561646572732E
		Private Sub HeadersDictionaryCreate()
		  /// Creates an internal dictionary representing the request headers.
		  ///
		  /// Note that "header 0" is actually the method, path, etc.
		  
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

	#tag Method, Flags = &h21, Description = 4765747320616E6420736574732074686520485454502076657273696F6E2066726F6D207468652066697273742048656164657273526177417272617920656C656D656E742E
		Private Sub HTTPVersionGet()
		  /// Gets and sets the HTTP version from the first HeadersRawArray element.
		  ///
		  /// Example: 
		  ///   POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  // Get the first header.
		  Var header As String = HeadersRawArray(0)
		  
		  // Get the HTTP version that was used to make the request.
		  HTTPVersion = header.NthField(" ", 3).NthField("/", 2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536574732074686520696E7465726E616C204B656570416C6976652070726F70657274792E
		Sub KeepAliveGet()
		  /// Sets the internal KeepAlive property.
		  
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

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit)), Description = 417474656D70747320746F206D61702061207265717565737420746F2061207374617469632066696C652E
		Sub MapToFile(useETags As Boolean = True)
		  /// Attempts to map a request to a static file.
		  
		  // Assume that the requested resource will not be found.
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

	#tag Method, Flags = &h21, Description = 47657420746865206D6574686F642066726F6D207468652066697273742048656164657273526177417272617920656C656D656E7420616E6420736574732074686520696E7465726E616C20604D6574686F64602070726F70657274792E
		Private Sub MethodGet()
		  /// Get the method from the first HeadersRawArray element and sets the internal `Method` property.
		  ///
		  /// Example:
		  ///  POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  // Get the first header.
		  Var header As String = HeadersRawArray(0)
		  
		  // Get the request method.
		  Method = header.NthField(" ", 1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 48616E646C652061206D756C74697061727420666F726D2E
		Private Sub MultipartFormHandle()
		  /// Handle a multipart form.
		  
		  // Split the content type at the boundary.
		  Var contentTypeParts() As String = ContentType.Split("boundary=")
		  
		  // Does the content have a boundary?
		  If contentTypeParts.LastIndex < 1 Then
		    Return
		  End If
		  
		  // Get the boundary.
		  Var boundary As String = contentTypeParts(1)
		  
		  // Split the content into parts based on the boundary.
		  Var parts() As String = Body.Split("--" + boundary)
		  
		  // Loop over the parts, skipping the header.
		  Var lastPartsIndex As Integer = parts.LastIndex
		  For i As Integer = 1 To lastPartsIndex
		    
		    // Split the part into its header and content.
		    Var partComponents() As String = parts(i).Split(EndOfLine.Windows + EndOfLine.Windows)
		    
		    // If this part has no content then continue.
		    If partComponents.LastIndex < 1 Then
		      Continue
		    End If
		    
		    // Get the part content.
		    Var partContent As String = partComponents(1)
		    
		    // Additional info about the part will be stored in these variables.
		    Var fieldname As String
		    Var filename As String
		    Var fileContentType As String
		    Var fieldIsAFile As Boolean = False
		    
		    // Split the part headers into an array.
		    // Example Header:
		    //   Content-Disposition: form-data; name="file1"; filename="woot.png"
		    //   Content-Type: image/png
		    Var partHeaders() As String = partComponents(0).Split(EndOfLine.Windows)
		    
		    // Loop over the part headers.
		    For Each partHeader As String In partHeaders
		      
		      // If this part header is empty.
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
		          
		          // Field name?
		          If nameValue(0) = "name" Then
		            Fieldname = nameValue(1).ReplaceAll("""", "")
		          End If
		          
		          // File name?
		          If nameValue(0) = "filename" Then
		            fieldIsAFile = True
		            filename = nameValue(1).ReplaceAll("""", "")
		          End If
		          
		        Next dispPart
		        
		      End If
		      
		    Next partHeader
		    
		    // If we couldn't get a field name from the part.
		    If fieldname = "" Then
		      Continue
		    End If
		    
		    // If this is a file.
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

	#tag Method, Flags = &h21, Description = 536574732074686520696E7465726E616C206050617468436F6D706F6E656E7473602070726F70657274792E
		Private Sub PathComponentsGet()
		  /// Sets the internal `PathComponents` property.
		  
		  // Create the path components by splitting the Path.
		  PathComponents = Path.Split("/")
		  
		  // Remove the first component, because it's a blank that appears before the first /.
		  If PathComponents.LastIndex > -1 Then
		    PathComponents.RemoveAt(0)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4765742074686520706174682066726F6D207468652066697273742048656164657273526177417272617920656C656D656E7420616E6420736574732074686520696E7465726E616C206050617468602070726F70657274792E
		Private Sub PathGet()
		  /// Get the path from the first HeadersRawArray element and sets the internal `Path` property.
		  ///
		  /// Example:
		  ///   POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  // Get the first header.
		  Var header As String = HeadersRawArray(0)
		  
		  // Get the request path.
		  Path = header.NthField(" ", 2).NthField("?", 1)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4372656174657320616E20696E7465726E616C2064696374696F6E61727920726570726573656E74696E6720746865207061746820636F6D706F6E656E74732028506174684974656D73292E
		Private Sub PathItemsGet()
		  /// Creates an internal dictionary representing the path components (PathItems).
		  
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

	#tag Method, Flags = &h0, Description = 50726570617265732061206E6577207265717565737420666F722070726F63657373696E672E20546869732069732063616C6C6564206F6E63652070657220726571756573742C207768656E20746865206669727374206261746368206F66206461746120697320726563656976656420766961207468652044617461417661696C61626C65206576656E742E
		Sub Prepare()
		  /// Prepares a new request for processing.
		  /// This is called once per request, when the first batch of data is received via the DataAvailable event.
		  
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
		  
		  // Initlialise the `Custom` dictionary.
		  Custom = New Dictionary
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Process()
		  /// Processes a request.
		  /// Called (1) by a RequestThread's Run event handler, if multithreading is enabled and 
		  /// (2) by the DataAvailable event handler, if multithreading is disabled.
		  
		  Try
		    // Create the POST and Files dictionaries.
		    BodyProcess
		    
		    // Hand the request off to the RequestHandler.
		    App.RequestHandler(Self, Self.Response)
		    
		  Catch err As ThreadEndException
		    
		    //RequestThread has been killed
		    DataReceivedCount = 0
		    Return
		    
		  Finally
		    
		    // Return the response.
		    ResponseReturn
		    
		    // Reset the data received counter. 
		    DataReceivedCount = 0
		    
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 47657473207468652070726F746F636F6C2066726F6D207468652066697273742048656164657273526177417272617920656C656D656E7420616E64207365747320746865206050726F746F636F6C6020616E64206050726F746F636F6C56657273696F6E602070726F706572746965732E
		Private Sub ProtocolGet()
		  /// Gets the protocol from the first HeadersRawArray element and sets the `Protocol` and `ProtocolVersion` properties.
		  // Example: POST /?a=123&b=456&c=999 HTTP/1.1
		  
		  // Get the first header.
		  Var header As String = HeadersRawArray(0)
		  
		  // Get the protocol that was used to make the request.
		  Protocol = header.NthField(" ", 3).NthField("/", 1)
		  ProtocolVersion = header.NthField(" ", 3).NthField("/", 2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5265736574732074686520736F636B65742070726F706572746965732061667465722061207265717565737420686173206265656E2070726F6365737365642E
		Sub Reset()
		  /// Resets the socket properties after a request has been processed.
		  ///
		  /// Note that these properties are not reset because they are used to service WebSockets:
		  /// - Custom
		  /// - Path
		  
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
		  RequestThread = Nil
		  Session = Nil
		  StaticPath = Nil
		  URLParams = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657427732074686520726573706F6E73652073746174757320746F2034303420224E6F7420466F756E642220616E642074686520636F6E74656E7420746F207468652048544D4C2077697468696E2074686520604E6F74466F756E64436F6E74656E746020636F6E7374616E742E
		Sub ResourceNotFound()
		  /// Set's the response status to 404 "Not Found" and the content to the 
		  /// HTML within the `NotFoundContent` constant.
		  
		  // Set the response content.
		  Response.Content = NotFoundContent
		  Response.Content = Response.Content.ReplaceAll("[[ServerType]]", "Xojo/" + XojoVersionString + "+ Express/" + Express.VERSION_STRING)
		  Response.Content = Response.Content.ReplaceAll("[[Host]]", Headers.Lookup("Host", ""))
		  Response.Content = Response.Content.ReplaceAll("[[Path]]", Path)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4576616C756174657320746865207265717565737420746F2064657465726D696E652069662074686520726573706F6E73652073686F756C6420626520636F6D707265737365642E
		Private Sub ResponseCompressDefault()
		  /// Evaluates the request to determine if the response should be compressed.
		  
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

	#tag Method, Flags = &h0, Description = 52657475726E2074686520726573706F6E73652E
		Sub ResponseReturn()
		  /// Return the response.
		  
		  // If the socket is still connected, try to write the response.
		  If IsConnected Then
		    
		    Try
		      
		      Write(Response.Get)
		      
		    Catch e As RunTimeException
		      
		      Var typeInfo As Introspection.TypeInfo = Introspection.GetType(e)
		      
		      System.DebugLog "ResponseReturn Exception: Socket " + SocketID.ToString _
		      + ", Last Error: " + LastErrorCode.ToString _
		      + ", Exception Type: " + typeInfo.Name
		      
		    End Try
		    
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4765747320612073657373696F6E20666F7220746865207265717565737420616E64206173736F636961746573206974207769746820746865206053657373696F6E602070726F70657274792E
		Sub SessionGet(assignNewID As Boolean = True)
		  /// Gets a session for the request and associates it with the `Session` property.
		  
		  Session = Server.SessionEngine.SessionGet(Self, assignNewID)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5465726D696E61746573207468652063757272656E742073657373696F6E2E
		Sub SessionTerminate()
		  /// Terminates the current session.
		  
		  If Session <> Nil Then
		    Server.SessionEngine.SessionTerminate(Session)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 53706C6974732074686520636F6E74656E7420737472696E6720696E746F20616E206172726179206F6620737472696E677320616E642075706461746573207468652060504F5354602064696374696F6E6172792070726F70657274792E
		Private Sub URLEncodedFormHandle()
		  /// Splits the content string into an array of strings and updates the `POST` dictionary property.
		  ///
		  /// Example: 
		  ///   a=123&b=456&c=999
		  
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

	#tag Method, Flags = &h21, Description = 4765742074686520706172616D65746572732066726F6D207468652066697273742048656164657273526177417272617920656C656D656E7420616E64207365747320746865206055524C506172616D73602070726F70657274792E
		Private Sub URLParamsGet()
		  /// Get the parameters from the first HeadersRawArray element and sets the `URLParams` property.
		  ///
		  /// Example:
		  ///  POST /?a=123&b=456&c=999 HTTP/1.1
		  ///
		  /// Note that it's also possible for a parameter to include a question mark in it:
		  ///   GET /?a=1234?format%3D1500w&MaxHeight=50 HTTP/1.1
		  
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

	#tag Method, Flags = &h0, Description = 436C6F736573207468697320776562736F636B657420636F6E6E656374696F6E2E
		Sub WSConnectionClose()
		  /// Closes this websocket connection.
		  
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

	#tag Method, Flags = &h0, Description = 506572666F726D7320616E206F70656E696E6720576562536F636B65742068616E647368616B652C2073657473206057535374617475736020616E64207265676973746572732074686520736F636B657420696E207468652060576562536F636B657473602061727261792E
		Sub WSHandshake()
		  /// Performs an opening WebSocket handshake, sets `WSStatus` and registers the socket in the `WebSockets` array.
		  
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

	#tag Method, Flags = &h0, Description = 50726F636573736573206120576562536F636B6574206D6573736167652E
		Sub WSMessageGet()
		  /// Processes a WebSocket message.
		  
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

	#tag Method, Flags = &h0, Description = 53656E6473206120576562536F636B657420287465787429206D65737361676520746F206120636C69656E742E
		Sub WSMessageSend(message As String)
		  /// Sends a WebSocket (text) message to a client.
		  
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

	#tag Method, Flags = &h0, Description = 4576616C75617465732074686520636F6E74656E74206F6620603C786F6A6F7363726970743E3C2F786F6A6F7363726970743E6020617320586F6A6F5363726970742C207265706C6163696E672074686520636F6E74656E7420776974682074686520726573756C7473206F6620746865207363726970742E
		Sub XojoScriptsParse()
		  #If XojoScriptAvailable Then
		    
		    // Evaluates the content of `<xojoscript></xojoscript>` as XojoScript,
		    // replacing the content with the results of the script.
		    
		    // Determine the number of scripts in the content.
		    Var scripts() As String = Response.Content.Split("<xojoscript>")
		    
		    // If there are no scripts in the content.
		    If scripts.LastIndex = 0 Then
		      Return
		    End If
		    
		    // Create an instance of the XojoScript evaluator.
		    Var evaluator As New XSProcessor
		    
		    // Loop over the XojoScript blocks.
		    Var lastScriptsIndex As Integer = scripts.LastIndex
		    For x As Integer = 0 To lastScriptsIndex
		      
		      // Get the next XojoScript block.
		      evaluator.Source = Express.BlockGet(Response.Content, "<xojoscript>", "</xojoscript>", 0)
		      
		      // Run the XojoScript.
		      evaluator.Run
		      
		      // Replace the block with the result.
		      Response.Content = Express.BlockReplace(Response.Content, "<xojoscript>", "</xojoscript>", 0, evaluator.Result)
		      
		    Next x
		    
		  #EndIf
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520626F6479206F662074686520726571756573742E
		Body As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652073697A65206F6620746865206461746120696E2074686520626F64792E
		ContentLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520636F6E74656E7420747970652E
		ContentType As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207265717565737420636F6F6B69657320284B6579203D20537472696E672C2056616C7565203D20537472696E67292E
		Cookies As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5573656420746F2073746F7265206170702D737065636966696320696E666F726D6174696F6E20666F72206120726571756573742C207768696368207065727369737473206265747765656E207265717565737473207768656E2074686520736F636B6574206973206265696E672068656C64206F70656E2E20496E697469616C6973656420696E207468652060526571756573742E50726570617265282960206D6574686F642E
		Custom As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207265717565737420646174612E
		Data As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F662074696D657320746865206044617461417661696C61626C6560206576656E742068617320666972656420666F72207468697320726571756573742E
		DataReceivedCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5768657265206120666F726D20686173206265656E207375626D697474656420776869636820696E636C75646564202266696C652220696E707574206669656C64732C20746869732044696374696F6E61727920697320757365642E204B6579203D206669656C64206E616D652E2056616C7565203D2044696374696F6E6172792028776869636820696E636C75646573206B65792F76616C756520706169727320666F72207468652066696C656E616D652C20636F6E74656E7420747970652C20636F6E74656E74206C656E6774682C20657463292E
		Files As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416E792055524C20706172616D65746572732070617373656420284B6579203D20537472696E672C2056616C7565203D20537472696E67292E
		GET As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207265717565737420686561646572732E204B6579203D20537472696E672C2056616C7565203D20537472696E672E
		Headers As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652072617720686561646572732E
		HeadersRaw As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416E206172726179207768657265206561636820656E7472792069732061207261772068656164657220737472696E672E
		HeadersRawArray() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520485454502076657273696F6E207468617420776173207573656420746F206D616B652074686520726571756573742E
		HTTPVersion As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416E206172726179206F66207468652076616C756520696E6465782048544D4C2066696C65206E616D65732E
		IndexFilenames() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 576865746865722074686520636F6E6E656374696F6E2073686F756C64206265206B65707420616C6976652E
		KeepAlive As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865204461746554696D65206F6620746865206C617374206044617461417661696C61626C6560206576656E742E2054686973206973207573656420746F2064657465726D696E652069662061204B6565702D416C697665206F7220576562536F636B657420636F6E6E656374696F6E206861732074696D6564206F75742E
		LastConnect As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5573656420746F206C696D6974207468652073697A65206F662061207265717565737420626F64792E2048656C7066756C207768656E20796F752077616E7420746F206C696D6974207468652073697A65200A6F662066696C652075706C6F6164732E2042792064656661756C742C20746869732069732073657420746F2031304D62202831303438353736302062697473292E
		MaxEntitySize As Integer = 1048576
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652072657175657374206D6574686F642E
		Method As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41207765616B207265666572656E636520746F207468697320726571756573742773207365727665722E
		Private mServerRef As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 496E686572697465642066726F6D20746865207365727665722E2057686574686572206F72206E6F74206D756C7469746872656164696E672073686F756C64206265207573656420666F7220726571756573742070726F63657373696E672E
		Multithreading As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207265717565737420706174682E
		Path As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520636F6D706F6E656E7473206F66207468652072657175657374277320706174682E
		PathComponents() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207061746820636F6D706F6E656E74732073706C697420627920696E6465782E204B6579203D20496E74656765722C2056616C7565203D20706174686F20636F6D706F6E656E742028537472696E67292E
		PathItems As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4B6579203D20537472696E672C2056616C7565203D20537472696E672E
		POST As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652070726F746F636F6C207573656420746F206D616B652074686520726571756573742E
		Protocol As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652070726F746F636F6C2076657273696F6E207468617420776173207573656420746F206D616B652074686520726571756573742E
		ProtocolVersion As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686973207265717565737427732070726F63657373696E67207468726561642E
		RequestThread As Express.RequestThread
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520726573706F6E736520696E7374616E63652E
		Response As Express.Response
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 41207765616B207265666572656E636520746F207468697320726571756573742773207365727665722E
		#tag Getter
			Get
			  If mServerRef <> Nil And mServerRef.Value <> Nil And mServerRef.Value IsA Express.Server Then
			    Return Express.Server(mServerRef.Value)
			  End If
			  
			  Return Nil
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value = Nil Then
			    mServerRef = Nil
			    Return
			  End If
			  
			  mServerRef = New WeakRef(value)
			End Set
		#tag EndSetter
		Server As Express.Server
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54686973207265717565737427732073657373696F6E2E
		Session As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320736F636B657427732049442E
		SocketID As UInteger
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C6F636174696F6E206F66207374617469632066696C65732E
		StaticPath As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207261772055524C20706172616D65746572732E
		URLParams As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520576562536F636B6574207374617475732E20456974686572202241637469766522206F722022496E616374697665222E
		WSStatus As String = "Inactive"
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E2074686520636F6E74656E7473206F66203C786F6A6F7363726970743E20746167732077696C6C206265206576616C756174656420617320586F6A6F5363726970742E20486173206E6F206566666563742069662074686520707269766174652070726F706572747920586F6A6F536372697074417661696C61626C652069732046616C73652E
		XojoScriptEnabled As Boolean = True
	#tag EndProperty


	#tag Constant, Name = NotFoundContent, Type = String, Dynamic = False, Default = \"<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html>\n<head>\n<title>404 Not Found</title>\n</head>\n<body>\n<h1>Not Found</h1>\n<p>The requested URL [[Path]] was not found on this server.</p>\n<hr>\n<address>[[ServerType]] at [[Host]]</address>\n</body>\n</html>", Scope = Public, Description = 5468652048544D4C20636F6E74656E74206F66207468652034303420706167652E
	#tag EndConstant

	#tag Constant, Name = XojoScriptAvailable, Type = Boolean, Dynamic = False, Default = \"True", Scope = Private, Description = 49662054727565207468656E2074686520586F6A6F536372697074206672616D65776F726B20697320696E636C7564656420636F6E646974696F6E616C6C7920617420636F6D70696C6174696F6E20696E20526571756573742E4D6170546F46696C652E
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
			Type="UInteger"
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
