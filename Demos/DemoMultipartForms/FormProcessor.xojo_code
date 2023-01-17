#tag Class
Protected Class FormProcessor
	#tag Method, Flags = &h0
		Sub Constructor(Request As Express.Request)
		  // Store the request.
		  Self.Request = Request
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FieldsProcess()
		  // We'll create a JSONItem for the field info.
		  FieldsInfoJSON = New JSONItem
		  
		  // Process files that were uploaded...
		  For Each fieldName As String In Request.POST.Keys
		    
		    // Create a JSONItem for this field.
		    Var fieldInfo As New JSONItem
		    fieldInfo.Value("Name") = fieldName
		    fieldInfo.Value("Value") = Request.POST.Value(fieldName)
		    
		    // Append this field's info tp the FieldsInfoJSON object.
		    FieldsInfoJSON.Add(fieldInfo)
		    
		  Next fieldName
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FilesProcess()
		  // Saves any files that have been uploaded to a specified folder.
		  
		  
		  // We'll create a JSONItem for the file info.
		  FilesInfoJSON = New JSONItem
		  
		  // If the form included files...
		  If Request.Files.Keys.LastIndex > -1 Then
		    
		    // Process files that were uploaded...
		    For Each fileFieldName As String In Request.Files.Keys
		      
		      // Get the file field's dictionary.
		      Var file As Dictionary = Request.Files.Value(fileFieldName)
		      
		      // Create a JSONItem for this file.
		      Var fileInfo As New JSONItem
		      fileInfo.Value("FieldName") = fileFieldName
		      
		      // If a file was uploaded...
		      If file.Lookup("Filename", "") <> "" Then
		        
		        // Grab the filename, type, and length.
		        fileInfo.Value("Filename") = file.Lookup("Filename", "")
		        fileInfo.Value("ContentType") = file.Lookup("ContentType", "")
		        fileInfo.Value("ContentLength") = file.Lookup("ContentLength", "")
		        
		        // If we're storing files in a folder...
		        If UploadFolder <> Nil Then
		          
		          // Get the filename to use when saving the file.
		          Var fileName As String = file.Value("Filename")
		          If FilenamePrefix <> "" Then
		            fileName = FilenamePrefix + "-" + fileName
		          End If
		          
		          // Create a folderitem for the file.
		          Var f As FolderItem = UploadFolder.Child(fileName)
		          
		          // Write the file content.
		          Var TOS As TextOutputStream
		          TOS = TextOutputStream.Create(f)
		          TOS.WriteLine(file.Value("content"))
		          TOS.Close
		          
		          // Store the filename that was used to save the file.
		          fileInfo.Value("SavedFilename") = fileName
		          
		          // Store the path to the file.
		          fileInfo.Value("NativePath") = f.NativePath
		          
		        End If
		        
		      End If
		      
		      // Append this file's info tp the FilesInfoJSON object.
		      FilesInfoJSON.Add(FileInfo)
		      
		    Next fileFieldName
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Process()
		  // Process any files that were uploaded.
		  FilesProcess
		  
		  // Process any fields in the form.
		  FieldsProcess
		  
		  // Prepare the form data object.
		  FormData = New JSONItem
		  FormData.Value("fields") = FieldsInfoJSON
		  FormData.Value("files") = FilesInfoJSON
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		FieldsInfoJSON As JSONItem
	#tag EndProperty

	#tag Property, Flags = &h0
		FilenamePrefix As String
	#tag EndProperty

	#tag Property, Flags = &h0
		FilesInfoJSON As JSONItem
	#tag EndProperty

	#tag Property, Flags = &h0
		FormData As JSONItem
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As Express.Request
	#tag EndProperty

	#tag Property, Flags = &h0
		UploadFolder As FolderItem
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
			Name="FilenamePrefix"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
