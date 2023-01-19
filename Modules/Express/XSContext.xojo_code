#tag Class
Protected Class XSContext
	#tag Method, Flags = &h21, Description = 546865206E756D626572206F66206D696E75746573207468652061707020686173206265656E2072756E6E696E6720686173206265656E2072756E6E696E672E
		Private Function SoftwareUptimeMinutes() As Double
		  /// The number of minutes the app has been running has been running.
		  
		  // In case the developer forgot to initialise the start time stamp during application launch.
		  If Express.StartTimestamp = Nil Then
		    Express.StartTimestamp = DateTime.Now
		  End If
		  
		  Var now As DateTime = DateTime.Now
		  Var uptimeSeconds As Double = (now.SecondsFrom1970 - StartTimestamp.SecondsFrom1970)
		  Var uptimeMinutes As Double = (uptimeSeconds / 60)
		  
		  Return uptimeMinutes
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 546865206E756D626572206F66207365636F6E6473207468652061707020686173206265656E2072756E6E696E6720686173206265656E2072756E6E696E672E
		Private Function SoftwareUptimeSeconds() As Double
		  /// The number of seconds the app has been running has been running.
		  
		  // In case the developer forgot to initialise the start time stamp during application launch.
		  If Express.StartTimestamp = Nil Then
		    Express.StartTimestamp = DateTime.Now
		  End If
		  
		  Var now As DateTime = DateTime.Now
		  Var uptimeSeconds As Double = (now.SecondsFrom1970 - StartTimestamp.SecondsFrom1970)
		  
		  Return uptimeSeconds
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73207468652072756E74696D6520696E207365636F6E647320666F722074686973206170706C69636174696F6E2E
		Private Function SystemUptimeMinutes() As Double
		  /// Returns the runtime in seconds for this application.
		  
		  Var micros As Double = System.Microseconds
		  Var minutes As Double = (micros / 1000000 / 60)
		  
		  Return minutes
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73207468652072756E74696D6520696E207365636F6E647320666F722074686973206170706C69636174696F6E2E
		Private Function SystemUptimeSeconds() As Double
		  /// Returns the runtime in seconds for this application.
		  
		  Var micros As Double = System.Microseconds
		  Var seconds As Double = (micros / 1000000)
		  
		  Return seconds
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206E756D626572206F66207365636F6E64732074686174206861766520656C61707365642073696E6365204A616E756172792031737420313937302E
		Private Function UnixEpoch() As Double
		  /// Returns the number of seconds that have elapsed since January 1st 1970.
		  
		  Var timestamp As DateTime = DateTime.Now
		  Var epoch As Double = timestamp.SecondsFrom1970
		  
		  Return epoch
		End Function
	#tag EndMethod


End Class
#tag EndClass
