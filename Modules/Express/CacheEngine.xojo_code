#tag Class
Protected Class CacheEngine
Inherits Timer
	#tag Event
		Sub Action()
		  // Removes expired objects from the cache.
		  // This prevents the cache from growing unnecessarily due to orphaned objects.
		  
		  // Get the current date/time.
		  Var now As DateTime = DateTime.Now
		  
		  // This is an array of the cache names that have expired.
		  Var expiredCacheNames() As String
		  
		  // Loop over the entries in the cache array...
		  For Each key As Variant In Cache.Keys
		    
		    // Get the entry's value.
		    Var cacheEntry As Dictionary = Cache.Value(key)
		    
		    // Set the expiration date.
		    Var expiration As DateTime = cacheEntry.Value("Expiration")
		    
		    // If the session has expired...
		    If now > expiration Then
		      
		      // Append the cache name to the array.
		      expiredCacheNames.Add(key)
		      
		    End If
		    
		  Next key
		  
		  // Removed the cache entries...
		  For Each cacheName As String In expiredCacheNames
		    Cache.Remove(cacheName)
		  Next cacheName
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Clear()
		  // Clears the cache.
		  
		  Cache = New Dictionary
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(SweepIntervalSecs As Integer = 300)
		  // Initilize the Cache dictionary.
		  Cache = New Dictionary
		  
		  // Set the SweepIntervalSecs property.
		  Self.SweepIntervalSecs = SweepIntervalSecs
		  
		  // Schedule the CacheSweep process.
		  Period = SweepIntervalSecs * 1000
		  RunMode = Timer.RunModes.Multiple
		  
		  
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Delete(Name As String)
		  // Deletes an object from the cache.
		  
		  
		  // If the value is in the cache...
		  If Cache.HasKey(Name) Then
		    
		    // Remove the expired cache entry.
		    Cache.Remove(Name)
		    
		  End If
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Get(Name As String) As Dictionary
		  // Gets an object from the cache, and checks its expiration date.
		  // If the object is found, but it has expired, it is deleted from the cache.
		  
		  
		  // If the value is in the cache...
		  If Cache.HasKey(Name) Then
		    
		    // Get the cache entry.
		    Var CacheEntry As Dictionary = Cache.Value(Name)
		    
		    // Get the cache's expiration date.
		    Var Expiration As DateTime = CacheEntry.Value("Expiration")
		    
		    // Get the current date.
		    Var Now As DateTime = DateTime.Now
		    
		    // If the cache has not expired...
		    If Expiration > Now Then
		      
		      // Return the cached content.
		      Return CacheEntry
		      
		    Else
		      
		      // Remove the expired cache entry.
		      Cache.Remove(Name)
		      
		      Return Nil
		      
		    End If
		    
		  End If
		  
		  
		  
		  
		  
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Put(Name As String, Content As Variant, ExpirationSecs As Integer)
		  // Puts an object into the cache, and sets its expiration date.
		  
		  
		  // Create the expiration date/time.
		  Var Expiration As DateTime = DateTime.Now
		  //years, months, days, hours, minutes, seconds
		  Expiration = Expiration.AddInterval( 0, 0, 0, 0, 0, ExpirationSecs )
		  
		  // Get the current date/time.
		  Var Now As DateTime = DateTime.Now
		  
		  // Create the cache entry.
		  Var CacheEntry As New Dictionary
		  CacheEntry.Value("Content") = Content
		  CacheEntry.Value("Expiration") = Expiration
		  CacheEntry.Value("Entered") = Now
		  
		  // Add the entry to the cache.
		  Cache.Value(Name) = CacheEntry
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Cache As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		SweepIntervalSecs As Integer = 300
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
			Name="Enabled"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunMode"
			Visible=true
			Group="Behavior"
			InitialValue="2"
			Type="RunModes"
			EditorType="Enum"
			#tag EnumValues
				"0 - Off"
				"1 - Single"
				"2 - Multiple"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Period"
			Visible=true
			Group="Behavior"
			InitialValue="1000"
			Type="Integer"
			EditorType=""
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
			Name="SweepIntervalSecs"
			Visible=false
			Group="Behavior"
			InitialValue="60"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
