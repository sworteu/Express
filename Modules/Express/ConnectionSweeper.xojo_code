#tag Class
Protected Class ConnectionSweeper
Inherits Timer
	#tag Event
		Sub Action()
		  // Closes any HTTP connections that have timed out.
		  HTTPConnSweep
		  
		  // Closes any WebSocket connections that have timed out.
		  WSConnSweep
		  
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor(Server As Express.Server)
		  // Store the server.
		  Self.Server = Server // Stored as a weakref internally
		  
		  // Schedule the Sweep process.
		  Period = Server.ConnSweepIntervalSecs * 1000
		  RunMode = Timer.RunModes.Multiple
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HTTPConnSweep()
		  // Closes connections that have timed out.
		  
		  
		  // Loop over the server's connections...
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
		      //years, months, days, hours, minutes, seconds
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

	#tag Method, Flags = &h0
		Sub WSConnSweep()
		  // Closes WebSocket connections that have timed out.
		  
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
		    //years, months, days, hours, minutes, seconds
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


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If Self.ServerRef <> Nil And Self.ServerRef.Value <> Nil And Self.ServerRef.Value IsA Express.Server Then
			    Return Express.Server(Self.ServerRef.Value)
			  End If
			  
			  Return Nil
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value = Nil Then
			    Self.ServerRef = Nil
			    Return
			  End If
			  
			  Self.ServerRef = New WeakRef(value)
			End Set
		#tag EndSetter
		Server As Express.Server
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private ServerRef As WeakRef
	#tag EndProperty


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
