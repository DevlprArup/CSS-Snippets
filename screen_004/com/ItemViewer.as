package  com{
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import fl.containers.*;
	import flash.utils.Timer;
	import fl.transitions.*;
    import fl.transitions.easing.*;
	import fl.video.*;
	import fl.video.VideoEvent;
	import flash.net.*;
	import flash.system.*;
	//
	import com.greensock.*; 
	import com.greensock.easing.*;
	
	public class ItemViewer extends MovieClip{
		
		private var _dataObj:Object;
		private var Xpos:Number;
		private var Ypos:Number;
		private var Width:Number;
		private var Height:Number;
		private var CrossFade:Boolean;
		private var _bgAlpha:Number;
		private var _borderAlpha:Number;
		private var _mediaArr:Array;
		//------------------------------------------//
		private var _mediaLength:Number;
		private var _mediaCntr:Number;
		private var _promoType:String;
		private var _src:String;
		private var _defaultGap:Number;
		
		private var _bg:MovieClip;
		private var _border:MovieClip;
		private var _holder_mc:MovieClip;		
		
		private var _imgLoader:Loader;
		private var _flvLoader:URLLoader;
		
		private var _bmpViewer:MovieClip;
		private var _flvViewer:MovieClip;
		private var _swfViewer:MovieClip;
		private var _lastViewer:MovieClip;
		
		private var _bringInTween:TweenLite;
		private var _fadeOutTween:TweenLite;
		private var _crossFadeTween:TweenLite;
		private var _gapTween:TweenLite;
		
		private var _timer:Timer;
		
		// TEXT Fields:
		private var _nameTXT:TextField;
		private var _descTXT:TextField;
		private var _priceTXT:TextField;
		private var _price2TXT:TextField;

		/*public function ItemViewer( mediaArray:Array , x:Number = 0, y:Number = 0, w:Number = 150, h:Number = 150, 
									borderAlpha:Number = 1 , bgAlpha:Number = 1, crossFade:Boolean = true) {*/
										
		public function ItemViewer(dataObj:Object) {
			_dataObj = dataObj;
			// constructor code
			//_mediaArr = mediaArray;	
			Xpos = dataObj.xpos;
			Ypos = dataObj.ypos;
			Width = dataObj.imgWidth;
			Height = dataObj.imgHeight;
			//
			_borderAlpha = 0;
			_bgAlpha = 0;
			CrossFade = false;
				
			//------------//			
			_nameTXT = this.nameTXT;
			_descTXT = this.descTXT;
			_priceTXT = this.priceTXT;
			_price2TXT = this.price2TXT;
			//-----------//
			
			//_mediaLength = _mediaArr.length;
			//_mediaCntr = 0;
			_holder_mc = this.holder_mc;
			_border = this.border_mc;
			_bg = this.bg_mc;
			//
			
			// Configure dimension:
			this.x = Xpos; this.y = Ypos;
			_bg.height = Height; _bg.width = Width; _bg.alpha = _bgAlpha;
			_border.height = Height; _border.width = Width; _border.alpha = _borderAlpha;
			//
			this.addEventListener(Event.ADDED_TO_STAGE , onItemViewerAdded);	
		}
		private function onItemViewerAdded(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE , onItemViewerAdded);	
			//
			if(_dataObj.catID == "cat1"){
				MenuUtil.show_text_names(this.nameTXT,"vagthin", _dataObj.name, _dataObj.color,0,0,20);
				MenuUtil.show_text_names(this.descTXT,"vagbold", _dataObj.description, _dataObj.descriptioncolor,0,0,20);
				MenuUtil.show_text_names(this.priceTXT,"Font8", _dataObj.price, _dataObj.pricecolor,0,0,20);
				MenuUtil.show_text_names(_price2TXT, "Font8", _dataObj.price, _dataObj.pricecolor,0,0,20);
			
			/*MenuUtil.show_text_names(_nameTXT, _dataObj.name , _dataObj.color, -0.5, -16, true, 35);
			MenuUtil.show_text_names(_descTXT, "" , _dataObj.descriptioncolor, 0, 0, false, 0);
			MenuUtil.show_text_names(_priceTXT, _dataObj.price , _dataObj.pricecolor, 0, 0, true, 25);
			MenuUtil.show_text_names(_price2TXT, "" , _dataObj.price2color, 0, 0, true, 0);*/
			//
			_priceTXT.y = _nameTXT.y + 5;
				
			}else if(_dataObj.catID == "cat3"){
				MenuUtil.show_text_names(this.nameTXT,"vagthin", _dataObj.name, _dataObj.color,0,0,20);
				MenuUtil.show_text_names(this.descTXT,"vagbold", _dataObj.description, _dataObj.descriptioncolor,0,0,20);
				MenuUtil.show_text_names(this.priceTXT,"Font8", _dataObj.price, _dataObj.pricecolor,0,0,20);
				MenuUtil.show_text_names(_price2TXT, "Font8", _dataObj.price, _dataObj.pricecolor,0,0,20);
				
			/*MenuUtil.show_text_names(_nameTXT, _dataObj.name , _dataObj.color, -1.9, -16, true, 37);
			MenuUtil.show_text_names(_descTXT, "" , _dataObj.descriptioncolor, 0, 0, false, 0);
			MenuUtil.show_text_names(_priceTXT, _dataObj.price , _dataObj.pricecolor, -0.3, 0, true, 25);
			MenuUtil.show_text_names(_price2TXT, "" , _dataObj.price2color, 0, 0, true, 0);*/
			
			_priceTXT.y = _nameTXT.y + 40;
				
			}
			// Add & Align Texts
			
			
			
			
			
			check_bitmap_video();
		}
		
		private function onItemViewer2Added(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE , onItemViewer2Added);	
			// Add & Align Texts
			
			/*MenuUtil.show_text_names(_nameTXT, _dataObj.name , _dataObj.color, -0.5, -16, true, 37);
			MenuUtil.show_text_names(_descTXT, "" , _dataObj.descriptioncolor, 0, 0, false, 0);
			MenuUtil.show_text_names(_priceTXT, _dataObj.price , _dataObj.pricecolor, 0, 0, true, 25);
			MenuUtil.show_text_names(_price2TXT, "" , _dataObj.price2color, 0, 0, true, 0);*/
			//
			_priceTXT.y = _nameTXT.y + 5;
			
			/*_priceTXT.y = ((_nameTXT.y + _nameTXT.height) - (_priceTXT.y + _priceTXT.height - 15));
			if (_nameTXT.numLines > 1){
				_descTXT.y = (_nameTXT.y + _nameTXT.height) - 10;
				
			}else if (_nameTXT.numLines == 1){
				_descTXT.y = (_nameTXT.y + _nameTXT.height) + 10;
			}
			if (_nameTXT.numLines > 1){
				_priceTXT.y = ((_nameTXT.y + _nameTXT.height) - (_priceTXT.y + _priceTXT.height +7));
			}else if (_nameTXT.numLines == 1){
				 _priceTXT.y = ((_nameTXT.y + _nameTXT.height) - (_priceTXT.y + _priceTXT.height - 15));
			}
			_price2TXT.y = _descTXT.y;*/
			//
			check_bitmap_video();
		}
		private function check_bitmap_video():void{	
			
			_promoType = MenuUtil.check_image_video(_dataObj.src);
			_src = _dataObj.src;
				
			//trace(_promoType);
			if(_promoType == "bitmap"){
				preload_bitmap();
			}else if(_promoType == "video"){		
				preload_video();
			}else if(_promoType == "swf"){
				preload_swf();
			}
		}
		private function preload_bitmap():void{
			_imgLoader = new Loader();
			//
			_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , onBitmapLoaded);
			var rqst:URLRequest = new URLRequest(_src);
			_imgLoader.load(rqst);
		}
		private function preload_video():void{
			_flvLoader = new URLLoader();
			//
			_flvLoader.addEventListener(Event.COMPLETE , onFLVloadComplete);
			//
			var rqst:URLRequest = new URLRequest(_src);
			_flvLoader.load(rqst);
		}
		private function preload_swf():void{
			_imgLoader = new Loader();
			//
			_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , onSwfLoaded);
			var rqst:URLRequest = new URLRequest(_src);
			_imgLoader.load(rqst);
		}
		//======================================================================//
		private function onBitmapLoaded(e:Event):void{
			if(_imgLoader == null){
				return;
			}
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onBitmapLoaded);
			var bit:Bitmap = Bitmap(e.target.content);
			if(bit != null){
				bit.smoothing = true;
				//
				
				_bmpViewer = new IVBmpMc();
				//
				//trace();
				_bmpViewer.img.setSize(Width , Height);
				_bmpViewer.img.source = bit;				
				//
				_bmpViewer.addEventListener(Event.ADDED_TO_STAGE , onMediaContainerAdded);
				_holder_mc.addChild(_bmpViewer);
			}
		}
		private function onFLVloadComplete(e:Event):void{
			if(_flvLoader == null){
				return;
			}
			_flvLoader.removeEventListener(Event.COMPLETE , onFLVloadComplete);
			//
			if(_holder_mc.numChildren > 1){
				//_lastViewer = _holder_mc.getChildAt(1) as MovieClip;;
			}
			
			_flvViewer = new IVFlvMc();
			//
			_flvViewer.vid.addEventListener(fl.video.VideoEvent.COMPLETE , onVideoComplete);
			_flvViewer.vid.setSize(Width , Height);
			_flvViewer.vid.source = _src;
			_flvViewer.addEventListener(Event.ADDED_TO_STAGE , onMediaContainerAdded);
			_holder_mc.addChild(_flvViewer);
		}
		private function onSwfLoaded(e:Event):void{
			if(_imgLoader == null){
				return;
			}
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onBitmapLoaded);
			var swfClip:MovieClip = e.target.content;
			if(swfClip != null){
				
				_swfViewer = new MovieClip();
				//
				_swfViewer.addChild(swfClip);
				_swfViewer.addEventListener(Event.ADDED_TO_STAGE , onMediaContainerAdded);
				_holder_mc.addChild(_swfViewer);
			}
		}
		//==============================================================================================//
				
		private function onMediaContainerAdded(e:Event):void{
			(e.target).removeEventListener(Event.ADDED_TO_STAGE , onMediaContainerAdded);
			trace(e.target.alpha)
			e.target.x -= 8;
			if(_dataObj.description == ""){
				e.target.y = (_nameTXT.y + _nameTXT.height) - 15;
			}else if(_dataObj.description != ""){
				e.target.y = (_descTXT.y + _descTXT.height) - 15;
			}
			
			this.dispatchEvent(new Event(GDP.SECTION_COMPLETE));
		}
		
		private function onVideoComplete(e:Event):void{
			//trace("Video End At Bottom Right Promo");
			if(_flvViewer != null){
				_flvViewer.vid.play();
			}
		}

	}
	
}
