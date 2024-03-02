#tag Module
Protected Module DemoTemplatesClientSide
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub RequestProcess(request As Express.Request)
		  // By default, the Request.StaticPath points to an "htdocs" folder.
		  // In this example, we're using an alternate folder.
		  #If DebugBuild Then
		    request.StaticPath = Specialfolder.Resources.Child("htdocs").Child("demo-templates-client-side")
		  #Else
		    request.StaticPath = App.ExecutableFile.Parent.Child("htdocs").Child("demo-templates-client-side")
		  #EndIf
		  
		  // Process the request based on the path of the requested resource...
		  If request.Path = "/data" Then
		    
		    // Simulate a slow query.
		    'Thread.SleepCurrent(10)
		    
		    // Get the orders.
		    Var orders As String 
		    #If DebugBuild Then
		      orders = Express.FileRead(request.StaticPath.Parent.Parent.Child("data").Child("orders.json"))
		    #Else
		      Orders = Express.FileRead(request.StaticPath.Parent.Child("data").Child("orders.json"))
		    #EndIf
		    
		    Try
		      
		      // Create the data object.
		      Var data As Dictionary = ParseJSON(orders)
		      data.Value("system") = SystemDataGet(request)
		      
		      // Return the data as a JSON string.
		      request.Response.Content = GenerateJSON(data, request.GET.HasKey("pretty"))
		      
		      // Specify the response content type.
		      request.Response.Headers.Value("Content-Type") = "application/json"
		      
		    Catch e As InvalidArgumentException
		      // Could not create the json from dictionary
		      request.Response.Status = "501"
		      request.Response.Content = "Internal Server Error"
		      request.Response.Headers.Value("Content-Type") = "text/html"
		    Catch e As JSONException
		      // Could not parse the json from the string
		      request.Response.Status = "501"
		      request.Response.Content = "Internal Server Error"
		      request.Response.Headers.Value("Content-Type") = "text/html"
		    End Try
		    
		  Else
		    
		    // Map the request to a file.
		    request.MapToFile
		    
		    // If the request couldn't be mapped to a static file...
		    If request.Response.Status = "404" Then
		      
		      // Return the standard 404 error response.
		      // You could also use a custom error handler that sets Request.Response.Content.
		      request.ResourceNotFound
		      
		    Else
		      
		      // Set the Cache-Control header value so that static content is cached for 1 hour.
		      request.Response.Headers.Value("Cache-Control") = "public, max-age=3600"
		      
		    End If
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SystemDataGet(request As Express.Request) As Dictionary
		  // Add the Date object.
		  Var dateData As New Dictionary
		  
		  Var today As DateTime = DateTime.Now
		  dateData.Value("abbreviateddate") = today.ToString( Nil, DateTime.FormatStyles.Medium, DateTime.FormatStyles.None )
		  dateData.Value("day") = today.Day
		  dateData.Value("dayofweek") = today.DayOfWeek
		  dateData.Value("dayofyear") = today.DayOfYear
		  Var GMTOffset As Double = today.Timezone.SecondsFromGMT // The actual offset
		  dateData.Value("gmtoffset") = GMTOffset
		  dateData.Value("hour") = today.Hour
		  dateData.Value("longdate") = today.ToString( Nil, DateTime.FormatStyles.Long, DateTime.FormatStyles.None )
		  dateData.Value("longtime") = today.ToString( Nil, DateTime.FormatStyles.None, DateTime.FormatStyles.Medium ) // This is the closest equivalent to the old code. We might have to trip the AM and PM off the end
		  dateData.Value("minute") = today.Minute
		  dateData.Value("month") = today.Month
		  dateData.Value("second") = today.Second
		  dateData.Value("shortdate") = today.ToString( Nil, DateTime.FormatStyles.Short, DateTime.FormatStyles.None )
		  dateData.Value("shorttime") = today.ToString( Nil, DateTime.FormatStyles.None, DateTime.FormatStyles.Short )
		  dateData.Value("sql") = today.SQLDate
		  dateData.Value("sqldate") = today.SQLDate
		  dateData.Value("sqldatetime") = today.SQLDateTime
		  dateData.Value("SecondsFrom1970") = today.SecondsFrom1970
		  dateData.Value("weekofyear") = today.WeekOfYear
		  dateData.Value("year") = today.Year
		  
		  // Add the Meta object.
		  Var metaData As New Dictionary
		  metaData.Value("xojo-version") = XojoVersionString
		  metaData.Value("express-version") = Express.VERSION_STRING
		  
		  // Add the Request object.
		  Var requestData As New Dictionary
		  requestData.Value("cookies") = request.Cookies
		  requestData.Value("data") = request.Data
		  requestData.Value("get") = request.GET
		  requestData.Value("headers") = request.Headers
		  requestData.Value("method") = request.Method
		  requestData.Value("path") = request.Path
		  requestData.Value("post") = request.POST
		  requestData.Value("remoteaddress") = request.RemoteAddress
		  requestData.Value("socketid") = request.SocketID.ToString
		  requestData.Value("urlparams") = request.URLParams
		  
		  // Create the system object.
		  Var systemData As New Dictionary
		  systemData.Value("date") = dateData
		  systemData.Value("meta") = metaData
		  systemData.Value("request") = requestData
		  
		  Return systemData
		  
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
