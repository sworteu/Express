#tag Class
Protected Class MustacheLite
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Initialize the data object.
		  Data = New JSONItem
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Merge()
		  // Merges a template ("Source") with data ("Data"), and stores the result in "Expanded."
		  
		  // Append the system hash to the data hash.
		  If MergeSystemTokens Then
		    SystemDataAppend
		  End If
		  
		  // Load the template.
		  Expanded = Source
		  
		  // Regex used for removal of comments and orphans.
		  Dim rg As New RegEx
		  Dim rgMatch As RegExMatch
		  
		  // Remove comments.
		  If RemoveComments = True Then
		    rg.SearchPattern = "\{\{!(?:(?!}})(.|\n))*\}\}"
		    rgMatch = rg.Search(Expanded)
		    While rgMatch <> Nil
		      Expanded = rg.Replace(Expanded)
		      rgMatch = rg.Search(Expanded)
		    Wend
		  End If
		  
		  // Loop over the data object's values...
		  For Each Key As String In Data.Names
		    
		    // Get the value.
		    Dim Value As Variant = Data.Value(Key)
		    
		    // If the value is null...
		    If Value = Nil Then
		      Continue
		    End If
		    
		    // Use introspection to determine the entry's value type.
		    Dim ValueType As Introspection.TypeInfo = Introspection.GetType(Value)
		    
		    // If the value is a boolean, number, string, etc..
		    If ValueType.IsPrimitive Then
		      
		      // Convert the primitive value to a string.
		      Dim ValueString As String = Value.StringValue
		      
		      // Using the object's name and the entry's key, generate the token to replace.
		      Dim Token As String = If(KeyPrefix <> "", KeyPrefix + ".", "") + Key
		      
		      // Replace all occurrences of the token with the value.
		      Expanded = Expanded.ReplaceAll("{{" + Token + "}}", ValueString)
		      
		      Continue
		      
		    End If
		    
		    // If the value is a nested JSONItem...
		    If ValueType.Name = "JSONItem" Then
		      
		      // Get the nested JSONItem.
		      Dim NestedJSON As JSONItem = Value
		      
		      // If the nested JSONItem is not an array...
		      If NestedJSON.IsArray = False Then
		        
		        // Process the nested JSON using another Template instance. 
		        Dim Engine As New MustacheLite
		        Engine.Source = Expanded
		        Engine.Data = NestedJSON
		        Engine.KeyPrefix = If(KeyPrefix <> "", KeyPrefix + ".", "") + Key
		        Engine.MergeSystemTokens = False
		        Engine.RemoveComments = False
		        Engine.RemoveOrphans = False
		        Engine.Merge
		        Expanded = Engine.Expanded
		        
		      Else
		        
		        // Get the beginning and ending tokens for this array.
		        Dim TokenBegin As String = "{{#" + If(KeyPrefix <> "", KeyPrefix + ".", "") + Key + "}}"
		        Dim TokenEnd As String = "{{/" + If(KeyPrefix <> "", KeyPrefix + ".", "") + Key + "}}"
		        
		        // Get the start position of the beginning token.
		        Dim StartPosition As Integer = Source.IndexOf(0, TokenBegin) 
		        
		        // Get the position of the ending token.
		        Dim StopPosition As Integer = Source.IndexOf(StartPosition, TokenEnd)
		        
		        // If the template does not include both the beginning and ending tokens...
		        If ( (StartPosition = -1) Or (StopPosition = -1) ) Then
		          // We do not need to merge the array.
		          Continue
		        End If
		        
		        // Get the content between the beginning and ending tokens.
		        Dim LoopSource As String = Source.Middle( StartPosition + TokenBegin.Length, StopPosition - StartPosition - TokenBegin.Length)
		        
		        // LoopContent is the content created by looping over the array and merging each value.
		        Dim LoopContent As String
		        
		        // Loop over the array elements...
		        For i As Integer = 0 to NestedJSON.Count - 1
		          
		          Dim ArrayValue As Variant = NestedJSON.ValueAt(i)
		          
		          // Process the value using another instance of Template. 
		          Dim Engine As New MustacheLite
		          Engine.Source = LoopSource
		          Engine.Data = ArrayValue
		          Engine.KeyPrefix = If(KeyPrefix <> "", KeyPrefix + ".", "") + Key
		          Engine.MergeSystemTokens = False
		          Engine.RemoveComments = False
		          Engine.RemoveOrphans = False
		          Engine.Merge
		          
		          // Append the expanded content with the loop content.
		          LoopContent = LoopContent + Engine.Expanded
		          
		        Next
		        
		        // Substitute the loop content block of the template with the expanded content.
		        Dim LoopBlock As String = TokenBegin + LoopSource + TokenEnd
		        Expanded = Expanded.ReplaceAll(LoopBlock, LoopContent)
		        
		      End If
		      
		      Continue
		      
		    End If
		    
		    // This is an unhandled value type.
		    // In theory, we should never get this far.
		    // Look at ValueType.Name to determine what the type is.
		    Break
		    
		  Next
		  
		  // Remove orphaned tokens.
		  If RemoveOrphans = True Then
		    rg.SearchPattern = "\{\{(?:(?!}}).)*\}\}"
		    rgMatch = rg.Search(Expanded)
		    While rgMatch <> Nil
		      Expanded = rg.Replace(Expanded)
		      rgMatch = rg.Search(Expanded)
		    Wend
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SystemDataAppend()
		  // Initialize the system object, which is used to merge system tokens.
		  Dim SystemData As New JSONItem
		  
		  // Append the system object to the data object.
		  Data.Value("system") = SystemData
		  
		  // Add the Date object.
		  Dim DateData As New JSONItem
		  Dim Today As DateTime = DateTime.Now
		  DateData.Value("abbreviateddate") = Today.ToString( Nil, DateTime.FormatStyles.Medium, DateTime.FormatStyles.None )
		  DateData.Value("day") = Today.Day.ToString
		  DateData.Value("dayofweek") = Today.DayOfWeek.ToString
		  DateData.Value("dayofyear") = Today.DayOfYear.ToString
		  Dim GMTOffset As Double = Today.Timezone.SecondsFromGMT / 3600 //3600 seconds in an hour
		  DateData.Value("gmtoffset") = GMTOffset.ToString
		  DateData.Value("hour") = Today.Hour.ToString
		  DateData.Value("longdate") = Today.ToString( Nil, DateTime.FormatStyles.Long, DateTime.FormatStyles.None )
		  DateData.Value("longtime") = Today.ToString( Nil, DateTime.FormatStyles.None, DateTime.FormatStyles.Medium ) // This is the closest equivalent to the old code. We might have to trip the AM and PM off the end
		  DateData.Value("minute") = Today.Minute.ToString
		  DateData.Value("month") = Today.Month.ToString
		  DateData.Value("second") = Today.Second.ToString
		  DateData.Value("shortdate") = Today.ToString( Nil, DateTime.FormatStyles.Short, DateTime.FormatStyles.None )
		  DateData.Value("shorttime") = Today.ToString( Nil, DateTime.FormatStyles.None, DateTime.FormatStyles.Short )
		  DateData.Value("sql") = Today.SQLDate
		  DateData.Value("sqldate") = Today.SQLDate
		  DateData.Value("sqldatetime") = Today.SQLDateTime
		  DateData.Value("SecondsFrom1970") = Today.SecondsFrom1970
		  DateData.Value("weekofyear") = Today.WeekOfYear.ToString
		  DateData.Value("year") = Today.Year.ToString
		  SystemData.Value("date") = DateData
		  
		  // Add the Meta object.
		  Dim MetaData As New JSONItem
		  MetaData.Value("xojo-version") = XojoVersionString
		  MetaData.Value("express-version") = Express.VERSION_STRING
		  SystemData.Value("meta") = MetaData
		  
		  // Add the Request object.
		  Dim RequestData As New JSONItem
		  Var cookiesJSON As JSONItem = Request.Cookies
		  RequestData.Value("cookies") = cookiesJSON
		  RequestData.Value("data") = Request.Data
		  Var getParamsJSON As JSONItem = Request.GET
		  RequestData.Value("get") = getParamsJSON
		  Var headersJSON As JSONItem = Request.Headers
		  RequestData.Value("headers") = headersJSON
		  RequestData.Value("method") = Request.Method
		  RequestData.Value("path") = Request.Path
		  Var postParamsJSON As JSONItem = Request.POST
		  RequestData.Value("post") = postParamsJSON
		  RequestData.Value("remoteaddress") = Request.RemoteAddress
		  RequestData.Value("socketid") = Request.SocketID
		  RequestData.Value("urlparams") = Request.URLParams
		  SystemData.Value("request") = RequestData
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Data As JSONItem
	#tag EndProperty

	#tag Property, Flags = &h0
		Expanded As String
	#tag EndProperty

	#tag Property, Flags = &h0
		KeyPrefix As String
	#tag EndProperty

	#tag Property, Flags = &h0
		MergeSystemTokens As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		RemoveComments As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		RemoveOrphans As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As Express.Request
	#tag EndProperty

	#tag Property, Flags = &h0
		Source As String
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
			Name="KeyPrefix"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Source"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Expanded"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RemoveOrphans"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RemoveComments"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MergeSystemTokens"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
