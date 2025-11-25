#tag Class
Protected Class MustacheLite
	#tag Method, Flags = &h0, Description = 44656661756C7420636F6E7374727563746F722E
		Sub Constructor()
		  // Default constructor.
		  
		  // Initialise the data object.
		  Data = New JSONItem
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4D657267657320612074656D706C617465202860536F757263656029207769746820646174612028604461746160292C20616E642073746F7265732074686520726573756C7420696E2060457870616E646564602E
		Sub Merge()
		  /// Merges a template (`Source`) with data (`Data`), and stores the result in `Expanded`.
		  
		  // Append the system hash to the data hash.
		  If MergeSystemTokens Then
		    SystemDataAppend
		  End If
		  
		  // Load the template.
		  Expanded = Source
		  
		  // Regex used for removal of comments and orphans.
		  Var rg As New RegEx
		  Var rgMatch As RegExMatch
		  
		  // Remove comments.
		  If RemoveComments = True Then
		    rg.SearchPattern = "\{\{!(?:(?!}})(.|\n))*\}\}"
		    rgMatch = rg.Search(Expanded)
		    While rgMatch <> Nil
		      Expanded = rg.Replace(Expanded)
		      rgMatch = rg.Search(Expanded)
		    Wend
		  End If
		  
		  // ============================================================================
		  // HANDLE CONDITIONAL SECTIONS (before processing data keys)
		  // Process {{#key}}...{{/key}} for missing or falsy keys (remove entire section)
		  // Process {{^key}}...{{/key}} inverted sections (show when key is missing/falsy)
		  // ============================================================================
		  
		  // First, find and process all section tags in the template
		  Var sectionRegex As New RegEx
		  sectionRegex.SearchPattern = "\{\{([#^])([^}]+)\}\}"
		  
		  Var processedSections() As String // Track which sections we've handled
		  
		  rgMatch = sectionRegex.Search(Expanded)
		  While rgMatch <> Nil
		    Var sectionType As String = rgMatch.SubExpressionString(1) // "#" or "^"
		    Var sectionKey As String = rgMatch.SubExpressionString(2).Trim
		    
		    // Skip if we've already processed this section
		    Var sectionId As String = sectionType + sectionKey
		    If processedSections.IndexOf(sectionId) > -1 Then
		      rgMatch = sectionRegex.Search(Expanded, rgMatch.SubExpressionStartB(0) + rgMatch.SubExpressionString(0).Bytes + 1)
		      Continue
		    End If
		    processedSections.Add(sectionId)
		    
		    // Build the token strings
		    Var tokenBegin As String = "{{" + sectionType + sectionKey + "}}"
		    Var tokenEnd As String = "{{/" + sectionKey + "}}"
		    
		    // Find the positions
		    Var startPos As Integer = Expanded.IndexOf(tokenBegin)
		    Var endPos As Integer = Expanded.IndexOf(startPos, tokenEnd)
		    
		    If startPos = -1 Or endPos = -1 Then
		      rgMatch = sectionRegex.Search(Expanded, rgMatch.SubExpressionStartB(0) + rgMatch.SubExpressionString(0).Bytes + 1)
		      Continue
		    End If
		    
		    // Get the content between the tags
		    Var innerContent As String = Expanded.Middle(startPos + tokenBegin.Length, endPos - startPos - tokenBegin.Length)
		    Var fullSection As String = tokenBegin + innerContent + tokenEnd
		    
		    // Determine if the key exists and is truthy
		    Var keyExists As Boolean = Data.HasKey(sectionKey)
		    Var isTruthy As Boolean = False
		    
		    If keyExists Then
		      Var value As Variant = Data.Value(sectionKey)
		      If value <> Nil Then
		        Select Case value.Type
		        Case Variant.TypeBoolean
		          isTruthy = value.BooleanValue
		        Case Variant.TypeString, Variant.TypeText
		          isTruthy = (value.StringValue <> "")
		        Case Variant.TypeInt32, Variant.TypeInt64
		          isTruthy = (value.IntegerValue <> 0)
		        Case Variant.TypeDouble
		          isTruthy = (value.DoubleValue <> 0)
		        Case Else
		          // For objects (like JSONItem), check if it's an array with items or a non-empty object
		          Var valueType As Introspection.TypeInfo = Introspection.GetType(value)
		          If valueType.Name = "JSONItem" Then
		            Var jsonVal As JSONItem = value
		            If jsonVal.IsArray Then
		              isTruthy = (jsonVal.Count > 0)
		            Else
		              isTruthy = True // Non-array JSONItem is truthy (will be processed later)
		            End If
		          Else
		            isTruthy = True // Other objects are truthy
		          End If
		        End Select
		      End If
		    End If
		    
		    // Handle based on section type
		    If sectionType = "#" Then
		      // Regular section: show if truthy
		      If isTruthy Then
		        // Check if it's a JSONItem that needs special processing (arrays handled later)
		        If keyExists Then
		          Var value As Variant = Data.Value(sectionKey)
		          If value <> Nil Then
		            Var valueType As Introspection.TypeInfo = Introspection.GetType(value)
		            If valueType <> Nil And valueType.Name = "JSONItem" Then
		              // Let the existing array/object handling code deal with this
		              rgMatch = sectionRegex.Search(Expanded, rgMatch.SubExpressionStartB(0) + rgMatch.SubExpressionString(0).Bytes + 1)
		              Continue
		            End If
		          End If
		        End If
		        // For simple truthy values, just remove the section tags but keep content
		        Expanded = Expanded.Replace(fullSection, innerContent)
		      Else
		        // Remove the entire section
		        Expanded = Expanded.Replace(fullSection, "")
		      End If
		    Else
		      // Inverted section (^): show if falsy/missing
		      If Not isTruthy Then
		        // Remove the section tags but keep content
		        Expanded = Expanded.Replace(fullSection, innerContent)
		      Else
		        // Remove the entire section
		        Expanded = Expanded.Replace(fullSection, "")
		      End If
		    End If
		    
		    // Start search over since we modified the string
		    rgMatch = sectionRegex.Search(Expanded)
		  Wend
		  
		  // ============================================================================
		  // END CONDITIONAL SECTIONS
		  // ============================================================================
		  
		  // Loop over the data object's values.
		  For Each key As String In Data.Keys
		    
		    // Get the value.
		    Var value As Variant = Data.Value(key)
		    
		    // If the value is Nil then continue.
		    If value = Nil Then
		      Continue
		    End If
		    
		    // Handle Xojo primitive types first.
		    Select Case value.Type
		    Case Variant.TypeBoolean, Variant.TypeDouble, Variant.TypeInt32, Variant.TypeInt64, Variant.TypeString, _
		      Variant.TypeText, Variant.TypeDateTime, Variant.TypeColor, Variant.TypeCurrency
		      // Convert the primitive value to a string.
		      Var valueString As String = value.StringValue
		      
		      // Using the object's name and the entry's key, generate the token to replace.
		      Var token As String = If(KeyPrefix <> "", KeyPrefix + ".", "") + key
		      
		      // Replace all occurrences of the token with the value.
		      Expanded = Expanded.ReplaceAll("{{" + Token + "}}", valueString)
		      
		      Continue
		    End Select
		    
		    // Not a primitive value. Use introspection to determine the entry's value type.
		    Var valueType As Introspection.TypeInfo = Introspection.GetType(value)
		    
		    // If the value is a nested JSONItem.
		    If valueType.Name = "JSONItem" Then
		      
		      // Get the nested JSONItem.
		      Var nestedJSON As JSONItem = value
		      
		      // If the nested JSONItem is not an array.
		      If nestedJSON.IsArray = False Then
		        
		        // Process the nested JSON using another Template instance. 
		        Var engine As New MustacheLite
		        engine.Source = Expanded
		        engine.Data = nestedJSON
		        engine.KeyPrefix = If(KeyPrefix <> "", KeyPrefix + ".", "") + key
		        engine.MergeSystemTokens = False
		        engine.RemoveComments = False
		        engine.RemoveOrphans = False
		        engine.Merge
		        Expanded = engine.Expanded
		        
		      Else
		        
		        // Get the beginning and ending tokens for this array.
		        Var tokenBegin As String = "{{#" + If(KeyPrefix <> "", KeyPrefix + ".", "") + key + "}}"
		        Var tokenEnd As String = "{{/" + If(KeyPrefix <> "", KeyPrefix + ".", "") + key + "}}"
		        
		        // Get the start position of the beginning token.
		        Var startPosition As Integer = Expanded.IndexOf(0, tokenBegin) 
		        
		        // Get the position of the ending token.
		        Var stopPosition As Integer = Expanded.IndexOf(startPosition, tokenEnd)
		        
		        // If the template does not include both the beginning and ending tokens.
		        If ( (startPosition = -1) Or (stopPosition = -1) ) Then
		          // We do not need to merge the array.
		          Continue
		        End If
		        
		        // Get the content between the beginning and ending tokens.
		        Var loopSource As String = Expanded.Middle( startPosition + tokenBegin.Length, stopPosition - startPosition - tokenBegin.Length)
		        
		        // LoopContent is the content created by looping over the array and merging each value.
		        Var loopContent As String
		        
		        // Loop over the array elements.
		        For i As Integer = 0 To NestedJSON.Count - 1
		          
		          Var arrayValue As Variant = NestedJSON.ValueAt(i)
		          
		          // Process the value using another MustacheLite instance. 
		          Var engine As New MustacheLite
		          engine.Source = loopSource
		          engine.Data = arrayValue
		          engine.KeyPrefix = If(KeyPrefix <> "", KeyPrefix + ".", "") + key
		          engine.MergeSystemTokens = False
		          engine.RemoveComments = False
		          Engine.RemoveOrphans = False
		          Engine.Merge
		          
		          // Append the expanded content with the loop content.
		          loopContent = loopContent + engine.Expanded
		          
		        Next i
		        
		        // Substitute the loop content block of the template with the expanded content.
		        Var loopBlock As String = tokenBegin + loopSource + tokenEnd
		        Expanded = Expanded.ReplaceAll(loopBlock, loopContent)
		        
		      End If
		      
		      Continue
		      
		    End If
		    
		    // This is an unhandled value type.
		    // In theory, we should never get this far.
		    // Look at ValueType.Name to determine what the type is.
		    Break
		    
		  Next key
		  
		  // Remove orphaned tokens.
		  If RemoveOrphans = True Then
		    rg.SearchPattern = "\{\{(?:(?!}}).)*\}\}"
		    rgMatch = rg.Search(Expanded)
		    While rgMatch <> Nil
		      Expanded = rg.Replace(Expanded)
		      rgMatch = rg.Search(Expanded)
		    Wend
		  End If
		  
		  
		  
		  
		  
		  
		  
		  ' // Merges a template (`Source`) with data (`Data`), and stores the result in `Expanded`.
		  ' 
		  ' // Append the system hash to the data hash.
		  ' If MergeSystemTokens Then
		  ' SystemDataAppend
		  ' End If
		  ' 
		  ' // Load the template.
		  ' Expanded = Source
		  ' 
		  ' // Regex used for removal of comments and orphans.
		  ' Var rg As New RegEx
		  ' Var rgMatch As RegExMatch
		  ' 
		  ' // Remove comments.
		  ' If RemoveComments = True Then
		  ' rg.SearchPattern = "\{\{!(?:(?!}})(.|\n))*\}\}"
		  ' rgMatch = rg.Search(Expanded)
		  ' While rgMatch <> Nil
		  ' Expanded = rg.Replace(Expanded)
		  ' rgMatch = rg.Search(Expanded)
		  ' Wend
		  ' End If
		  ' 
		  ' // Loop over the data object's values.
		  ' For Each key As String In Data.Keys
		  ' 
		  ' // Get the value.
		  ' Var value As Variant = Data.Value(key)
		  ' 
		  ' // If the value is Nil then continue.
		  ' If value = Nil Then
		  ' Continue
		  ' End If
		  ' 
		  ' // Handle Xojo primitive types first.
		  ' Select Case value.Type
		  ' Case Variant.TypeBoolean, Variant.TypeDouble, Variant.TypeInt32, Variant.TypeInt64, Variant.TypeString, _
		  ' Variant.TypeText, Variant.TypeDateTime, Variant.TypeColor, Variant.TypeCurrency
		  ' // Convert the primitive value to a string.
		  ' Var valueString As String = value.StringValue
		  ' 
		  ' // Using the object's name and the entry's key, generate the token to replace.
		  ' Var token As String = If(KeyPrefix <> "", KeyPrefix + ".", "") + key
		  ' 
		  ' // Replace all occurrences of the token with the value.
		  ' Expanded = Expanded.ReplaceAll("{{" + Token + "}}", valueString)
		  ' 
		  ' Continue
		  ' End Select
		  ' 
		  ' // Not a primitive value. Use introspection to determine the entry's value type.
		  ' Var valueType As Introspection.TypeInfo = Introspection.GetType(value)
		  ' 
		  ' // If the value is a nested JSONItem.
		  ' If valueType.Name = "JSONItem" Then
		  ' 
		  ' // Get the nested JSONItem.
		  ' Var nestedJSON As JSONItem = value
		  ' 
		  ' // If the nested JSONItem is not an array.
		  ' If nestedJSON.IsArray = False Then
		  ' 
		  ' // Process the nested JSON using another Template instance. 
		  ' Var engine As New MustacheLite
		  ' engine.Source = Expanded
		  ' engine.Data = nestedJSON
		  ' engine.KeyPrefix = If(KeyPrefix <> "", KeyPrefix + ".", "") + key
		  ' engine.MergeSystemTokens = False
		  ' engine.RemoveComments = False
		  ' engine.RemoveOrphans = False
		  ' engine.Merge
		  ' Expanded = engine.Expanded
		  ' 
		  ' Else
		  ' 
		  ' // Get the beginning and ending tokens for this array.
		  ' Var tokenBegin As String = "{{#" + If(KeyPrefix <> "", KeyPrefix + ".", "") + key + "}}"
		  ' Var tokenEnd As String = "{{/" + If(KeyPrefix <> "", KeyPrefix + ".", "") + key + "}}"
		  ' 
		  ' // Get the start position of the beginning token.
		  ' Var startPosition As Integer = Source.IndexOf(0, tokenBegin) 
		  ' 
		  ' // Get the position of the ending token.
		  ' Var stopPosition As Integer = Source.IndexOf(startPosition, tokenEnd)
		  ' 
		  ' // If the template does not include both the beginning and ending tokens.
		  ' If ( (startPosition = -1) Or (stopPosition = -1) ) Then
		  ' // We do not need to merge the array.
		  ' Continue
		  ' End If
		  ' 
		  ' // Get the content between the beginning and ending tokens.
		  ' Var loopSource As String = Source.Middle( startPosition + tokenBegin.Length, stopPosition - startPosition - tokenBegin.Length)
		  ' 
		  ' // LoopContent is the content created by looping over the array and merging each value.
		  ' Var loopContent As String
		  ' 
		  ' // Loop over the array elements.
		  ' For i As Integer = 0 to NestedJSON.Count - 1
		  ' 
		  ' Var arrayValue As Variant = NestedJSON.ValueAt(i)
		  ' 
		  ' // Process the value using another MustacheLite instance. 
		  ' Var engine As New MustacheLite
		  ' engine.Source = loopSource
		  ' engine.Data = arrayValue
		  ' engine.KeyPrefix = If(KeyPrefix <> "", KeyPrefix + ".", "") + key
		  ' engine.MergeSystemTokens = False
		  ' engine.RemoveComments = False
		  ' Engine.RemoveOrphans = False
		  ' Engine.Merge
		  ' 
		  ' // Append the expanded content with the loop content.
		  ' loopContent = loopContent + engine.Expanded
		  ' 
		  ' Next i
		  ' 
		  ' // Substitute the loop content block of the template with the expanded content.
		  ' Var loopBlock As String = tokenBegin + loopSource + tokenEnd
		  ' Expanded = Expanded.ReplaceAll(loopBlock, loopContent)
		  ' 
		  ' End If
		  ' 
		  ' Continue
		  ' 
		  ' End If
		  ' 
		  ' // This is an unhandled value type.
		  ' // In theory, we should never get this far.
		  ' // Look at ValueType.Name to determine what the type is.
		  ' Break
		  ' 
		  ' Next key
		  ' 
		  ' // Remove orphaned tokens.
		  ' If RemoveOrphans = True Then
		  ' rg.SearchPattern = "\{\{(?:(?!}}).)*\}\}"
		  ' rgMatch = rg.Search(Expanded)
		  ' While rgMatch <> Nil
		  ' Expanded = rg.Replace(Expanded)
		  ' rgMatch = rg.Search(Expanded)
		  ' Wend
		  ' End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SystemDataAppend()
		  // Initialise the system object, which is used to merge system tokens.
		  Var systemData As New JSONItem
		  
		  // Append the system object to the data object.
		  Data.Value("system") = SystemData
		  
		  // Add the Date object.
		  Var dateData As New JSONItem
		  Var today As DateTime = DateTime.Now
		  dateData.Value("abbreviateddate") = today.ToString( Nil, DateTime.FormatStyles.Medium, DateTime.FormatStyles.None )
		  dateData.Value("day") = today.Day.ToString
		  dateData.Value("dayofweek") = today.DayOfWeek.ToString
		  dateData.Value("dayofyear") = today.DayOfYear.ToString
		  Var GMTOffset As Double = today.Timezone.SecondsFromGMT / 3600 //3600 seconds in an hour
		  dateData.Value("gmtoffset") = GMTOffset.ToString
		  dateData.Value("hour") = today.Hour.ToString
		  dateData.Value("longdate") = today.ToString( Nil, DateTime.FormatStyles.Long, DateTime.FormatStyles.None )
		  dateData.Value("longtime") = today.ToString( Nil, DateTime.FormatStyles.None, DateTime.FormatStyles.Medium )
		  dateData.Value("minute") = today.Minute.ToString
		  dateData.Value("month") = today.Month.ToString
		  dateData.Value("second") = today.Second.ToString
		  dateData.Value("shortdate") = today.ToString( Nil, DateTime.FormatStyles.Short, DateTime.FormatStyles.None )
		  dateData.Value("shorttime") = today.ToString( Nil, DateTime.FormatStyles.None, DateTime.FormatStyles.Short )
		  dateData.Value("sql") = today.SQLDate
		  dateData.Value("sqldate") = today.SQLDate
		  dateData.Value("sqldatetime") = today.SQLDateTime
		  dateData.Value("SecondsFrom1970") = today.SecondsFrom1970
		  dateData.Value("weekofyear") = today.WeekOfYear.ToString
		  dateData.Value("year") = today.Year.ToString
		  systemData.Value("date") = dateData
		  
		  // Add the Meta object.
		  Var metaData As New JSONItem
		  metaData.Value("xojo-version") = XojoVersionString
		  metaData.Value("express-version") = Express.VERSION_STRING
		  systemData.Value("meta") = metaData
		  
		  // Add the Request object.
		  Var requestData As New JSONItem
		  Var cookiesJSON As JSONItem = Request.Cookies
		  requestData.Value("cookies") = cookiesJSON
		  requestData.Value("data") = Request.Body
		  Var getParamsJSON As JSONItem = Request.GET
		  requestData.Value("get") = getParamsJSON
		  Var headersJSON As JSONItem = Request.Headers
		  requestData.Value("headers") = headersJSON
		  requestData.Value("method") = Request.Method
		  requestData.Value("path") = Request.Path
		  Var postParamsJSON As JSONItem = Request.POST
		  requestData.Value("post") = postParamsJSON
		  requestData.Value("remoteaddress") = Request.RemoteAddress
		  requestData.Value("socketid") = Request.SocketID
		  requestData.Value("urlparams") = Request.URLParams
		  systemData.Value("request") = requestData
		  
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
