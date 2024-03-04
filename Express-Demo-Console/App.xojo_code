#tag Class
Protected Class App
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  // Use Port 8080 for this demo if not specified otherwise
		  Var arguments As Dictionary = Express.ArgsToDictionary(args)
		  If (Not arguments.HasKey("--Port")) Then
		    args.Add("--Port=8080")
		  End If
		  
		  // Express Demo
		  Print "----------------"
		  Print "- Express-Demo -"
		  Print "----------------"
		  Print Express.CHAR_LOG_BULLET + " Express Version: " + Express.VERSION_STRING
		  Print ""
		  Print ""
		  Print "-----------------"
		  Print "- Choose a demo -"
		  Print "-----------------"
		  Print " 1: Hello World"
		  Print " 2: Hello World (simple plain text response)"
		  Print " 3: Caching (Drummers)"
		  Print " 4: Multipart Forms"
		  Print " 5: Sessions"
		  Print " 6: Templates Client Side"
		  Print " 7: Templates Server Side"
		  Print " 8: WebSockets (simple chat app)"
		  Print " 9: XojoScript"
		  Print "10: ServerThread"
		  Print ""
		  Print ""
		  Print "Enter number and <enter> to start a demo:"
		  
		  Var inputString As String = Input
		  Var inputNumber As Integer = Val(inputString)
		  
		  Select Case inputNumber
		  Case 1
		    Me.Demo_01_HelloWorld(args)
		  Case 2
		    Me.Demo_02_HelloWorldPlainText(args)
		  Case 3
		    Me.Demo_03_Caching(args)
		  Case 4
		    Me.Demo_04_MultipartForms(args)
		  Case 5
		    Me.Demo_05_Sessions(args)
		  Case 6
		    Me.Demo_06_TemplatesClientSide(args)
		  Case 7
		    Me.Demo_07_TemplatesServerSide(args)
		  Case 8
		    Me.Demo_08_WebSockets(args)
		  Case 9
		    Me.Demo_09_XojoScript(args)
		  Case 10
		    Me.Demo_10_ServerThread(args)
		    
		  Else
		    Me.Demo_01_HelloWorld(args)
		    
		  End Select
		  
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


	#tag Method, Flags = &h21
		Private Sub Demo_01_HelloWorld(args() As String)
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  // Note: The Express.RequestHandlerDelegate tells Express.Server which method is going to process the requests
		  Server = New Express.Server(args, AddressOf DemoHelloWorld.RequestProcess)
		  
		  // Configure App to handle Express EventLog with LogLevel Debug
		  Express.EventLogLevel = Express.LogLevel.Debug
		  
		  // Assign the Express.EventLogHandlerDelegate to tell Express which method is processing the EventLogs
		  // Comment out or Assign Nil if you want to use Express's default EventLog-Handling
		  Express.EventLogHandler = WeakAddressOf ExpressEventLog
		  
		  // Start the server.
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Demo_02_HelloWorldPlainText(args() As String)
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  // Note: The Express.RequestHandlerDelegate tells Express.Server which method is going to process the requests
		  Server = New Express.Server(args, AddressOf DemoHelloWorld.SimplePlainTextResponse)
		  
		  // Configure App to handle Express EventLog with LogLevel Debug
		  Express.EventLogLevel = Express.LogLevel.Debug
		  
		  // Assign the Express.EventLogHandlerDelegate to tell Express which method is processing the EventLogs
		  // Comment out or Assign Nil if you want to use Express's default EventLog-Handling
		  Express.EventLogHandler = WeakAddressOf ExpressEventLog
		  
		  // Start the server.
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Demo_03_Caching(args() As String)
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  // Note: The Express.RequestHandlerDelegate tells Express.Server which method is going to process the requests
		  Server = New Express.Server(args, AddressOf DemoCaching.RequestProcess)
		  
		  // Configure App to handle Express EventLog with LogLevel Debug
		  Express.EventLogLevel = Express.LogLevel.Debug
		  
		  // Assign the Express.EventLogHandlerDelegate to tell Express which method is processing the EventLogs
		  // Comment out or Assign Nil if you want to use Express's default EventLog-Handling
		  Express.EventLogHandler = WeakAddressOf ExpressEventLog
		  
		  // Configure server-level caching.
		  // This is used by the DemoCaching demo module.
		  Server.CachingEnabled = True
		  
		  // Start the server.
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Demo_04_MultipartForms(args() As String)
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  // Note: The Express.RequestHandlerDelegate tells Express.Server which method is going to process the requests
		  Server = New Express.Server(args, AddressOf DemoMultipartForms.RequestProcess)
		  
		  // Configure App to handle Express EventLog with LogLevel Debug
		  Express.EventLogLevel = Express.LogLevel.Debug
		  
		  // Assign the Express.EventLogHandlerDelegate to tell Express which method is processing the EventLogs
		  // Comment out or Assign Nil if you want to use Express's default EventLog-Handling
		  Express.EventLogHandler = WeakAddressOf ExpressEventLog
		  
		  // Start the server.
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Demo_05_Sessions(args() As String)
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  // Note: The Express.RequestHandlerDelegate tells Express.Server which method is going to process the requests
		  Server = New Express.Server(args, AddressOf DemoSessions.RequestProcess)
		  
		  // Configure App to handle Express EventLog with LogLevel Debug
		  Express.EventLogLevel = Express.LogLevel.Debug
		  
		  // Assign the Express.EventLogHandlerDelegate to tell Express which method is processing the EventLogs
		  // Comment out or Assign Nil if you want to use Express's default EventLog-Handling
		  Express.EventLogHandler = WeakAddressOf ExpressEventLog
		  
		  // Configure server-level session management. 
		  // This is used by the DemoSessions demo module.
		  Server.SessionsEnabled = True
		  
		  // Start the server.
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Demo_06_TemplatesClientSide(args() As String)
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  // Note: The Express.RequestHandlerDelegate tells Express.Server which method is going to process the requests
		  Server = New Express.Server(args, AddressOf DemoTemplatesClientSide.RequestProcess)
		  
		  // Configure App to handle Express EventLog with LogLevel Debug
		  Express.EventLogLevel = Express.LogLevel.Debug
		  
		  // Assign the Express.EventLogHandlerDelegate to tell Express which method is processing the EventLogs
		  // Comment out or Assign Nil if you want to use Express's default EventLog-Handling
		  Express.EventLogHandler = WeakAddressOf ExpressEventLog
		  
		  // Start the server.
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Demo_07_TemplatesServerSide(args() As String)
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  // Note: The Express.RequestHandlerDelegate tells Express.Server which method is going to process the requests
		  Server = New Express.Server(args, AddressOf DemoTemplatesServerSide.RequestProcess)
		  
		  // Configure App to handle Express EventLog with LogLevel Debug
		  Express.EventLogLevel = Express.LogLevel.Debug
		  
		  // Assign the Express.EventLogHandlerDelegate to tell Express which method is processing the EventLogs
		  // Comment out or Assign Nil if you want to use Express's default EventLog-Handling
		  Express.EventLogHandler = WeakAddressOf ExpressEventLog
		  
		  // Start the server.
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Demo_08_WebSockets(args() As String)
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  // Note: The Express.RequestHandlerDelegate tells Express.Server which method is going to process the requests
		  Server = New Express.Server(args, AddressOf DemoWebSockets.RequestProcess)
		  
		  // Configure App to handle Express EventLog with LogLevel Debug
		  Express.EventLogLevel = Express.LogLevel.Debug
		  
		  // Assign the Express.EventLogHandlerDelegate to tell Express which method is processing the EventLogs
		  // Comment out or Assign Nil if you want to use Express's default EventLog-Handling
		  Express.EventLogHandler = WeakAddressOf ExpressEventLog
		  
		  // Start the server.
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Demo_09_XojoScript(args() As String)
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  // Note: The Express.RequestHandlerDelegate tells Express.Server which method is going to process the requests
		  Server = New Express.Server(args, AddressOf DemoXojoScript.RequestProcess)
		  
		  // Configure App to handle Express EventLog with LogLevel Debug
		  Express.EventLogLevel = Express.LogLevel.Debug
		  
		  // Assign the Express.EventLogHandlerDelegate to tell Express which method is processing the EventLogs
		  // Comment out or Assign Nil if you want to use Express's default EventLog-Handling
		  Express.EventLogHandler = WeakAddressOf ExpressEventLog
		  
		  // Start the server.
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50726F63657373657320616E204854545020726571756573742E
		Private Sub Demo_10_ServerThread(args() As String)
		  // Configure App to handle Express EventLog with LogLevel Debug
		  Express.EventLogLevel = Express.LogLevel.Debug
		  
		  // Assign the Express.EventLogHandlerDelegate to tell Express which method is processing the EventLogs
		  // Comment out or Assign Nil if you want to use Express's default EventLog-Handling
		  Express.EventLogHandler = WeakAddressOf ExpressEventLog
		  
		  // Express.ServerThread demo.
		  // Test ports are: 64000, 64001, 64002, and 64003.
		  // Requests sent to 64003 will respond with an error,
		  // to demonstrate a misconfigured app.
		  
		  DemoServerThreads.ServersLaunch(args, AddressOf DemoServerThreads.RequestProcess)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ExpressEventLog(Message As String, Level As Express.LogLevel) As Boolean
		  //If you don't want to use Express's default EventLog-Handling (StdOut in Console Applications,
		  //System.DebugLog in GUI Applications), then you can add the Express.EventLogHandlerDelegate and
		  //handle the Logging there.
		  //Just make sure to 'Return True' to tell Express to NOT handle the EventLog as well
		  
		  //So this would be the place to forward the Logs to your App's own Log-Handling facility
		  
		  Select Case CType(Level, Integer)
		    
		  Case CType(Express.LogLevel.None, Integer)
		    // Confirm that we have handled this Log, so that Express doesn't handle it, too.
		    Return True
		    
		  Case CType(Express.LogLevel.Critical, Integer)
		    Message = "CRITICAL: " + Message
		  Case CType(Express.LogLevel.Error, Integer)
		    Message = "ERROR: " + Message
		  Case CType(Express.LogLevel.Warning, Integer)
		    Message = "WARNING: " + Message
		  Case CType(Express.LogLevel.Info, Integer)
		    Message = "INFO: " + Message
		  Case CType(Express.LogLevel.Debug, Integer)
		    Message = "DEBUG: " + Message
		    
		  End Select
		  
		  // Let's write all Output to StdOut in this Demo
		  stdout.WriteLine Message
		  stdout.Flush
		  
		  // Confirm that we have handled this Log, so that Express doesn't handle it, too.
		  Return True
		  
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Server As Express.Server
	#tag EndProperty


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
