#tag Class
Protected Class IndexPage
	#tag Method, Flags = &h0
		Sub Generate()
		  // Get the orders as a JSON string.
		  Dim Orders As String = Express.FileRead(Request.StaticPath.Parent.Parent.Child("data").Child("orders.json"))
		  
		  // Create a Template instance.  
		  Dim Template As New Templates.MustacheLite
		  
		  // Load the template file and use it as the source.
		  Template.Source = Express.FileRead(Request.StaticPath.Child("template-index.html"))
		  
		  // Use the contents of the JSON data file as the merge data source.
		  Template.Data = New JSONItem(Orders)
		  
		  // Pass the Request to the Template so that request-related system tokens can be handled.
		  Template.Request = Request
		  
		  // Merge the template with the data.
		  Template.Merge
		  
		  // Update the response content with the expanded template.
		  Request.Response.Content = Template.Expanded
		End Sub
	#tag EndMethod


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
	#tag EndViewBehavior
End Class
#tag EndClass
