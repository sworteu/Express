#tag Module
Protected Module DemoSessions
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Express.Request)
		  // By default, the Request.StaticPath points to an "htdocs" folder.
		  // In this example, we're using an alternate folder.
		  Request.StaticPath = App.ExecutableFile.Parent.Child("htdocs").Child("demo-sessions")
		  
		  // If this is a request for the root...
		  If Request.Path = "/" or Request.Path = "/index.html" Then
		    Var Home As New Home(Request)
		    #Pragma Unused Home
		    
		  ElseIf Request.Path = "/confidential" Then
		    Var Confidential As New Confidential(Request)
		    #Pragma Unused Confidential
		    
		  ElseIf Request.Path = "/login" Then
		    Var Login As New Login(Request)
		    #Pragma Unused Login
		    
		  Elseif Request.Path = "/logout" Then
		    Var Logout As New Logout(Request)
		    #Pragma Unused Logout
		    
		  ElseIf Request.Path = "/secret" Then
		    Var Secret As New Secret(Request)
		    #Pragma Unused Secret
		    
		  Elseif Request.Path = "/sessions" Then
		    Var Sessions As New Sessions(Request)
		    #Pragma Unused Sessions
		    
		  Else
		    
		    // Map the request to a file.
		    Request.MapToFile
		    
		    // If the request couldn't be mapped to a static file...
		    If Request.Response.Status = "404" Then
		      
		      // Return the standard 404 error response.
		      // You could also use a custom error handler that sets Request.Response.Content.
		      Request.ResourceNotFound
		      
		    Else
		      
		      // Set the Cache-Control header value so that static content is cached for 1 hour.
		      Request.Response.Headers.Value("Cache-Control") = "public, max-age=3600"
		      
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
