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
		  For Each FieldName As String In Request.POST.Keys
		    
		    // Create a JSONItem for this field.
		    Dim FieldInfo As New JSONItem
		    FieldInfo.Value("Name") = FieldName
		    FieldInfo.Value("Value") = Request.POST.Value(FieldName)
		    
		    // Append this field's info tp the FieldsInfoJSON object.
		    FieldsInfoJSON.Add(FieldInfo)
		    
		  Next
		  
		  
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
		    For Each FileFieldName As String In Request.Files.Keys
		      
		      // Get the file field's dictionary.
		      Dim File As Dictionary = Request.Files.Value(FileFieldName)
		      
		      // Create a JSONItem for this file.
		      Dim FileInfo As New JSONItem
		      FileInfo.Value("FieldName") = FileFieldName
		      
		      // If a file was uploaded...
		      If File.Lookup("Filename", "") <> "" Then
		        
		        // Grab the filename, type, and length.
		        FileInfo.Value("Filename") = File.Lookup("Filename", "")
		        FileInfo.Value("ContentType") = File.Lookup("ContentType", "")
		        FileInfo.Value("ContentLength") = File.Lookup("ContentLength", "")
		        
		        // If we're storing files in a folder...
		        If UploadFolder <> Nil Then
		          
		          // Get the filename to use when saving the file.
		          Dim FileName As String = File.Value("Filename")
		          If FilenamePrefix <> "" Then
		            FileName = FilenamePrefix + "-" + FileName
		          End If
		          
		          // Create a folderitem for the file.
		          Dim F As FolderItem = UploadFolder.Child(FileName)
		          
		          // Write the file content.
		          Dim TOS As TextOutputStream
		          TOS = TextOutputStream.Create(F)
		          TOS.WriteLine(File.Value("content"))
		          TOS.Close
		          
		          // Store the filename that was used to save the file.
		          FileInfo.Value("SavedFilename") = FileName
		          
		          // Store the path to the file.
		          FileInfo.Value("NativePath") = F.NativePath
		          
		        End If
		        
		      End If
		      
		      // Append this file's info tp the FilesInfoJSON object.
		      FilesInfoJSON.Add(FileInfo)
		      
		    Next
		    
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
