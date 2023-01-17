#tag Class
Protected Class DrummersList
	#tag CompatibilityFlags = ( TargetConsole and ( Target32Bit or Target64Bit ) ) or ( TargetWeb and ( Target32Bit or Target64Bit ) ) or ( TargetDesktop and ( Target32Bit or Target64Bit ) ) or ( TargetIOS and ( Target32Bit or Target64Bit ) )
	#tag Method, Flags = &h0
		Sub Constructor(Request As Express.Request)
		  // Store the request instance so that it can be used throughout the class.
		  Self.Request = Request
		  
		  // Get the data.
		  DrummersGet
		  
		  // If the database is not available, or rhe query failed to return data...
		  If Request.Response.Status <> "200 OK" Then
		    Request.Response.Content = "Sorry, but we're unable to connect our database at the moment."
		    Return
		  End If
		  
		  // Use the data to generate a response.
		  ResponseGenerate
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DatabaseConnect()
		  // Opens a connection to the SQLite database.
		  
		  
		  // Create a folderitem that points to the database file.
		  DatabaseFile = App.ExecutableFile.Parent.Parent.Child("data").Child("drummers.sqlite")
		  
		  // Create a new database instance.
		  Database = New SQLiteDatabase
		  
		  // Assume that the connection will fail.
		  DatabaseConnected = False
		  
		  // If the database file doesn't exist...
		  If DatabaseFile = Nil or DatabaseFile.Exists = False Then
		    Return
		  End If
		  
		  // Assign the database file to the database.
		  Database.DatabaseFile = DatabaseFile
		  
		  // If we can connect the database...
		  If Database.Connect Then
		    DatabaseConnected = True
		  End If
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DrummersGet()
		  // Try to get the data from the cache.
		  Var CacheEntry As Dictionary = Request.Server.CacheEngine.Get("Drummers")
		  
		  // If cached data is available...
		  If CacheEntry <> Nil Then
		    Drummers = CacheEntry.Value("Content")
		    CacheExpiration = CacheEntry.Value("Expiration")
		    CacheUsed = True
		    Return
		  End If
		  
		  // Try to connect to the database.
		  DatabaseConnect
		  
		  // If we were unable to connect to the database...
		  If DatabaseConnected = False Then
		    Request.Response.Status = "500"
		    Return
		  End If
		  
		  // Try to get the records from the database.
		  RecordsGet
		  
		  // If we were unable to get records from the database...
		  If Records = Nil or Records.RowCount = 0 Then
		    Request.Response.Status = "500"
		    Return
		  End If
		  
		  // Convert the recordset to a JSON object.
		  Drummers = Express.RowSetToJSONItem(Records)
		  
		  // Cache the data.
		  Request.Server.CacheEngine.Put("Drummers", Drummers, 300)
		  
		  // Get the cache entry so that we have access to its expiration.
		  CacheEntry = Request.Server.CacheEngine.Get("Drummers")
		  CacheExpiration = CacheEntry.Value("Expiration")
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RecordsGet()
		  // Gets all records from the Drummers table.
		  
		  
		  // Simulate a slow query.
		  Thread.SleepCurrent(3000)
		  
		  // Prepare a SQL statement.
		  Var SQL As String = "SELECT * FROM Drummers ORDER BY Votes DESC"
		  
		  // Create a prepared statement.
		  Var PS As SQLitePreparedStatement = Database.Prepare(SQL)
		  
		  // Perform the query.
		  Records = PS.SelectSQL
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ResponseGenerate()
		  // Prepare a JSON item for use with the Template.
		  Var TemplateData As New JSONItem
		  TemplateData.Value("cached") = CacheUsed.ToString
		  TemplateData.Value("cacheExpiration") = CacheExpiration.ToString( Nil, DateTime.FormatStyles.None, DateTime.FormatStyles.Short )
		  TemplateData.Value("drummers") = Drummers
		  
		  // Create a Template instance.  
		  Var Template As New Templates.MustacheLite
		  
		  // Load the template file and use it as the source.
		  Template.Source = Express.FileRead(Request.StaticPath.Child("template-index.html"))
		  
		  // Set the merge data source.
		  Template.Data = TemplateData
		  
		  // Pass the Request to the Template so that request-related system tokens can be handled.
		  Template.Request = Request
		  
		  // Merge the template with the data.
		  Template.Merge
		  
		  // Update the response content with the expanded template.
		  Request.Response.Content = Template.Expanded
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		CacheExpiration As DateTime
	#tag EndProperty

	#tag Property, Flags = &h0
		CacheUsed As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Database As SQLiteDatabase
	#tag EndProperty

	#tag Property, Flags = &h0
		DatabaseConnected As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		DatabaseFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		Drummers As JSONItem
	#tag EndProperty

	#tag Property, Flags = &h0
		Records As RowSet
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As Express.Request
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
		#tag ViewProperty
			Name="DatabaseConnected"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CacheUsed"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
