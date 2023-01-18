#tag Class
Protected Class Secret
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub BodyContentGenerate()
		  BodyContent = PageContent
		End Sub
	#tag EndMethod

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
		  
		  
		  // Generate the body content.
		  BodyContentGenerate
		  
		  
		  // Display the page.
		  PageDisplay
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PageDisplay()
		  // Load the template.
		  TemplateLoad
		  
		  
		  // Substitute special tokens.
		  HTML = HTML.ReplaceAll("[[H1]]", "Secret of Life")
		  HTML = HTML.ReplaceAll("[[Content]]", BodyContent)
		  
		  
		  // Update the response content.
		  Request.Response.Content = HTML
		  
		  
		  // Update the request status code.
		  Request.Response.Status = "200"
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TemplateLoad()
		  // Loads the template file.
		  
		  // Create a folderitem that points to the template file.
		  Var f as FolderItem = Request.StaticPath.Child("template.html")
		  
		  // Use Aloe's FileRead method to load the file.
		  HTML = Express.FileRead(f)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		BodyContent As String
	#tag EndProperty

	#tag Property, Flags = &h0
		HTML As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As Express.Request
	#tag EndProperty


	#tag Constant, Name = PageContent, Type = String, Dynamic = False, Default = \"<p>\nThis is a protected page. You can only see it because you are logged in.\n</p>\n<iframe width\x3D\"560\" height\x3D\"315\" src\x3D\"https://www.youtube.com/embed/yHWHPPHpAj8\?rel\x3D0\" frameborder\x3D\"0\" allowfullscreen></iframe>\n<p>\n<a href\x3D\"/\">Click here</a> to go back to the home page.\n</p>", Scope = Public
	#tag EndConstant


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
			Name="HTML"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BodyContent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
