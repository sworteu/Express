#tag Class
Protected Class XSContext
	#tag Method, Flags = &h21
		Private Function SoftwareUptimeMinutes() As Double
		  Var now As DateTime = DateTime.Now
		  Var uptimeSeconds As Double = (now.SecondsFrom1970 - StartTimestamp.SecondsFrom1970)
		  Var uptimeMinutes As Double = (uptimeSeconds / 60)
		  
		  Return uptimeMinutes
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SoftwareUptimeSeconds() As Double
		  Var now As DateTime = DateTime.Now
		  Var uptimeSeconds As Double = (now.SecondsFrom1970 - StartTimestamp.SecondsFrom1970)
		  
		  Return uptimeSeconds
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SystemUptimeMinutes() As Double
		  // Returns the runtime in seconds for this application
		  Var micros As Double = System.Microseconds
		  Var minutes As Double = (micros / 1000000 / 60)
		  
		  Return minutes
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SystemUptimeSeconds() As Double
		  // Returns the runtime in seconds for this application
		  Var micros As Double = System.Microseconds
		  Var seconds As Double = (micros / 1000000)
		  
		  Return seconds
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function UnixEpoch() As Double
		  Var timestamp As DateTime = DateTime.Now
		  Var epoch As Double = timestamp.SecondsFrom1970
		  
		  Return epoch
		End Function
	#tag EndMethod


End Class
#tag EndClass
