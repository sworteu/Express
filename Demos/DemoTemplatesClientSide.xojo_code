#tag Module
Protected Module DemoTemplatesClientSide
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub RequestProcess(Request As Express.Request)
		  // By default, the Request.StaticPath points to an "htdocs" folder.
		  // In this example, we're using an alternate folder.
		  #If DebugBuild Then
		    Request.StaticPath = App.ExecutableFile.Parent.Parent.Child("htdocs").Child("demo-templates-client-side")
		  #Else
		    Request.StaticPath = App.ExecutableFile.Parent.Child("htdocs").Child("demo-templates-client-side")
		  #EndIf
		  
		  // Process the request based on the path of the requested resource...
		  If Request.Path = "/data" Then
		    
		    // Simulate a slow query.
		    'Thread.SleepCurrent(10)
		    
		    // Get the orders.
		    Dim Orders As String 
		    #If DebugBuild Then
		      orders = Express.FileRead(Request.StaticPath.Parent.Parent.Child("data").Child("orders.json"))
		    #Else
		      Orders = Express.FileRead(Request.StaticPath.Parent.Child("data").Child("orders.json"))
		    #EndIf
		    
		    Try
		      
		      // Create the data object.
		      Dim Data As Dictionary = ParseJSON(Orders)
		      Data.Value("system") = SystemDataGet(Request)
		      
		      // Return the data as a JSON string.
		      Request.Response.Content = GenerateJSON(Data, Request.GET.HasKey("pretty"))
		      
		      // Specify the response content type.
		      Request.Response.Headers.Value("Content-Type") = "application/json"
		      
		    Catch e As InvalidArgumentException
		      // Could not create the json from dictionary
		      Request.Response.Status = "501"
		      Request.Response.Content = "Internal Server Error"
		      Request.Response.Headers.Value("Content-Type") = "text/html"
		    Catch e As InvalidJSONException
		      // Could not parse the json from the string
		      Request.Response.Status = "501"
		      Request.Response.Content = "Internal Server Error"
		      Request.Response.Headers.Value("Content-Type") = "text/html"
		    End Try
		    
		  Else
		    
		    // Map the request to a file.
		    Request.MapToFile
		    
		    // If the request couldn't be mapped to a static file...
		    If Request.Response.Status = "404" Then
		      
		      // Return the standard 404 error response.
		      // You could also use a custom error handler that sets Request.Response.Content.
		      Request.ResourceNotFound
		      
		    Else
		      
		      // Set the Cache-Control header value so that static content is cached for 1 hour.
		      Request.Response.Headers.Value("Cache-Control") = "public, max-age=3600"
		      
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SystemDataGet(Request As Express.Request) As Dictionary
		  // Add the Date object.
		  Dim DateData As New Dictionary
		  
		  Dim Today As DateTime = DateTime.Now
		  DateData.Value("abbreviateddate") = Today.ToString( Nil, DateTime.FormatStyles.Medium, DateTime.FormatStyles.None )
		  DateData.Value("day") = Today.Day
		  DateData.Value("dayofweek") = Today.DayOfWeek
		  DateData.Value("dayofyear") = Today.DayOfYear
		  Dim GMTOffset As Double = Today.Timezone.SecondsFromGMT // The actual offset
		  DateData.Value("gmtoffset") = GMTOffset
		  DateData.Value("hour") = Today.Hour
		  DateData.Value("longdate") = Today.ToString( Nil, DateTime.FormatStyles.Long, DateTime.FormatStyles.None )
		  DateData.Value("longtime") = Today.ToString( Nil, DateTime.FormatStyles.None, DateTime.FormatStyles.Medium ) // This is the closest equivalent to the old code. We might have to trip the AM and PM off the end
		  DateData.Value("minute") = Today.Minute
		  DateData.Value("month") = Today.Month
		  DateData.Value("second") = Today.Second
		  DateData.Value("shortdate") = Today.ToString( Nil, DateTime.FormatStyles.Short, DateTime.FormatStyles.None )
		  DateData.Value("shorttime") = Today.ToString( Nil, DateTime.FormatStyles.None, DateTime.FormatStyles.Short )
		  DateData.Value("sql") = Today.SQLDate
		  DateData.Value("sqldate") = Today.SQLDate
		  DateData.Value("sqldatetime") = Today.SQLDateTime
		  DateData.Value("SecondsFrom1970") = Today.SecondsFrom1970
		  DateData.Value("weekofyear") = Today.WeekOfYear
		  DateData.Value("year") = Today.Year
		  
		  // Add the Meta object.
		  Dim MetaData As New Dictionary
		  MetaData.Value("xojo-version") = XojoVersionString
		  MetaData.Value("express-version") = Express.VersionString
		  
		  // Add the Request object.
		  Dim RequestData As New Dictionary
		  RequestData.Value("cookies") = Request.Cookies
		  RequestData.Value("data") = Request.Data
		  RequestData.Value("get") = Request.GET
		  RequestData.Value("headers") = Request.Headers
		  RequestData.Value("method") = Request.Method
		  RequestData.Value("path") = Request.Path
		  RequestData.Value("post") = Request.POST
		  RequestData.Value("remoteaddress") = Request.RemoteAddress
		  RequestData.Value("socketid") = Request.SocketID.ToString
		  RequestData.Value("urlparams") = Request.URLParams
		  
		  // Create the system object.
		  Dim SystemData As New Dictionary
		  SystemData.Value("date") = DateData
		  SystemData.Value("meta") = MetaData
		  SystemData.Value("request") = RequestData
		  
		  Return SystemData
		  
		  
		  
		  
		End Function
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
