#tag Module
Protected Module Express
	#tag Method, Flags = &h1, Description = 436F6E766572747320636F6D6D616E64206C696E6520617267756D656E747320746F20612064696374696F6E6172792E2045616368206B657920697320616E20617267756D656E74206E616D6520616E642074686520636F72726573706F6E64696E672076616C75652069732074686520617267756D656E742076616C75652E
		Protected Function ArgsToDictionary(args() As String) As Dictionary
		  /// Converts command line arguments to a dictionary.
		  /// Each key is an argument name and the corresponding value is the argument value.
		  
		  Var arguments As New Dictionary
		  
		  For Each argument As String In args
		    
		    Var argParts() As String = argument.Split("=")
		    Var name As String = argParts(0)
		    Var value As String  = If(argParts.LastIndex = 1,  argParts(1), "")
		    
		    arguments.value(Name) = value
		    
		  Next argument
		  
		  Return arguments
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E732074686520636F6E74656E74206F6620612022626C6F636B2220746861742069732064656D617263617465642062792060746F6B656E426567696E6020616E642060746F6B656E456E64602E205468652022746F6B656E732220617265206E6F7420696E636C7564656420696E207468652072657475726E656420737472696E672E
		Protected Function BlockGet(source As String, tokenBegin As String, tokenEnd As String, start As Integer = 0) As String
		  /// Returns the content of a "block" that is demarcated by `tokenBegin` and `tokenEnd`.
		  /// The "tokens" are not included in the returned string.
		  
		  Var content As String
		  
		  // Get the start position of the beginning token.
		  Var startPosition As Integer = Source.IndexOf(start, tokenBegin) 
		  
		  // Get the position of the ending token.
		  Var stopPosition As Integer = Source.IndexOf(startPosition, tokenEnd)
		  
		  // If the source includes both the beginning and ending tokens.
		  If ( (startPosition > -1) And (stopPosition > -1) ) Then
		    
		    // Get the content between the tokens.
		    content = Source.Middle( startPosition + tokenBegin.Length, stopPosition - startPosition - tokenBegin.Length )
		    
		  End If
		  
		  Return content
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 5265706C616365732065766572797468696E67206265747765656E2060746F6B656E426567696E6020616E642060746F6B656E456E6460207769746820607265706C6163656D656E74436F6E74656E74602E
		Protected Function BlockReplace(source As String, tokenBegin As String, tokenEnd As String, start As Integer = 0, replacementContent As String = "") As String
		  /// Replaces everything between `tokenBegin` and `tokenEnd` with `replacementContent`.
		  
		  // Get the content block.
		  Var blockContent As String = BlockGet(Source, tokenBegin, tokenEnd, start)
		  
		  // Replace the content.
		  source = source.ReplaceAll(tokenBegin + blockContent + tokenEnd, replacementContent)
		  
		  Return source
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E732061204461746554696D72206173206120737472696E6720696E2052464320383232202F203131323320666F726D61742E
		Protected Function DateToRFC1123(theDate As DateTime = Nil) As String
		  /// Returns a DateTimr as a string in RFC 822 / 1123 format.
		  ///
		  /// Example: Mon, 27 Nov 2017 13:27:26 GMT
		  /// Special thanks to Norman Palardy.
		  /// See: https://forum.xojo.com/42908-current-date-time-stamp-in-rfc-822-1123-format
		  
		  Var tmp As String
		  
		  If theDate = Nil Then
		    theDate = DateTime.Now
		    theDate = TheDate.SubtractInterval( 0, 0, 0, 0, 0, theDate.Timezone.SecondsFromGMT )
		  End If
		  
		  Select Case theDate.DayOfWeek
		  Case 1
		    tmp = tmp + "Sun"
		  Case 2
		    tmp = tmp + "Mon"
		  Case 3
		    tmp = tmp + "Tue"
		  Case 4
		    tmp = tmp + "Wed"
		  Case 5
		    tmp = tmp + "Thu"
		  Case 6
		    tmp = tmp + "Fri"
		  Case 7
		    tmp = tmp + "Sat"
		  End Select
		  
		  tmp = tmp + ", "
		  
		  tmp = tmp + If(theDate.Day < 10, "0", "") + theDate.Day.ToString
		  
		  tmp = tmp + " "
		  
		  Select Case theDate.Month
		  Case 1
		    tmp = tmp + "Jan" 
		  Case 2
		    tmp = tmp + "Feb" 
		  Case 3
		    tmp = tmp + "Mar"
		  Case 4
		    tmp = tmp + "Apr"
		  Case 5
		    tmp = tmp + "May" 
		  Case 6
		    tmp = tmp + "Jun" 
		  Case 7
		    tmp = tmp + "Jul" 
		  Case 8
		    tmp = tmp + "Aug"
		  Case 9
		    tmp = tmp + "Sep" 
		  Case 10
		    tmp = tmp + "Oct"
		  Case 11
		    tmp = tmp + "Nov" 
		  Case 12
		    tmp = tmp + "Dec"
		  End Select
		  
		  tmp = tmp + " "
		  
		  tmp = tmp + theDate.Year.ToString
		  tmp = tmp + " "
		  
		  tmp = tmp + If(theDate.Hour < 10, "0", "") + theDate.Hour.ToString
		  tmp = tmp + ":"
		  
		  tmp = tmp + If(theDate.Minute < 10, "0", "") + theDate.Minute.ToString
		  tmp = tmp + ":"
		  
		  tmp = tmp + If(theDate.Second < 10, "0", "") + theDate.Second.ToString
		  tmp = tmp + " "
		  
		  tmp = tmp + "GMT"
		  
		  Return tmp
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 526561647320616E642072657475726E732074686520636F6E74656E7473206F6620612066696C652C20676976656E206120466F6C6465724974656D2E204966206066602063616E6E6F74206265207265616420666F7220776861746576657220726561736F6E207468656E20616E20656D70747920737472696E672069732072657475726E65642E
		Protected Function FileRead(f As FolderItem, encoding As TextEncoding = Nil) As String
		  /// Reads and returns the contents of a file, given a FolderItem.
		  /// If `f` cannot be read for whatever reason then an empty string is returned.
		  
		  If f <> Nil Then
		    
		    If f.Exists Then
		      
		      Var tin As TextInputStream
		      
		      Try
		        
		        tin = TextInputStream.Open(f)
		        tin.Encoding = If(encoding = Nil, Encodings.UTF8, encoding)
		        Return tin.ReadAll
		        
		      Catch e As IOException
		        
		        Return ""
		        
		      End Try
		      
		    End If
		    
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 4465636F6D70726573736573206120677A697070656420737472696E672E
		Protected Function Gunzip(compressed As String) As String
		  /// Decompresses a gzipped string.
		  ///
		  /// Source: https://forum.xojo.com/11634-gunzip-without-a-file/0
		  /// Feedback request: https://tracker.xojo.com/xojoinc/xojo/-/issues/20404
		  
		  Var gzipContent As New _GzipString
		  
		  Return gzipContent.Decompress(compressed)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 436F6D70726573736573206120737472696E67207573696E6720677A69702E
		Protected Function GZip(uncompressed As String) As String
		  /// Compresses a string using gzip.
		  ///
		  /// Source: https://forum.xojo.com/11634-gunzip-without-a-file/0
		  /// Feedback request: https://tracker.xojo.com/xojoinc/xojo/-/issues/20404
		  
		  // Return the compressed string.
		  Var gzipContent As New _GzipString
		  Return gzipContent.Compress(uncompressed)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 4D61707320612066696C6520657874656E73696F6E20746F20697473204D494D4520747970652E
		Protected Function MIMETypeGet(extension As String) As String
		  /// Maps a file extension to its MIME type.
		  ///
		  /// Source: https://github.com/samuelneff/MimeTypeMap
		  
		  Var mimeTypes As New Dictionary
		  mimeTypes.Value("323") = "text/h323"
		  mimeTypes.Value("3g2") = "video/3gpp2"
		  mimeTypes.Value("3gp") = "video/3gpp"
		  mimeTypes.Value("3gp2") = "video/3gpp2"
		  mimeTypes.Value("3gpp") = "video/3gpp"
		  mimeTypes.Value("7z") = "application/x-7z-compressed"
		  mimeTypes.Value("aa") = "audio/audible"
		  mimeTypes.Value("AAC") = "audio/aac"
		  mimeTypes.Value("aaf") = "application/octet-stream"
		  mimeTypes.Value("aax") = "audio/vnd.audible.aax"
		  mimeTypes.Value("ac3") = "audio/ac3"
		  mimeTypes.Value("aca") = "application/octet-stream"
		  mimeTypes.Value("accda") = "application/msaccess.addin"
		  mimeTypes.Value("accdb") = "application/msaccess"
		  mimeTypes.Value("accdc") = "application/msaccess.cab"
		  mimeTypes.Value("accde") = "application/msaccess"
		  mimeTypes.Value("accdr") = "application/msaccess.runtime"
		  mimeTypes.Value("accdt") = "application/msaccess"
		  mimeTypes.Value("accdw") = "application/msaccess.webapplication"
		  mimeTypes.Value("accft") = "application/msaccess.ftemplate"
		  mimeTypes.Value("acx") = "application/internet-property-stream"
		  mimeTypes.Value("AddIn") = "text/xml"
		  mimeTypes.Value("ade") = "application/msaccess"
		  mimeTypes.Value("adobebridge") = "application/x-bridge-url"
		  mimeTypes.Value("adp") = "application/msaccess"
		  mimeTypes.Value("ADT") = "audio/vnd.dlna.adts"
		  mimeTypes.Value("ADTS") = "audio/aac"
		  mimeTypes.Value("afm") = "application/octet-stream"
		  mimeTypes.Value("ai") = "application/postscript"
		  mimeTypes.Value("aif") = "audio/aiff"
		  mimeTypes.Value("aifc") = "audio/aiff"
		  mimeTypes.Value("aiff") = "audio/aiff"
		  mimeTypes.Value("air") = "application/vnd.adobe.air-application-installer-package+zip"
		  mimeTypes.Value("amc") = "application/mpeg"
		  mimeTypes.Value("anx") = "application/annodex"
		  mimeTypes.Value("apk") = "application/vnd.android.package-archive" 
		  mimeTypes.Value("application") = "application/x-ms-application"
		  mimeTypes.Value("art") = "image/x-jg"
		  mimeTypes.Value("asa") = "application/xml"
		  mimeTypes.Value("asax") = "application/xml"
		  mimeTypes.Value("ascx") = "application/xml"
		  mimeTypes.Value("asd") = "application/octet-stream"
		  mimeTypes.Value("asf") = "video/x-ms-asf"
		  mimeTypes.Value("ashx") = "application/xml"
		  mimeTypes.Value("asi") = "application/octet-stream"
		  mimeTypes.Value("asm") = "text/plain"
		  mimeTypes.Value("asmx") = "application/xml"
		  mimeTypes.Value("aspx") = "application/xml"
		  mimeTypes.Value("asr") = "video/x-ms-asf"
		  mimeTypes.Value("asx") = "video/x-ms-asf"
		  mimeTypes.Value("atom") = "application/atom+xml"
		  mimeTypes.Value("au") = "audio/basic"
		  mimeTypes.Value("avi") = "video/x-msvideo"
		  mimeTypes.Value("axa") = "audio/annodex"
		  mimeTypes.Value("axs") = "application/olescript"
		  mimeTypes.Value("axv") = "video/annodex"
		  mimeTypes.Value("bas") = "text/plain"
		  mimeTypes.Value("bcpio") = "application/x-bcpio"
		  mimeTypes.Value("bin") = "application/octet-stream"
		  mimeTypes.Value("bmp") = "image/bmp"
		  mimeTypes.Value("c") = "text/plain"
		  mimeTypes.Value("cab") = "application/octet-stream"
		  mimeTypes.Value("caf") = "audio/x-caf"
		  mimeTypes.Value("calx") = "application/vnd.ms-office.calx"
		  mimeTypes.Value("cat") = "application/vnd.ms-pki.seccat"
		  mimeTypes.Value("cc") = "text/plain"
		  mimeTypes.Value("cd") = "text/plain"
		  mimeTypes.Value("cdda") = "audio/aiff"
		  mimeTypes.Value("cdf") = "application/x-cdf"
		  mimeTypes.Value("cer") = "application/x-x509-ca-cert"
		  mimeTypes.Value("cfg") = "text/plain"
		  mimeTypes.Value("chm") = "application/octet-stream"
		  mimeTypes.Value("class") = "application/x-java-applet"
		  mimeTypes.Value("clp") = "application/x-msclip"
		  mimeTypes.Value("cmd") = "text/plain"
		  mimeTypes.Value("cmx") = "image/x-cmx"
		  mimeTypes.Value("cnf") = "text/plain"
		  mimeTypes.Value("cod") = "image/cis-cod"
		  mimeTypes.Value("config") = "application/xml"
		  mimeTypes.Value("contact") = "text/x-ms-contact"
		  mimeTypes.Value("coverage") = "application/xml"
		  mimeTypes.Value("cpio") = "application/x-cpio"
		  mimeTypes.Value("cpp") = "text/plain"
		  mimeTypes.Value("crd") = "application/x-mscardfile"
		  mimeTypes.Value("crl") = "application/pkix-crl"
		  mimeTypes.Value("crt") = "application/x-x509-ca-cert"
		  mimeTypes.Value("cs") = "text/plain"
		  mimeTypes.Value("csdproj") = "text/plain"
		  mimeTypes.Value("csh") = "application/x-csh"
		  mimeTypes.Value("csproj") = "text/plain"
		  mimeTypes.Value("css") = "text/css"
		  mimeTypes.Value("csv") = "text/csv"
		  mimeTypes.Value("cur") = "application/octet-stream"
		  mimeTypes.Value("cxx") = "text/plain"
		  mimeTypes.Value("dat") = "application/octet-stream"
		  mimeTypes.Value("datasource") = "application/xml"
		  mimeTypes.Value("dbproj") = "text/plain"
		  mimeTypes.Value("dcr") = "application/x-director"
		  mimeTypes.Value("def") = "text/plain"
		  mimeTypes.Value("deploy") = "application/octet-stream"
		  mimeTypes.Value("der") = "application/x-x509-ca-cert"
		  mimeTypes.Value("dgml") = "application/xml"
		  mimeTypes.Value("dib") = "image/bmp"
		  mimeTypes.Value("dif") = "video/x-dv"
		  mimeTypes.Value("dir") = "application/x-director"
		  mimeTypes.Value("disco") = "text/xml"
		  mimeTypes.Value("divx") = "video/divx"
		  mimeTypes.Value("dll") = "application/x-msdownload"
		  mimeTypes.Value("dll.config") = "text/xml"
		  mimeTypes.Value("dlm") = "text/dlm"
		  mimeTypes.Value("doc") = "application/msword"
		  mimeTypes.Value("docm") = "application/vnd.ms-word.document.macroEnabled.12"
		  mimeTypes.Value("docx") = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
		  mimeTypes.Value("dot") = "application/msword"
		  mimeTypes.Value("dotm") = "application/vnd.ms-word.template.macroEnabled.12"
		  mimeTypes.Value("dotx") = "application/vnd.openxmlformats-officedocument.wordprocessingml.template"
		  mimeTypes.Value("dsp") = "application/octet-stream"
		  mimeTypes.Value("dsw") = "text/plain"
		  mimeTypes.Value("dtd") = "text/xml"
		  mimeTypes.Value("dtsConfig") = "text/xml"
		  mimeTypes.Value("dv") = "video/x-dv"
		  mimeTypes.Value("dvi") = "application/x-dvi"
		  mimeTypes.Value("dwf") = "drawing/x-dwf"
		  mimeTypes.Value("dwg") = "application/acad"
		  mimeTypes.Value("dwp") = "application/octet-stream"
		  mimeTypes.Value("dxr") = "application/x-director"
		  mimeTypes.Value("eml") = "message/rfc822"
		  mimeTypes.Value("emz") = "application/octet-stream"
		  mimeTypes.Value("eot") = "application/vnd.ms-fontobject"
		  mimeTypes.Value("eps") = "application/postscript"
		  mimeTypes.Value("etl") = "application/etl"
		  mimeTypes.Value("etx") = "text/x-setext"
		  mimeTypes.Value("evy") = "application/envoy"
		  mimeTypes.Value("exe") = "application/octet-stream"
		  mimeTypes.Value("exe.config") = "text/xml"
		  mimeTypes.Value("fdf") = "application/vnd.fdf"
		  mimeTypes.Value("fif") = "application/fractals"
		  mimeTypes.Value("filters") = "application/xml"
		  mimeTypes.Value("fla") = "application/octet-stream"
		  mimeTypes.Value("flac") = "audio/flac"
		  mimeTypes.Value("flr") = "x-world/x-vrml"
		  mimeTypes.Value("flv") = "video/x-flv"
		  mimeTypes.Value("fsscript") = "application/fsharp-script"
		  mimeTypes.Value("fsx") = "application/fsharp-script"
		  mimeTypes.Value("generictest") = "application/xml"
		  mimeTypes.Value("gif") = "image/gif"
		  mimeTypes.Value("gpx") = "application/gpx+xml"
		  mimeTypes.Value("group") = "text/x-ms-group"
		  mimeTypes.Value("gsm") = "audio/x-gsm"
		  mimeTypes.Value("gtar") = "application/x-gtar"
		  mimeTypes.Value("gz") = "application/x-gzip"
		  mimeTypes.Value("h") = "text/plain"
		  mimeTypes.Value("hdf") = "application/x-hdf"
		  mimeTypes.Value("hdml") = "text/x-hdml"
		  mimeTypes.Value("hhc") = "application/x-oleobject"
		  mimeTypes.Value("hhk") = "application/octet-stream"
		  mimeTypes.Value("hhp") = "application/octet-stream"
		  mimeTypes.Value("hlp") = "application/winhlp"
		  mimeTypes.Value("hpp") = "text/plain"
		  mimeTypes.Value("hqx") = "application/mac-binhex40"
		  mimeTypes.Value("hta") = "application/hta"
		  mimeTypes.Value("htc") = "text/x-component"
		  mimeTypes.Value("htm") = "text/html"
		  mimeTypes.Value("html") = "text/html"
		  mimeTypes.Value("htt") = "text/webviewhtml"
		  mimeTypes.Value("hxa") = "application/xml"
		  mimeTypes.Value("hxc") = "application/xml"
		  mimeTypes.Value("hxd") = "application/octet-stream"
		  mimeTypes.Value("hxe") = "application/xml"
		  mimeTypes.Value("hxf") = "application/xml"
		  mimeTypes.Value("hxh") = "application/octet-stream"
		  mimeTypes.Value("hxi") = "application/octet-stream"
		  mimeTypes.Value("hxk") = "application/xml"
		  mimeTypes.Value("hxq") = "application/octet-stream"
		  mimeTypes.Value("hxr") = "application/octet-stream"
		  mimeTypes.Value("hxs") = "application/octet-stream"
		  mimeTypes.Value("hxt") = "text/html"
		  mimeTypes.Value("hxv") = "application/xml"
		  mimeTypes.Value("hxw") = "application/octet-stream"
		  mimeTypes.Value("hxx") = "text/plain"
		  mimeTypes.Value("i") = "text/plain"
		  mimeTypes.Value("ico") = "image/x-icon"
		  mimeTypes.Value("ics") = "application/octet-stream"
		  mimeTypes.Value("idl") = "text/plain"
		  mimeTypes.Value("ief") = "image/ief"
		  mimeTypes.Value("iii") = "application/x-iphone"
		  mimeTypes.Value("inc") = "text/plain"
		  mimeTypes.Value("inf") = "application/octet-stream"
		  mimeTypes.Value("ini") = "text/plain"
		  mimeTypes.Value("inl") = "text/plain"
		  mimeTypes.Value("ins") = "application/x-internet-signup"
		  mimeTypes.Value("ipa") = "application/x-itunes-ipa"
		  mimeTypes.Value("ipg") = "application/x-itunes-ipg"
		  mimeTypes.Value("ipproj") = "text/plain"
		  mimeTypes.Value("ipsw") = "application/x-itunes-ipsw"
		  mimeTypes.Value("iqy") = "text/x-ms-iqy"
		  mimeTypes.Value("isp") = "application/x-internet-signup"
		  mimeTypes.Value("ite") = "application/x-itunes-ite"
		  mimeTypes.Value("itlp") = "application/x-itunes-itlp"
		  mimeTypes.Value("itms") = "application/x-itunes-itms"
		  mimeTypes.Value("itpc") = "application/x-itunes-itpc"
		  mimeTypes.Value("IVF") = "video/x-ivf"
		  mimeTypes.Value("jar") = "application/java-archive"
		  mimeTypes.Value("java") = "application/octet-stream"
		  mimeTypes.Value("jck") = "application/liquidmotion"
		  mimeTypes.Value("jcz") = "application/liquidmotion"
		  mimeTypes.Value("jfif") = "image/pjpeg"
		  mimeTypes.Value("jnlp") = "application/x-java-jnlp-file"
		  mimeTypes.Value("jpb") = "application/octet-stream"
		  mimeTypes.Value("jpe") = "image/jpeg"
		  mimeTypes.Value("jpeg") = "image/jpeg"
		  mimeTypes.Value("jpg") = "image/jpeg"
		  mimeTypes.Value("js") = "application/javascript"
		  mimeTypes.Value("json") = "application/json"
		  mimeTypes.Value("jsx") = "text/jscript"
		  mimeTypes.Value("jsxbin") = "text/plain"
		  mimeTypes.Value("latex") = "application/x-latex"
		  mimeTypes.Value("library-ms") = "application/windows-library+xml"
		  mimeTypes.Value("lit") = "application/x-ms-reader"
		  mimeTypes.Value("loadtest") = "application/xml"
		  mimeTypes.Value("lpk") = "application/octet-stream"
		  mimeTypes.Value("lsf") = "video/x-la-asf"
		  mimeTypes.Value("lst") = "text/plain"
		  mimeTypes.Value("lsx") = "video/x-la-asf"
		  mimeTypes.Value("lzh") = "application/octet-stream"
		  mimeTypes.Value("m13") = "application/x-msmediaview"
		  mimeTypes.Value("m14") = "application/x-msmediaview"
		  mimeTypes.Value("m1v") = "video/mpeg"
		  mimeTypes.Value("m2t") = "video/vnd.dlna.mpeg-tts"
		  mimeTypes.Value("m2ts") = "video/vnd.dlna.mpeg-tts"
		  mimeTypes.Value("m2v") = "video/mpeg"
		  mimeTypes.Value("m3u") = "audio/x-mpegurl"
		  mimeTypes.Value("m3u8") = "audio/x-mpegurl"
		  mimeTypes.Value("m4a") = "audio/m4a"
		  mimeTypes.Value("m4b") = "audio/m4b"
		  mimeTypes.Value("m4p") = "audio/m4p"
		  mimeTypes.Value("m4r") = "audio/x-m4r"
		  mimeTypes.Value("m4v") = "video/x-m4v"
		  mimeTypes.Value("mac") = "image/x-macpaint"
		  mimeTypes.Value("mak") = "text/plain"
		  mimeTypes.Value("man") = "application/x-troff-man"
		  mimeTypes.Value("manifest") = "application/x-ms-manifest"
		  mimeTypes.Value("map") = "text/plain"
		  mimeTypes.Value("master") = "application/xml"
		  mimeTypes.Value("mda") = "application/msaccess"
		  mimeTypes.Value("mdb") = "application/x-msaccess"
		  mimeTypes.Value("mde") = "application/msaccess"
		  mimeTypes.Value("mdp") = "application/octet-stream"
		  mimeTypes.Value("me") = "application/x-troff-me"
		  mimeTypes.Value("mfp") = "application/x-shockwave-flash"
		  mimeTypes.Value("mht") = "message/rfc822"
		  mimeTypes.Value("mhtml") = "message/rfc822"
		  mimeTypes.Value("mid") = "audio/mid"
		  mimeTypes.Value("midi") = "audio/mid"
		  mimeTypes.Value("mix") = "application/octet-stream"
		  mimeTypes.Value("mk") = "text/plain"
		  mimeTypes.Value("mmf") = "application/x-smaf"
		  mimeTypes.Value("mno") = "text/xml"
		  mimeTypes.Value("mny") = "application/x-msmoney"
		  mimeTypes.Value("mod") = "video/mpeg"
		  mimeTypes.Value("mov") = "video/quicktime"
		  mimeTypes.Value("movie") = "video/x-sgi-movie"
		  mimeTypes.Value("mp2") = "video/mpeg"
		  mimeTypes.Value("mp2v") = "video/mpeg"
		  mimeTypes.Value("mp3") = "audio/mpeg"
		  mimeTypes.Value("mp4") = "video/mp4"
		  mimeTypes.Value("mp4v") = "video/mp4"
		  mimeTypes.Value("mpa") = "video/mpeg"
		  mimeTypes.Value("mpe") = "video/mpeg"
		  mimeTypes.Value("mpeg") = "video/mpeg"
		  mimeTypes.Value("mpf") = "application/vnd.ms-mediapackage"
		  mimeTypes.Value("mpg") = "video/mpeg"
		  mimeTypes.Value("mpp") = "application/vnd.ms-project"
		  mimeTypes.Value("mpv2") = "video/mpeg"
		  mimeTypes.Value("mqv") = "video/quicktime"
		  mimeTypes.Value("ms") = "application/x-troff-ms"
		  mimeTypes.Value("msi") = "application/octet-stream"
		  mimeTypes.Value("mso") = "application/octet-stream"
		  mimeTypes.Value("mts") = "video/vnd.dlna.mpeg-tts"
		  mimeTypes.Value("mtx") = "application/xml"
		  mimeTypes.Value("mvb") = "application/x-msmediaview"
		  mimeTypes.Value("mvc") = "application/x-miva-compiled"
		  mimeTypes.Value("mxp") = "application/x-mmxp"
		  mimeTypes.Value("nc") = "application/x-netcdf"
		  mimeTypes.Value("nsc") = "video/x-ms-asf"
		  mimeTypes.Value("nws") = "message/rfc822"
		  mimeTypes.Value("ocx") = "application/octet-stream"
		  mimeTypes.Value("oda") = "application/oda"
		  mimeTypes.Value("odb") = "application/vnd.oasis.opendocument.database"
		  mimeTypes.Value("odc") = "application/vnd.oasis.opendocument.chart"
		  mimeTypes.Value("odf") = "application/vnd.oasis.opendocument.formula"
		  mimeTypes.Value("odg") = "application/vnd.oasis.opendocument.graphics"
		  mimeTypes.Value("odh") = "text/plain"
		  mimeTypes.Value("odi") = "application/vnd.oasis.opendocument.image"
		  mimeTypes.Value("odl") = "text/plain"
		  mimeTypes.Value("odm") = "application/vnd.oasis.opendocument.text-master"
		  mimeTypes.Value("odp") = "application/vnd.oasis.opendocument.presentation"
		  mimeTypes.Value("ods") = "application/vnd.oasis.opendocument.spreadsheet"
		  mimeTypes.Value("odt") = "application/vnd.oasis.opendocument.text"
		  mimeTypes.Value("oga") = "audio/ogg"
		  mimeTypes.Value("ogg") = "audio/ogg"
		  mimeTypes.Value("ogv") = "video/ogg"
		  mimeTypes.Value("ogx") = "application/ogg"
		  mimeTypes.Value("one") = "application/onenote"
		  mimeTypes.Value("onea") = "application/onenote"
		  mimeTypes.Value("onepkg") = "application/onenote"
		  mimeTypes.Value("onetmp") = "application/onenote"
		  mimeTypes.Value("onetoc") = "application/onenote"
		  mimeTypes.Value("onetoc2") = "application/onenote"
		  mimeTypes.Value("opus") = "audio/ogg"
		  mimeTypes.Value("orderedtest") = "application/xml"
		  mimeTypes.Value("osdx") = "application/opensearchdescription+xml"
		  mimeTypes.Value("otf") = "application/font-sfnt"
		  mimeTypes.Value("otg") = "application/vnd.oasis.opendocument.graphics-template"
		  mimeTypes.Value("oth") = "application/vnd.oasis.opendocument.text-web"
		  mimeTypes.Value("otp") = "application/vnd.oasis.opendocument.presentation-template"
		  mimeTypes.Value("ots") = "application/vnd.oasis.opendocument.spreadsheet-template"
		  mimeTypes.Value("ott") = "application/vnd.oasis.opendocument.text-template"
		  mimeTypes.Value("oxt") = "application/vnd.openofficeorg.extension"
		  mimeTypes.Value("p10") = "application/pkcs10"
		  mimeTypes.Value("p12") = "application/x-pkcs12"
		  mimeTypes.Value("p7b") = "application/x-pkcs7-certificates"
		  mimeTypes.Value("p7c") = "application/pkcs7-mime"
		  mimeTypes.Value("p7m") = "application/pkcs7-mime"
		  mimeTypes.Value("p7r") = "application/x-pkcs7-certreqresp"
		  mimeTypes.Value("p7s") = "application/pkcs7-signature"
		  mimeTypes.Value("pbm") = "image/x-portable-bitmap"
		  mimeTypes.Value("pcast") = "application/x-podcast"
		  mimeTypes.Value("pct") = "image/pict"
		  mimeTypes.Value("pcx") = "application/octet-stream"
		  mimeTypes.Value("pcz") = "application/octet-stream"
		  mimeTypes.Value("pdf") = "application/pdf"
		  mimeTypes.Value("pfb") = "application/octet-stream"
		  mimeTypes.Value("pfm") = "application/octet-stream"
		  mimeTypes.Value("pfx") = "application/x-pkcs12"
		  mimeTypes.Value("pgm") = "image/x-portable-graymap"
		  mimeTypes.Value("php") = "text/html"
		  mimeTypes.Value("pic") = "image/pict"
		  mimeTypes.Value("pict") = "image/pict"
		  mimeTypes.Value("pkgdef") = "text/plain"
		  mimeTypes.Value("pkgundef") = "text/plain"
		  mimeTypes.Value("pko") = "application/vnd.ms-pki.pko"
		  mimeTypes.Value("pls") = "audio/scpls"
		  mimeTypes.Value("pma") = "application/x-perfmon"
		  mimeTypes.Value("pmc") = "application/x-perfmon"
		  mimeTypes.Value("pml") = "application/x-perfmon"
		  mimeTypes.Value("pmr") = "application/x-perfmon"
		  mimeTypes.Value("pmw") = "application/x-perfmon"
		  mimeTypes.Value("png") = "image/png"
		  mimeTypes.Value("pnm") = "image/x-portable-anymap"
		  mimeTypes.Value("pnt") = "image/x-macpaint"
		  mimeTypes.Value("pntg") = "image/x-macpaint"
		  mimeTypes.Value("pnz") = "image/png"
		  mimeTypes.Value("pot") = "application/vnd.ms-powerpoint"
		  mimeTypes.Value("potm") = "application/vnd.ms-powerpoint.template.macroEnabled.12"
		  mimeTypes.Value("potx") = "application/vnd.openxmlformats-officedocument.presentationml.template"
		  mimeTypes.Value("ppa") = "application/vnd.ms-powerpoint"
		  mimeTypes.Value("ppam") = "application/vnd.ms-powerpoint.addin.macroEnabled.12"
		  mimeTypes.Value("ppm") = "image/x-portable-pixmap"
		  mimeTypes.Value("pps") = "application/vnd.ms-powerpoint"
		  mimeTypes.Value("ppsm") = "application/vnd.ms-powerpoint.slideshow.macroEnabled.12"
		  mimeTypes.Value("ppsx") = "application/vnd.openxmlformats-officedocument.presentationml.slideshow"
		  mimeTypes.Value("ppt") = "application/vnd.ms-powerpoint"
		  mimeTypes.Value("pptm") = "application/vnd.ms-powerpoint.presentation.macroEnabled.12"
		  mimeTypes.Value("pptx") = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
		  mimeTypes.Value("prf") = "application/pics-rules"
		  mimeTypes.Value("prm") = "application/octet-stream"
		  mimeTypes.Value("prx") = "application/octet-stream"
		  mimeTypes.Value("ps") = "application/postscript"
		  mimeTypes.Value("psc1") = "application/PowerShell"
		  mimeTypes.Value("psd") = "application/octet-stream"
		  mimeTypes.Value("psess") = "application/xml"
		  mimeTypes.Value("psm") = "application/octet-stream"
		  mimeTypes.Value("psp") = "application/octet-stream"
		  mimeTypes.Value("pub") = "application/x-mspublisher"
		  mimeTypes.Value("pwz") = "application/vnd.ms-powerpoint"
		  mimeTypes.Value("qht") = "text/x-html-insertion"
		  mimeTypes.Value("qhtm") = "text/x-html-insertion"
		  mimeTypes.Value("qt") = "video/quicktime"
		  mimeTypes.Value("qti") = "image/x-quicktime"
		  mimeTypes.Value("qtif") = "image/x-quicktime"
		  mimeTypes.Value("qtl") = "application/x-quicktimeplayer"
		  mimeTypes.Value("qxd") = "application/octet-stream"
		  mimeTypes.Value("ra") = "audio/x-pn-realaudio"
		  mimeTypes.Value("ram") = "audio/x-pn-realaudio"
		  mimeTypes.Value("rar") = "application/x-rar-compressed"
		  mimeTypes.Value("ras") = "image/x-cmu-raster"
		  mimeTypes.Value("rat") = "application/rat-file"
		  mimeTypes.Value("rc") = "text/plain"
		  mimeTypes.Value("rc2") = "text/plain"
		  mimeTypes.Value("rct") = "text/plain"
		  mimeTypes.Value("rdlc") = "application/xml"
		  mimeTypes.Value("reg") = "text/plain"
		  mimeTypes.Value("resx") = "application/xml"
		  mimeTypes.Value("rf") = "image/vnd.rn-realflash"
		  mimeTypes.Value("rgb") = "image/x-rgb"
		  mimeTypes.Value("rgs") = "text/plain"
		  mimeTypes.Value("rm") = "application/vnd.rn-realmedia"
		  mimeTypes.Value("rmi") = "audio/mid"
		  mimeTypes.Value("rmp") = "application/vnd.rn-rn_music_package"
		  mimeTypes.Value("roff") = "application/x-troff"
		  mimeTypes.Value("rpm") = "audio/x-pn-realaudio-plugin"
		  mimeTypes.Value("rqy") = "text/x-ms-rqy"
		  mimeTypes.Value("rtf") = "application/rtf"
		  mimeTypes.Value("rtx") = "text/richtext"
		  mimeTypes.Value("ruleset") = "application/xml"
		  mimeTypes.Value("s") = "text/plain"
		  mimeTypes.Value("safariextz") = "application/x-safari-safariextz"
		  mimeTypes.Value("scd") = "application/x-msschedule"
		  mimeTypes.Value("scr") = "text/plain"
		  mimeTypes.Value("sct") = "text/scriptlet"
		  mimeTypes.Value("sd2") = "audio/x-sd2"
		  mimeTypes.Value("sdp") = "application/sdp"
		  mimeTypes.Value("sea") = "application/octet-stream"
		  mimeTypes.Value("searchConnector-ms") = "application/windows-search-connector+xml"
		  mimeTypes.Value("setpay") = "application/set-payment-initiation"
		  mimeTypes.Value("setreg") = "application/set-registration-initiation"
		  mimeTypes.Value("settings") = "application/xml"
		  mimeTypes.Value("sgimb") = "application/x-sgimb"
		  mimeTypes.Value("sgml") = "text/sgml"
		  mimeTypes.Value("sh") = "application/x-sh"
		  mimeTypes.Value("shar") = "application/x-shar"
		  mimeTypes.Value("shtml") = "text/html"
		  mimeTypes.Value("sit") = "application/x-stuffit"
		  mimeTypes.Value("sitemap") = "application/xml"
		  mimeTypes.Value("skin") = "application/xml"
		  mimeTypes.Value("sldm") = "application/vnd.ms-powerpoint.slide.macroEnabled.12"
		  mimeTypes.Value("sldx") = "application/vnd.openxmlformats-officedocument.presentationml.slide"
		  mimeTypes.Value("slk") = "application/vnd.ms-excel"
		  mimeTypes.Value("sln") = "text/plain"
		  mimeTypes.Value("slupkg-ms") = "application/x-ms-license"
		  mimeTypes.Value("smd") = "audio/x-smd"
		  mimeTypes.Value("smi") = "application/octet-stream"
		  mimeTypes.Value("smx") = "audio/x-smd"
		  mimeTypes.Value("smz") = "audio/x-smd"
		  mimeTypes.Value("snd") = "audio/basic"
		  mimeTypes.Value("snippet") = "application/xml"
		  mimeTypes.Value("snp") = "application/octet-stream"
		  mimeTypes.Value("sol") = "text/plain"
		  mimeTypes.Value("sor") = "text/plain"
		  mimeTypes.Value("spc") = "application/x-pkcs7-certificates"
		  mimeTypes.Value("spl") = "application/futuresplash"
		  mimeTypes.Value("spx") = "audio/ogg"
		  mimeTypes.Value("src") = "application/x-wais-source"
		  mimeTypes.Value("srf") = "text/plain"
		  mimeTypes.Value("SSISDeploymentManifest") = "text/xml"
		  mimeTypes.Value("ssm") = "application/streamingmedia"
		  mimeTypes.Value("sst") = "application/vnd.ms-pki.certstore"
		  mimeTypes.Value("stl") = "application/vnd.ms-pki.stl"
		  mimeTypes.Value("sv4cpio") = "application/x-sv4cpio"
		  mimeTypes.Value("sv4crc") = "application/x-sv4crc"
		  mimeTypes.Value("svc") = "application/xml"
		  mimeTypes.Value("svg") = "image/svg+xml"
		  mimeTypes.Value("swf") = "application/x-shockwave-flash"
		  mimeTypes.Value("step") = "application/step"
		  mimeTypes.Value("stp") = "application/step"
		  mimeTypes.Value("t") = "application/x-troff"
		  mimeTypes.Value("tar") = "application/x-tar"
		  mimeTypes.Value("tcl") = "application/x-tcl"
		  mimeTypes.Value("testrunconfig") = "application/xml"
		  mimeTypes.Value("testsettings") = "application/xml"
		  mimeTypes.Value("tex") = "application/x-tex"
		  mimeTypes.Value("texi") = "application/x-texinfo"
		  mimeTypes.Value("texinfo") = "application/x-texinfo"
		  mimeTypes.Value("tgz") = "application/x-compressed"
		  mimeTypes.Value("thmx") = "application/vnd.ms-officetheme"
		  mimeTypes.Value("thn") = "application/octet-stream"
		  mimeTypes.Value("tif") = "image/tiff"
		  mimeTypes.Value("tiff") = "image/tiff"
		  mimeTypes.Value("tlh") = "text/plain"
		  mimeTypes.Value("tli") = "text/plain"
		  mimeTypes.Value("toc") = "application/octet-stream"
		  mimeTypes.Value("tr") = "application/x-troff"
		  mimeTypes.Value("trm") = "application/x-msterminal"
		  mimeTypes.Value("trx") = "application/xml"
		  mimeTypes.Value("ts") = "video/vnd.dlna.mpeg-tts"
		  mimeTypes.Value("tsv") = "text/tab-separated-values"
		  mimeTypes.Value("ttf") = "application/font-sfnt"
		  mimeTypes.Value("tts") = "video/vnd.dlna.mpeg-tts"
		  mimeTypes.Value("txt") = "text/plain"
		  mimeTypes.Value("u32") = "application/octet-stream"
		  mimeTypes.Value("uls") = "text/iuls"
		  mimeTypes.Value("user") = "text/plain"
		  mimeTypes.Value("ustar") = "application/x-ustar"
		  mimeTypes.Value("vb") = "text/plain"
		  mimeTypes.Value("vbdproj") = "text/plain"
		  mimeTypes.Value("vbk") = "video/mpeg"
		  mimeTypes.Value("vbproj") = "text/plain"
		  mimeTypes.Value("vbs") = "text/vbscript"
		  mimeTypes.Value("vcf") = "text/x-vcard"
		  mimeTypes.Value("vcproj") = "application/xml"
		  mimeTypes.Value("vcs") = "text/plain"
		  mimeTypes.Value("vcxproj") = "application/xml"
		  mimeTypes.Value("vddproj") = "text/plain"
		  mimeTypes.Value("vdp") = "text/plain"
		  mimeTypes.Value("vdproj") = "text/plain"
		  mimeTypes.Value("vdx") = "application/vnd.ms-visio.viewer"
		  mimeTypes.Value("vml") = "text/xml"
		  mimeTypes.Value("vscontent") = "application/xml"
		  mimeTypes.Value("vsct") = "text/xml"
		  mimeTypes.Value("vsd") = "application/vnd.visio"
		  mimeTypes.Value("vsi") = "application/ms-vsi"
		  mimeTypes.Value("vsix") = "application/vsix"
		  mimeTypes.Value("vsixlangpack") = "text/xml"
		  mimeTypes.Value("vsixmanifest") = "text/xml"
		  mimeTypes.Value("vsmdi") = "application/xml"
		  mimeTypes.Value("vspscc") = "text/plain"
		  mimeTypes.Value("vss") = "application/vnd.visio"
		  mimeTypes.Value("vsscc") = "text/plain"
		  mimeTypes.Value("vssettings") = "text/xml"
		  mimeTypes.Value("vssscc") = "text/plain"
		  mimeTypes.Value("vst") = "application/vnd.visio"
		  mimeTypes.Value("vstemplate") = "text/xml"
		  mimeTypes.Value("vsto") = "application/x-ms-vsto"
		  mimeTypes.Value("vsw") = "application/vnd.visio"
		  mimeTypes.Value("vsx") = "application/vnd.visio"
		  mimeTypes.Value("vtx") = "application/vnd.visio"
		  mimeTypes.Value("wav") = "audio/wav"
		  mimeTypes.Value("wave") = "audio/wav"
		  mimeTypes.Value("wax") = "audio/x-ms-wax"
		  mimeTypes.Value("wbk") = "application/msword"
		  mimeTypes.Value("wbmp") = "image/vnd.wap.wbmp"
		  mimeTypes.Value("wcm") = "application/vnd.ms-works"
		  mimeTypes.Value("wdb") = "application/vnd.ms-works"
		  mimeTypes.Value("wdp") = "image/vnd.ms-photo"
		  mimeTypes.Value("webarchive") = "application/x-safari-webarchive"
		  mimeTypes.Value("webm") = "video/webm"
		  mimeTypes.Value("webp") = "image/webp"
		  mimeTypes.Value("webtest") = "application/xml"
		  mimeTypes.Value("wiq") = "application/xml"
		  mimeTypes.Value("wiz") = "application/msword"
		  mimeTypes.Value("wks") = "application/vnd.ms-works"
		  mimeTypes.Value("WLMP") = "application/wlmoviemaker"
		  mimeTypes.Value("wlpginstall") = "application/x-wlpg-detect"
		  mimeTypes.Value("wlpginstall3") = "application/x-wlpg3-detect"
		  mimeTypes.Value("wm") = "video/x-ms-wm"
		  mimeTypes.Value("wma") = "audio/x-ms-wma"
		  mimeTypes.Value("wmd") = "application/x-ms-wmd"
		  mimeTypes.Value("wmf") = "application/x-msmetafile"
		  mimeTypes.Value("wml") = "text/vnd.wap.wml"
		  mimeTypes.Value("wmlc") = "application/vnd.wap.wmlc"
		  mimeTypes.Value("wmls") = "text/vnd.wap.wmlscript"
		  mimeTypes.Value("wmlsc") = "application/vnd.wap.wmlscriptc"
		  mimeTypes.Value("wmp") = "video/x-ms-wmp"
		  mimeTypes.Value("wmv") = "video/x-ms-wmv"
		  mimeTypes.Value("wmx") = "video/x-ms-wmx"
		  mimeTypes.Value("wmz") = "application/x-ms-wmz"
		  mimeTypes.Value("woff") = "application/font-woff"
		  mimeTypes.Value("wpl") = "application/vnd.ms-wpl"
		  mimeTypes.Value("wps") = "application/vnd.ms-works"
		  mimeTypes.Value("wri") = "application/x-mswrite"
		  mimeTypes.Value("wrl") = "x-world/x-vrml"
		  mimeTypes.Value("wrz") = "x-world/x-vrml"
		  mimeTypes.Value("wsc") = "text/scriptlet"
		  mimeTypes.Value("wsdl") = "text/xml"
		  mimeTypes.Value("wvx") = "video/x-ms-wvx"
		  mimeTypes.Value("x") = "application/directx"
		  mimeTypes.Value("xaf") = "x-world/x-vrml"
		  mimeTypes.Value("xaml") = "application/xaml+xml"
		  mimeTypes.Value("xap") = "application/x-silverlight-app"
		  mimeTypes.Value("xbap") = "application/x-ms-xbap"
		  mimeTypes.Value("xbm") = "image/x-xbitmap"
		  mimeTypes.Value("xdr") = "text/plain"
		  mimeTypes.Value("xht") = "application/xhtml+xml"
		  mimeTypes.Value("xhtml") = "application/xhtml+xml"
		  mimeTypes.Value("xla") = "application/vnd.ms-excel"
		  mimeTypes.Value("xlam") = "application/vnd.ms-excel.addin.macroEnabled.12"
		  mimeTypes.Value("xlc") = "application/vnd.ms-excel"
		  mimeTypes.Value("xld") = "application/vnd.ms-excel"
		  mimeTypes.Value("xlk") = "application/vnd.ms-excel"
		  mimeTypes.Value("xll") = "application/vnd.ms-excel"
		  mimeTypes.Value("xlm") = "application/vnd.ms-excel"
		  mimeTypes.Value("xls") = "application/vnd.ms-excel"
		  mimeTypes.Value("xlsb") = "application/vnd.ms-excel.sheet.binary.macroEnabled.12"
		  mimeTypes.Value("xlsm") = "application/vnd.ms-excel.sheet.macroEnabled.12"
		  mimeTypes.Value("xlsx") = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
		  mimeTypes.Value("xlt") = "application/vnd.ms-excel"
		  mimeTypes.Value("xltm") = "application/vnd.ms-excel.template.macroEnabled.12"
		  mimeTypes.Value("xltx") = "application/vnd.openxmlformats-officedocument.spreadsheetml.template"
		  mimeTypes.Value("xlw") = "application/vnd.ms-excel"
		  mimeTypes.Value("xml") = "text/xml"
		  mimeTypes.Value("xmta") = "application/xml"
		  mimeTypes.Value("xof") = "x-world/x-vrml"
		  mimeTypes.Value("XOML") = "text/plain"
		  mimeTypes.Value("xpm") = "image/x-xpixmap"
		  mimeTypes.Value("xps") = "application/vnd.ms-xpsdocument"
		  mimeTypes.Value("xrm-ms") = "text/xml"
		  mimeTypes.Value("xsc") = "application/xml"
		  mimeTypes.Value("xsd") = "text/xml"
		  mimeTypes.Value("xsf") = "text/xml"
		  mimeTypes.Value("xsl") = "text/xml"
		  mimeTypes.Value("xslt") = "text/xml"
		  mimeTypes.Value("xsn") = "application/octet-stream"
		  mimeTypes.Value("xss") = "application/xml"
		  mimeTypes.Value("xspf") = "application/xspf+xml"
		  mimeTypes.Value("xtp") = "application/octet-stream"
		  mimeTypes.Value("xwd") = "image/x-xwindowdump"
		  mimeTypes.Value("z") = "application/x-compress"
		  mimeTypes.Value("zip") = "application/zip"
		  
		  Return mimeTypes.Lookup(extension, "binary/octet-stream")
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 436F6E7665727473206120526F7753657420746F2061204A534F4E4974656D2E
		Protected Function RowSetToJSONItem(records As RowSet, close As Boolean = True) As JSONItem
		  /// Converts a RowSet to a JSONItem.
		  
		  Var recordsJSON As New JSONItem
		  
		  // Loop over each record.
		  While Not records.AfterLastRow
		    
		    Var recordJSON As New JSONItem
		    
		    // Loop over each column.
		    For i As Integer = 0 To records.ColumnCount-1
		      
		      // Add a name / value pair to the JSON record.
		      recordJSON.Value( records.ColumnAt(i).Name ) = records.ColumnAt(i).StringValue
		      
		    Next i
		    
		    // Add the JSON record to the JSON records object.
		    recordsJSON.Add(recordJSON)
		    
		    // Go to the next row.
		    records.MoveToNextRow
		    
		  Wend
		  
		  // Close the recordset.
		  If close Then
		    records.Close
		  End If
		  
		  Return recordsJSON
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E6720726570726573656E746174696F6E206F6620616E2053534C436F6E6E656374696F6E547970652E
		Function ToString(extends s as SSLSocket.SSLConnectionTypes) As String
		  /// Returns a string representation of an SSLConnectionType.
		  
		  Var output As String
		  
		  Select Case s
		    
		  Case SSLSocket.SSLConnectionTypes.SSLv23
		    
		    output = "SSLv3, TLSv1, TLSv1.1, TLSv1.2"
		    
		  Case SSLSocket.SSLConnectionTypes.TLSv1
		    
		    output = "TLS version 1"
		    
		  Case SSLSocket.SSLConnectionTypes.TLSv11
		    
		    output = "TLS version 1.1"
		    
		  Case SSLSocket.SSLConnectionTypes.TLSv12
		    
		    output = "TLS version 1.2"
		    
		  Else
		    
		    Raise New InvalidArgumentException
		    
		  End Select
		  
		  Return output
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 46756C6C79206465636F64657320612055524C2D656E636F6465642076616C75652E
		Protected Function URLDecode(encoded As String) As String
		  /// Fully decodes a URL-encoded value.
		  ///
		  /// Unlike Xojo's "DecodeURLComponent," this method decodes any "+" characters
		  /// that represent encoded space characters.
		  
		  // Replace any "+" chars with spaces.
		  encoded = encoded.ReplaceAll("+", " ")
		  
		  // Decode everything else.
		  encoded = DecodeURLComponent(encoded)
		  
		  Return encoded
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 41207772617070657220666F7220586F6A6F277320456E636F646555524C436F6D706F6E656E742C2070726F766964656420666F7220636F6E73697374656E637920616E6420636F6E76656E69656E63652E
		Protected Function URLEncode(value As String) As String
		  /// A wrapper for Xojo's EncodeURLComponent, provided for consistency and convenience.
		  
		  Return EncodeURLComponent(value)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 47656E657261746573206120555549442E
		Protected Function UUIDGenerate() As String
		  /// Generates a UUID.
		  ///
		  /// Source: https://forum.xojo.com/18856-getting-guid/0 (Roberto Calvi)
		  /// Replace this with whatever UUID generation function that you prefer.
		  
		  Var db As New SQLiteDatabase
		  
		  Var SQL_Instruction As String= "select hex( randomblob(4)) " _
		  + "|| '-' || hex( randomblob(2)) " _
		  + "|| '-' || '4' || substr( hex( randomblob(2)), 2) " _
		  + "|| '-' || substr('AB89', 1 + (abs(random()) % 4) , 1) " _
		  + "|| substr(hex(randomblob(2)), 2) " _
		  + "|| '-' || hex(randomblob(6)) AS GUID"
		  
		  Try
		    db.Connect
		    Var GUID As String = db.SelectSQL(SQL_Instruction).Column("GUID")
		    db.Close
		    Return GUID
		  Catch error As DatabaseException
		    System.DebugLog("SQLite Error: " + error.Message)
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 4163636570747320612064696374696F6E61727920636F6E7461696E696E6720224E616D65223A22537472696E6756616C756522204F7220224E616D65223A466F6C6465724974656D20706169727320746F20626520656E636F6465642C20616C6F6E67207769746820616E206F7074696F6E616C20626F756E6461727920737472696E6720746F20626520757365642E2053657473207468652070617373656420636F6E6E656374696F6E2773207265717565737420636F6E74656E742E
		Protected Sub xSetMultipartFormData(Extends con As URLConnection, formData As Dictionary, boundary As String = "")
		  /// Accepts a dictionary containing "Name":"StringValue" Or "Name":FolderItem pairs to be encoded, 
		  /// along with an optional boundary string to be used.
		  /// Sets the passed connection's request content.
		  ///
		  /// To have a boundary generated for you, pass an empty string.
		  
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


	#tag Note, Name = 0.0.0 ORIGINAL AUTHOR
		
		-----------------------------------------------------------------------------------------
		The Original Developer of AloeExpress (Express is based on AloeExpress):
		-----------------------------------------------------------------------------------------
		Tim Dietrich
		• Email: timdietrich@me.com
		• Web: http://timdietrich.me
		
		
		For support for Express, please reach to the github repository:
		https://github.com/sworteu/Express
		-> If you have issues or feature requests please create an issue.
		-> If you want a feature to be added, please issue a pull request
		-> If you want to collaborate, please request it via github.com
		
	#tag EndNote

	#tag Note, Name = 1.0.0
		-----------------------------------------------------------------------------------------
		1.0.0
		-----------------------------------------------------------------------------------------
		
		Initial public production release.
		
	#tag EndNote

	#tag Note, Name = 1.1.0
		-----------------------------------------------------------------------------------------
		1.1.0
		-----------------------------------------------------------------------------------------
		
		Added support for the ServerThread class, which makes it possible to run multiple 
		Express.Server instances in a single application process. 
		
		Added support for HelperApp class, which makes it easier to use helper apps.
	#tag EndNote

	#tag Note, Name = 1.2.0
		-----------------------------------------------------------------------------------------
		1.2.0
		-----------------------------------------------------------------------------------------
		
		Added support for the Template class, which is based loosely on mustache. For more 
		information on mustache, visit: http://mustache.github.io
		
		Also includes changes to the demo app:
		• The name has been changed to "Aloe-Express-Demo."
		• The HelperApp demo module has been removed. (The class itself is still supported.)
		• The HelperApp Xojo project file has been removed from the AE distribution package.
		• See AloeExpress v1.1 for the HelperApp demo and project file.
	#tag EndNote

	#tag Note, Name = 2.0.0
		-----------------------------------------------------------------------------------------
		2.0.0
		-----------------------------------------------------------------------------------------
		
		The Server class includes minor changes that make it possible to use AE in a Xojo 
		desktop app.
		
		The Server's Constructor method has changed slightly so that default ServerSocket
		properties are set. The default Port is 8080, MaximumSocketsConnected default is 200
		and MinimumSocketsAvailable default is 50. Command line arguments are still supported.
		
		The MajorVersion, MinorVersion, and BugVersion constants have been removed. Use
		the new VersionString method as a replacement.
		
		The Response.MetaRedirect method has been renamed to MetaRefresh.
		
		The Response.CookieSet method now uses "/" as its default path. Special thanks to 
		Hal Gumbert for suggesting this.
		
		Resolves long-standing issues in SessionEngine and CacheEngine, where their
		"sweep" methods would throw an exception when expired entries were deleted.
		
		Several new "helper methods" have been added to the module. Most are intended to make
		converting between data types a little easier.
		
	#tag EndNote

	#tag Note, Name = 3.0.0
		-----------------------------------------------------------------------------------------
		3.0.0
		-----------------------------------------------------------------------------------------
		
		New features:
		• Support for persistent connections ("Keep-Alives").
		• Support for multipart forms.
		• Support for large entity bodies.
		• Support for ETags.
		
		Key changes:
		• Improvements to the FileRead method.
		• The Template class has been moved to its own module.
		
		Details:
		
		Removed all references to the "new framework." This includes uses of Xojo.Core.Date,
		Xojo.Core.DateInterval, etc.
		
		Persistent connections (also known as "Keep-Alives") are now supported and enabled by
		default. Two new Server properties can be used to configure persistent connections.
		Server.KeepAlive, a boolean (True by default) can be used to enable or disable
		persistent connections. When KeepAlives are enabled, the Server.KeepAliveTimeout 
		property, an integer (set to 30 by default), can be used to specify the amount of time 
		that a connection can be idle before it is considered to have timed out.
		
		A new ConnectionSweeper class (a Timer subclass) handles the "sweep" process that
		is mentioned above. An instance of this class is automatically created when a server
		instance runs. The interval with which the sweep occurs is controlled by the server's
		ConnSweepIntervalSecs property. Its default is 15 seconds.
		
		The Request class now properly handles large HTTP requests. In cases where a 
		payload's length requires that that a socket wait until all data has been received,
		the DataAvailable event handler will wait until all data has been received in the
		buffer before reading the data and processing the request.
		
		Support for multipart forms has been added. In cases where a form has been submitted
		which included "file" input fields, information about the fields will be provided in a 
		new Request.Files dictionary. The dictionary's keys will be the field names. The
		values will also be dictionaries, and will include key/value pairs for the filename,
		content type, content length, etc.
		
		The Server class now supports a MaxEntitySize property, which can be used to limit 
		the size of a request body. This is particularly helpful when you want to limit the size 
		of file uploads. By default, this is set to 10Mb (10485760 bits).
		
		The Template class, which was previously included in the AloeExpress core module, has
		been moved to its own Templates module, and the class has been renamed 
		to MustacheLite. 
		
		The new DemoTemplateClientSide module has been added to demonstrate the use of 
		client-side templating solutions. In this demo, a Mustache logic-less template is used. 
		The module also demonstrates the use of XMLHttpRequestto make XML calls to the 
		app for data, which is then merged with the page.
		
		The Logger class now automatically takes into account any "X-Forwarded-For" headers,
		which are used when apps are being proxied.
		
		CacheEngine and SessionEngine are now subclasses of the Timer class. Expiration logic
		in both classes has been modified to reflect the move away from Xojo.Core.Dates.
		
		The FileRead method now takes an optional TextEncoding parameter. The default is UTF8.
		
		When running in the debugger, additional headers are added to the response. These 
		include X-Aloe-Version, X-Host, X-Last-Connect, X-Socket-ID, and X-Xojo-Version. For 
		security reasons, you should not return these headers in production environments.
		
		ETag support has been added via the Request.MapToFile method, which provides
		web cache validation. By default, ETags are used when serving static resources via 
		the method. You can disable this feature by calling the method and passing
		False as the "UseEtags" parameter.
		
		The Request class now has a Server property, which is automatically set to 
		the Express.Server instances that it is associated with. 
		
		Similarly, the Response class now has a Request property, which is automatically 
		set to the Express.Request instance that it is associated with.
		
	#tag EndNote

	#tag Note, Name = 3.1.0
		-----------------------------------------------------------------------------------------
		3.1.0
		-----------------------------------------------------------------------------------------
		
		Reduces the memory needed to process multipart forms, and frees up memory as
		quickly as possible. Connections involving multipart forms are now closed after 
		processing.
		
	#tag EndNote

	#tag Note, Name = 3.2.0
		-----------------------------------------------------------------------------------------
		3.2.0
		-----------------------------------------------------------------------------------------
		
		Seamlessly adds support for XojoScript. Blocks of XojoScript code (wrapped in 
		"<xojoscript>" and "</xojoscript>" tags) will be run, and their output (via Print
		commands in the scripts) will be substituted in the rendered code. The feature can
		be disabled by setting the Request.XojoScriptEnabled property to False. A new demo, 
		DemoXojoScript, has been added to the AE project to demonstrate this functionality.
		Refer to the HTML file in the demo's associated htdocs folder for example XojoScript.
		
		The XSProcessor class has been added to the module to add XojoScript support.
		Special thanks to Paul Lefebvre and the Xojo team for the XojoScript example project,
		which this class is based on.
		
		Adds support for two new Server parameters: Name and SilentStart. Name
		(which defaults to "Aloe Express Server") can be used to display an alternate name 
		when the server launches. SilentStart (which defaults to False) can be used to suppress 
		the display of the server info when the server launches. Both params are used in 
		the Server.ServerInfoDisplay method.
		
		A minor bug was fixed in the BlockReplace method. The method now honors the Start
		parameter. Previously, the method had zero hardcoded in the call to BlockGet.
		
		
	#tag EndNote

	#tag Note, Name = 4.0.0
		-----------------------------------------------------------------------------------------
		4.0.0
		-----------------------------------------------------------------------------------------
		
		This release adds support for the WebSocket Protocol, enabling two-way communication 
		between clients and an Aloe Express-based server. This implementation is based on 
		RFC 6455 ( https://tools.ietf.org/html/rfc6455 ).
		
		For a demonstration of Aloe Express's WebSocket support, see the new
		DemoWebSockets demo module.
		
		Aloe Express's WebSocket support is designed to be seamless. To add WebSocket 
		support to an app, simply have the client open a WebSocket connection and 
		reference an endpoint. In your app, route WebSocket-related requests just as you 
		would HTTP requests, evaluate them, and process them.
		 
		For security, you might want to evaluate the Origin header before handshaking and
		continuing with a WebSocket connect request. You should respond with a 
		"403 Forbidden" status if the request is being denied.
		
		To handshake with a client, simply call Request.WSHandshake. From that point on, 
		messages received on the WebSocket that will continue to be routed to the original 
		endpoint. Aloe will automatically manage and decode an incoming message.
		It will fully compose and decode an incoming message, store it in the Request's 
		Body property, and pass it to the app's RequestHandler method.
		
		To respond to a message, or to send a message to the client for any reason, use
		the Request.WSMessageSend method. All frame encoding and message 
		composition is handled by the method. See below for known limitations.
		
		WebSocket-related changes:
		• A WSStatus property has been added to the Request class. Default is Inactive.
		• The Request class has new WebSocket-related methods: WSHandShake,
		WSMessageGet, and WSMessageSend.
		• The Request.Reset method no longer resets the path, which makes it possible
		to route an inbound WebSocket message after the initial handshake.
		• The Request.DataAvailable event handler automatically handles WebSocket 
		messages after the handshake. See the Request.WSMessageGet method for the 
		frame decoding logic that is being used.
		• The Request class now has a Close method which cleans up custom properties
		before calling Super.Close. This is intended to prevent WebSocket connections 
		and persistent connections from inadvertently maintaining state as sockets are
		recycled.
		• Server.WebSockets, an array of Express.Request instances, has been
		added to support bulk WebSocket-related functions such as message 
		broadcasting and "who"-like functionality (as seen in the new demo).
		• A new WSMessageBroadcast method has been added to the Server class.
		It can be used to send a message to all active WebSockets.
		• The Server class has a new WSTimeout property, which can be used to specify
		the number of seconds of inactivity that can pass before a WebSocket will
		be considered to have timed out. The default is 1800 seconds (30 minutes).
		You can set the value to zero to disable WebSocket timeouts.
		• The ConnectionSweeper class has been modified so that two sweeps are done.
		The HTTPConnSweep method sweeps expired HTTP connections. Similarly, 
		the WSConnSweep method sweeps expired WebSocket connections (based 
		on the Server.WSTimeout property mentioned above).
		
		Known WebSocket-related limitations and issues:
		• Request.WSMessageSend only supports text frames (Opcode 1). For details, 
		refer to RFC 6455 Section 11.8 ("WebSocket Opcode Registry"). Binary frames 
		(Opcode 2) might be supported in a future version. Similarly, pings (Opcode 9)
		 and pongs (Opcode 10) are not supported in this release.
		
		Session management-related changes:
		• This release includes a number of changes that are designed to make
		session management more seamless. The changes listed below are
		illustrated in the updated DemoSessions module.
		• The Server class now includes a SessionEngine property which is an
		Express.SessionEngine type.
		• The Server class also now includes a SessionsEnabled property which 
		is a Boolean that defaults to False.
		• If the server is started with the SessionsEnabled property set to True,
		then the server's SessionEngine will be set to an instance of 
		Express.SessionEngine. 
		• The Server class includes a new SessionsSweepIntervalSecs property,
		which is an Integer with a default value of 300. This property is used
		to determine the frequency with which expired sessions are removed.
		• The Request class now includes a Session property, which is a dictionary.
		• To obtain or restore a session for a given session, simply call the 
		class's new SessionGet method. You can optionally pass a AssignNewID 
		Boolean parameter to indicate whether a new Session ID should be 
		assigned to the session. By default, this is set to True to prevent session
		fixation attacks. In some cases, such as when processing XHRs 
		(XMLHttpRequests), you might want to obtain a session without 
		generating a new Session ID.
		• To terminate a request's session, simply call the class's new
		SessionTerminate method.
		
		Cache management-related changes:
		• This release also includes a number of changes that are designed to make
		Server-level caching more seamless. The changes listed below are
		illustrated in the updated DemoCaching module.
		• The Server class now includes a CachEngine property which is an
		Express.CacheEngine type.
		• The Server class also now includes a CachingEnabled property which 
		is a Boolean that defaults to False.
		• If the server is started with the CachingEnabled property set to True,
		then the server's CacheEngine will be set to an instance of 
		Express.CacheEngine. 
		• The Server class includes a new CacheSweepIntervalSecs property,
		which is an Integer with a default value of 300. This property is used
		to determine the frequency with which expired cache entries are removed.
		
		Miscellaneous changes:
		• The Request.URLParamsGet method has been modified to take into account the
		possibility that a URL parameter might have an unescaped question mark in it.
		• The Server class includes a new dictionary property named "Custom."
		The dictionary will persist between requests, and is scoped in such a way 
		that it acts very much like an App-level property.
		• The Request class also has a new property named "Custom." It's a dictionary 
		that can be used to store application-specific information for a request, which
		persists between requests when the socket is being held open (for example,
		when it is servicing a WebSocket connection). For an example of how it can
		be used, see the WebSocket demo. Note that the dictionary is initialized
		in the Request.Prepare method.
		• The Request class has a new PathItems property. This is a dictionary that 
		makes it easier to evaluate a request's path for routing and processing.
		
		
		
		
	#tag EndNote

	#tag Note, Name = 4.0.1
		-----------------------------------------------------------------------------------------
		4.0.1
		-----------------------------------------------------------------------------------------
		
		The Request.WSHandshake method has been modified to prevent crashing when no 
		"Sec-WebSocket-Version" header is specified. If an HTTP/HTTPS request is made to
		an endpoint whose purpose is to service WebSockets, and that request is not the initial
		WebSocket handshake, then a 400 ("Bad Request") response is returned. Special thanks 
		to Derk Jochems for reporting this issue.
		
		New Protocol and ProtocolVersion properties have been added to the Request class. 
		These represent the application protocol (ex: http, https, etc) and version (ex: 1.1) 
		that was used by the client to submit the request. Please note that when running behind
		a proxy server, these values might not reflect the client's original upstream request.
		
	#tag EndNote

	#tag Note, Name = 4.1.0
		-----------------------------------------------------------------------------------------
		4.1.0
		-----------------------------------------------------------------------------------------
		
		Updated the Request class GETDictionaryCreate method so that, when multiple values 
		are passed for the same key, the dictionary entry is treated as an array of strings.
		Example: a=1&b=2&a=3&b=4&a=5&c=678
		
		Request DataAvailable event handler now handles binary content properly. The length 
		of the content is calculated using the underlying TCPSocket's Lookahead method and 
		the LenB function to determine the number of bytes received.
		
		The Request class MapToFile method now includes additional exception handling 
		to prevent references to invalid file and directory references.
		
		Multiple changes were made to the Request class in an attempt to handle non-HTTP requests
		that might be received (for example by apps probing the server that the AE-based app
		is running on. See changes in the Prepare and HeadersDictionaryCreate methods.
		
		Multithreading support has been improved to help prevent memory leaks. 
		See changes in the RequestThread class for details. 
		
		The Request class includes a XojoScriptAvailable constant that is used to conditionally 
		include / exclude the XojoScript Framework during compilation. This is a private 
		constant, set by default to True.
		
	#tag EndNote

	#tag Note, Name = 4.1.1
		-----------------------------------------------------------------------------------------
		4.1.1
		-----------------------------------------------------------------------------------------
		
		The DataAvailable event handler has been rolled back to resolve issues that some
		users are experiencing when processing multi-part forms.
		
	#tag EndNote

	#tag Note, Name = 4.2.0
		-----------------------------------------------------------------------------------------
		4.2.0
		-----------------------------------------------------------------------------------------
		
		AloeExpress has been updated to use API 2.0 released with Xojo 2019R2
		
		By: Jon Eisen
		https://github.com/joneisen
		
	#tag EndNote

	#tag Note, Name = 4.2.1
		-----------------------------------------------------------------------------------------
		4.2.1
		-----------------------------------------------------------------------------------------
		
		Fixes an IOException when writing to the log using Logger
	#tag EndNote

	#tag Note, Name = 4.2.3
		-----------------------------------------------------------------------------------------
		4.2.3
		-----------------------------------------------------------------------------------------
		
		Revert events back following Xojo 2019 R3
		--- This includes addressing a bug where Xojo silently failed to update an event which lead to a NilObjectException
		--- Thank you Github User @jensulrich
		
		Changed Request.Error to use the err event parameter rather than the LastErrorCode property
	#tag EndNote

	#tag Note, Name = 4.2.4
		-----------------------------------------------------------------------------------------
		4.2.4
		-----------------------------------------------------------------------------------------
		
		Moved the DataGet and BodyGet methods on Express.Request to the DataAvailable event 
		to be able to handle a behavior that sometimes comes up when the calling program is using URLConnection.
		--Github Issue #9
	#tag EndNote

	#tag Note, Name = 4.3.0 - API 2.0
		
		- Fixed a processing order problem for POST requests.
		An issue where the content length wasn't correctly compared to the body. 
		Instead it was compared to the Request Lookahead length, which was incorrect at that position.
		
		- Converted mostly (if not all) to API 2.0 compatability.
		
		- Fixed a bug where the StaticPath in some examples was set to the wrong main folder (parent.parent.. changed to parent..)
	#tag EndNote

	#tag Note, Name = 5.0.1
		- Fixed serveral minor issues.
		- Improved memory leak free coding, now using weakref and conversions for server/client.
		- Removed the logging module, suggest using System.Log instead for improved loggin capabilities provided by the system.
		- Express.VERSION_STRING is now a constant.
	#tag EndNote

	#tag Note, Name = 5.0.2
		- Added descriptions to almost all methods and properties which will be displayed in the code editor syntax help area in the Xojo IDE.
		- Removed a few Xojo deprecations.
		- Local variables now all begin with a lowercase letter.
		- Refactored a few string concatenating methods to use the faster String.FromArray method.
		
	#tag EndNote

	#tag Note, Name = 5.0.3
		- Fix Description of SSLConnectionTypes
		- Server.CurrentSocketID and Request.SocketID: UInteger
		- Fix Conditional Compilation of XSProcessor
		  - XojoScriptAvailable=False: XSProcessor should not be compiled and causing the app to include XojoScript Libs
		- Request, Event "Error (102)": If Multithreading then kill the still running Thread
		  - otherwise processing in this Thread continues and uses resources, even though no response
		    is required and possible –> blocking processing power for other Requests
		- Request, Event "SendComplete": Close and Return
		  - Close calls "Reset", so no need to call it twice
		  - should both conditions be true, this would lead to calling super.Close 2x
		- Request, Method "Process": Try-Catch a possible ThreadEndException
		  - If the Thread gets killed, we'll notice that here, and can safely 'return'
		    without having to send or do anything
		- Request, Method "Reset": Also set RequestThread = nil
		
	#tag EndNote

	#tag Note, Name = About
		-----------------------------------------------------------------------------------------
		About
		-----------------------------------------------------------------------------------------
		
		
		-- AloeExpress info: (deprecated)
		-> Aloe Express is a Xojo Web server module.
		-> To learn more, visit: http://aloe.zone (deprecated info)
		
		
		
		-- Express info (2021+):
		For support for Express, please reach to the github repository:
		https://github.com/sworteu/Express
		-> If you have issues or feature requests please create an issue.
		-> If you want a feature to be added, please issue a pull request
		-> If you want to collaborate, please request it via github.com
		
		
		
	#tag EndNote

	#tag Note, Name = Express 5.0.0 - API 2.0
		"AloeExpress" converted to (fork) "Express"
		
		
		Major changes:
		- Changed project name to "Express" from "AloeExpress" 
		- Added Express.Response as the second parameter of the RequestHandler
		- Moved Request handling to Dictionary lookup based by default for dynamic requests. 
		For Static files (or with xojoscript handling) it will be checked if it's a valid path into the "public_html" folder. 
		If the path is invalid a 404 will be given, if it's valid and parsable it will be checked for xojoscript (if .htm, .html or .xs and will be executed if it 
		exists inside the file, otherwise if will just forward the file.
		
		- Removed slower functions and classes. Replaced JSONItem with Dictionary (ParseJSON, GenerateJSON) to improve speed.
		- Removed functions to go from primitives to boolean, string, integer etc. Since API 2.0 has those natively using .ToString, FromString etc.
		
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
		
		To learn more, visit https://www.tldrlegal.com/l/mit
	#tag EndNote

	#tag Note, Name = Thanks (AloeExpress\x2C Deprecated)
		-----------------------------------------------------------------------------------------
		Special thanks to... For initiating AloeExpress and providing changes:
		-----------------------------------------------------------------------------------------
		
		Hal Gumbert of Camp Software (http://campsoftware.com), for his continued feedback, 
		guidance, support, and friendship as Aloe Express has continued to evolve.
		
		Geoff Perlman of Xojo (https://www.xojo.com) for his early suggestions and feedback
		regarding the Aloe Express concept. 
		
		Joshua Golub of Finite Wisdom (https://www.finitewisdom.com) for sharing
		his insights regarding NodeJS, which have certainly influenced Aloe Express.
		
		Scott Boss of Nocturnal Coding Monkeys (http://nocturnalcodingmonkeys.com), for
		providing valuable feedback and for working on the "loopback" support.
		
		Paul Lefebvre of Xojo (https://www.xojo.com) for reviewing Aloe Express from
		a technical perspective, and for all that he does for the Xojo community.
		
		Kem Tekinay of MacTechnologies Consulting (http://mactechnologies.com) for
		sharing his Xojo-WebSocket class (https://github.com/ktekinay/Xojo-WebSocket)
		and for helping with the WebSocket testing.
		
		Derk Jochems for suggesting the Request.PathItems concept, which makes it much
		easier to route and process reqeusts. And fixing several socket parsing issues.
		
		Wes Westhaver for reporting issues that he found with regards to non-HTTP requests.
		
		Yvonnick for suggesting changes to the MapToFile and multipart form functionality
		to better support binary data.
		
		Jürg Otter for his numerous contributions, including the improved RequestThread class
		and other multi-threading improvements, suggesting the EventLog class, and more.
		
		
	#tag EndNote

	#tag Note, Name = Thanks (Express)
		-----------------------------------------------------------------------------------------
		Special thanks to... For work on Express
		-----------------------------------------------------------------------------------------
		
		Dr Garry Pettet (https://garrypettet.com) for adding documentation and refactoring
		several methods.
		
	#tag EndNote


	#tag Property, Flags = &h0, Description = 546865204461746554696D652074686520617070206C61756E636865642E204D75737420626520736574206D616E75616C6C7920647572696E6720746865206C61756E6368206F6620796F7572206170706C69636174696F6E2E
		StartTimestamp As DateTime
	#tag EndProperty


	#tag Constant, Name = VERSION_STRING, Type = String, Dynamic = False, Default = \"5.0.3", Scope = Public, Description = 546865206D6F64756C6527732076657273696F6E2E20496E2053656D56657220666F726D617420284D414A4F522E4D494E4F522E5041544348292E
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
