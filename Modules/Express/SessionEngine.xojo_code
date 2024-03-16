#tag Class
Protected Class SessionEngine
Inherits Timer
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Event
		Sub Action()
		  // Removes any expired sessions.
		  //
		  // This prevents the dictionary from growing unnecessarily large due to orphaned sessions.
		  
		  #If Not DebugBuild Then
		    #Pragma BackgroundTasks False
		  #EndIf
		  
		  // Get the current date/time.
		  Var now As DateTime = DateTime.Now
		  
		  // This is an array of the session IDs that have expired.
		  Var expiredSessionIDs() As String
		  
		  // Prepare variables outside of the loops to improve speed.
		  Var sessionKeys() As Variant = Sessions.Keys
		  Var key As Variant, session As Dictionary, lastRequestTimestamp As DateTime, timeElapsedSecs As Double
		  
		  // Loop over the dictionary entries.
		  For Each key In sessionKeys
		    
		    // Get the entry's value.
		    session = Sessions.Value(key)
		    
		    // Get the session's LastRequestTimestamp.
		    lastRequestTimestamp = session.Value("LastRequestTimestamp")
		    
		    // Determine the time that has elapsed since the last request.
		    timeElapsedSecs = Now.SecondsFrom1970 - lastRequestTimestamp.SecondsFrom1970
		    
		    // If the session has expired then append the session's key to the array.
		    If timeElapsedSecs > sessionsTimeOutSecs Then
		      expiredSessionIDs.Add(Key)
		    End If
		    
		  Next key
		  
		  // Removed the expired sessions.
		  For Each sessionID As String In expiredSessionIDs
		    Express.EventLog("SessionEngine: Removing expired SessionID " + SessionID, Express.LogLevel.Debug)
		    sessions.Remove(sessionID)
		  Next sessionID
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0, Description = 44656661756C7420636F6E7374727563746F7220746861742074616B657320746865206E756D626572206F66207365636F6E647320666F722074686520737765657020696E74657276616C2E
		Sub Constructor(sweepIntervalSecs As Integer = 300)
		  // Default constructor that takes the number of seconds for the sweep interval.
		  
		  // Initiliase the Sessions dictionary.
		  Sessions = New Dictionary
		  
		  // Set the SweepIntervalSecs property.
		  Self.SweepIntervalSecs = sweepIntervalSecs
		  
		  // Schedule the SessionSweep process.
		  Period = SweepIntervalSecs * 1000
		  RunMode = timer.RunModes.Multiple
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320612073657373696F6E20666F722074686520726571756573742E20496620616E206578697374696E672073657373696F6E20697320617661696C61626C652C207468656E20697427732072657475726E65642E204F74686572776973652061206E65772073657373696F6E206973206372656174656420616E642072657475726E65642E
		Function SessionGet(request As Express.Request, assignNewID As Boolean = True) As Dictionary
		  // Returns a session for the request.
		  // If an existing session is available, then it's returned.
		  // Otherwise a new session is created and returned.
		  
		  // This is the session that we'll return.
		  Var session As Dictionary
		  
		  // This will be used if a new session ID is assigned.
		  Var newSessionID As String
		  
		  // Get the current date/time.
		  Var now As DateTime = DateTime.Now
		  
		  // Get the original session ID, if applicable.
		  Var originalSessionID As String = request.Cookies.Lookup("SessionID", "")
		  
		  // If the user has a session ID cookie...
		  If originalSessionID <> "" Then
		    
		    // If the session ID matches a session in the Sessions dictionary...
		    If Sessions.HasKey(originalSessionID) = True Then
		      
		      // Get the session.
		      session = Sessions.Value(originalSessionID)
		      
		      // Get the session's LastRequestTimestamp.
		      Var lastRequestTimestamp As New DateTime( session.Value("LastRequestTimestamp").DateTimeValue )
		      
		      // Determine the time that has elapsed since the last request.
		      Var timeElapsed As Double = now.SecondsFrom1970 - lastRequestTimestamp.SecondsFrom1970
		      
		      // If the session has expired...
		      If timeElapsed > SessionsTimeOutSecs Then
		        
		        // Remove the session from the array.
		        Sessions.Remove(originalSessionID)
		        
		        // Clear the session.
		        session = Nil
		        
		      End If
		      
		    End If
		    
		  End If
		  
		  // If an existing session is available...
		  If session <> Nil Then
		    
		    // Update the session's LastRequestTimestamp.
		    session.Value("LastRequestTimestamp") = now
		    
		    // Increment the session's Request Count.
		    session.Value("RequestCount") = session.Value("RequestCount") + 1
		    
		    // If we're not going to assign a new Session ID to the existing session...
		    If assignNewID = False Then
		      
		      // Return the session to the caller.
		      Return session
		      
		    End If
		    
		    // Assign a new session ID to the existing session.
		    
		    // Generate a new session ID.
		    newSessionID = UUIDGenerate
		    
		    // Update the session with the new ID.
		    session.Value("SessionID") = newSessionID
		    
		    // Add the new session to the Sessions dictionary.
		    Sessions.Value(newSessionID) = session
		    
		    // Remove the old session from the Sessions dictionary.
		    Sessions.Remove(originalSessionID)
		    
		  Else
		    
		    // We were unable to re-use an existing session, so create a new one.
		    
		    newSessionID = UUIDGenerate
		    
		    // Create a new session dictionary.
		    session = New Dictionary
		    session.Value("SessionID") = newSessionID
		    session.Value("LastRequestTimestamp") = now
		    session.Value("RemoteAddress") = request.RemoteAddress
		    session.Value("UserAgent") = request.Headers.Lookup("User-Agent", "")
		    session.Value("RequestCount") = 1
		    session.Value("Authenticated") = False
		    
		  End If
		  
		  // Add the session to the Sessions dictionary.
		  Sessions.Value(newSessionID) = session
		  
		  // Set the cookie expiration date.
		  Var cookieExpiration As DateTime = DateTime.Now
		  cookieExpiration = cookieExpiration.AddInterval( 0, 0, 0, 0, 0, SessionsTimeOutSecs )
		  
		  // Drop the SessionID cookie.
		  request.Response.CookieSet("SessionID", newSessionID, cookieExpiration)
		  
		  // Return the session to the caller.
		  Return session
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5465726D696E61746573206120676976656E2073657373696F6E2E
		Sub SessionTerminate(session As Dictionary)
		  // Terminates a given session.
		  
		  // If the session still exists...
		  If Sessions.HasKey(session.Value("SessionID")) Then
		    
		    Express.EventLog("SessionEngine: Terminate SessionID " + Session.Value("SessionID"), Express.LogLevel.Debug)
		    
		    // Remove the session from the array of sessions.
		    Sessions.Remove(session.Value("SessionID"))
		    
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 5468652073657373696F6E73206265696E67206D616E616765642062792074686520656E67696E652E
		Sessions As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F66207365636F6E6473206265666F726520612073657373696F6E2074696D6573206F75742E
		SessionsTimeOutSecs As Integer = 600
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F66207365636F6E6473206265747765656E207377656570732E
		SweepIntervalSecs As Integer = 300
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
		#tag ViewProperty
			Name="SweepIntervalSecs"
			Visible=false
			Group="Behavior"
			InitialValue="300"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SessionsTimeOutSecs"
			Visible=false
			Group="Behavior"
			InitialValue="600"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
