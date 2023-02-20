#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  StartTimestamp = DateTime.Now
		  
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  Server = New Express.Server(args)
		  
		  // Configure server-level session management. 
		  // This is used by the DemoSessions demo module.
		  Server.SessionsEnabled = True
		  
		  // Configure server-level caching.
		  // This is used by the DemoCaching demo module.
		  Server.CachingEnabled = True
		  
		  server.KeepAlive = True
		  
		  // Start the server.
		  Server.Start
		  
		End Function
	#tag EndEvent

	#tag Event
		Function UnhandledException(error As RuntimeException) As Boolean
		  Var exceptionType As Introspection.TypeInfo = Introspection.GetType(error)
		  
		  System.Log System.LogLevelCritical, CurrentMethodName + ", " + exceptionType.FullName
		  System.Log System.LogLevelCritical, "Message: " + error.Message
		  System.Log System.LogLevelCritical, "Error Number: " + error.ErrorNumber.ToString
		  
		  Var traces(-1) As String = error.Stack
		  
		  If traces.Count > 0 Then
		    
		    System.Log System.LogLevelCritical, "BEGIN STACK TRACE >"
		    
		    For Each trace As String In traces
		      
		      System.Log System.LogLevelCritical, trace
		      
		    Next trace
		    
		    System.Log System.LogLevelCritical, "END STACK TRACE <"
		    
		  End If
		  
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0, Description = 50726F63657373657320616E204854545020726571756573742E
		Sub RequestHandler(Request As Express.Request, Response As Express.Response)
		  /// Processes an HTTP request.
		  ///
		  /// Uncomment the demo module that you want to use.
		  
		  // Keep the analyser happy.
		  #Pragma Unused Response
		  
		  // Hello, world demo.
		  DemoHelloWorld.RequestProcess(Request)
		  
		  // Or simply...
		  'Request.Response.Content = "Hello, world!"
		  
		  // Express.CacheEngine.
		  'DemoCaching.RequestProcess(Request)
		  
		  // Multipart forms demo.
		  DemoMultipartForms.RequestProcess(Request)
		  
		  // Express.SessionEngine.
		  'DemoSessions.RequestProcess(Request)
		  
		  // Demonstrates the use of client-side templating.
		  'DemoTemplatesClientSide.RequestProcess(Request)
		  
		  // Demonstrates the use of server-side templates.
		  'DemoTemplatesServerSide.RequestProcess(Request)
		  
		  // A simple chat app that demonstrates WebSocket support.
		  'DemoWebSockets.RequestProcess(Request)
		  
		  // Demonstrates Xojoscript support.
		  //DemoXojoScript.RequestProcess(Request)
		  
		  // Express.ServerThread demo.
		  // *** Before using this demo... *** 
		  // Replace the App.Run event handler with this: 
		  // DemoServerThreads.ServersLaunch
		  // Test ports are: 64000, 64001, 64002, and 64003.
		  // Requests sent to 64003 will respond with an error,
		  // to demonstrate a misconfigured app.
		  'DemoServerThreads.RequestProcess(Request)
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Server As Express.Server
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
