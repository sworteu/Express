#tag Class
Protected Class Server
Inherits ServerSocket
	#tag Event
		Function AddSocket() As TCPSocket
		  /// Tries to add a socket to the pool.
		  
		  Try
		    
		    // Increment the Socket ID.
		    CurrentSocketID = CurrentSocketID + 1
		    
		    // Create a new request instance to act as the socket, and assign it an ID.
		    Var newSocket As New Request(Self)
		    NewSocket.SocketID = CurrentSocketID
		    
		    // Return the socket.
		    Return newSocket
		    
		  Catch e As RunTimeException
		    
		    Var typeInfo As Introspection.TypeInfo = Introspection.GetType(e)
		    #Pragma Unused typeInfo
		    
		    System.DebugLog "Express Server Error: Unable to Add Socket w/ID " + CurrentSocketID.ToString
		    
		  End Try
		  
		End Function
	#tag EndEvent

	#tag Event
		Sub Error(ErrorCode As Integer, err As RuntimeException)
		  #Pragma Unused err
		  System.DebugLog "Express Server Error: Code: " + ErrorCode.ToString
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0, Description = 52657475726E7320746865206E756D626572206F6620636F6E6E65637465642061637469766520736F636B6574732E
		Function ConnectedSocketCount() As Integer
		  /// Returns the number of connected active sockets.
		  
		  Var activeSockets() As TCPSocket = Self.ActiveConnections
		  Var count As Integer = 0
		  
		  For Each sock As TCPSocket In activeSockets
		    If sock.IsConnected Then
		      count = count + 1
		    End If
		  Next sock
		  
		  Return count
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 44656661756C7420636F6E7374727563746F7220746861742074616B6573206F7074696F6E616C20617267756D656E74732E
		Sub Constructor(args() As String = Nil)
		  /// Default constructor that takes optional arguments.
		  
		  // Set defaults.
		  #If DebugBuild Then
		    Port = 8080
		  #Else
		    Port = 80
		  #EndIf
		  
		  MaximumSocketsConnected = 5000
		  MinimumSocketsAvailable = 10
		  Secure = False
		  ConnectionType = SSLSocket.SSLConnectionTypes.TLSv12
		  CertificatePassword = ""
		  KeepAlive = True
		  
		  // Any arguments?
		  If args <> Nil Then
		    
		    // Convert any command line arguments into a dictionary.
		    Var arguments As Dictionary = ArgsToDictionary(args)
		    
		    // Assign valid arguments to their corresponding properties.
		    If arguments.HasKey("--Port") Then
		      Port = Val(arguments.Value("--Port"))
		    End If
		    
		    If arguments.HasKey("--MaxSockets") Then
		      MaximumSocketsConnected = Val(arguments.Value("--MaxSockets"))
		    End If
		    
		    If arguments.HasKey("--MinSockets") Then
		      MinimumSocketsAvailable = Val(arguments.Value("--MinSockets"))
		    End If
		    
		    Loopback = arguments.HasKey("--Loopback")
		    
		    If arguments.HasKey("--Nothreads") Then 
		      Multithreading = False
		    End If
		    
		    If arguments.HasKey("--Secure") Then 
		      Secure = True
		    End If
		    
		    If arguments.HasKey("--ConnectionType") Then 
		      ConnectionType = arguments.Value("--ConnectionType")
		    End If
		    
		    If arguments.HasKey("--CertificateFile") Then 
		      CertificateFile = New FolderItem(arguments.Value("--CertificateFile"), FolderItem.PathModes.Shell)
		    End If
		    
		    If arguments.HasKey("--CertificatePassword") Then 
		      CertificatePassword = CertificatePassword
		    End If
		    
		    If arguments.HasKey("--CloseConnections") Then 
		      KeepAlive = False
		    End If
		    
		  End If
		  
		  // Initlialise the Custom dictionary.
		  Custom = New Dictionary
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 446973706C6179732073657276657220636F6E66696775726174696F6E20696E666F2E
		Sub ServerInfoDisplay()
		  /// Displays server configuration info.
		  
		  Var info() As String
		  
		  info.Add(EndOfLine)
		  
		  info.Add(Name + " has started... ")
		  info.Add("• Xojo Version: " + XojoVersionString)
		  info.Add("• Express Version: " + Express.VERSION_STRING)
		  info.Add("• Caching: " + If(CachingEnabled , "Enabled", "Disabled"))
		  info.Add("• Cache Sweep Interval: " + CacheSweepIntervalSecs.ToString + " seconds")
		  info.Add("• Loopback: " + If(Loopback , "Enabled", "Disabled"))
		  info.Add("• Keep-Alives: " + If(KeepAlive , "Enabled", "Disabled"))
		  info.Add("• Keep-Alive Timeout: " + KeepAliveTimeout.ToString  + " seconds")
		  info.Add("• Keep-Alive Sweep Interval: " + ConnSweepIntervalSecs.ToString)
		  info.Add("• Maximum Entity Size: " + MaxEntitySize.ToString)
		  info.Add("• Maximum Sockets Connected: " + MaximumSocketsConnected.ToString)
		  info.Add("• Minimum Sockets Available: " + MinimumSocketsAvailable.ToString)
		  info.Add("• Multithreading: " + If(Multithreading, "Enabled", "Disabled"))
		  info.Add("• Port: " + Port.ToString)
		  info.Add("• Sessions: " + If(SessionsEnabled , "Enabled", "Disabled"))
		  info.Add("• SSL: " + If(Secure , "Enabled", "Disabled"))
		  info.Add("• WebSocket Timeout: " + WSTimeout.ToString + " seconds")
		  
		  If Secure Then
		    info.Add("• SSL Certificate Path: " + CertificateFile.NativePath)
		    info.Add("• SSL Connection Type: " + ConnectionType.ToString)
		  End If
		  
		  If AdditionalServerDisplayInfo <> Nil Then
		    For Each entry As DictionaryEntry In AdditionalServerDisplayInfo
		      info.Add("• " + entry.Key.StringValue + ": " + entry.Value.StringValue)
		    Next entry
		  End If
		  
		  System.Log( System.LogLevelNotice, String.FromArray(info, EndOfLine) )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 537461727473207468652073657276657220736F2074686174206974206C697374656E7320666F7220696E636F6D696E672072657175657374732E
		Sub Start()
		  /// Starts the server so that it listens for incoming requests.
		  
		  // If the server should use the loopback network interface.
		  If Loopback Then
		    NetworkInterface = NetworkInterface.Loopback
		  End If
		  
		  // Create a ConnectionSweeper timer object for this server.
		  mSweeper New ConnectionSweeper(Self)
		  
		  // Caching enabled?
		  If CachingEnabled Then
		    CacheEngine = New Express.CacheEngine(CacheSweepIntervalSecs)
		  End If
		  
		  // Session management enabled?
		  If SessionsEnabled Then
		    SessionEngine = New Express.SessionEngine(SessionsSweepIntervalSecs)
		  End If
		  
		  // Start listening for incoming requests.
		  Listen
		  
		  // If the server is running as part of a desktop app then we're done.
		  If TargetDesktop Then Return
		  
		  // If the server isn't starting silently then display server info.
		  If Not SilentStart Then
		    ServerInfoDisplay
		  End If
		  
		  // Speed up if we have more than 10 connections active to keep the server responsive.
		  Var connCount As Integer = 0
		  While True
		    connCount = ConnectedSocketCount
		    If connCount > 10 Then
		      // Speed up.
		      If Multithreading Then
		        App.DoEvents(0) // Fast switch between threads after doing events
		      Else
		        App.DoEvents(-1) // Fast do events (default)
		      End If
		    Else
		      // Slow down a little
		      App.DoEvents(2)
		    End If
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 42726F616463617374732061206D65737361676520746F20616C6C206F662074686520576562536F636B65747320746861742061726520636F6E6E656374656420746F20746865207365727665722E
		Sub WSMessageBroadcast(message As String)
		  /// Broadcasts a message to all of the WebSockets that are connected to the server.
		  
		  // Loop over each WebSocket connection.
		  For Each socket As Express.Request In WebSockets
		    
		    // If the WebSocket is still connected then send it the message.
		    If socket.IsConnected Then
		      socket.WSMessageSend(message)
		    End If
		    
		  Next socket
		  
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
		CurrentSocketID As Integer = 0
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

	#tag Property, Flags = &h21, Description = 5468697320736572766572277320636F6E6E656374696F6E20737765657065722E
		Private mSweeper As Express.ConnectionSweeper
	#tag EndProperty

	#tag Property, Flags = &h0
		Multithreading As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String = "Express Server"
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
			InitialValue="0"
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
