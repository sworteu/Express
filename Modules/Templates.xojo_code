#tag Module
Protected Module Templates
	#tag Note, Name = 1.0.0
		------------------------------------------------------------------------------------------
		1.0.0
		------------------------------------------------------------------------------------------
		
		Initial public production release. Templates.MustacheLite was previously included as
		a class in Express.
		
		The MustacheLite class now accepts a JSONItem (the "Data" property) exclusively
		as the merge data source. Its "Merge" method has been significantly refactored to
		account for the move away from Xojo.Core.Dictionary. 
		
	#tag EndNote

	#tag Note, Name = 1.0.1
		------------------------------------------------------------------------------------------
		1.0.1
		------------------------------------------------------------------------------------------
		
		Fixed MustacheLite.Merge() to handle conditional sections for simple values (strings, 
		booleans) not just values in JSONItem arrays.
		
		Supports inverted sections with {{^key}}...{{/key}} which show content only when a key 
		is missing or falsy.
		
		For example:
		
		```html
		{{^loggedIn}}
		  <a href="/login">Please sign in</a>
		{{/loggedIn}}
		```
	#tag EndNote

	#tag Note, Name = About
		-----------------------------------------------------------------------------------------
		About
		-----------------------------------------------------------------------------------------
		
		Templates provides server-side templating support to Express-based apps.
		
	#tag EndNote

	#tag Note, Name = License
		-----------------------------------------------------------------------------------------
		The MIT License (MIT)
		-----------------------------------------------------------------------------------------
		
		Copyright (c) 2018 Timothy Dietrich
		
		Permission is hereby granted, free of charge, to any person obtaining a copy of this 
		software and associated documentation files (the "Software"), to deal in the Software 
		without restriction, including without limitation the rights to use, copy, modify, merge, 
		publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
		persons to whom the Software is furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all copies 
		or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
		EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
		MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
		IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
		CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
		TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
		SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
		
		To learn more, visit https://www.tldrlegal.com/l/mit.
	#tag EndNote


	#tag Constant, Name = VERSION_STRING, Type = String, Dynamic = False, Default = \"1.0.1", Scope = Protected, Description = 546865206D6F64756C6527732076657273696F6E2E20496E2053656D56657220666F726D617420284D414A4F522E4D494E4F522E5041544348292E
	#tag EndConstant


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
