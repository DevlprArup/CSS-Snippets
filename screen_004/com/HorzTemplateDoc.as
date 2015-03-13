package  com {
	import flash.display.*;
	import flash.events.*;
	import flash.system.*;
	//
	import com.greensock.*; 
	import com.greensock.easing.*;

	public class HorzTemplateDoc extends MovieClip{
		
		private var _xmlPath:String;
		private var _xmlReader:XML_Reader;
		
		private var _container:MovieClip;
		private var _containerHolder:MovieClip;
		private var _containerCover:MovieClip;
		
		private var _graphicHolder:MovieClip;
		
		//
		private var _layoutMngr:LayoutManager;
		
		

		public function HorzTemplateDoc() {
			// constructor code
			//fscommand("fullscreen", "true");
			//fscommand("allowscale", "false");
			//
			_containerCover = this.containerCover_mc;
			_containerHolder = this.containerHolder_mc;
			_graphicHolder = this.bgHolder_mc;
			//_graphicHolder.alpha = 0;
					
			// Check if Flash Vars has injected XML path ?
			if (LoaderInfo(this.root.loaderInfo).parameters.xml_file != null) {				
				var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
				_xmlPath = unescape(paramObj.xml_file.toString());				
			}else if (LoaderInfo(this.root.loaderInfo).parameters.xml_file == null){
				_xmlPath = "pollo004.xml";
			}
			
			// XML path as decided passed to the XML_Reader Class:
			_xmlReader = new XML_Reader();
			
			// After the XML is parsed, and Event will initiate the LayOutManager Class:
			_xmlReader.addEventListener(GDP.PARSE_COMPLETE , add_temp_container);
			
			// When the XML is changed and re saved - we cover the menu 
			_xmlReader.addEventListener(GDP.FADEIN_COVER , fadeInCover);
			
			_xmlReader.set_xml_path = _xmlPath;
		}
		private function add_temp_container(e:Event):void{
			//trace("lay_out_menu");
			_container = new ContainerMC();
			_container.addEventListener(Event.ADDED_TO_STAGE , containerAdded);
			_containerHolder.addChild(_container);			
		}
		private function containerAdded(e:Event):void{
			//trace("tempContainerAdded");
			_container.removeEventListener(Event.ADDED_TO_STAGE , containerAdded);
			this.stage.addEventListener(GDP.LAY_OUT_COMPLETE , handleLayOutComplete);
			_layoutMngr = new LayoutManager(_container , _graphicHolder);
		}

		private function handleLayOutComplete(e:Event):void{
			//trace("handleLayOutComplete");
			this.stage.removeEventListener(GDP.LAY_OUT_COMPLETE , handleLayOutComplete);
			TweenLite.to(_containerCover , 0.8 , {alpha:0 , onComplete:onCoverFadeOutComplete});			
		}
		
		private function onCoverFadeOutComplete():void{
			//trace("onCoverFadeOutComplete");
			this.stage.dispatchEvent(new Event(GDP.START_EFFECT));
		}
		private function fadeInCover(e:Event):void{
			//trace("fadeInCover");
			TweenLite.to(_containerCover , 0.4 , {alpha:1 , onComplete:onCoverFadeINComplete});
		}
		private function onCoverFadeINComplete():void{			
			_container.addEventListener(Event.REMOVED_FROM_STAGE , onContRemovedFromStage);
			_containerHolder.removeChild(_container);
		}
		private function onContRemovedFromStage(e:Event):void{
			_container.removeEventListener(Event.REMOVED_FROM_STAGE , onContRemovedFromStage);
			TweenLite.to(_container , 0.3 , {alpha:0 , onComplete:allowTimeToDelete});
		}
		private function allowTimeToDelete():void{
			//trace("allowTimeToDelete");
			_container = null;
			_xmlReader.dispatchEvent(new Event(GDP.RE_PARSE));
		}
		
		// GARBAGE COLLECTION:
		private function onMenuRemovedFromStage(e:Event):void{
			/*trace("Daily Removed");
			this.removeEventListener(Event.REMOVED_FROM_STAGE , onMenuRemovedFromStage);	
			_xmlReader.removeEventListener(GDP.PARSE_COMPLETE , lay_out_menu);
			_xmlReader.removeEventListener(GDP.FADEIN_COVER , fadeInCover);
			_container.removeEventListener(Event.ADDED_TO_STAGE , onContainerAddedToStage);
			this.stage.removeEventListener(GDP.LAY_OUT_COMPLETE , handleLayOutComplete);
			_xmlReader = null;
			_layoutMngr.destroyGarbage();
			_layoutMngr = null;
			//
			flash.system.System.gc();*/
		}

	}
	
}
