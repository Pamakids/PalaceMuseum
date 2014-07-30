package
{
	import com.greensock.TweenMax;
	import com.greensock.plugins.MotionBlurPlugin;
	import com.greensock.plugins.ShakeEffect;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.FullFillBG;

	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	import assets.embed.EmbedAssets;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import models.PosVO;

	import sound.SoundAssets;

	import starling.core.Starling;

	import views.components.share.ShareView;
	import views.logo.GG_Logo;

//	import utils.TouchEventUtils;

	[SWF(width="1024", height="768", frameRate="30", backgroundColor="0x351016")]
	public class PalaceMuseum extends Sprite
	{
//		private var ipTXT:TextField;
//		private var server:AIRServer;

		public function PalaceMuseum()
		{
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;

			PosVO.init(stage.fullScreenWidth, stage.fullScreenHeight);

			var scale:Number=PosVO.scale;
			this.scaleX=this.scaleY=scale;
			this.x=PosVO.OffsetX;
			this.y=PosVO.OffsetY;

			var isFit:Boolean=PosVO.OffsetX == 0 && PosVO.OffsetY == 0

			if (!isFit)
			{
				var msk:Shape=new Shape();
				addChild(msk);
				msk.graphics.beginFill(0);
				msk.graphics.drawRect(0, 0, 1024, 768)
				mask=msk;

				stage.addChildAt(new FullFillBG(),0);
			}

			UserBehaviorAnalysis.init();
			UserBehaviorAnalysis.trackView("OPENAPP");

			ShareView.instance.init(this);

			TweenPlugin.activate([ShakeEffect]);
			TweenPlugin.activate([MotionBlurPlugin]);

			initLogo();

//			var tv:Boolean=false;
//			if (tv)
//				initTVRemoter();
//			initRemoteServer();
		}

		private function initLogo():void
		{
			if(logo)
			{
				removeChild(logo);
				logo.dispose();
				logo=null;
			}
			logo=new GG_Logo(initStarling);
			addChild(logo);
		}

		private var logo:GG_Logo;

		private function initStarling():void
		{
			removeChild(logo);
			logo.dispose();
			logo=null;

			Starling.multitouchEnabled=true;

			var android:Boolean=false;
			if (android)
			{
				Starling.handleLostContext=true;
				MC.isIOS=false;
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActive);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeActive);
			}else{
				Starling.handleLostContext=false;
				MC.isIOS=true;
			}

			var rect:Rectangle=new Rectangle(PosVO.OffsetX, PosVO.OffsetY, 1024 * PosVO.scale, 768 * PosVO.scale)
			var main:Starling=new Starling(Main, stage, rect);
			main.start();
			main.showStats=Capabilities.isDebugger;
			main.antiAliasing=1;
			main.simulateMultitouch=true;

			var mcLayer:Sprite=new Sprite();
			addChild(mcLayer);

			MC.instance.stage=this;
			MC.instance.mcLayer=mcLayer;
		}

//		private function initTVRemoter():void
//		{
//			cursor=new EmbedAssets.cursor();
//			addChild(cursor);
//			cursor.x=512;
//			cursor.y=384;
//			addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
//			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
//		}

//		private var mouseDirection:int=-1;
//		private var cursor:Bitmap;

//		protected function onEnterFrame(e:Event):void
//		{
//			if (mouseDirection >= 0)
//			{
//				cursor.x+=mouseDirection % 2 == 0 ? (mouseDirection - 1) * 15 : 0;
//				cursor.y+=mouseDirection % 2 == 0 ? 0 : (mouseDirection - 2) * 15;
//			}
//
//			if (cursor.x < 0)
//				cursor.x=0;
//			else if (cursor.x > 1024)
//				cursor.x=1024;
//
//			if (cursor.y < 0)
//				cursor.y=0;
//			else if (cursor.y > 768)
//				cursor.y=768;
//		}

//		protected function onKeyDown(e:KeyboardEvent):void
//		{
//			switch (e.keyCode)
//			{
//				case MiTVKeyCode.LEFT: //37
//				case MiTVKeyCode.UP: //38
//				case MiTVKeyCode.RIGHT: //39 
//				case MiTVKeyCode.DOWN: //40
//					mouseDirection=e.keyCode - MiTVKeyCode.LEFT;
//					break;
//
//				case MiTVKeyCode.OK: //13
//				{
//					remoteMouse(true);
//					break;
//				}
//
//				default:
//				{
//					break;
//				}
//			}
//		}

		private var clickHint:Bitmap;
		public var hintShowed:Boolean;

		public function addClickHint():void
		{
			if(hintShowed)
				return;
			if(clickHint&&this.contains(clickHint))
			{
				removeChild(clickHint);
				clickHint=null;
			}
			clickHint = new EmbedAssets.lionClick();
			addChild(clickHint);
			clickHint.x=218;
			clickHint.y=678;

		}

		public function removeClickHint():void
		{
			hintShowed=true;
			if(clickHint&&this.contains(clickHint))
			{
				removeChild(clickHint);
			}
		}

//		private function remoteMouse(down:Boolean):void
//		{
//			var pt:Point=new Point(cursor.x, cursor.y);
//			var o:Object={type: down ? TouchEvent.TOUCH_BEGIN : TouchEvent.TOUCH_END, x: pt.x, y: pt.y, id: 0}
////			var e1:TouchEvent=TouchEventUtils.objToTouch(o, this);
////			var e2:MouseEvent=TouchEventUtils.objToMouse(o, this);
//			stage.dispatchEvent(e1);
//			if (e2)
//			{
//				stage.dispatchEvent(e2);
//			}
//
//		}

