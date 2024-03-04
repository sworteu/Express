#tag DesktopWindow
Begin DesktopWindow Window1
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   True
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   450
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   2040606719
   MenuBarVisible  =   False
   MinimumHeight   =   450
   MinimumWidth    =   600
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
      Left            =   130
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   12
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Demo:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   155
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
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
      Left            =   250
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      SelectedRowIndex=   0
      TabIndex        =   13
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   155
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   330
   End
   Begin DesktopLabel labExpressStatus
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   25
      Index           =   -2147483648
      Italic          =   False
      Left            =   250
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
      Top             =   45
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   200
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
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
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
      TabIndex        =   10
      TabPanelIndex   =   0
      Tooltip         =   ""
      Top             =   126
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
      Height          =   25
      Index           =   -2147483648
      Italic          =   False
      Left            =   250
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "..."
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   70
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   200
   End
   Begin DesktopLabel labExpressStatusTitle
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   25
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
      Top             =   45
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
   Begin DesktopLabel labExpressPortTitle
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   25
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
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Port:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   70
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
   Begin DesktopLabel labExpressActiveConnections
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   25
      Index           =   -2147483648
      Italic          =   False
      Left            =   250
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   9
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "..."
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   95
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   200
   End
   Begin DesktopLabel labExpressActiveConnectionsTitle
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   25
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
      TabIndex        =   8
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Connections:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   95
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
   Begin DesktopCanvas cnvExpress
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   True
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   100
      Index           =   -2147483648
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Transparent     =   True
      Visible         =   True
      Width           =   100
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
      TabIndex        =   14
      TabPanelIndex   =   0
      Tooltip         =   ""
      Top             =   185
      Transparent     =   False
      Visible         =   True
      Width           =   600
      _mIndex         =   0
      _mInitialParent =   ""
      _mName          =   ""
      _mPanelIndex    =   0
   End
   Begin DesktopLabel labEventLogLevel
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
      TabIndex        =   16
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Event Log Level:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   205
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
   Begin DesktopPopupMenu lstEventLogLevel
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
      Left            =   250
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   2
      SelectedRowIndex=   0
      TabIndex        =   17
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   205
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   200
   End
   Begin DesktopTextArea EventLogEntries
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   True
      AllowStyledText =   True
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      Height          =   193
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   True
      Scope           =   2
      TabIndex        =   19
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   237
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
      Visible         =   True
      Width           =   560
   End
   Begin DesktopLabel labLog
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
      TabIndex        =   15
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Log"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   205
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
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
      TabIndex        =   11
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Express"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   155
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
   Begin DesktopButton btnLogClear
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Clear"
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
      TabIndex        =   18
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   205
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
   Begin DesktopLabel labUrlTitle
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   25
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
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "URL:"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   120
   End
   Begin DesktopLabel labUrl
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   25
      Index           =   -2147483648
      Italic          =   False
      Left            =   250
      LockBottom      =   False
      LockedInPosition=   True
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   2
      Selectable      =   False
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "..."
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   200
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
		Private Sub ClearLog()
		  Redim PendingEventLogEntries(-1)
		  EventLogEntries.Text = ""
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ExpressEventLog(Message As String, Level As Express.LogLevel) As Boolean
		  //If you don't want to use Express's default EventLog-Handling (StdOut in Console Applications,
		  //System.DebugLog in GUI Applications), then you can add the Express.EventLogHandlerDelegate and
		  //handle the Logging there.
		  //Just make sure to 'Return True' to tell Express to NOT handle the EventLog as well
		  
		  //So this would be the place to forward the Logs to your App's own Log-Handling facility
		  
		  Select Case CType(Level, Integer)
		    
		  Case CType(Express.LogLevel.None, Integer)
		    // Confirm that we have handled this Log, so that Express doesn't handle it, too.
		    Return True
		    
		  Case CType(Express.LogLevel.Critical, Integer)
		    Message = "CRITICAL: " + Message
		  Case CType(Express.LogLevel.Error, Integer)
		    Message = "ERROR: " + Message
		  Case CType(Express.LogLevel.Warning, Integer)
		    Message = "WARNING: " + Message
		  Case CType(Express.LogLevel.Info, Integer)
		    Message = "INFO: " + Message
		  Case CType(Express.LogLevel.Debug, Integer)
		    Message = "DEBUG: " + Message
		    
		  End Select
		  
		  // Let's append all Logs to PendingEventLogEntries
		  // Note: Express might send Log Entries from a Thread, so don't try to display it
		  //       in the GUI from here. Let's use a Timer to show pending log entries.
		  PendingEventLogEntries.Add Message
		  
		  // Confirm that we have handled this Log, so that Express doesn't handle it, too.
		  Return True
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessPendingEventLogEntries()
		  If (PendingEventLogEntries.LastIndex < 0) Then Return
		  
		  For Each logEntry As String In PendingEventLogEntries
		    EventLogEntries.AddText logEntry + EndOfLine
		  Next
		  
		  Redim PendingEventLogEntries(-1)
		  
		  #Pragma BreakOnExceptions False
		  Try
		    Var lastLineNumber As Integer = EventLogEntries.LineNumber(EventLogEntries.Text.Length)
		    If (lastLineNumber > 2) Then
		      lastLineNumber = lastLineNumber - 1
		      EventLogEntries.VerticalScrollPosition = lastLineNumber
		    End If
		  Catch err As RuntimeException
		    'ignore
		  End Try
		  
		End Sub
	#tag EndMethod

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
		  
		  Me.ClearLog
		  
		  // Create an instance of Express.Server, and configure it with optional command-line arguments.
		  // Note: The Express.RequestHandlerDelegate tells Express.Server which method is going to process the requests
		  Var args() As String = Array("--Port=8080")
		  
		  Select Case lstDemo.RowTagAt(lstDemo.SelectedRowIndex)
		    
		  Case 1
		    Server = New Express.Server(args, AddressOf DemoHelloWorld.RequestProcess)
		    
		  Case 2
		    Server = New Express.Server(args, AddressOf DemoHelloWorld.SimplePlainTextResponse)
		    
		  Case 3
		    Server = New Express.Server(args, AddressOf DemoCaching.RequestProcess)
		    
		    // Configure server-level caching.
		    // This is used by the DemoCaching demo module.
		    Server.CachingEnabled = True
		    
		  Case 4
		    Server = New Express.Server(args, AddressOf DemoMultipartForms.RequestProcess)
		    
		  Case 5
		    Server = New Express.Server(args, AddressOf DemoSessions.RequestProcess)
		    
		    // Configure server-level session management. 
		    // This is used by the DemoSessions demo module.
		    Server.SessionsEnabled = True
		    
		  Case 6
		    Server = New Express.Server(args, AddressOf DemoTemplatesClientSide.RequestProcess)
		    
		  Case 7
		    Server = New Express.Server(args, AddressOf DemoTemplatesServerSide.RequestProcess)
		    
		  Case 8
		    Server = New Express.Server(args, AddressOf DemoWebSockets.RequestProcess)
		    
		  Case 9
		    Server = New Express.Server(args, AddressOf DemoXojoScript.RequestProcess)
		    
		  Else
		    Server = Nil
		    MessageBox "Invalid Demo"
		    Return
		    
		  End Select
		  
		  // Configure App to handle Express EventLog with LogLevel Debug
		  Express.EventLogLevel = lstEventLogLevel.RowTagAt(lstEventLogLevel.SelectedRowIndex)
		  
		  // Assign the Express.EventLogHandlerDelegate to tell Express which method is processing the EventLogs
		  // Comment out or Assign Nil if you want to use Express's default EventLog-Handling
		  Express.EventLogHandler = WeakAddressOf ExpressEventLog
		  
		  // Start the server.
		  Server.Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Status()
		  Var sUrl As String = "---"
		  Var sStatus As String = "---"
		  Var sPort As String = "---"
		  Var sActiveConnections As String = "---"
		  Var sAction As String = "Start"
		  
		  If (Server <> Nil) Then
		    sUrl = "http://" + Server.LocalAddress + ":" + Server.Port.ToString + "/"
		    sStatus = If(Server.IsListening, "Started", "Stopped")
		    sPort = Server.Port.ToString
		    sActiveConnections = Server.ConnectedSocketCount.ToString
		    sAction = If(Server.IsListening, "Stop", "Start")
		  End If
		  
		  If (labUrl.Text <> sUrl) Then labUrl.Text = sUrl
		  If (labExpressStatus.Text <> sStatus) Then labExpressStatus.Text = sStatus
		  If (labExpressPort.Text <> sPort) Then labExpressPort.Text = sPort
		  If (labExpressActiveConnections.Text <> sActiveConnections) Then labExpressActiveConnections.Text = sActiveConnections
		  If (btnStartStop.Caption <> sAction) Then btnStartStop.Caption = sAction
		  
		  Var colStatus As Color = If(Server.IsListening, Color.Green, Color.Red)
		  If (labExpressStatus.TextColor <> colStatus) Then labExpressStatus.TextColor = colStatus
		  
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
		Private PendingEventLogEntries() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Server As Express.Server
	#tag EndProperty


