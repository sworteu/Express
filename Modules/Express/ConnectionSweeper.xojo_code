#tag Class
Protected Class ConnectionSweeper
Inherits Timer
	#tag Event
		Sub Action()
		  /// Closes defunct connections.
		  
		  // Closes any HTTP connections that have timed out.
		  HTTPConnSweep
		  
		  // Closes any WebSocket connections that have timed out.
		  WSConnSweep
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0, Description = 44656661756C7420636F6E7374727563746F722E
		Sub Constructor(server As Express.Server)
		  /// Default constructor.
		  
		  // Store the server.
		  Self.Server = server // Stored as a weakref internally
		  
		  // Schedule the Sweep process.
		  Period = server.ConnSweepIntervalSecs * 1000
		  RunMode = Timer.RunModes.Multiple
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6F73657320636F6E6E656374696F6E73207468617420686176652074696D6564206F75742E
		Sub HTTPConnSweep()
		  /// Closes connections that have timed out.
		  
		  // Loop over the server's connections.
		  Var socks() As TCPSocket = server.ActiveConnections
		  Var lastSocketIndex As Integer = socks.LastIndex
		  Var sockCount As Integer = socks.Count
		  
		  If sockCount > 0 Then
		    
		    Var socket As Express.Request
		    
		    For i As Integer = 0 To lastSocketIndex
		      socket = Express.Request(socks(i))
		      
		      // If the socket isn't connected...
		      If socket.IsConnected = False Then
		        Continue
		      End If
		      
		      // If the socket has not been connected to...
		      If socket.LastConnect = Nil Then
		        Continue
		      End If
		      
		      // If the socket is actively servicing a WebSocket...
		      If socket.WSStatus = "Active" Then
		        Continue
		      End If
		      
		      // Get the current date/time.
		      Var now As DateTime = DateTime.Now
		      
		      // Get the socket's last connection timestamp.
		      Var timeout As DateTime = socket.LastConnect
		      
		      // Determine when the connection will timeout due to inactivity.
		      timeout = timeout.AddInterval(  0, 0, 0, 0, 0,  Server.KeepAliveTimeout )
		      
		      // If the socket's keep-alive has timed out...
		      If now > timeout Then
		        
		        // Reset the socket's last connection time.
		        socket.LastConnect = Nil
		        
		        // Close the socket.
		        socket.Close
		        
		      End If
		      
		    Next i
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6F73657320616E7920576562536F636B657420636F6E6E656374696F6E73207468617420686176652074696D6564206F75742E
		Sub WSConnSweep()
		  /// Closes any WebSocket connections that have timed out.
		  
		  // If the server has been configured so that WebSocket connections do not timeout...
		  If Server.WSTimeout = 0 Then
		    Return
		  End If
		  
		  // Loop over the server's WebSockets...
		  Var i As Integer = -1
		  
		  For i = Server.WebSockets.LastIndex DownTo 0
		    
		    // Get the socket.
		    Var socket As Express.Request = Server.WebSockets(i)
		    
		    // Get the current date/time.
		    Var now As DateTime = DateTime.Now
		    
		    // Get the socket's last connection timestamp.
		    Var timeout As DateTime = socket.LastConnect
		    
		    // Determine when the connection will timeout due to inactivity.
		    timeout = timeout.AddInterval( 0, 0, 0, 0, 0, Server.WSTimeout )
		    
		    // If the socket has timed out...
		    If now > timeout Then
		      
		      // Reset the socket's last connection time.
		      socket.LastConnect = Nil
		      
		      // Set the WebSocket status.
		      socket.WSStatus = "Inactive"
		      
		      // Close the socket.
		      socket.Close
		      
		      // Remove the socket from the array.
		      Server.WebSockets.RemoveAt(i)
		      
		    End If
		    
		  Next i
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 41207765616B207265666572656E636520746F207468697320737765657065722773207365727665722E
		Private mServerRef As WeakRef
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 41207765616B207265666572656E636520746F207468697320737765657065722773207365727665722E
		#tag Getter
			Get
			  If mServerRef <> Nil And mServerRef.Value <> Nil And mServerRef.Value IsA Express.Server Then
			    Return Express.Server(mServerRef.Value)
			  End If
			  
			  Return Nil
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value = Nil Then
			    mServerRef = Nil
			    Return
			  End If
			  
			  mServerRef = New WeakRef(value)
			End Set
		#tag EndSetter
		Server As Express.Server
	#tag EndComputedProperty


	#tag ViewBehavior
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
			Name="Enabled"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunMode"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="RunModes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Off"
				"1 - Single"
				"2 - Multiple"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Period"
			Visible=true
			Group="Behavior"
			InitialValue="1000"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
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
	#tag EndViewBehavior
End Class
#tag EndClass
