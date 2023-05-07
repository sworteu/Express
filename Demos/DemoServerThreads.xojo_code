#tag Module
Protected Module DemoServerThreads
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Express.Request)
		  // Demonstrates processing requests when the app is running multiple AE server instances.
		  // Note that while a server is listening on port 64003 (see App.MultipleServerDemo), it isn't
		  // "wired up" in this method. If you send a request to that port, you should get a 
		  // "501 Not Implemented" response.
		  
		  
		  // Route the request based on the port that the request came in on.
		  If Request.Port = 64000 Then
		    DemoHelloWorld.RequestProcess(Request)
		  ElseIf Request.Port = 64001 Then
		    DemoSessions.RequestProcess(Request)
		  ElseIf Request.Port = 64002 Then
		    DemoTemplatesServerSide.RequestProcess(Request)
		  Else 
		    Request.Response.Status = "501 Not Implemented"
		    Request.Response.Content = "The server is not configured to handle requests on port " + Request.Port.ToString + "."
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ServersLaunch(args() As String, requestHandler As Express.RequestHandlerDelegate)
		  // See the comments in the App.Run event handler for information about this method.
		  
		  // Create ServerThread instances with servers listening on port 64000, 64001, etc.
		  Var serverThread1 As New Express.ServerThread(args, requestHandler)
		  serverThread1.Server.Port = 64000
		  serverThread1.Start
		  
		  Var serverThread2 As New Express.ServerThread(args, requestHandler)
		  serverThread2.Server.Port = 64001
		  serverThread2.Server.SessionsEnabled = True
		  serverThread2.Start
		  
		  Var serverThread3 As New Express.ServerThread(args, requestHandler)
		  serverThread3.Server.Port = 64002
		  serverThread3.Start
		  
		  Var serverThread4 As New Express.ServerThread(args, requestHandler)
		  serverThread4.Server.Port = 64003
		  serverThread4.Start
		  
		  While True
		    App.DoEvents
		  Wend
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
