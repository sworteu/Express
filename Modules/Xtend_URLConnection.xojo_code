#tag Module
Protected Module Xtend_URLConnection
	#tag Method, Flags = &h0
		Sub xSetMultipartFormData(Extends con As URLConnection, formData As Dictionary, boundary As String = "")
		  // Code based on 
		  
		  ' Pass the URLConnection1
		  ' a Dictionary containg "Name":"StringValue" Or "Name":FolderItem pairs To be encoded, 
		  ' along With the boundary String To be used. 
		  ' To have a boundary generated For you, pass the empty String.
		  ' 
		  ' Var HTMLForm As New Dictionary
		  ' HTMLForm.Value("UserName") = "Bob Smith"
		  ' HTMLForm.Value("Upload") = SpecialFolder.Desktop.Child("Somefile.zip")
		  ' URLConnection1.xSetMultipartFormData(HTMLForm, "") ' pass an empty boundary to generate a new one (default = "")
		  ' URLConnection1.Send("POST", "www.example.com/uploads.php", 60)
		  ' // Note: handle IOExceptions in the caller of SetMultipartFormData since folderitems can cause such exceptions.
		  
		  If boundary.Trim = "" Then
		    Var uniqueBoundary As String = EncodeHex(Crypto.GenerateRandomBytes(32), False)
		    boundary = "--" + uniqueBoundary + "-bOuNdArY"
		  End If
		  
		  Static CRLF As String = EndOfLine.Windows
		  Var data As New MemoryBlock(0)
		  Var out As New BinaryStream(data)
		  
		  For Each key As String In formData.Keys
		    
		    out.Write("--" + boundary + CRLF)
		    
		    If formData.Value(key).Type = Variant.TypeString Then
		      out.Write("Content-Disposition: form-data; name=""" + key + """" + CRLF + CRLF)
		      out.Write(formData.Value(key).StringValue + CRLF)
		      
		    Elseif formData.Value(Key) IsA FolderItem Then
		      
		      Var file As FolderItem = FormData.Value(key)
		      out.Write("Content-Disposition: form-data; name=""" + key + """; filename=""" + File.Name + """" + CRLF)
		      out.Write("Content-Type: application/octet-stream" + CRLF + CRLF) // Replace with actual MIME Type.
		      Var bs As BinaryStream = BinaryStream.Open(File)
		      out.Write(bs.Read(bs.Length) + CRLF)
		      bs.Close
		      
		    End If
		    
		  Next key
		  
		  out.Write("--" + Boundary + "--" + CRLF)
		  out.Close
		  
		  con.SetRequestContent(data, "multipart/form-data; boundary=" + boundary)
		  
		End Sub
	#tag EndMethod


End Module
#tag EndModule
