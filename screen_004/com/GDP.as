package  com{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	
	public class GDP {
		/*
		EVENT STRINGS DEFINED: This class has been used as a central location to declare 
		all the Event Types required for the project
		*/
		
		//http://digitalmenuinabox.com/menu_preview.php?template_id=311&location_id=300
		public static const PARSE_COMPLETE:String = "parseComplete";
		public static const FADEIN_COVER:String = "fadeInCover";
		public static const RE_PARSE:String = "reParseXml";
		
		// The following 2 are used at Document Class
		public static const START_DISPLAY:String = "startDisplay";
		public static const START_EFFECT:String = "startEffectAnimation";	
		
		// The following 2 are used at LayoutManager Class
		public static const LAY_OUT_COMPLETE:String = "layOutManagerComplete";		
		public static const EFFECT_COMPLETE:String = "effectAnimationComplete";
		public static const SECTION_COMPLETE:String = "sectionClipLayOutComplete";
		//
		public static const FULL_SCREEN_PROMO_START:String = "fullScreenPromoStart";
		public static const FULL_SCREEN_PROMO_ENDS:String = "fullScreenPromoEnds";
		
		//
		public static const EFFECT_DELAY:Number = 50;
		public static const REFRESH_DELAY:Number = 60000; // Every 1 minute
		public static const DATE_CHECK:Number = 300000;   // Every 5 Minute
		public static const WEEK_END_SWAP:Number = 30000; // Every 30 Seconds
		public static const MEDIA_GAP:Number = 10; // Seconds: To be used by TweenLite
		
		
		// The XMLArrObj will be created in the XML_Reader and will hold all the arrays		
		public static var XMLArrObj:Object;
		
		
		// The following variables are project specific & not mandatory
		public static var CommentString:String = "";		
		public static var BackGroundGraphic:String;
		public static var BGgraphicCopy:Bitmap;
		public static var CoverPromoDelay:Number; //  For Full Screen Promo		
		public static var Logo:MovieClip;
		
		public static var ItemX:Number;
		public static var ItemY:Number;
		public static var CatNum:Number = 0;
		public static var VGap:Number = 0;
		
		//
		public static var Categories:Array = [];
		
		public static var MultiColorArray:Array = ["0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00",  "0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20",
						"0xD22144" , "0x00CC00" , "0x2818B1" , "0xFFDA00" , "0x7109AA","0x000000", "0x0A64A3","0xFFBE00","0xC7007D","0x7DCD20"];
		
		

		public function GDP() {
			// constructor code
		}

	}	
}
