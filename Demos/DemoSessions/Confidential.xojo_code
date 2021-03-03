#tag Class
Protected Class Confidential
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub Constructor(Request As Express.Request)
		  // Store the request instance so that it can be used throughout the class.
		  Self.Request = Request
		  
		  // Get a session.
		  Request.SessionGet
		  
		  // If the user has not been authenticated...
		  If Request.Session.Lookup("Authenticated", False) = False Then
		    Request.Response.MetaRefresh("/login")
		    Return
		  End If
		  
		  
		  // Create a folderitem that points to the template file.
		  Dim FI as FolderItem = Request.StaticPath.Child("protected").Child("confidential.pdf")
		  
		  
		  // Use Aloe's FileRead method to load the file.
		  Dim PDFContent As String = Express.FileRead(FI)
		  
		  
		  // Update the response content.
		  Request.Response.Content = PDFContent
		  
		  
		  // Specify the mime type using the Content-Type header.
		  Request.Response.Headers.Value("Content-Type") = Express.MIMETypeGet("pdf")
		  
		  
		  // Specify the filename using the Content-Disposition header.
		  Request.Response.Headers.Value("Content-Disposition") = "inline; filename=confidential.pdf"
		  
		  
		  // Update the request status code.
		  Request.Response.Status = "200"
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Request As Express.Request
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
	#tag EndViewBehavior
End Class
#tag EndClass
