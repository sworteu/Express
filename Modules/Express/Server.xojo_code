#tag Class
Protected Class Server
Inherits ServerSocket
	#tag Event
		Function AddSocket() As TCPSocket
		  // Tries to add a socket to the pool.
		  Try
		    
		    // Increment the Socket ID.
		    CurrentSocketID = CurrentSocketID + 1
		    
		    // Create a new instance of Request to act as the socket, and assign it an ID.
		    Dim NewSocket As New Request(Self)
		    NewSocket.SocketID = CurrentSocketID
		    
		    // Append the socket to the array.
		    'Sockets.AddRow(NewSocket)
		    
		    // Return the socket.
		    Return NewSocket
		    
		  Catch e As RunTimeException
		    
		    Dim TypeInfo As Introspection.TypeInfo = Introspection.GetType(e)
		    #Pragma Unused TypeInfo
		    
		    System.DebugLog "Aloe Express Server Error: Unable to Add Socket w/ID " + CurrentSocketID.ToString
		    
		  End Try
		End Function
	#tag EndEvent

	#tag Event
		Sub Error(ErrorCode As Integer, err As RuntimeException)
		  #Pragma Unused err
		  System.DebugLog "Aloe Express Server Error: Code: " + ErrorCode.ToString
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Function ConnectedSocketCount() As Integer
		  Var activeSockets() As TCPSocket = Self.ActiveConnections
		  
		  Var i As Integer = 0 
		  Var lastSocketIndex As Integer = activeSockets.LastIndex
		  
		  Var count As Integer = 0
		  
		  For i = 0 To lastSocketIndex
		    
		    If activeSockets(i).IsConnected Then
		      count = count + 1
		    End If
		    
		  Next
		  
		  Return count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Args() As String = Nil)
		  // Set defaults.
		  #If DebugBuild Then
		    Port = 8080
		  #Else
		    Port = 80
		  #EndIf
		  MaximumSocketsConnected = 5000
		  MinimumSocketsAvailable = 1000
		  Secure = False
		  ConnectionType = SSLSocket.SSLConnectionTypes.TLSv12
		  'CertificateFile = App.ExecutableFile.Parent.Parent.Child("certificates").Child("default-certificate.crt")
		  CertificatePassword = ""
		  KeepAlive = True
		  
		  // If arguments were passed...
		  If Args <> Nil Then
		    
		    // Convert any command line arguments into a dictionary.
		    Dim Arguments As Dictionary = ArgsToDictionary(Args)
		    
		    // Assign valid arguments to their corresponding properties...
		    
		    If Arguments.HasKey("--Port") Then
		      Port = Val(Arguments.Value("--Port"))
		    End If
		    
		    If Arguments.HasKey("--MaxSockets") Then
		      MaximumSocketsConnected = Val(Arguments.Value("--MaxSockets"))
		    End If
		    
		    If Arguments.HasKey("--MinSockets") Then
		      MinimumSocketsAvailable = Val(Arguments.Value("--MinSockets"))
		    End If
		    
		    Loopback = Arguments.HasKey("--Loopback")
		    
		    If Arguments.HasKey("--Nothreads") Then 
		      Multithreading = False
		    End If
		    
		    If Arguments.HasKey("--Secure") Then 
		      Secure = True
		    End If
		    
		    If Arguments.HasKey("--ConnectionType") Then 
		      ConnectionType = Arguments.Value("--ConnectionType")
		    End If
		    
		    If Arguments.HasKey("--CertificateFile") Then 
		      CertificateFile = New FolderItem(Arguments.Value("--CertificateFile"), FolderItem.PathModes.Shell)
		    End If
		    
		    If Arguments.HasKey("--CertificatePassword") Then 
		      CertificatePassword = CertificatePassword
		    End If
		    
		    If Arguments.HasKey("--CloseConnections") Then 
		      KeepAlive = False
		    End If
		    
		    //Check for VerboseLogging argument
		    If Arguments.HasKey("--VerboseLogging") Then
		      Dim level As String = Arguments.Value("--VerboseLogging")
		      //If a value has been passed, assign it otherwise we have a default value for the parameter of Debug
		      //You can call "--VerboseLogging" and get LogLevel.Debug or pass a parameter such as critical to the argument "--VerboseLogging=Critical"
		      If level <> "" Then
		        'MinimumLogLevel.StringValue = level
		      Else
		        'MinimumLogLevel = LogLevel.Debug
		      End If
		      
		    End If
		    
		  End If
		  
		  // Initlialize the Custom dictionary.
		  Custom = New Dictionary
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ServerInfoDisplay()
		  // Displays server configuration info.
		  
		  Dim Info As String = EndOfLine + EndOfLine _
		  + Name + " has started... " + EndOfLine _
		  + "• Xojo Version: " + XojoVersionString + EndOfLine _
		  + "• Aloe Express Version: " + Express.VersionString + EndOfLine _
		  + "• Caching: " + If(CachingEnabled , "Enabled", "Disabled") + EndOfLine _
		  + "• Cache Sweep Interval: " + CacheSweepIntervalSecs.ToString + " seconds" + EndOfLine _
		  + "• Loopback: " + If(Loopback , "Enabled", "Disabled") + EndOfLine _
		  + "• Keep-Alives: " + If(KeepAlive , "Enabled", "Disabled") + EndOfLine _
		  + "• Keep-Alive Timeout: " + KeepAliveTimeout.ToString  + " seconds" + EndOfLine _
		  + "• Keep-Alive Sweep Interval: " + ConnSweepIntervalSecs.ToString + EndOfLine _
		  + "• Maximum Entity Size: " + MaxEntitySize.ToString + EndOfLine _
		  + "• Maximum Sockets Connected: " + MaximumSocketsConnected.ToString + EndOfLine _
		  + "• Minimum Sockets Available: " + MinimumSocketsAvailable.ToString + EndOfLine _
		  + "• Multithreading: " + If(Multithreading, "Enabled", "Disabled") + EndOfLine _
		  + "• Port: " + Port.ToString + EndOfLine _
		  + "• Sessions: " + If(SessionsEnabled , "Enabled", "Disabled") + EndOfLine _
		  + "• Sessions Sweep Interval: " + SessionsSweepIntervalSecs.ToString + " seconds" + EndOfLine _
		  + "• SSL: " + If(Secure , "Enabled", "Disabled") + EndOfLine _
		  + If(Secure , "• SSL Certificate Path: " + CertificateFile.NativePath + EndOfLine, "") _
		  + If(Secure , "• SSL Connection Type: " + ConnectionType.ToString  + EndOfLine, "") _
		  + "• WebSocket Timeout: " + WSTimeout.ToString + " seconds" + EndOfLine '_
		  '+ "• Log Level: " + MinimumLogLevel.ToString + EndOfLine
		  If AdditionalServerDisplayInfo <> Nil Then
		    Dim keys() As Variant = AdditionalServerDisplayInfo.Keys
		    Var lastKeyIndex As Integer = keys.LastIndex
		    For i As Integer = 0 To lastKeyIndex
		      info = info + "• " + keys( i ).StringValue + ": " + AdditionalServerDisplayInfo.Value( keys( i ) ).StringValue + EndOfLine
		    Next
		  End If
		  
		  info = info + EndOfLine + EndOfLine
		  
		  System.Log( System.LogLevelNotice, Info + EndOfLine + EndOfLine )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start()
		  // Starts the server so that it listens for incoming requests.
		  
		  
		  // If the server should use the loopback network interface.
		  If Loopback Then
		    NetworkInterface = NetworkInterface.Loopback
		  End If
		  
		  // Create a ConnectionSweeper timer object for this server.
		  Dim Sweeper As New ConnectionSweeper(Self)
		  #Pragma Unused Sweeper
		  
		  // If caching is enabled...
		  If CachingEnabled Then
		    CacheEngine = New Express.CacheEngine(CacheSweepIntervalSecs)
		  End If
		  
		  // If session management is enabled...
		  If SessionsEnabled Then
		    SessionEngine = New Express.SessionEngine(SessionsSweepIntervalSecs)
		  End If
		  
		  // Start listening for incoming requests.
		  Listen
		  
		  // If the server is running as part of a desktop app...
		  #If TargetDesktop Then
		    // We're done.
		    Return
		  #Endif
		  
		  // If the server isn't starting silently...
		  If SilentStart = False Then
		    // Display server info.
		    ServerInfoDisplay
		  End If
		  
		  // Rock on.
		  // Speed up if we have more than 10 connections active to keep the server responsive!
		  Var connCount As Integer = 0
		  While True
		    connCount = ConnectedSocketCount
		    If connCount > 10 Then
		      // Speed up massively
		      If Multithreading Then
		        app.DoEvents(0) // Fast switch between threads after doing events
		      Else
		        app.DoEvents(-1) // Fast do events (default)
		      End If
		    Else
		      // Slow down a little
		      app.DoEvents(2)
		    End If
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WSMessageBroadcast(Message As String)
		  // Broadcasts a message to all of the WebSockets that are connected to the server.
		  
		  
		  // Loop over each WebSocket connection...
		  For Each Socket As Express.Request In WebSockets
		    
		    // If the WebSocket is still connected...
		    If Socket.IsConnected Then
		      
		      // Send it the message.
		      Socket.WSMessageSend(Message)
		      
		    End If
		    
		  Next
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		AdditionalServerDisplayInfo As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		CacheEngine As Express.CacheEngine
	#tag EndProperty

	#tag Property, Flags = &h0
		CacheSweepIntervalSecs As Integer = 300
	#tag EndProperty

	#tag Property, Flags = &h0
		CachingEnabled As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		CertificateFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		CertificatePassword As String
	#tag EndProperty

	#tag Property, Flags = &h0
		ConnectionType As SSLSocket.SSLConnectionTypes
	#tag EndProperty

	#tag Property, Flags = &h0
		ConnSweepIntervalSecs As Integer = 15
	#tag EndProperty

	#tag Property, Flags = &h0
		CurrentSocketID As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Custom As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		KeepAlive As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		KeepAliveTimeout As Integer = 30
	#tag EndProperty

	#tag Property, Flags = &h0
		Loopback As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		MaxEntitySize As Integer = 10485760
	#tag EndProperty

	#tag Property, Flags = &h0
		Multithreading As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String = "Aloe Express Server"
	#tag EndProperty

	#tag Property, Flags = &h0
		Secure As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		SessionEngine As Express.SessionEngine
	#tag EndProperty

	#tag Property, Flags = &h0
		SessionsEnabled As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		SessionsSweepIntervalSecs As Integer = 300
	#tag EndProperty

	#tag Property, Flags = &h0
		SilentStart As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		WebSockets() As Express.Request
	#tag EndProperty

	#tag Property, Flags = &h0
		WSTimeout As Integer = 1800
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
			InitialValue=""
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
			Name="Port"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MinimumSocketsAvailable"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaximumSocketsConnected"
			Visible=true
			Group="Behavior"
			InitialValue="10"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentSocketID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Loopback"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Multithreading"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Secure"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ConnectionType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="SSLSocket.SSLConnectionTypes"
			EditorType="Enum"
			#tag EnumValues
				"1 - SSLv23"
				"3 - TLSv1"
				"4 - TLSv11"
				"5 - TLSv12"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="CertificatePassword"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MaxEntitySize"
			Visible=false
			Group="Behavior"
			InitialValue="10485760"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeepAlive"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="KeepAliveTimeout"
			Visible=false
			Group="Behavior"
			InitialValue="60"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ConnSweepIntervalSecs"
			Visible=false
			Group="Behavior"
			InitialValue="60"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SilentStart"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="WSTimeout"
			Visible=false
			Group="Behavior"
			InitialValue="1800"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CachingEnabled"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionsEnabled"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CacheSweepIntervalSecs"
			Visible=false
			Group="Behavior"
			InitialValue="300"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionsSweepIntervalSecs"
			Visible=false
			Group="Behavior"
			InitialValue="300"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
