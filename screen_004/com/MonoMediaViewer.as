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
	
	public class MonoMediaViewer extends MovieClip{
		
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

		public function MonoMediaViewer( src:String , x:Number = 0, y:Number = 0, w:Number = 150, h:Number = 150, 
									borderAlpha:Number = 1 , bgAlpha:Number = 1, crossFade:Boolean = true) {
			// constructor code
			_src = src;
			//_mediaArr = mediaArray;	
			Xpos = x;
			Ypos = y;
			Width = w;
			Height = h;			
			_borderAlpha = borderAlpha;
			_bgAlpha = bgAlpha;
			CrossFade = crossFade;
				
			//------------//			
			
			//_mediaLength = _mediaArr.length;
			_mediaCntr = 0;
			_holder_mc = this.holder_mc;
			_border = this.border_mc;
			_bg = this.bg_mc;
			_defaultGap = GDP.MEDIA_GAP;
			
			// Configure dimension:
			this.x = Xpos; this.y = Ypos;
			_bg.height = Height; _bg.width = Width; _bg.alpha = _bgAlpha;
			_border.height = Height; _border.width = Width; _border.alpha = _borderAlpha;
			this.addEventListener(Event.ADDED_TO_STAGE , onMediaViewerAdded);	
		}
		private function onMediaViewerAdded(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE , onMediaViewerAdded);	
			//
			check_bitmap_video();
		}
		private function check_bitmap_video():void{	
			
			_promoType = MenuUtil.check_image_video(_src);
			//_src = _mediaArr[_mediaCntr].src;
			//
			if(CrossFade){
				//_holder_mc.alpha = 0;
			}else if(!CrossFade){
				this.alpha = 0;
				if(_holder_mc.numChildren > 1){
					var mc:MovieClip = _holder_mc.getChildAt(1) as MovieClip;
					_holder_mc.removeChild(mc);
					mc = null;
				}
			}
			//			
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
				if(_holder_mc.numChildren > 1){
					_lastViewer = _holder_mc.getChildAt(1) as MovieClip;;
				}
				_bmpViewer = new BmpMc();
				if(CrossFade){
					_bmpViewer.alpha = 0;
				}
				_bmpViewer.img.setSize(Width , Height);
				_bmpViewer.img.source = bit;				
				//
				_holder_mc.addChild(_bmpViewer);
				showMedia();
			}
		}
		private function onFLVloadComplete(e:Event):void{
			if(_flvLoader == null){
				return;
			}
			_flvLoader.removeEventListener(Event.COMPLETE , onFLVloadComplete);
			//
			if(_holder_mc.numChildren > 1){
				_lastViewer = _holder_mc.getChildAt(1) as MovieClip;;
			}
			
			_flvViewer = new FlvMc();
			if(CrossFade){
				_flvViewer.alpha = 0;
			}
			//
			_flvViewer.vid.addEventListener(fl.video.VideoEvent.COMPLETE , onVideoComplete);
			_flvViewer.vid.setSize(Width , Height);
			_flvViewer.vid.source = _src;
			_holder_mc.addChild(_flvViewer);
			//
			showMedia();
		}
		private function onSwfLoaded(e:Event):void{
			if(_imgLoader == null){
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
			}
		}
		//==============================================================================================//
		private function showMedia():void{
			if(CrossFade){
				// When CrossFading is enabled - the added asset is supposed to Fade in
				if(_flvViewer != null){
					_bringInTween = TweenLite.to(_flvViewer, 0.7 , {alpha:1 , onComplete:bringInComplete});
				}
				if(_bmpViewer != null){
					_bringInTween = TweenLite.to(_bmpViewer, 0.7 , {alpha:1 , onComplete:bringInComplete});
				}
				if(_swfViewer != null){
					_bringInTween = TweenLite.to(_swfViewer, 0.7 , {alpha:1 , onComplete:bringInComplete});
				}
				if(_lastViewer != null){
					_crossFadeTween = TweenLite.to(_lastViewer, 0.7 , {alpha:0 , onComplete:crossFadeOutComplete});
				}
			}else if(!CrossFade){
				// When Cross Fade is false the whole container is supposed to fade in
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
		}		
		private function crossFadeOutComplete():void{
			if(_holder_mc.numChildren > 2){
				var mc:MovieClip = _holder_mc.getChildAt(1) as MovieClip;
				_holder_mc.removeChild(mc);
				mc = null;
			}
		}
		private function bringInComplete():void{
			// Check if time attribute is available on the array
			/*var dur:Number;
			if(_mediaArr[_mediaCntr].time != null){
				dur = Number(_mediaArr[_mediaCntr].time);
			}else if(_mediaArr[_mediaCntr].time == null){
				dur = _defaultGap;
			}*/
			
			//_gapTween = TweenLite.to(this , dur , {alpha:1 , onComplete:onDurationComplete});
		}
		private function onDurationComplete():void{
			_mediaCntr++;
			if(_mediaCntr == _mediaLength){
				_mediaCntr = 0;
			}	
			// Fade out is only possible when there is more than one media item to rotate 
			//trace(_mediaArr.length);
			/*if(_mediaArr.length > 1){
				fade_out();
			}*/			
		}
		private function fade_out():void{
			if(CrossFade){
				// For CrossFading - diretly to load next media asset
				check_bitmap_video();
			}else if(!CrossFade){
				_fadeOutTween = TweenLite.to(this , 0.7 , {alpha:0 , onComplete:onFadeOutComplete});
			}
			
		}
		private function onFadeOutComplete():void{
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
