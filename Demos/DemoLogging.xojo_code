#tag Module
Protected Module DemoLogging
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Express.Request)
		  // By default, the Request.StaticPath points to an "htdocs" folder.
		  // In this example, we're using an alternate folder.
		  Request.StaticPath = App.ExecutableFile.Parent.Parent.Child("htdocs").Child("demo-logging")
		  
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
		  
		  // Log the request.
		  Dim Logger As New Express.Logger
		  Logger.Folder = App.ExecutableFile.Parent.Parent.Child("logs")
		  Logger.Request = Request
		  Logger.Start
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
