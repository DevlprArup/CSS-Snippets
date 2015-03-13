// Item consists of 3 text fields Name, Description & price.
package  com{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	import flash.system.*;
	
	import com.greensock.*; 
	import com.greensock.easing.*;
	//
	import flash.utils.Timer;	
	
	
	public class MenuItem extends MovieClip{
		
		private var _dataObj:Object;    // Consists Item Data 
		private var _vGap:Number = 2;  // adjust vertical space between 2 items
		
		private var _flickTimer:Timer;
		private var _gapTimer:Timer;
		private var _txtAnim:Boolean = false;
		private var _colorArr:Array;
		private var _sequenceNum:Number = 10;
		private var _sequenceCounter:Number = 0;
		

		public function MenuItem(dataObj) {
			// constructor code
			_dataObj = dataObj;
			this.addEventListener(Event.ADDED_TO_STAGE , handleItemAddedToStage);
		}
		private function handleItemAddedToStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE , handleItemAddedToStage);
			this.stage.addEventListener(CustomMediaEvent.MEDIA_CHANGE , onMediaChange);
			//			
			this.nameTXT.x = this.descTXT.x = this.priceTXT.x = 0;
			this.nameTXT.y = this.descTXT.y = this.priceTXT.y = 0;
			// Set positional values
			//this.line.visible = false;
			if (_dataObj.xy != null) {
				this.x = _dataObj.xpos;
				this.y = _dataObj.ypos;
				GDP.ItemX = this.x;
				GDP.ItemY = this.y;				
			}else if (_dataObj.xy == null) {
				this.x = GDP.ItemX;
				this.y = GDP.ItemY;				
			}	
			//
			if (_dataObj.vgap == null) {
				_vGap = GDP.VGap;
			}else if (_dataObj.vgap != null) {
				_vGap = GDP.VGap = _dataObj.vgap;
			}
			//trace (_dataObj.name+"     " + _dataObj.xy);  singleMenuItems
			//
			if (_dataObj.spclObj.name == "MenuTitle") {
				MenuUtil.show_text_names(this.nameTXT,"GarageGothic", _dataObj.name, _dataObj.color,0,0,82);
				//MenuUtil.show_text_names (this.descTXT, "brandonmid", _dataObj.desc, _dataObj.desccolor, 0, 0, 35);
				//this.descTXT.y = this.nameTXT.y + this.nameTXT.height - 5;
				//MenuUtil.show_text_names(this.priceTXT,"Font8", _dataObj.price, _dataObj.pricecolor,0,0,20);
				
			}else if (_dataObj.spclObj.name == "leftMenuItems" ) {
				MenuUtil.show_text_names (this.nameTXT, "GarageGothic", _dataObj.name, _dataObj.color, 0, 0, 45);
				if (this.nameTXT.numLines > 1) {
					MenuUtil.show_text_names (this.nameTXT, "GarageGothic", _dataObj.name, _dataObj.color, 0, -9, 45);
				}
				formatQuote (this.nameTXT, "^", 45, "Garage Gothic FB");
				
				MenuUtil.show_text_names (this.priceTXT, "GarageGothic", _dataObj.price, _dataObj.pricecolor, 0, 0, 45);
				formatQuote (this.priceTXT, "^", 65, "GarageGothic");
				this.priceTXT.x  = 395;
				if (this.priceTXT.height > this.nameTXT.height) {
					// This signifies that the price has a bigger character iside
					this.priceTXT.y  -= 20;
				}
				
				
			}else if (_dataObj.spclObj.name == "rightMenuItems" ) {
				MenuUtil.show_text_names (this.nameTXT, "GarageGothic", _dataObj.name, _dataObj.color, 0, 0, 50);
				if (this.nameTXT.numLines > 1) {
					MenuUtil.show_text_names (this.nameTXT, "GarageGothic", _dataObj.name, _dataObj.color, 0, -9, 50);
				}
				formatQuote (this.nameTXT, "^", 50, "Garage Gothic FB");
				
			}else if (_dataObj.spclObj.name == "pricedItems" ) {				
				
				MenuUtil.show_text_names (this.descTXT, "GarageGothic", _dataObj.desc, _dataObj.desccolor, 0, 0, 30);
				MenuUtil.show_text_names (this.priceTXT, "GarageGothic", _dataObj.price, _dataObj.pricecolor, 0, 0, 50);
				formatQuote (this.priceTXT, "^", 75, "GarageGothic");
				//
				this.priceTXT.x = this.descTXT.x + this.descTXT.width + 10;
				this.descTXT.y = ((this.priceTXT.height - this.descTXT.height)/2) + 5;
				
			}
			
			
			
			
			
			
			
			
			
			else if (_dataObj.spclObj.name == "pricedItemsRight" ) {
				
				MenuUtil.show_text_names (this.descTXT, "GarageGothic", _dataObj.desc, _dataObj.desccolor, 0, 0, 27);
				MenuUtil.show_text_names (this.priceTXT, "GarageGothic", _dataObj.price, _dataObj.pricecolor, 0, 0, 40);
				formatQuote (this.priceTXT, "^", 60, "GarageGothic");
				//
				this.descTXT.y = (this.priceTXT.y + this.priceTXT.height) - 8;
				
			}else if (_dataObj.spclObj.name == "rightFoods" ) {
				MenuUtil.show_text_names (this.nameTXT, "GarageGothic", _dataObj.name, _dataObj.color, 0, 0, 34);
				formatQuote (this.nameTXT, "^", 34, "Garage Gothic FB");
				// 'Garage Gothic FB' is not the LinkageIdentifier .. it is the name of the Font Family
				
			}else if (_dataObj.spclObj.name == "numbersOnly" ) {
				MenuUtil.show_text_names (this.nameTXT, "GarageGothic", _dataObj.name, _dataObj.color, 0, 0, 75);
			}
			
			
			
			//
			else if (_dataObj.spclObj.name == "smallItems") {
				//MenuUtil.show_text_names (this.nameTXT, "GarageGothic", _dataObj.name, _dataObj.color, 0.5, 0, 26);
				
			}else if (_dataObj.spclObj.name == "thinItems") {
				//MenuUtil.show_text_names(this.nameTXT,"GarageGothicThin", _dataObj.name, _dataObj.color, -0.5, 0, 33);				
			}
			
			
			GDP.ItemY = (this.y + this.height) + _vGap;
			GDP.ItemX = this.x;
			// Task Completion Event Dispatch:
			this.dispatchEvent(new Event(GDP.SECTION_COMPLETE));
		}
		private function onMediaChange(e:CustomMediaEvent):void{
			// for Item highlight
			var colorStr:uint = uint(e.prop3);
			var orgColor:uint = uint(_dataObj.color);
			if(e.mediaName == _dataObj.name){		
				TweenMax.to(this.nameTXT, 0.5, {colorTransform:{tint:colorStr, tintAmount:1}});
			}else{
				TweenMax.to(this.nameTXT, 0.5, {colorTransform:{tint:orgColor, tintAmount:1}});
			}			
		}
		function formatQuote(tf:TextField, quote:String, size:Object, font:String):void{
			var str:String = String(tf.text);
			var len:uint = str.length;
			var format:TextFormat;
			var colorize:Boolean = false;
			var quoteOccurance:Number = 0;
			//
			for(var i:uint = 0; i<len; i++){
				if(str.charAt(i) == quote){	
					quoteOccurance++;
					colorize = (colorize == false)? true:false;
				}
				// Color characters based on quote 
				if(colorize){
					format = tf.getTextFormat(i , (i + 1)); 
					//format.color = parseInt(color , 16);
					format.font = font;
					//format.bold = true;
					format.size = size;
					tf.setTextFormat(format , i , (i + 1));    
				}  
			} 
			// another loop that deletes the quotes
			for(i = 0; i<quoteOccurance; i++){
			//trace(str.charAt(indexes[i]));
				str = String(tf.text);
				len = str.length; 
				for(var j:uint = 0; j<len; j++){
				if(str.charAt(j) == quote){
						tf.replaceText(j, (j+1), "");
						break;
					}   
				}
			}	 
		}
		private function applyMultiColorAnim(tf:TextField):void{
			_txtAnim = true;
			var repeat:int = String(tf.text).length;
			_flickTimer = new Timer(50,repeat);
			_flickTimer.addEventListener(TimerEvent.TIMER, handleFlickTimeUp);
			_flickTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handleFlickTimeComplete);
			_flickTimer.start();	
		}
		private function handleFlickTimeUp(e:TimerEvent):void{			 
			var format:TextFormat;
			var i:uint = uint(_flickTimer.currentCount - 1);
			var charIndex:Number = Number(_flickTimer.currentCount - 1);
			format = this.nameTXT.getTextFormat(charIndex , (charIndex + 1));	
			//trace(String(this.nameTXT.text).charAt(charIndex));
			//
			if((_sequenceCounter % 2) == 0){
				format.color = parseInt(_colorArr[i] , 16);
			}else if((_sequenceCounter % 2) == 1){
				format.color = parseInt(_dataObj.color , 16);
			}
			this.nameTXT.setTextFormat(format , charIndex , (charIndex + 1));			
		}
		private function handleFlickTimeComplete(e:TimerEvent):void{
			_sequenceCounter++;			
			if(_sequenceCounter < _sequenceNum){
				_flickTimer.reset();
				_flickTimer.start();
			}else if(_sequenceCounter == _sequenceNum){
				_sequenceCounter = 0;
				//trace("over .......................")
				_flickTimer.reset();
				//_gapTimer.reset();
				//_gapTimer.start();
			}
		}

	}
}
