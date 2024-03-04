#tag Class
Protected Class Sessions
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub BodyContentGenerate()
		  
		  
		  
		  // Generate the sessions table.
		  TableGenerate
		  
		  // Add the content to the page.
		  BodyContent = PageContent + TableHTML
		  
		  
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
		  HTML = HTML.ReplaceAll("[[H1]]", "Sessions")
		  HTML = HTML.ReplaceAll("[[Content]]", BodyContent)
		  
		  
		  // Update the response content.
		  Request.Response.Content = HTML
		  
		  
		  // Update the request status code.
		  Request.Response.Status = "200"
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target32Bit or Target64Bit))
		Sub TableGenerate()
		  // Server could be Nil if stopped
		  Var serverInstance As Express.Server = Request.Server
		  If (serverInstance = Nil) Then
		    Request.Response.Status = "500"
		    Return
		  End If
		  
		  // Generates an HTML table to display the sessions that SessionEngineAE is managing.
		  
		  // Open a table.
		  TableHTML = "" _
		  + "<table class=""gridtable"" width=""100%"">" _
		  + "<tr>" _
		  + "<th width=""30%"">Session ID</th>" _
		  + "<th width=""20%"">User IP Address</th>" _
		  + "<th width=""30%"">Username</th>" _
		  + "<th width=""10%"">Authenticated</th>" _
		  + "<th width=""10%""># Requests</th>" _
		  + "</tr>" + EndOfLine
		  
		  
		  // Loop over the server's session keys...
		  For Each key As Variant In serverInstance.SessionEngine.Sessions.Keys
		    
		    // Get the entry's key and value.
		    Var sessionID As String = key
		    Var session As Dictionary = serverInstance.SessionEngine.Sessions.Value(key)
		    
		    Var remoteAddress As String = session.Lookup("RemoteAddress", "")
		    Var username As String = session.Lookup("Username", "n/a")
		    Var authenticated As String = If (session.Lookup("Authenticated", False), "Yes", "No")
		    Var requestCount As Integer = session.Lookup("RequestCount", 0)
		    
		    TableHTML = TableHTML _
		    + "<tr>" + EndOfLine _
		    + "<td>" + SessionID + "</td>" + EndOfLine _
		    + "<td>" + RemoteAddress + "</td>" + EndOfLine _
		    + "<td>" + Username + "</td>" + EndOfLine _
		    + "<td>" + Authenticated + "</td>" + EndOfLine _
		    + "<td>" + RequestCount.ToString + "</td>" + EndOfLine _
		    + "<tr>" + EndOfLine
		    
		  Next key
		  
		  
		  // Close the table.
		  TableHTML = TableHTML + "</table>" + EndOfLine
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TemplateLoad()
		  // Loads the template file.
		  
		  // Create a folderitem that points to the template file.
		  Var f as FolderItem = Request.StaticPath.Child("template.html")
		  
		  // Use Express' FileRead method to load the file.
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

	#tag Property, Flags = &h0
		Session As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		TableHTML As String
	#tag EndProperty


	#tag Constant, Name = PageContent, Type = String, Dynamic = False, Default = \"<p>\nThis is a protected page. You can only see it because you are logged in.\n</p>", Scope = Public
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
		#tag ViewProperty
			Name="TableHTML"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
