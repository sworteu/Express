#tag Class
Protected Class Confidential
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub Constructor(request As Express.Request)
		  // Store the request instance so that it can be used throughout the class.
		  Self.Request = request
		  
		  // Get a session.
		  request.SessionGet
		  
		  // If the user has not been authenticated...
		  If request.Session.Lookup("Authenticated", False) = False Then
		    request.Response.MetaRefresh("/login")
		    Return
		  End If
		  
		  // Create a folderitem that points to the template file.
		  Var f as FolderItem = request.StaticPath.Child("protected").Child("confidential.pdf")
		  
		  // Use Express' FileRead method to load the file.
		  Var PDFContent As String = Express.FileRead(f)
		  
		  // Update the response content.
		  request.Response.Content = PDFContent
		  
		  // Specify the mime type using the Content-Type header.
		  request.Response.Headers.Value("Content-Type") = Express.MIMETypeGet("pdf")
		  
		  // Specify the filename using the Content-Disposition header.
		  request.Response.Headers.Value("Content-Disposition") = "inline; filename=confidential.pdf"
		  
		  // Update the request status code.
		  request.Response.Status = "200"
		  
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
