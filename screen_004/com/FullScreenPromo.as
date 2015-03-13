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
	
	
	
	public class FullScreenPromo extends MovieClip{
		//
		private var _mediaArr:Array;
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
		
		private var _promoWidth:Number = 1360;
		private var _promoHeight:Number = 768;
		private var _promoX:Number = 0;
		private var _promoY:Number = 0;
		//
		private var dur:Number;
		private var removeObject:DisplayObject;

		public function FullScreenPromo(mediaArray:Array) {
			// constructor code
			_mediaArr = mediaArray;
			_mediaLength = _mediaArr.length;
			_mediaCntr = 0;
			this.alpha = 0;
			_defaultGap = GDP.MEDIA_GAP;
			this.addEventListener(Event.ADDED_TO_STAGE , onPromoViewerAdded);	
		}
		private function onPromoViewerAdded(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE , onPromoViewerAdded);
			dur = Number(_mediaArr[_mediaCntr].delay);
			if(_gapTween != null){
				_gapTween = null;
			}
			_gapTween = TweenLite.to(this , dur , {alpha:0 , onComplete:firstDelayEnd});			
		}
		private function firstDelayEnd(){
			check_bitmap_video();
		}
		private function check_bitmap_video():void{				
			_promoType = MenuUtil.check_image_video(_mediaArr[_mediaCntr].src);
			_src = _mediaArr[_mediaCntr].src;
			//	
			if(_promoType == "bitmap"){
				preload_bitmap();
			}else if(_promoType == "video"){		
				preload_video();
			}else if(_promoType == "swf"){
				//preload_swf();
			}
		}
		//====================================================================//
		private function preload_bitmap():void{
			_imgLoader = new Loader();
			_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , onBitmapLoaded);
			var rqst:URLRequest = new URLRequest(_src);
			_imgLoader.load(rqst);
		}
		private function preload_video():void{
			_flvLoader = new URLLoader();
			_flvLoader.addEventListener(Event.COMPLETE , onFLVloadComplete);
			var rqst:URLRequest = new URLRequest(_src);
			_flvLoader.load(rqst);
		}
		private function preload_swf():void{
			_imgLoader = new Loader();
			_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , onSwfLoaded);
			var rqst:URLRequest = new URLRequest(_src);
			_imgLoader.load(rqst);
		}
		//====================================================================//
		private function onBitmapLoaded(e:Event):void{
			if(_imgLoader == null){
				return;
			}
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onBitmapLoaded);
			var bit:Bitmap = Bitmap(e.target.content);
			if(bit != null){
				_bmpViewer = new BmpMc();
				_bmpViewer.img.setSize(_promoWidth , _promoHeight);
				_bmpViewer.x = _promoX;;
				_bmpViewer.y = _promoY;
				_bmpViewer.img.source = bit;				
				//
				this.addChild(_bmpViewer);
				showMedia();
			}
		}
		//-----
		private function onFLVloadComplete(e:Event):void{
			if(_flvLoader == null){
				return;
			}
			_flvLoader.removeEventListener(Event.COMPLETE , onFLVloadComplete);
			_flvViewer = new FlvMc();
			//
			_flvViewer.vid.addEventListener(fl.video.VideoEvent.COMPLETE , onVideoComplete);
			_flvViewer.vid.setSize(_promoWidth , _promoHeight);
			_flvViewer.x = _promoX;
			_flvViewer.y = _promoY;
			_flvViewer.vid.source = _src;
			this.addChild(_flvViewer);
			//
			showMedia();
		}
		private function onSwfLoaded(e:Event):void{
			/*if(_imgLoader == null){
				return;
			}
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onBitmapLoaded);
			var swfClip:MovieClip = e.target.content;
			if(swfClip != null){
				if(_holder_mc.numChildren > 1){
					_lastViewer = _holder_mc.getChildAt(1) as MovieClip;;
				}
				_swfViewer = new MovieClip();
				if(CrossFade){
					_swfViewer.alpha = 0;
				}
				_swfViewer.addChild(swfClip);
				_holder_mc.addChild(_swfViewer);
				showMedia();
			}*/
		}
		private function showMedia():void{
			if(_flvViewer != null){
				_bringInTween = TweenLite.to(this, 0.7 , {alpha:1 , onComplete:bringInComplete});
			}
			if(_bmpViewer != null){
				_bringInTween = TweenLite.to(this, 0.7 , {alpha:1 , onComplete:bringInComplete});
			}
			if(_swfViewer != null){
				_bringInTween = TweenLite.to(this, 0.7 , {alpha:1 , onComplete:bringInComplete});
			}
		}
		private function bringInComplete():void{
			// Check if time attribute is available on the array
			if(_mediaArr[_mediaCntr].time != null){
				dur = Number(_mediaArr[_mediaCntr].time);
			}else if(_mediaArr[_mediaCntr].time == null){
				dur = _defaultGap;
			}			
			if(_gapTween != null){
				_gapTween = null;
			}
			_gapTween = TweenLite.to(this , dur , {alpha:1 , onComplete:fade_out});
		}
		private function fade_out():void{
			_fadeOutTween = TweenLite.to(this , 0.7 , {alpha:0 , onComplete:onFadeOutComplete});			
		}
		private function onFadeOutComplete():void{
			if(_gapTween != null){
				_gapTween = null;
			}
			removeObject = this.getChildAt(this.numChildren - 1);
			removeObject.addEventListener(Event.REMOVED_FROM_STAGE, onDisplayObjectRemoved);
			this.removeChild(removeObject);
			//
			dur = Number(_mediaArr[_mediaCntr].delay);
			_gapTween = TweenLite.to(this , dur , {alpha:0 , onComplete:onDelayComplete});
		}
		private function onDisplayObjectRemoved(e:Event):void{
			removeObject.removeEventListener(Event.REMOVED_FROM_STAGE, onDisplayObjectRemoved);
			removeObject = null;
		}
		private function onDelayComplete():void{
			_mediaCntr++;
			if(_mediaCntr == _mediaLength){
				_mediaCntr = 0;
			}	
			check_bitmap_video();
		}
		private function onVideoComplete(e:Event):void{
			//trace("Video End At Bottom Right Promo");
			if(_flvViewer != null){
				_flvViewer.vid.play();
			}
		}
		
		
		
	}
	
}
