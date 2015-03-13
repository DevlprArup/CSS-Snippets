package com{
	// Import default Event Class:  
	import flash.events.Event;

	public class CustomMediaEvent extends Event {

		// Define your Event Constants: (if any)
		public static const COMPLETE:String = "string 1 Here";
		public static const THUMBCLICK:String = "string 2 Here";
		public static const MEDIA_CHANGE:String = "mediaBeingChanged";
		//public static const MEDIA_CHANGE_SOLO:String = "mediaBeingChangedAtBottom";
		

		/* Related properties to make accessible */

		private var _prop1:String;
		private var _prop2:String;
		private var _prop3:*;

		// Following function could be accessed through the Event Object:

		public function get mediaName():String {

			return _prop1;

		}
		public function get category():String {
			return _prop2;
		}
		public function get prop3():String{
			return _prop3;
		}
		// 
		public function CustomMediaEvent(type:String, prop1:String = "None",
		                                              prop2:String = "Not Provided",
		                                              prop3 = 0) {
			super(type, true);
			/* SET PROPERTIES as per PARAMETERS RECEIVED */
			_prop1 = prop1;
			_prop2 = prop2;
			_prop3 = prop3;
		}
		// override clone method so that it can correctly return a 'CustomMediaEvent' instance 
		public override function clone():Event {
			return new CustomMediaEvent(type, _prop1, _prop2 , _prop3);
		}
	}
	// Class Body Ends; 
}