#tag Class
Protected Class Chat
	#tag Method, Flags = &h0
		Sub Constructor(Request As Express.Request)
		  // Store the request.
		  Self.Request = Request
		  
		  // If this is a request from an active WebSocket connection...
		  If Request.WSStatus = "Active" Then
		    // Process the payload.
		    PayloadProcess
		  Else
		    // Process the connection request with an opening handshake.
		    Request.WSHandshake
		  End If
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub JoinProcess()
		  
		  // Get the username.
		  Var newUsername As String = Payload.Lookup("username", "")
		  
		  // Associate the username with the socket.
		  Request.Custom.Value("username") = newUsername
		  
		  // Get the names of the other users that are online...
		  Var usernames() As String
		  For Each webSockets As Express.Request In Request.Server.WebSockets
		    Var username As String = webSockets.Custom.Lookup("username", "")
		    If username <> newUsername Then
		      usernames.Add(username)
		    End If
		  Next webSockets
		  
		  // If this is the first user in the chat...
		  If usernames.LastIndex = -1 Then
		    
		    // Return the list.
		    Var responseJSON As New JSONItem
		    responseJSON.Value("type") = "message"
		    responseJSON.Value("username") = "Server"
		    responseJSON.Value("message") = "Welcome, " + newUsername + ". You are the first user in the chat."
		    Request.WSMessageSend(responseJSON.ToString)
		    
		  Else
		    
		    // Return the list of users.
		    Var responseJSON As New JSONItem
		    responseJSON.Value("type") = "message"
		    responseJSON.Value("username") = "Server"
		    
		    Var serverMessage As String = "Welcome, " + newUsername + "."
		    If usernames.Count > 1 Then
		      serverMessage = serverMessage + "You are joining " + String.FromArray(usernames, ", ") + " in the chat."
		    End If
		    responseJSON.Value("message") = serverMessage
		    Request.WSMessageSend(responseJSON.ToString)
		    
		    // Broadcast a message announcing the new user.
		    responseJSON = New JSONItem
		    responseJSON.Value("type") = "message"
		    responseJSON.Value("username") = "Server"
		    responseJSON.Value("message") = newUsername + " has joined the chat."
		    Request.Server.WSMessageBroadcast(responseJSON.ToString)
		    
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LeaveProcess()
		  // Close the connection.
		  Request.WSConnectionClose
		  
		  // Get the username.
		  Var Username As String = Payload.Lookup("username", "")
		  
		  // Broadcast a message announcing the departure of the user.
		  Var responseJSON As New JSONItem
		  responseJSON.Value("type") = "message"
		  responseJSON.Value("username") = "Server"
		  responseJSON.Value("message") = username + " has left the chat."
		  Request.Server.WSMessageBroadcast(responseJSON.ToString)
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MessageProcess()
		  // Broadcasts a message.
		  
		  // If the message isn't blank...
		  If Request.Body <> "" Then
		    Request.Server.WSMessageBroadcast(Request.Body)
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PayloadProcess()
		  // Processes a request.
		  
		  // Try to convert the request body (the payload) to JSON.
		  Try
		    Var content As String = Request.Body.DefineEncoding(Encodings.UTF8)
		    Payload = New JSONItem(content)
		  Catch e As JSONException
		    // Ignore the payload.
		    Return
		  End Try
		  
		  // Get the payload type.
		  Var payloadType As String = Payload.Lookup("type", "message")
		  
		  // Process the request...
		  Select Case payloadType
		  Case "join"
		    JoinProcess
		  Case "leave"
		    LeaveProcess
		  Case "who"
		    WhoProcess
		  Else
		    MessageProcess
		  End Select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WhoProcess()
		  // If this is a request to get a list of users...
		  
		  // Get the names of the users that are online...
		  Var usernames() As String
		  For Each req As Express.Request In Request.Server.WebSockets
		    Var username As String = req.Custom.Lookup("username", "")
		    If username <> "" Then
		      usernames.Add(username)
		    End If
		  Next req
		  
		  // Return the list.
		  Var responseJSON As New JSONItem
		  responseJSON.Value("type") = "message"
		  responseJSON.Value("username") = "Server"
		  
		  Var serverMessage As String 
		  If usernames.Count > 1 Then
		    serverMessage = "These users are currently online: " + String.FromArray(usernames, ", ")
		  Else
		    serverMessage = "Your are the only one online."
		  End If
		  responseJSON.Value("message") = serverMessage
		  
		  Request.WSMessageSend(responseJSON.ToString)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Payload As JSONItem
	#tag EndProperty

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
