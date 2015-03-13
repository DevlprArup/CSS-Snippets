package com{

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import fl.containers.*;
	import flash.utils.*;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import fl.video.*;
	import fl.video.VideoEvent;
	import flash.net.*;
	import flash.system.*;
	//
	import com.greensock.*;
	import com.greensock.easing.*;

	public class MediaViewerAdv extends MovieClip {

		private var Xpos:Number;
		private var Ypos:Number;
		private var Width:Number;
		private var Height:Number;

		private var _bgAlpha:Number;
		private var _borderAlpha:Number;
		private var _mediaArr:Array;
		//------------------------------------------//
		private var _mediaLength:Number;
		private var _mediaCntr:Number;
		private var _promoType:String;
		private var _src:String;
		private var _time:String;
		private var _defaultGap:Number;
		private var _col:String;
		private var _itemRef:String;

		private var _bg:MovieClip;
		private var _border:MovieClip;
		private var _holder_mc:MovieClip;

		private var _imgLoader:Loader;
		private var _flvLoader:URLLoader;

		private var _bmpViewer:MovieClip;
		private var _flvViewer:MovieClip;
		private var _swfViewer:MovieClip;


		/*private var _bringInTween:TweenLite;
		private var _fadeOutTween:TweenLite;
		private var _crossFadeTween:TweenLite;*/
		private var _removeTween:TweenLite;
		private var _gapTween:TweenLite;
		private var _animCounter:Number = 0;
		private var _maxAnim:Number = 2;

		private var _timer:Timer;

		public function MediaViewerAdv( mediaArray:Array , x:Number = 0, y:Number = 0, w:Number = 150, h:Number = 150, 
		borderAlpha:Number = 1 , bgAlpha:Number = 1) {
			// constructor code
			_mediaArr = mediaArray;
			Xpos = x;
			Ypos = y;
			Width = w;
			Height = h;
			_borderAlpha = borderAlpha;
			_bgAlpha = bgAlpha;

			//------------//
			_mediaLength = _mediaArr.length;
			_mediaCntr = 0;
			_holder_mc = this.holder_mc;
			_border = this.border_mc;
			_bg = this.bg_mc;
			_defaultGap = GDP.MEDIA_GAP;

			// Configure dimension:
			this.x = Xpos;
			this.y = Ypos;
			_bg.height = Height;
			_bg.width = Width;
			_bg.alpha = _bgAlpha;
			_border.height = Height;
			_border.width = Width;
			_border.alpha = _borderAlpha;
			this.addEventListener(Event.ADDED_TO_STAGE , onMediaViewerAdded);
		}
		private function onMediaViewerAdded(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE , onMediaViewerAdded);
			//
			check_bitmap_video();
		}
		private function check_bitmap_video():void {
			//
			if(_mediaArr[_mediaCntr].src == null){
				var missingMedia = new MissingMedia();
				missingMedia.x = (Width - missingMedia.width)/2;
				missingMedia.y = (Height - missingMedia.height)/2;
				this.addChild(missingMedia);
				return;
			}			
			_promoType = MenuUtil.check_image_video(_mediaArr[_mediaCntr].src);
			_src = _mediaArr[_mediaCntr].src;
			_time = _mediaArr[_mediaCntr].time;
			_itemRef = _mediaArr[_mediaCntr].itemRef;
			_col = _mediaArr[_mediaCntr].itemHighlightColor;
			
			//
			if (_promoType == "bitmap") {
				preload_bitmap();
			}
			else if (_promoType == "video") {
				preload_video();
			}else if(_promoType == "swf"){
				preload_swf();
			}
			

			
		}
		private function preload_bitmap():void {
			_imgLoader = new Loader();
			//
			_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , onBitmapLoaded);
			var rqst:URLRequest = new URLRequest(_src);
			_imgLoader.load(rqst);
		}
		private function preload_video():void {
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
		private function onSwfLoaded(e:Event):void {
			if (_imgLoader == null) {
				return;
			}
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onSwfLoaded);
			var swfClip:MovieClip = e.target.content;
			//
			if (swfClip != null) {
				_swfViewer = null;
				_swfViewer = new MovieClip();
				//
				var msk:MovieClip;
				if (_animCounter == 0) {
					msk = MenuUtil.getLibraryClip(31,Width,Height);
				}
				else if (_animCounter == 1) {
					msk = MenuUtil.getLibraryClip(31,Width,Height);
				}
				
				/*
				this.stage.dispatchEvent(new Event("advanceMaskAnimComplete")) --- Thrown 
				from the last frame of attached mask clips:  */
				this.stage.addEventListener("advanceMaskAnimComplete" ,  handleAdvanceAnimComplete);
				
				_swfViewer.addChild(swfClip);
				_swfViewer.addChild(msk);
				
				//
				swfClip.mask = msk;
				//
				_swfViewer.addEventListener(Event.ADDED_TO_STAGE , onViewerAdded);
				_holder_mc.addChild(_swfViewer);
			}
		}
		private function onBitmapLoaded(e:Event):void {
			if (_imgLoader == null) {
				return;
			}
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onBitmapLoaded);
			var bit:Bitmap = Bitmap(e.target.content);
			if (bit != null) {
				bit.smoothing = true;

				_bmpViewer = null;
				_bmpViewer = new BmpAdvMc();
				// Set Mask Animations:
				var msk:MovieClip;
				if (_animCounter == 0) {
					msk = MenuUtil.getLibraryClip(31,Width,Height);
				}
				else if (_animCounter == 1) {
					msk = MenuUtil.getLibraryClip(31,Width,Height);
				}
				
				/*
				this.stage.dispatchEvent(new Event("advanceMaskAnimComplete")) --- Thrown 
				from the last frame of attached mask clips:  */
				this.stage.addEventListener("advanceMaskAnimComplete" ,  handleAdvanceAnimComplete);

				_bmpViewer.addChild(msk);
				//
				_bmpViewer.img.setSize(Width , Height);
				_bmpViewer.img.source = bit;
				_bmpViewer.mask = msk;
				//
				_bmpViewer.addEventListener(Event.ADDED_TO_STAGE , onViewerAdded);
				_holder_mc.addChild(_bmpViewer);
			}
		}
		
		private function onFLVloadComplete(e:Event):void {
			if (_flvLoader == null) {
				return;
			}
			_flvLoader.removeEventListener(Event.COMPLETE , onFLVloadComplete);
			//;
			_flvViewer = new FlvAdvMc();
			// Set Mask Animations:
			var msk:MovieClip;
			if (_animCounter == 0) {
				msk = MenuUtil.getLibraryClip(31,Width,Height);
			}
			else if (_animCounter == 1) {
				msk = MenuUtil.getLibraryClip(31,Width,Height);
			}
			/*
			this.stage.dispatchEvent(new Event("advanceMaskAnimComplete")) --- Thrown 
			from the last frame of attached mask clips:  */
			this.stage.addEventListener("advanceMaskAnimComplete" ,  handleAdvanceAnimComplete);
			//
			_flvViewer.addChild(msk);		
			
			_flvViewer.vid.addEventListener(fl.video.VideoEvent.COMPLETE , onVideoComplete);
			_flvViewer.vid.setSize(Width , Height);
			_flvViewer.vid.source = _src;
			
			_flvViewer.mask = msk;
			_flvViewer.addEventListener(Event.ADDED_TO_STAGE , onViewerAdded);
			_holder_mc.addChild(_flvViewer);
		}
		private function onViewerAdded(e:Event):void{
			e.target.removeEventListener(Event.ADDED_TO_STAGE , onViewerAdded);
			//trace(e.target);
			if (_holder_mc.numChildren > 2) {
				//var mc:MovieClip = _holder_mc.getChildAt(1) as MovieClip;
				//_removeTween = TweenLite.to(mc , 2.2, {alpha:0, onComplete:OnRemoveTweenComplete});
			}
		}
		
		private function OnRemoveTweenComplete():void{
			/*if(_removeTween != null){
				_removeTween = null;
			}
			if (_holder_mc.numChildren > 2) {
				var mc:MovieClip = _holder_mc.getChildAt(1) as MovieClip;
				_holder_mc.removeChild(mc);
				mc = null;
			}*/
		}
		private function handleAdvanceAnimComplete(e:Event):void {
			this.stage.removeEventListener("advanceMaskAnimComplete" ,  handleAdvanceAnimComplete);
			if (_holder_mc.numChildren > 2) {
				var mc:MovieClip = _holder_mc.getChildAt(1) as MovieClip;
				_holder_mc.removeChild(mc);
				mc = null;
			}
			this.stage.dispatchEvent(new CustomMediaEvent(CustomMediaEvent.MEDIA_CHANGE, _itemRef,"",_col));
			//;
			var dur:Number;
			if (_time != null && _time != "") {
				dur = Number(_time);
			}
			else if (_time == null || _time == "") {
				dur = _defaultGap;
			}
			if (_gapTween != null) {
				_gapTween = null;
			}
			_gapTween = TweenLite.to(this,dur,{alpha:1,onComplete:onDurationComplete});
		}

		private function onDurationComplete():void {
			/*if (_holder_mc.numChildren > 2) {
				var mc:MovieClip = _holder_mc.getChildAt(1) as MovieClip;
				_holder_mc.removeChild(mc);
				mc = null;
			}*/
			//
			_mediaCntr++;
			if (_mediaCntr >= _mediaLength) {
				_mediaCntr = 0;
			}
			_animCounter++;
			if (_animCounter == _maxAnim) {
				_animCounter = 0;
			}

			// Next Animation is only possible when there is more than one media item to rotate 
			trace("length:  ",_mediaArr.length);
			if (_mediaArr.length > 1) {
				this.stage.dispatchEvent(new Event("HideMarketing"));
				check_bitmap_video();
			}
		}

		private function onVideoComplete(e:Event):void {
			//trace("Video End At Bottom Right Promo");
			if (_flvViewer != null) {
				_flvViewer.vid.play();
			}
		}

	}

}