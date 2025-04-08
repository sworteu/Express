#tag Module
Protected Module DemoHelloWorld
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub RequestProcess(request As Express.Request)
		  // By default, the Request.StaticPath points to an "htdocs" folder.
		  // In this example, we're using an alternate folder.
		  request.StaticPath = SpecialFolder.Resources.Child("htdocs").Child("demo-hello-world")
		  
		  // If the request was for the "/hello" path.
		  If request.Path = "/hello" Then
		    
		    // Dynamically generate a response.
		    
		    // Get the current time in RFC1123 format.
		    Var now As String = Express.DateToRFC1123
		    
		    request.Response.Content = "<link rel=""stylesheet"" type=""text/css"" media=""all"" href=""/stylesheets/stylesheet.css"" />" _
		    + "<div class=""pagewrapper"">" _
		    + "<p style=""text-align: center; margin-bottom: 24px;"">" _
		    + "<img src=""/images/aloe-logo-white.png"" width=""200"">" _
		    + "</p>" _
		    + "<h1 style=""text-align: center; font-size: 24pt;"">Hello again!</h1>" _
		    + "<p style=""text-align: center;"">This is a dynamically generated response.</p>" _
		    + "<p style=""text-align: center;"">This is a demo of Express Server " + Express.VERSION_STRING + ".</p>" _
		    + "<p style=""text-align: center;"">You're running Xojo " + XojoVersionString + ".</p>" _
		    + "<p style=""text-align: center;"">The date and time is " + Now + ".</p>" _
		    + "<br><br>" _
		    + "<p style=""text-align: center;""><a href=""/"">Back</a></p>" _
		    + "</div>"
		    
		  ElseIf request.Path = "/express-info" Then
		    // Get Server Info
		    Var serverInstance As Express.Server = request.Server
		    Var info As Dictionary
		    If Not (serverInstance Is Nil) Then info = serverInstance.ServerInfo
		    If (info Is Nil) Then info = New Dictionary
		    
		    Var infoLinesHtml() As String
		    For Each infoKey As Variant In info.Keys
		      infoLinesHtml.Add("<tr><td>" + infoKey.StringValue + "</td><td>" + info.Lookup(infoKey, "n/a").StringValue + "</td></tr>")
		    Next
		    
		    request.Response.Content = "<link rel=""stylesheet"" type=""text/css"" media=""all"" href=""/stylesheets/stylesheet.css"" />" _
		    + "<div class=""pagewrapper"">" _
		    + "<p style=""text-align: center; margin-bottom: 24px;"">" _
		    + "<img src=""/images/aloe-logo-white.png"" width=""200"">" _
		    + "</p>" _
		    + "<h1 style=""text-align: center; font-size: 24pt;"">Express Server Info</h1>" _
		    + "<table class=""gridtable"" width=""100%"">" _
		    + "<tr><th width=""30%"">Info</th><th width=""70%"">Value</th></tr>" _
		    + String.FromArray(infoLinesHtml, "") _
		    + "</table>" _
		    + "<br><br>" _
		    + "<p style=""text-align: center;""><a href=""/"">Back</a></p>" _
		    + "</div>"
		    
		  Else
		    
		    // Map the request to a file.
		    request.MapToFile
		    
		    // If the request couldn't be mapped to a static file...
		    If request.Response.Status = "404" Then
		      
		      // Return the standard 404 error response.
		      // You could also use a custom error handler that sets Request.Response.Content.
		      request.ResourceNotFound
		      
		    Else
		      
		      // Set the Cache-Control header value so that static content is cached for 1 hour.
		      // For ETag testing, you might want to disable sending Cache-Control headers,
		      // or reduce the max-age.
		      request.Response.Headers.Value("Cache-Control") = "public, max-age=3600"
		      
		    End If
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SimplePlainTextResponse(request As Express.Request)
		  request.Response.Content = "Hello, world!"
		  
		End Sub
	#tag EndMethod


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
	#tag EndViewBehavior
End Module
#tag EndModule
