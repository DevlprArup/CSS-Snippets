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
	
	
	public class LayoutManager extends MovieClip{
		
		//private static const ITEM_Y_GAP:Number = 2;
		
		private var _loader:Loader;
		// Container MovieClips:
		private var _bgGraphic:MovieClip;
		private var _container:MovieClip;
		
		private var _item:MenuItem;
		private var _itemCntr:Number;
		private var _itemNum:Number;
		
		private var _xPos:Number = 99;  // First coordinate to be hardcoded as per PSD
		private var _yPos:Number = 181; // First coordinate to be hardcoded as per PSD
		
		private var _foodCatNum:Number = 1;
		private var _foodCatCounter:Number = 0;
		private var _useArr:Array;
		private var _posArr:Array;
		private var _catName:String;
		
		private var _medViewer:MediaViewer;
		private var _medViewerAdv:MediaViewerAdv;
		private var _singleImgVwr:SingleImageViewer;
			
		private var _fullScrPromo:FullScreenPromo;
		
		public function LayoutManager(param:MovieClip , graphicHolder:MovieClip) {
			// constructor code
			_container = param;
			_bgGraphic = graphicHolder;
			//
			_foodCatNum = GDP.Categories.length;
			add_bg_graphic();
		}
		
		private function add_bg_graphic ():void {
			//
			if (GDP.XMLArrObj.BGArr[0].src != null) {
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.INIT , onGraphicLoadComplete);
				_loader.load(new URLRequest(GDP.XMLArrObj.BGArr[0].src));
			}else if (GDP.XMLArrObj.BGArr[0].src == null) {
				determine_arr();
			}			
		}
		private function onGraphicLoadComplete(e:Event):void{			
			_loader.contentLoaderInfo.removeEventListener(Event.INIT , onGraphicLoadComplete);
			_bgGraphic.addChild(_loader);
			//
			determine_arr();
		}
		
		
		private function determine_arr ():void {
			_useArr = GDP.Categories[_foodCatCounter].arrRef;
			_catName = GDP.Categories[_foodCatCounter].catType;
			//
			_itemCntr = 0;
			_itemNum = _useArr.length;
			//
			add_food_items();
		}
		private function add_food_items():void{
			var spclObj:Object = new Object();
			spclObj.name = _catName;
			spclObj.id = "yourCustomId";
			_useArr[_itemCntr].spclObj = spclObj;
			//
			_item = new MenuItem(_useArr[_itemCntr]);
			_item.addEventListener(GDP.SECTION_COMPLETE , onItemComplete);
			_container.addChild(_item);
		}
		private function onItemComplete(e:Event):void{
			_item.removeEventListener(GDP.SECTION_COMPLETE , onItemComplete);
			// Update x,y position from already used data object
			//			
			_itemCntr++;
			if(_itemCntr < _itemNum){
				add_food_items();				
			}else if(_itemCntr == _itemNum){
				//
				_foodCatCounter++;
				if(_foodCatCounter < _foodCatNum){
					determine_arr();
				}else if(_foodCatCounter == _foodCatNum){					
					//addFullScreenPromo();
					//add_media_viewer();
					//_container.stage.dispatchEvent(new Event(GDP.LAY_OUT_COMPLETE));
					addLogos ();
					
				}				
			}
		}
		private function addLogos ():void {
			
			if (GDP.XMLArrObj.logosArr.length > 0) {
				for (var i:uint = 0; i < GDP.XMLArrObj.logosArr.length; i++) {
					var loader = new Loader ();
					loader.x = GDP.XMLArrObj.logosArr[i].xpos;
					loader.y = GDP.XMLArrObj.logosArr[i].ypos;
					loader.load (new URLRequest (GDP.XMLArrObj.logosArr[i].src));
					//
					_container.addChild (loader);
				}
			}
			add_lines ();			
		}
		
		private function add_lines ():void {
			
			for (var i = 0; i < GDP.XMLArrObj.LinesArr.length; i++ ) {
				var lineClip:MovieClip = new line ();
				MenuUtil.colorizeDisplayObject (GDP.XMLArrObj.LinesArr[i].color, lineClip);
				lineClip.width = GDP.XMLArrObj.LinesArr[i].width;
				lineClip.x = GDP.XMLArrObj.LinesArr[i].xpos;
				lineClip.y = GDP.XMLArrObj.LinesArr[i].ypos;
				_container.addChild (lineClip);
				
			}
			//
			//_container.stage.dispatchEvent(new Event(GDP.LAY_OUT_COMPLETE));
			add_media_viewer ();
		}
		
		private function add_media_viewer():void{
			// Just pass on the array containing Image/Video references:			
			var _medViewerLeft = new MediaViewer(GDP.XMLArrObj.MediaArrLeft,28,94,537,266,0,0);
			_container.addChild (_medViewerLeft);
			//
			
			_container.stage.dispatchEvent(new Event(GDP.LAY_OUT_COMPLETE));
			
			// OR if Advanced Media Viewer is applied:
			//var mediaArrA:Array = MenuUtil.filterMediaSources(GDP.XMLArrObj.GraphicsArr);
			/*var mediaArrA:Array = MenuUtil.filterMediaSources(GDP.XMLArrObj.GraphicsArr);
			_medViewerAdv = new MediaViewerAdv(GDP.XMLArrObj.GraphicsArr,240,250,300,450,0,1);
			_container.addChild(_medViewerAdv);*/
			//
			addFullScreenPromo();
		}
		private function addFullScreenPromo():void{
			/*var _fullScrPromo = new FullScreenPromo(GDP.XMLArrObj.PromoArr);
			_fullScrPromo.x = 0;
			_fullScrPromo.y = 0;
			_container.addChild(_fullScrPromo);	*/
			_container.stage.dispatchEvent(new Event(GDP.LAY_OUT_COMPLETE));
		}
		
		
		
		//***********************************************************************************************//
		public function destroyGarbage():void{
			//_loader.contentLoaderInfo.removeEventListener(Event.INIT , onGraphicLoadComplete);
			//_block.removeEventListener(GDP.SECTION_COMPLETE , handleDayItemAdd);
			//flash.system.System.gc();
			
		}
		//***********************************************************************************************//
				
	}
	
}
