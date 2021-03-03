#tag Class
Protected Class Logger
Inherits Thread
	#tag Event
		Sub Run()
		  // Logs an HTTP request and response.
		  RequestLog
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor()
		  // Set the default log folder.
		  Folder = App.ExecutableFile.Parent.Parent.Child( "logs" )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RequestLog()
		  // Logs all requests, including Date/Time, Method (GET, POST, etc), the resource requested,
		  // the HTTP response status (200, 404, etc), response size, and user-agent name.
		  
		  
		  // Get the current date.
		  Dim CurrentDate As DateTime = DateTime.Now
		  
		  // Adjust the current date so that it is based on GMT.
		  //years, months, days, hours, minutes, seconds
		  CurrentDate = CurrentDate.SubtractInterval( 0, 0, 0, 0, 0, CurrentDate.Timezone.SecondsFromGMT )
		  
		  // Get the current date formatted as YYYYMMDD.
		  Dim YearFormatted As String = CurrentDate.Year.ToString
		  Dim MonthFormatted As String = If (CurrentDate.Month < 10, "0" + CurrentDate.Month.ToString, CurrentDate.Month.ToString)
		  Dim DayFormatted As String = If (CurrentDate.Day < 10, "0" + CurrentDate.Day.ToString, CurrentDate.Day.ToString)
		  Dim DateFormatted As String = YearFormatted + MonthFormatted + DayFormatted
		  
		  // Get the current time formatted as HHMMSS.
		  Dim HourFormatted As String = If(CurrentDate.Hour < 10, "0" + CurrentDate.Hour.ToString, CurrentDate.Hour.ToString)
		  Dim MinuteFormatted As String = If(CurrentDate.Minute < 10, "0" + CurrentDate.Minute.ToString, CurrentDate.Minute.ToString)
		  Dim SecondFormatted As String = If(CurrentDate.Second < 10, "0" + CurrentDate.Second.ToString, CurrentDate.Second.ToString)
		  Dim TimeFormatted As String = HourFormatted + ":" + MinuteFormatted + ":" +  SecondFormatted
		  
		  // If no IP address has been specified, use the default remote IP address.
		  IPAddress = If(IPAddress = "", Request.RemoteAddress, IPAddress)
		  
		  //Set up logs folder
		  SetUpLogsFolder
		  
		  // Create the log file name using the formatted date.
		  Dim LogFileName As String = DateFormatted + ".log"
		  
		  // Create a folder item for the log file.
		  Dim FI As FolderItem = Folder.Child(LogFileName)
		  
		  //  If the folderitem is valid...
		  If FI <> nil Then
		    
		    // Create a textstream.
		    Dim TOS As TextOutputStream
		    
		    // If the file doesn't already exist...
		    If Not FI.exists Then
		      
		      // Create the file.
		      TOS = TextOutputStream.Create(FI)
		      
		      // Write the headers...
		      TOS.WriteLine("#Version: 1.0")
		      TOS.WriteLine("#Date: " + DateFormatted + " " + TimeFormatted)
		      TOS.WriteLine("time" + CHR(9) _
		      + "cs-method" + CHR(9) _
		      + "cs-uri" + CHR(9) _
		      + "sc-status" + CHR(9) _
		      + "sc-bytes" + CHR(9) _
		      + "cs-ip" + CHR(9) _
		      + "cs-user-agent" + CHR(9) _
		      + "cs-user-referrer" _
		      )
		      
		    Else
		      // Append to the existing file.
		      TOS = TextOutputStream.Open(FI)
		    End If
		    
		    // Write to the log file.
		    TOS.WriteLine(TimeFormatted + CHR(9) _
		    + Request.Method + CHR(9) _
		    + Request.Path + CHR(9) _
		    + Request.Response.Status + CHR(9) _
		    + Request.Response.Content.Length.ToString + Chr(9) _
		    + Request.Headers.Lookup("X-Forwarded-For", Request.RemoteAddress) + CHR(9) _
		    + Request.Headers.Lookup("User-Agent", "") + CHR(9) _
		    + Request.Headers.Lookup("Referer", "") _
		    )
		    
		    // Close the stream.
		    TOS.Close
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub SetUpLogsFolder()
		  // Set up logs folder
		  If Not Folder.Exists Then
		    Folder.CreateFolder
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Folder As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h0
		IPAddress As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Request As Express.Request
	#tag EndProperty


	#tag ViewBehavior
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
			Name="DebugIdentifier"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThreadID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ThreadState"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="ThreadStates"
			EditorType="Enum"
			#tag EnumValues
				"0 - Running"
				"1 - Waiting"
				"2 - Paused"
				"3 - Sleeping"
				"4 - NotRunning"
			#tag EndEnumValues
		#tag EndViewProperty
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
			InitialValue=""
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
			Name="Priority"
			Visible=true
			Group="Behavior"
			InitialValue="5"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StackSize"
			Visible=true
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IPAddress"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
