#tag Class
Protected Class Response
	#tag Method, Flags = &h0, Description = 44656661756C7420636F6E7374727563746F72207468617420637265617465732061206E657720726573706F6E736520776974682061207765616B207265666572656E636520746F207468652070617373656420726571756573742060726571602E
		Sub Constructor(req As Express.Request)
		  /// Default constructor that creates a new response with a weak reference to the passed request `req`.
		  
		  // Store the request that this response is associated with.
		  mRequest = New WeakRef(req)
		  
		  // Initialize the headers.
		  HeadersInit
		  
		  // Initialize the cookies.
		  Cookies = New Dictionary
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6D707265737365732074686520636F6E74656E74207573696E6720677A69702C20616E64206164647320746865206E6563657373617279206865616465722E
		Sub ContentCompress()
		  /// Compresses the content using gzip, and adds the necessary header.
		  ///
		  /// Source: https://forum.xojo.com/11634-gunzip-without-a-file/0
		  
		  // Compress the content.
		  Content = GZip(Content)
		  
		  // Add a content-encoding header.
		  Headers.Value("Content-Encoding") = "gzip"
		  
		  // Update the Content-Length
		  Headers.Value("Content-Length") = Content.Bytes.ToString
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41646473206120636F6F6B696520746F2074686520696E7465726E616C2060436F6F6B696573602064696374696F6E6172792E
		Sub CookieSet(name As String, value As String, expiration As DateTime = Nil, domain As String = "", path As String = "/", secure As Boolean = False, HttpOnly As Boolean = False)
		  /// Adds a cookie to the internal `Cookies` dictionary.
		  
		  // Create a dictionary for the cookie's settings.
		  Var cookie As New Dictionary
		  cookie.Value("Value") = value
		  cookie.Value("Expiration") = expiration
		  cookie.Value("Domain") = domain
		  cookie.Value("Path") = path
		  cookie.Value("Secure") = secure
		  cookie.Value("HttpOnly") = HttpOnly
		  
		  // Add / replace the cookie.
		  Cookies.Value(name) = cookie
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41646473206120636F6F6B696520746F2074686520696E7465726E616C2060436F6F6B696573602064696374696F6E61727920776974682066696E6520636F6E74726F6C206F766572207468652065787069726174696F6E20646174652F74696D652E
		Sub CookieSet(name As String, value As String, expirationDays As Integer = 0, expirationHours As Integer = 0, expirationMinutes As Integer = 0, expirationSeconds As Integer = 0, domain As String = "", path As String = "/", secure As Boolean = False, HttpOnly As Boolean = False)
		  /// Adds a cookie to the internal `Cookies` dictionary with fine control over the expiration date/time.
		  
		  // Create the cookie's expiration date.
		  Var expirationDate As DateTime = DateTime.Now
		  expirationDate = ExpirationDate.AddInterval( 0, 0, expirationDate.Day + expirationDays, expirationDate.Hour + expirationHours, _
		  expirationDate.Minute + expirationMinutes, expirationDate.Second + expirationSeconds )
		  
		  // Create a dictionary for the cookie's settings.
		  Var cookie As New Dictionary
		  cookie.Value("Value") = value
		  cookie.Value("Expiration") = expirationDate
		  cookie.Value("Domain") = domain
		  cookie.Value("Path") = path
		  cookie.Value("Secure") = secure
		  cookie.Value("HttpOnly") = HttpOnly
		  
		  // Add / replace the cookie.
		  Cookies.Value(name) = cookie
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E7665727473207468652020696E7465726E616C2060436F6F6B696573602064696374696F6E61727920696E746F20612068656164657220737472696E672E
		Private Function CookiesToHeaders() As String
		  /// Converts the  internal `Cookies` dictionary into a header string.
		  
		  Var headersString As String
		  
		  // Loop over the dictionary entries...
		  For Each key As Variant in Cookies.Keys
		    
		    // Get the entry's key and value.
		    Var name As String = key
		    Var settings As Dictionary = Cookies.Value(key)
		    
		    // Create the cookie sting.
		    Var cookieString As String 
		    cookieString = cookieString + URLEncode(name) + "=" + URLEncode(settings.Value("Value")) + "; "
		    
		    If settings.Value("Expiration") <> Nil Then
		      Var expirationDate As String = Express.DateToRFC1123(settings.Value("Expiration"))
		      cookieString = cookieString + "expires=" + expirationDate + "; "
		    End If 
		    
		    If settings.Value("Domain") <> Nil Then
		      cookieString = cookieString + "domain=" + settings.Value("Domain") + "; "
		    End If
		    
		    If settings.Value("Path") <> Nil Then
		      cookieString = cookieString + "path=" + settings.Value("Path") + "; "
		    End If
		    
		    If settings.Value("Secure") Then
		      cookieString = cookieString + "secure; "
		    End If
		    
		    If settings.Value("HttpOnly") Then
		      cookieString = cookieString + "HttpOnly;"
		    End If
		    
		    // Add the string representation of the cookie to the headers string.
		    headersString = headersString _
		    + "Set-Cookie: " + cookieString + EndOfLine.CRLF
		    
		  Next key
		  
		  Return headersString
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44756D70732074686520636F6E74656E74206F66207468697320726573706F6E736520617320616E2048544D4C20737472696E672E
		Function Dump() As String
		  /// Dumps the content of this response as an HTML string.
		  
		  Var html As String
		  
		  html = html + "<p>HTTP Version: " + HTTPVersion + "</p>" + EndOfLine.CRLF
		  
		  html = html + "<p>Headers: " + EndOfLine.CRLF
		  html = html + "<ul>" + EndOfLine.CRLF
		  For Each key As Variant in Headers.keys
		    html = html + "<li>" + Key + "=" + Headers.Value(key) + "</li>"+ EndOfLine.CRLF
		  Next key
		  html = html + "</ul>" + EndOfLine.CRLF
		  html = html + "</p>" + EndOfLine.CRLF
		  
		  html = html + "<p>Response Content...<br /><br />" + Content + "</p>" + EndOfLine.CRLF
		  
		  Return html
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520726573706F6E73652E
		Function Get() As String
		  /// Returns the response.
		  ///
		  /// Called by `Request.ResponseReturn`.
		  
		  // If the content is to be compressed...
		  If Compress = True Then
		    ContentCompress
		  End If
		  
		  // Return the response, including headers and content.
		  Return HeadersToString + CookiesToHeaders + EndOfLine.CRLF + Content
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 53657473207468652064656661756C7420726573706F6E736520686561646572732E
		Private Sub HeadersInit()
		  /// Sets the default response headers.
		  
		  Headers = New Dictionary
		  
		  If Request.KeepAlive = True Then
		    Headers.Value("Connection") = "Keep-Alive"
		  Else 
		    Headers.Value("Connection") = "Close"
		  End If
		  
		  Headers.Value("Content-Language") = "en"
		  Headers.Value("Content-Type") = "text/html; charset=UTF-8"
		  Headers.Value("Date") = DateToRFC1123
		  
		  // Set debug-related headers if applicable...
		  #If DebugBuild Then
		    Headers.Value("X-Express-Version") = Express.VERSION_STRING
		    Headers.Value("X-Host") = Request.Headers.Lookup("Host", "")
		    Headers.Value("X-Last-Connect") = Request.LastConnect.SQLDateTime
		    Headers.Value("X-Socket-ID") = Request.SocketID
		    Headers.Value("X-Xojo-Version") = XojoVersionString
		    Headers.Value("X-Server-Active-Conns") = Request.Server.ActiveConnections.Count.ToString
		    Headers.Value("X-Server-Port") = Request.Server.Port
		  #Endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E76657274732074686520726573706F6E73652060486561646572736020746F206120737472696E67
		Private Function HeadersToString() As String
		  /// Converts the response `Headers` to a string
		  
		  // This is the string that will be returned.
		  Var rh As String
		  
		  // Define the encoding for the response headers.
		  rh = rh.DefineEncoding(Encodings.UTF8)
		  
		  // Add the initial header.
		  RH = "HTTP/" + HTTPVersion + " " + Status + EndOfLine.CRLF
		  
		  // Specify the content length.
		  Headers.Value("Content-Length") = Content.Bytes.ToString
		  
		  // Loop over the dictionary entries...
		  For Each key As Variant in Headers.Keys
		    
		    If key = "" Or Headers.Value(key).StringValue = "" Then
		      Continue
		    End If
		    
		    // Add the value.
		    RH = RH + Key + ": " + Headers.Value(Key).StringValue + EndOfLine.CRLF
		    
		  Next key
		  
		  Return rh
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 47656E657261746573207468652048544D4C206E656564656420746F20646F2061204D657461205265667265736820746F2061207370656369666965642055524C2C2077686963682072656469726563747320746865207573657220746F2061206E6577206C6F636174696F6E2E2060436F6E74656E7460206973207570646174656420616E642060537461747573602069732073657420746F203230302E
		Sub MetaRefresh(URL As String)
		  /// Generates the HTML needed to do a Meta Refresh to a specified URL,
		  /// which redirects the user to a new location.
		  /// `Content` is updated and `Status` is set to 200.
		  
		  // Update the status code.
		  Status = "200"
		  
		  // Update the content.
		  Content = "<html xmlns=""http://www.w3.org/1999/xhtml"">" _
		  + "<head>" _
		  + "<title>Redirecting...</title>" _
		  + "<meta http-equiv=""refresh"" content=""0;URL='" + URL + "'"" />" _
		  + "</head>" _
		  + "<body style=""background: #fff;"">" _
		  + "</body>" _
		  + "</html>"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207375676765737465642073656375726974792D72656C6174656420686561646572732E
		Sub SecurityHeadersSet()
		  /// Sets suggested security-related headers.
		  ///
		  /// For guidance, see:
		  /// https://content-security-policy.com/
		  /// https://wiki.mozilla.org/Security/Guidelines/Web_Security
		  
		  Headers.Value("Content-Security-Policy") = "default-src 'none'; connect-src 'self'; frame-ancestors 'none'; img-src 'self'; script-src 'self'; style-src 'unsafe-inline' 'self';"
		  Headers.Value("Referrer-Policy") = "no-referrer, strict-origin-when-cross-origin"
		  Headers.Value("Strict-Transport-Security") = "max-age=63072000"
		  Headers.Value("X-Content-Type-Options") = "nosniff"
		  Headers.Value("X-Frame-Options") = "DENY"
		  Headers.Value("X-XSS-Protection") = "1; mode=block"
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 547275652069662074686520726573706F6E736520636F6E74656E742073686F756C6420626520636F6D707265737365642E
		Compress As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520726573706F6E736520636F6E74656E742E
		Content As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320726573706F6E7365277320636F6F6B6965732E204B6579203D20636F6F6B6965206E616D652028537472696E67292C2056616C7565203D2044696374696F6E6172792E
		Cookies As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		GMTOffset As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520726573706F6E736520686561646572732E204B6579203D20537472696E672C2056616C7565203D20537472696E672E
		Headers As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520485454502076657273696F6E2E
		HTTPVersion As String = "1.1"
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41207765616B207265666572656E636520746F207468697320726573706F6E7365277320726571756573742E
		Private mRequest As WeakRef
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21, Description = 41207765616B207265666572656E636520746F207468697320726573706F6E7365277320726571756573742E
		#tag Getter
			Get
			  If mRequest <> Nil And mRequest.Value <> Nil Then
			    Return Express.Request(mRequest.Value)
			  End If
			  
			  Return Nil
			  
			End Get
		#tag EndGetter
		Private Request As Express.Request
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 74686520726573706F6E7365207374617475732E
		Status As String = "200 OK"
	#tag EndProperty


	#tag ViewBehavior
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
			InitialValue="-2147483648"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Content"
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
			InitialValue="1.1"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Status"
			Visible=false
			Group="Behavior"
			InitialValue="200 OK"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Compress"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="GMTOffset"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
