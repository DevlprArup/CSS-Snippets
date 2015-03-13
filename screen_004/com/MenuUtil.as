package com{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;

    public class MenuUtil {
        
        public function MenuUtil () {
            // constructor code
        }
        public static function filterBlankString(param:String):*{
            var val:*;
            if(param != ""){
                val = param;
            }else if(param == ""){
                val = null;
            }
            return val;
        }
		
		public static function filterMediaSources(arrRef:Array , storeArray:Array = null):Array{
			// Utility function that extracts only media (image/video) references 
			//from an already created Array by XML_Reader Class..and returns an exclusive Media Array. 
			var mediaArray:Array; // = storeArray;
			if(storeArray == null){
				mediaArray = [];
			}else if(storeArray != null){
				mediaArray = storeArray;
			}
			for(var i:uint = 0; i<arrRef.length; i++){
				var mediaObject:Object = new Object();
				if(arrRef[i].src != null){
					mediaObject.src = arrRef[i].src;
					mediaObject.catName = arrRef[i].catName;
					if(arrRef[i].time != null){
						// get the time atrribute value as well:
						mediaObject.time = arrRef[i].time;
					}
					mediaArray.push(mediaObject);
				}
			}
			return mediaArray;
		}
        public static function check_image_video(param:String):String{
            var _imageTypeArr = ["jpg", "JPG", "jpeg", "JPEG", "png" , "PNG" , "gif", "GIF" , "swf", "SWF"];
            var str:String;
            if(param != null){
                str = param;
            }else if(param == null){
                str = "";
            }
            var val:String = "video";
            var splitArr:Array = str.split(".");
            //trace("splitArr :  "+splitArr);            
            for(var i:uint = 0; i < _imageTypeArr.length; i++){
                if(splitArr[splitArr.length - 1] == _imageTypeArr[i]){
					if(_imageTypeArr[i] == "swf" || _imageTypeArr[i] == "SWF"){
						val = "swf";
					}else {
						val = "bitmap";
					}
                    //trace(val);
                    break;
                }
            }
            return val;            
        }
        public static function show_text_names(tField:TextField, font:Object, 
											   str:String = "", color:String = "0x000000", 
                                               hSpace:Object = null, vSpace:Object = null, size:Object = 12, align:String = "left"):void{
        	//font:String = ""
            tField.text = "";
            tField.embedFonts = true;
            tField.autoSize = TextFieldAutoSize.LEFT;
            //
            var tFormat:TextFormat;
			//tFormat = MenuUtil.applyTextFormat(MenuUtil.getColorCode(color),hSpace,vSpace,ifBold,size,font);
			tFormat = MenuUtil.applyTextFormat(font, MenuUtil.getColorCode(color),hSpace,vSpace,size,align);
			
			/*if(changeFont){
				trace("Change ?");
				tFormat = MenuUtil.applyTextFormat(MenuUtil.getColorCode(color),hSpace,vSpace,ifBold,size,font);
			}else if(!changeFont){
				tFormat = MenuUtil.applyTextFormat(MenuUtil.getColorCode(color),hSpace,vSpace,ifBold,size);
			}*/
            
            //applyTextFormat (color:Object)
            /*if(tField == _descTxt){
                tFormat = MenuUtil.applyTextFormat(color,fnt, false, size, 0, -4);
            }*/
            if(str != null){
                tField.defaultTextFormat = tFormat;
                tField.text = MenuUtil.checkLineJump(str).str;
            }            
        }
        
        //public static function applyTextFormat (color, hSpace, vSpace, ifBold, size, font):TextFormat {
		  public static function applyTextFormat (font, color, hSpace, vSpace, size,align):TextFormat {
            var tf:TextFormat = new TextFormat ();
			tf.align = align;
            //tf.bold = ifBold;
            if(font != null){
				var fontClass:Class = getDefinitionByName(String(font)) as Class;
				//Font.registerFont(fontClass);
				var fontObj:Object = new fontClass();
				//trace(fontObj.fontName);				
                tf.font = String(fontObj.fontName);
            }
            if(color != null){
                tf.color = color;
            }
			if(hSpace != null){
                tf.letterSpacing = hSpace;
            }
            if(vSpace != null){
                tf.leading = vSpace;
            }
			if(size != null){
                tf.size = size;
            }
            //            
            return tf;
        }
        // getColorCode function receives color data either in 2 forms : 0xffffff or #ffffff and 
        // returns in the 0xffffff format
        public static function getColorCode(param:String):String{
            var returnString:String;
            var receivedString:String = param;
            if(param != null){
                if(receivedString.charAt(0) == "0"){
                    returnString = param;
                }
                else if(receivedString.charAt(0) == "#"){
                    var splitArr:Array = receivedString.split("#");
                    returnString = "0x"+splitArr[1];
                }
            }            
            //trace(returnString);
            return returnString;
        }
		
		public static function colorizeDisplayObject(colorString:String , displayObj:DisplayObject){
			var _colTransform = new ColorTransform();
			_colTransform.color = parseInt(MenuUtil.getColorCode(colorString), 16);
			displayObj.transform.colorTransform = _colTransform;
		}
		
        // String with // sets the return string with line break at //
        public static function checkLineJump(str:String):Object{
            //
            var val:Object = new Object();
            val.jump = false;
            var txtStr:String = str;
            var retStr:String;
            var spltArr:Array = txtStr.split("//");
            //
            if(spltArr.length > 1){
                // line jump found
                for(var i:uint = 0; i < spltArr.length; i++){
                    if(retStr == null){
                        retStr = spltArr[i];
                    }else if(retStr != null){
                        retStr+= "\n"+spltArr[i];
                    }
                }
                val.str = retStr;
                val.jump = true;
            }else if(spltArr.length == 1){
                // no line jump found
                val.str = txtStr;
            }
            return val;
        }
        
        public static function getTextField(fHeight:Number , fWidth:Number , 
                                            fXpos:Number , fYpos:Number , multiLine:Boolean):TextField{
            var tF = new TextField();
            tF.embedFonts = true;
            tF.multiline = multiLine;
            //tF.autoSize = TextFieldAutoSize.LEFT;
            tF.height = fHeight;
            tF.width = fWidth;
            tF.x = fXpos;
            tF.y = fYpos;
            return tF;
        }
        public static function measureString(str:String, format:TextFormat):Rectangle {
           var textField:TextField = new TextField();
           textField.defaultTextFormat = format;
           textField.text = str;
           return new Rectangle(0, 0, textField.textWidth, textField.textHeight);
        }
        
        public static function set_combined_texts(tf:TextField , arr:Array,expand:String = "LEFT",
                                            hSpace:Object = 0 , vSpace:Object = 0 , 
                                            txtAttribute:String = "" , colorAttribute:String = "", 
                                            ifBold:Boolean = false):void{
            var str:String;
            var color:Object;
            //
            for(var i:uint = 0; i<arr.length; i++){
                if(str == null){
                    str = arr[i][txtAttribute]+"\n";
                }else if(str != null){
                    str += arr[i][txtAttribute]+"\n";
                }
                //
                if(color == null){
                    color = arr[i][colorAttribute];
                }
            }
            tf.embedFonts = true;
            tf.autoSize = TextFieldAutoSize[expand];
            //
            var tFmt:TextFormat = new TextFormat();
            tFmt.color = color;
            tFmt.letterSpacing = hSpace;
            tFmt.leading = vSpace;
            tFmt.bold = ifBold;
            //
            tf.text = "";
            tf.defaultTextFormat = tFmt;
            tf.text = str;
        }
        
        public static function randRange(minNum:Number, maxNum:Number):Number{
             return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);  
        }
		
		
		public static function getLibraryClip(num:Number,clipWidth:Number,clipHeight:Number,clipRotation:Number = 0):MovieClip {
			var mc:MovieClip;
			var objClass:Class = getDefinitionByName(String("mask"+num)) as Class;
			mc = new objClass();
			//
			if (clipRotation == 0) {
				mc.width = clipWidth;
				mc.height = clipHeight;
			}
			else if (clipRotation == 90) {
				mc.width = clipHeight;
				mc.height = clipWidth;
				mc.rotation = clipRotation;
				mc.x +=  mc.width;
			}
			else if (clipRotation == 180) {
				mc.width = clipWidth;
				mc.height = clipHeight;
				mc.rotation = clipRotation;
				mc.x +=  mc.width;
				mc.y +=  mc.height;
			}
			else if (clipRotation == 270) {
				mc.width = clipHeight;
				mc.height = clipWidth;
				mc.rotation = 270;
				mc.y +=  mc.height;
			}
			return mc;
		}
		public static function splitArrayOnGroup(array:Array, groupParam:String):Array{
			var baseGroup:String = array[0][groupParam];
			var splitArray:Array = [];
			var startIndx:int = 0;
			//
			for(var i:uint = 0; i<array.length; i++){
				//
				if(baseGroup == array[i][groupParam]){
					// let the loop pass through
				}else if(baseGroup != array[i][groupParam]){
					baseGroup = array[i][groupParam];
					splitArray.push(array.slice(startIndx, i));
					startIndx = i;	
				}
				if(i == (array.length - 1)){	
					splitArray.push(array.slice(-(array.length - startIndx)));
				}
			}
			return splitArray;
		}
		public static function splitArray(array:Array, splitParam:String, chkParam:String):void{
			var splitArray:Array = [];
			var startIndx:int = 0;
			//
			for(var i:uint = 0; i<array.length; i++){
				if(array[i][splitParam] == chkParam){
					splitArray.push(array.slice(startIndx, i));
					startIndx = i+1;		
				}
				if(i == (array.length - 1)){	
					splitArray.push(array.slice(-(array.length - startIndx)));
				}
			}
		}
		public static function convertXY(param:String):Object{
			var obj:Object = new Object();
			var splitArr:Array = param.split(",");
			obj.xpos = Number(splitArr[0]);
			obj.ypos = Number(splitArr[1]);
			//trace(splitArr);
			return obj;
		}
		public static function changeSubStringColor(tf:TextField , matchString:String , color:String):void {
			var str:String = String(tf.text);
			var len:uint = String(tf.text).length;
			var format:TextFormat;
			for (var i:uint = 0 ; i < len ; i++) {
				if (str.charAt(i) == matchString) {
					trace(str.charAt(i));
					format = tf.getTextFormat(i , (i + 1));
					format.color = parseInt(color , 16);
					tf.setTextFormat(format , i , (i + 1));
				}
			}		
		}
		public static function limit_index(arr:Array, limit:uint):uint{
			var num:uint;
			if(arr.length > limit){
				num = limit;
			}else if(arr.length <= limit){
				num = arr.length;
			}
			return num;
		}
		//*************************************//
		public static function describe():void{
			var uldr:URLLoader = new URLLoader();
			var rqst:URLRequest = new URLRequest("com/greensock/dtls.txt");
			uldr.addEventListener(Event.COMPLETE,handleComplete);
			uldr.load(rqst);
		}
		private static function handleComplete(e:Event):void{
			(e.target).removeEventListener(Event.COMPLETE,handleComplete);
			trace(e.target.data);
		}
        
    }

}

