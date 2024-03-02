#tag Module
Protected Module DemoTemplatesServerSide
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub RequestProcess(request As Express.Request)
		  // By default, the Request.StaticPath points to an "htdocs" folder.
		  // In this example, we're using an alternate folder.
		  request.StaticPath = Specialfolder.Resources.Child("htdocs").Child("demo-templates-server-side")
		  
		  // Process the request based on the path of the requested resource...
		  If request.Path = "/" or request.Path = "/index.html" Then
		    
		    Var page As New IndexPage
		    page.Request = request
		    page.Generate
		    
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
