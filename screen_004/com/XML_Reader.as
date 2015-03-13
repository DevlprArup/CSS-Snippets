package  com{
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	//
	import com.GDP;
	import flash.utils.Timer;
	
	public class XML_Reader extends EventDispatcher{
				
		// Variables for loading XML:
		private var _URLLoader:URLLoader;
		private var _rqst:URLRequest;
		private var _xmlPath:String;
		private var _xmlList:XMLList;
		
		
		private var _timerObj:Timer;
		//
		private var initString:String;
		private var changedString:String;
		
		private var AppInitialized:Boolean = false;
		
		
		public function set set_xml_path(param:String):void{
			_xmlPath = param;
			_rqst = new URLRequest(_xmlPath);
			_URLLoader.load(_rqst);
		}
		
		
		public function XML_Reader() {
			// constructor code	
			var timeDelay:Number = GDP.REFRESH_DELAY;
			_timerObj = new Timer(timeDelay , 0);
			_timerObj.addEventListener(TimerEvent.TIMER , handleTimerComplete);
			_URLLoader = new URLLoader();
			_URLLoader.addEventListener(Event.COMPLETE , handleXMLloadComplete);
			_URLLoader.addEventListener(IOErrorEvent.IO_ERROR , handleIOerror);
			//
			_timerObj.start();
			//
			this.addEventListener(GDP.RE_PARSE , handleReParsingRequest);			
		}
		
		
		private function handleTimerComplete(e:TimerEvent):void{					
			//trace("Timer complete");
			_URLLoader.load(_rqst);
		}
		
		private function handleXMLloadComplete(e:Event):void{
			//trace("Successfully loaded XML");
			if(_xmlList != null){
				_xmlList = null;
			}
			
			_xmlList = new XMLList(e.target.data);
			//trace("ll:   "+_xmlList)
			changedString = _xmlList.menus.menu.lastchanged;
			//trace(_xmlList.menus.menu.lastchanged);
			if(!AppInitialized){
				
				AppInitialized = true;
				initString = changedString
				
				parseChangedXML();
				
			}else if(AppInitialized){						
				
				if(initString != changedString){
					initString = changedString
					// cover to fade in
					this.dispatchEvent(new Event(GDP.FADEIN_COVER));

				}else if(initString == changedString){
					// do nothing 
				}
			}		
		}
		private function handleReParsingRequest(e:Event):void{
			//trace("reParse:  "+GDP.TopItemsArr);
			parseChangedXML();
		}
		
		
		private function parseChangedXML():void{
			//trace("parseChangedXML");
			var indx:uint = 0;
			var nodeLen:uint;
			var i:uint = 0;
			//
			if(GDP.XMLArrObj != null){
				GDP.XMLArrObj = null;
			}
			GDP.XMLArrObj = new Object();
			// Clear Global Data Arrays - 
			GDP.XMLArrObj.BGArr = [];
			
			GDP.XMLArrObj.CatOneArr = [];
			
			//GDP.XMLArrObj.GraphicsArr = [];
			GDP.XMLArrObj.PromoArr = [];
						
			// Find the Background Graphic:
			store_in_array (_xmlList.menus.menu.categories.category[indx] , GDP.XMLArrObj.BGArr);
			
			GDP.XMLArrObj.MenuTitlesArr = [];
			indx++;
			store_in_array (_xmlList.menus.menu.categories.category[indx] , GDP.XMLArrObj.MenuTitlesArr, "MenuTitle");
			
			GDP.XMLArrObj.leftItemsArr = [];
			indx++;
			store_in_array (_xmlList.menus.menu.categories.category[indx] , GDP.XMLArrObj.leftItemsArr, "leftMenuItems");
			
			GDP.XMLArrObj.rightItemsArr = [];
			indx++;
			store_in_array (_xmlList.menus.menu.categories.category[indx] , GDP.XMLArrObj.rightItemsArr, "rightMenuItems");
			
			
			GDP.XMLArrObj.pricedItemsArr = [];
			indx++;
			store_in_array (_xmlList.menus.menu.categories.category[indx] , GDP.XMLArrObj.pricedItemsArr, "pricedItems");
			
			
			GDP.XMLArrObj.logosArr = [];
			indx++;
			store_in_array (_xmlList.menus.menu.categories.category[indx] , GDP.XMLArrObj.logosArr);
			
			
			//===========================================================//
			
			GDP.XMLArrObj.LinesArr = [];
			indx++;
			store_in_array (_xmlList.menus.menu.categories.category[indx] , GDP.XMLArrObj.LinesArr);
			
			GDP.XMLArrObj.MediaArrLeft = [];
			indx++;
			store_in_array (_xmlList.menus.menu.categories.category[indx] , GDP.XMLArrObj.MediaArrLeft);
			
			
			
			indx++;
			store_in_array(_xmlList.menus.menu.categories.category[indx] , GDP.XMLArrObj.PromoArr);	
			
			// Event targetted at this Object  , dispatched to notify the parsing done
			dispatchEvent(new Event(GDP.PARSE_COMPLETE));			
		}
		
		public function destroyGarbage():void{
			/*_timerObj.stop();
			_timerObj.removeEventListener(TimerEvent.TIMER , handleTimerComplete);
			_URLLoader.removeEventListener(Event.COMPLETE , handleXMLloadComplete);
			_URLLoader.removeEventListener(IOErrorEvent.IO_ERROR , handleIOerror);
			this.removeEventListener(GDP.RE_PARSE , handleReParsingRequest);
			//
			GDP.XMLArrObj.TopGraphicsArr = [];
			GDP.XMLArrObj.BotLeftGrphArr = [];
			GDP.XMLArrObj.BotRigtGrphArr = [];
			//
			GDP.XMLArrObj.LeftItemsArr = [];
			GDP.XMLArrObj.CntrItemsArr = [];
			GDP.XMLArrObj.RghtItemsArr = [];
			//
			flash.system.System.gc();		
			flash.system.System.gc();*/
		}
		
		
		private function store_in_array(node:String , gdpArr:Array, identifier:String = ""):void{
			var xml:XML = new XML(node);
			//
			if (identifier != "") {
				var dataObj = { catType: identifier, arrRef: gdpArr };
				GDP.Categories.push (dataObj);
			}
			//
			var childLength:Number = xml.elements('*').length();
			for(var i:uint = 0; i < childLength; i++){
				//trace(childLength+" .. childLength \n"+xml.children());
				var obj:Object = new Object();
				obj["catName"] = xml.attributes()[1];
				/* The new Object will be populated with dynamic properties based 
				on the number of attributes available  */
				var attsLength:Number = xml.children()[i].attributes().length();
				for(var j:uint = 0; j <attsLength; j++){
					obj[String(xml.children()[i].attributes()[j].name())] = xml.children()[i].attributes()[j];
					//
					if(String(xml.children()[i].attributes()[j].name()) == "xy"){
						var posObj:Object = MenuUtil.convertXY(xml.children()[i].attributes()[j]);
						obj.xpos = posObj.xpos;
						obj.ypos = posObj.ypos;
					}
					if(String(xml.children()[i].attributes()[j]).length == 0){
						obj[String(xml.children()[i].attributes()[j].name())] = null;
					}
				}
				gdpArr.push(obj);
			}
		}
		private function handleIOerror(e:IOErrorEvent):void{
			trace("could not load XML");
		}

	}
	
}