#tag EndWindowCode

#tag Events labDemo
	#tag Event
		Sub Opening()
		  #If TargetLinux Then
		    Me.Height = 30
		    Me.Top = Me.Top - 5
		  #EndIf
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events lstDemo
	#tag Event
		Sub Opening()
		  #If TargetLinux Then
		    Me.Height = 30
		    Me.Top = Me.Top - 5
		  #EndIf
		  
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
		  
		  Me.SelectRowWithTag(1)
		  
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
	#tag Event
		Sub Opening()
		  #If TargetLinux Then
		    Me.Height = 30
		    Me.Top = Me.Top - 5
		  #EndIf
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events timGUI
	#tag Event
		Sub Action()
		  Self.Status
		  self.ProcessPendingEventLogEntries
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events cnvExpress
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #Pragma Unused areas
		  
		  g.DrawPicture Express_512, 0, 0, g.Width, g.Height, 0, 0, Express_512.Width, Express_512.Height
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events labEventLogLevel
	#tag Event
		Sub Opening()
		  #If TargetLinux Then
		    Me.Height = 30
		    Me.Top = Me.Top - 5
		  #EndIf
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events lstEventLogLevel
	#tag Event
		Sub Opening()
		  #If TargetLinux Then
		    Me.Height = 30
		    Me.Top = Me.Top - 5
		  #EndIf
		  
		  Me.RemoveAllRows
		  
		  Me.AddRow "None"
		  Me.RowTagAt(Me.LastAddedRowIndex) = Express.LogLevel.None
		  
		  Me.AddRow "-"
		  
		  // Note: Express.LogLevel.Always
		  // This is only intended to be used when sending Logs.
		  // E.g.: The Startup Infos of Express will be sent and always been shown.
		  // Don't use this to filter, don't set this for Express.EventLogLevel!
		  
		  Me.AddRow "Critical"
		  Me.RowTagAt(Me.LastAddedRowIndex) = Express.LogLevel.Critical
		  
		  Me.AddRow "Error"
		  Me.RowTagAt(Me.LastAddedRowIndex) = Express.LogLevel.Error
		  
		  Me.AddRow "Warning"
		  Me.RowTagAt(Me.LastAddedRowIndex) = Express.LogLevel.Warning
		  
		  Me.AddRow "Info"
		  Me.RowTagAt(Me.LastAddedRowIndex) = Express.LogLevel.Info
		  
		  Me.AddRow "Debug"
		  Me.RowTagAt(Me.LastAddedRowIndex) = Express.LogLevel.Debug
		  
		  Me.SelectRowWithTag(Express.LogLevel.Info)
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub SelectionChanged(item As DesktopMenuItem)
		  #Pragma unused item
		  
		  If (Not Self.IsOpened) Then Return
		  
		  Express.EventLogLevel = me.RowTagAt(me.SelectedRowIndex)
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events labLog
	#tag Event
		Sub Opening()
		  #If TargetLinux Then
		    Me.Height = 30
		    Me.Top = Me.Top - 5
		  #EndIf
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events labExpress
	#tag Event
		Sub Opening()
		  #If TargetLinux Then
		    Me.Height = 30
		    Me.Top = Me.Top - 5
		  #EndIf
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnLogClear
	#tag Event
		Sub Pressed()
		  self.ClearLog
		End Sub
	#tag EndEvent
	#tag Event
		Sub Opening()
		  #If TargetLinux Then
		    Me.Height = 30
		    Me.Top = Me.Top - 5
		  #EndIf
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events labUrl
	#tag Event
		Sub Opening()
		  Me.TextColor = Color.RGB(0, 114, 206)
		  Me.Underline = True
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseUp(x As Integer, y As Integer)
		  If (x >= 0) And (x < Me.Width) And (y > 0) And (y < Me.Height) Then
		    If Me.Text.Left(4) = "http" Then
		      System.GotoURL(Me.Text)
		    End If
		  End If
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseExit()
		  Me.MouseCursor = Nil
		  
		End Sub
	#tag EndEvent
	#tag Event
		Sub MouseEnter()
		  Me.MouseCursor = System.Cursors.FingerPointer
		End Sub
	#tag EndEvent
	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  #Pragma unused X
		  #Pragma unused Y
		  
		  Return True
		End Function
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
