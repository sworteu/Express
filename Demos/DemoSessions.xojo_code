#tag Module
Protected Module DemoSessions
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub RequestProcess(request As Express.Request)
		  // By default, the Request.StaticPath points to an "htdocs" folder.
		  // In this example, we're using an alternate folder.
		  request.StaticPath = SpecialFolder.Resources.Child("htdocs").Child("demo-sessions")
		  
		  // If this is a request for the root...
		  If request.Path = "/" or request.Path = "/index.html" Then
		    Var home As New Home(Request)
		    #Pragma Unused home
		    
		  ElseIf request.Path = "/confidential" Then
		    Var confidential As New Confidential(Request)
		    #Pragma Unused confidential
		    
		  ElseIf request.Path = "/login" Then
		    Var login As New Login(request)
		    #Pragma Unused login
		    
		  Elseif request.Path = "/logout" Then
		    Var logout As New Logout(request)
		    #Pragma Unused logout
		    
		  ElseIf request.Path = "/secret" Then
		    Var secret As New Secret(request)
		    #Pragma Unused secret
		    
		  Elseif request.Path = "/sessions" Then
		    Var sessions As New Sessions(request)
		    #Pragma Unused sessions
		    
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
		      request.Response.Headers.Value("Cache-Control") = "public, max-age=3600"
		      
		    End If
		    
		  End If
		  
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