//		protected function onKeyUp(e:KeyboardEvent):void
//		{
//			switch (e.keyCode)
//			{
//				case MiTVKeyCode.LEFT: //37
//				case MiTVKeyCode.UP: //38
//				case MiTVKeyCode.RIGHT: //39
//				case MiTVKeyCode.DOWN: //40
//					mouseDirection=-1;
//					break;
//
//				case MiTVKeyCode.OK: //13
//				{
//					remoteMouse(false);
//					break;
//				}
//
//				default:
//				{
//					break;
//				}
//			}
//		}

		protected function onActive(event:Event):void
		{
			if (lastBGM)
				SoundAssets.playBGM(lastBGM);
			lastBGM="";
			TweenMax.resumeAll();
		}

		protected function onDeActive(event:Event):void
		{
			lastBGM=SoundAssets.crtBGM;
			SoundAssets.stopBGM(true);
			TweenMax.pauseAll();
		}

//		private function initRemoteServer():void
//		{
//			ipTXT=new TextField();
//			ipTXT.width=500;
//			addChild(ipTXT);
//			ipTXT.mouseEnabled=false;
//			GetAddress();
//
//			server=new AIRServer();
//			server.addEndPoint(new SocketEndPoint(1234, new AMFSocketClientHandlerFactory()));
//			server.addEventListener(AIRServerEvent.CLIENT_ADDED, onClientAdded);
//			server.addEventListener(AIRServerEvent.CLIENT_REMOVED, onClientRemoved);
//			server.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, messageReceivedHandler, false, 0, true);
//			server.start();
//
////			if (Starling.multitouchEnabled)
//			{
//				cursorArr=new Vector.<Bitmap>(10);
//				stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
//				stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
//				stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
//			}
//		}

//		override public function addChild(child:DisplayObject):DisplayObject
//		{
//			var obj:DisplayObject=super.addChild(child);
//			if (ipTXT)
//				this.setChildIndex(ipTXT, this.numChildren - 1);
//			return obj;
//		}

//		protected function onTouchBegin(e:TouchEvent):void
//		{
//			var id:int=e.touchPointID;
//			if (!cursorArr[id])
//			{
//				cursorArr[id]=new EmbedAssets.cursor();
//				addChild(cursorArr[id]);
//			}
//
//			this.setChildIndex(cursorArr[id], this.numChildren - 1);
//
//			var pt:Point=new Point(e.localX, e.localY)
//			pt=this.globalToLocal(pt);
//
//			cursorArr[id].x=pt.x;
//			cursorArr[id].y=pt.y;
//			cursorArr[id].visible=true;
//		}
//
//		protected function onTouchMove(e:TouchEvent):void
//		{
//			var id:int=e.touchPointID;
//
//			if (!cursorArr[id])
//			{
//				cursorArr[id]=new EmbedAssets.cursor();
//				addChild(cursorArr[id]);
//			}
//
//			var pt:Point=new Point(e.localX, e.localY)
//			pt=this.globalToLocal(pt);
//
//			cursorArr[id].x=pt.x;
//			cursorArr[id].y=pt.y;
//		}
//
//		protected function onTouchEnd(e:TouchEvent):void
//		{
//			var id:int=e.touchPointID;
//			if (!cursorArr[id])
//			{
//				cursorArr[id]=new EmbedAssets.cursor();
//				addChild(cursorArr[id]);
//			}
//
//			cursorArr[id].visible=false;
//		}

//		private var cursorArr:Vector.<Bitmap>

//		protected function onClientRemoved(event:AIRServerEvent):void
//		{
//			if (currentClient)
//				currentClient=null;
//			ipTXT.text="请连接IP       " + currentAddress;
//		}
//
//		protected function onClientAdded(event:AIRServerEvent):void
//		{
//			if (currentClient)
//				currentClient.close();
//			currentClient=event.client;
//			ipTXT.text="已连接遥控器"
//		}
//
//		private var currentClient:Client;

//		public function GetAddress():void
//		{
//			var interfaces:Vector.<NetworkInterface>=NetworkInfo.networkInfo.findInterfaces();
//			if (interfaces != null)
//			{
//				for each (var interfaceObj:NetworkInterface in interfaces)
//				{
//					if (interfaceObj.subInterfaces != null)
//					{
//						trace("# subinterfaces: " + interfaceObj.subInterfaces.length);
//					}
//					for each (var address:InterfaceAddress in interfaceObj.addresses)
//					{
//						check(address.ipVersion, address.address)
//					}
//				}
//			}
//		}

//		private var currentAddress:String;

		private var lastBGM:String;

//		private function check(version:String, address:String):void
//		{
//			if (version.toLowerCase() == "ipv4" && address != "127.0.0.1")
//			{
//				currentAddress=address;
//				ipTXT.text="请连接IP       " + currentAddress;
//			}
//		}

//		protected function messageReceivedHandler(event:MessageReceivedEvent):void
//		{
//			switch (event.message.command)
//			{
//				case "touch":
//				{
//					var arr:Array=event.message.data;
//					for each (var o:Object in arr)
//					{
//						var e1:TouchEvent=TouchEventUtils.objToTouch(o, this);
//						var e2:MouseEvent=TouchEventUtils.objToMouse(o, this);
//						stage.dispatchEvent(e1);
//						if (e2)
//						{
//							stage.dispatchEvent(e2);
//						}
//					}
//					break;
//				}
//
//				default:
//				{
//					break;
//				}
//			}
//		}
	}
}

