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
	
	public class SingleImageViewer extends MovieClip{
		
		private var Xpos:Number;
		private var Ypos:Number;
		private var Width:Number;
		private var Height:Number;
		//
		private var _bgAlpha:Number;
		private var _borderAlpha:Number;
		//
		private var _src:String;		
		private var _bg:MovieClip;
		private var _border:MovieClip;
		private var _holder_mc:MovieClip;		
		
		private var _imgLoader:Loader;				
		private var _bringInTween:TweenLite;
				
			
		public function SingleImageViewer(dataObj:Object, sourceId:String, xpos:String, ypos:String) {
			// constructor code
			//trace(dataObj[sourceId]);
			_src = dataObj[sourceId];
			Xpos = Number(dataObj[xpos]);
			Ypos = Number(dataObj[ypos]);
			//Width = Number(dataObj[wid]);
			//Height = Number(dataObj[hght]);;
			//
			_borderAlpha = 0;
			_bgAlpha = 0;
			//
			_holder_mc = this.holder_mc;
			_border = this.border_mc;
			_bg = this.bg_mc;
			
			// Configure dimension:
			this.x = Xpos; this.y = Ypos;
			_bg.height = 100; _bg.width = 100; _bg.alpha = _bgAlpha;
			_border.height = 100; _border.width = 100; _border.alpha = _borderAlpha;
			//
			this.addEventListener(Event.ADDED_TO_STAGE , onSingleImageViewerAdded);	
		}
		private function onSingleImageViewerAdded(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE , onSingleImageViewerAdded);	
			this.dispatchEvent(new Event(GDP.SECTION_COMPLETE));
			//
			preload_bitmap();
		}
		private function preload_bitmap():void{
			_imgLoader = new Loader();
			//
			_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , onBitmapLoaded);
			var rqst:URLRequest = new URLRequest(_src);
			_imgLoader.load(rqst);
		}
		private function onBitmapLoaded(e:Event):void{
			if(_imgLoader == null){
				return;
			}
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onBitmapLoaded);
			var bit = (e.target.content);
			if(bit != null){
				//bit.smoothing = true;
				bit.alpha = 0;
				//
				bit.addEventListener(Event.ADDED_TO_STAGE , showMedia);
				_holder_mc.addChild(bit);
				
			}
		}
		private function showMedia(e:Event):void{
			(e.target).removeEventListener(Event.ADDED_TO_STAGE , showMedia);
			_bringInTween = TweenLite.to((e.target), 0.8,{alpha:1});
		}
	}
	
}
