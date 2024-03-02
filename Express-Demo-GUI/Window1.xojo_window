#tag DesktopWindow
Begin DesktopWindow Window1
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   400
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   2040606719
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "Express Demo"
   Type            =   0
   Visible         =   True
   Width           =   600
   Begin DesktopLabel labDemo
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Demo:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
   Begin DesktopPopupMenu lstDemo
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   False
      Left            =   130
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   2
      SelectedRowIndex=   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   450
   End
   Begin DesktopSeparator sepDemo
      Active          =   False
      AllowAutoDeactivate=   True
      AllowTabStop    =   True
      Enabled         =   True
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      PanelIndex      =   0
      Scope           =   2
      TabIndex        =   2
      TabPanelIndex   =   0
      Tooltip         =   ""
      Top             =   52
      Transparent     =   False
      Visible         =   True
      Width           =   600
      _mIndex         =   0
      _mInitialParent =   ""
      _mName          =   ""
      _mPanelIndex    =   0
   End
   Begin DesktopLabel labExpress
      AllowAutoDeactivate=   True
      Bold            =   True
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Server"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   75
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
   Begin DesktopLabel labExpressStatus
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   240
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "..."
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   75
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   205
   End
   Begin DesktopButton btnStartStop
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Start | Stop"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   460
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   75
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
   Begin DesktopSeparator sepExpress
      Active          =   False
      AllowAutoDeactivate=   True
      AllowTabStop    =   True
      Enabled         =   True
      Height          =   20
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      PanelIndex      =   0
      Scope           =   2
      TabIndex        =   11
      TabPanelIndex   =   0
      Tooltip         =   ""
      Top             =   165
      Transparent     =   False
      Visible         =   True
      Width           =   600
      _mIndex         =   0
      _mInitialParent =   ""
      _mName          =   ""
      _mPanelIndex    =   0
   End
   Begin Timer timGUI
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   True
      Period          =   250
      RunMode         =   2
      Scope           =   2
      TabPanelIndex   =   0
   End
   Begin DesktopLabel labExpressPort
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   240
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "..."
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   105
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   205
   End
   Begin DesktopLabel labExpressStatusTitle
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   130
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Status:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   75
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
   Begin DesktopLabel labExpressPortTitle
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   130
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Port:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   105
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
   Begin DesktopLabel labExpressActiveConnections
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   240
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   10
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "..."
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   137
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   205
   End
   Begin DesktopLabel labExpressActiveConnectionsTitle
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   130
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Connections:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   137
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  IsOpened = True
		  
		  Self.StartDemo
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub Start()
		  If (Server = Nil) Then
		    Me.StartDemo
		    Return
		  End If
		  
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StartDemo()
		  If (Not Self.IsOpened) Then Return
		  
		  If (Server <> Nil) Then
		    Me.Stop
		    Server = Nil
		  End If
		  
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  // Note: The Express.RequestHandlerDelegate tells Express.Server which method is going to process the requests
		  Select Case lstDemo.RowTagAt(lstDemo.SelectedRowIndex)
		    
		  Case 1
		    Server = New Express.Server(AddressOf DemoHelloWorld.RequestProcess)
		    
		  Case 2
		    Server = New Express.Server(AddressOf DemoHelloWorld.SimplePlainTextResponse)
		    
		  Case 3
		    Server = New Express.Server(AddressOf DemoCaching.RequestProcess)
		    
		    // Configure server-level caching.
		    // This is used by the DemoCaching demo module.
		    Server.CachingEnabled = True
		    
		  Case 4
		    Server = New Express.Server(AddressOf DemoMultipartForms.RequestProcess)
		    
		  Case 5
		    Server = New Express.Server(AddressOf DemoSessions.RequestProcess)
		    
		    // Configure server-level session management. 
		    // This is used by the DemoSessions demo module.
		    Server.SessionsEnabled = True
		    
		  Case 6
		    Server = New Express.Server(AddressOf DemoTemplatesClientSide.RequestProcess)
		    
		  Case 7
		    Server = New Express.Server(AddressOf DemoTemplatesServerSide.RequestProcess)
		    
		  Case 8
		    Server = New Express.Server(AddressOf DemoWebSockets.RequestProcess)
		    
		  Case 9
		    Server = New Express.Server(AddressOf DemoXojoScript.RequestProcess)
		    
		  Else
		    Server = Nil
		    MessageBox "Invalid Demo"
		    Return
		    
		  End Select
		  
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Status()
		  Dim sStatus As String = "---"
		  Dim sPort As String = "---"
		  Dim sActiveConnections As String = "---"
		  Dim sAction As String = "Start"
		  
		  If (Server <> Nil) Then
		    sStatus = If(Server.IsListening, "Started", "Stopped")
		    sPort = Server.Port.ToString
		    sActiveConnections = Server.ConnectedSocketCount.ToString
		    sAction = If(Server.IsListening, "Stop", "Start")
		  End If
		  
		  If (labExpressStatus.Text <> sStatus) Then labExpressStatus.Text = sStatus
		  If (labExpressPort.Text <> sPort) Then labExpressPort.Text = sPort
		  If (labExpressActiveConnections.Text <> sActiveConnections) Then labExpressActiveConnections.Text = sActiveConnections
		  If (btnStartStop.Caption <> sAction) Then btnStartStop.Caption = sAction
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Stop()
		  If (Server = Nil) Then Return
		  
		  Server.Stop
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private IsOpened As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Server As Express.Server
	#tag EndProperty


#tag EndWindowCode

#tag Events lstDemo
	#tag Event
		Sub Opening()
		  Me.RemoveAllRows
		  
		  Me.AddRow "Hello World"
		  Me.RowTagAt(Me.LastAddedRowIndex) = 1
		  
		  Me.AddRow "Hello World (simple plain text response)"
		  Me.RowTagAt(Me.LastAddedRowIndex) = 2
		  
		  Me.AddRow "Caching (Drummers)"
		  Me.RowTagAt(Me.LastAddedRowIndex) = 3
		  
		  Me.AddRow "Multipart Forms"
		  Me.RowTagAt(Me.LastAddedRowIndex) = 4
		  
		  Me.AddRow "Sessions"
		  Me.RowTagAt(Me.LastAddedRowIndex) = 5
		  
		  Me.AddRow "Templates Client Side"
		  Me.RowTagAt(Me.LastAddedRowIndex) = 6
		  
		  Me.AddRow "Templates Server Side"
		  Me.RowTagAt(Me.LastAddedRowIndex) = 7
		  
		  Me.AddRow "WebSockets (simple chat app)"
		  Me.RowTagAt(Me.LastAddedRowIndex) = 8
		  
		  Me.AddRow "XojoScript"
		  Me.RowTagAt(Me.LastAddedRowIndex) = 9
		  
		  Me.SelectedRowIndex = 0
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged(item As DesktopMenuItem)
		  #Pragma unused item
		  
		  If (Not Self.IsOpened) Then Return
		  
		  Self.StartDemo
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnStartStop
	#tag Event
		Sub Pressed()
		  If (Not Self.IsOpened) Then Return
		  
		  If (Self.Server = Nil) Then
		    Self.StartDemo
		    Return
		  End If
		  
		  If Self.Server.IsListening Then
		    Self.Stop
		  Else
		    Self.Start
		  End If
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events timGUI
	#tag Event
		Sub Action()
		  Self.Status
		  
		End Sub
	#tag EndEvent
#tag EndEvents
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
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
