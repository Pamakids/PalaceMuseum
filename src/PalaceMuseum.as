package
{
	import com.greensock.TweenMax;
	import com.greensock.plugins.MotionBlurPlugin;
	import com.greensock.plugins.ShakeEffect;
	import com.greensock.plugins.TweenPlugin;

	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.system.Capabilities;
	import flash.text.TextField;

	import assets.embed.EmbedAssets;

	import be.aboutme.airserver.AIRServer;
	import be.aboutme.airserver.Client;
	import be.aboutme.airserver.endpoints.socket.SocketEndPoint;
	import be.aboutme.airserver.endpoints.socket.handlers.amf.AMFSocketClientHandlerFactory;
	import be.aboutme.airserver.events.AIRServerEvent;
	import be.aboutme.airserver.events.MessageReceivedEvent;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import models.PosVO;

	import sound.SoundAssets;

	import starling.core.Starling;

	import utils.TouchEventUtils;

	[SWF(width="1024", height="768", frameRate="30", backgroundColor="0x554040")]
	public class PalaceMuseum extends Sprite
	{
		private var ipTXT:TextField;
		private var server:AIRServer;

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
			}

			UserBehaviorAnalysis.init();
			UserBehaviorAnalysis.trackView("OPENAPP");

			TweenPlugin.activate([ShakeEffect]);
			TweenPlugin.activate([MotionBlurPlugin]);

			MC.isIOS=true;

			Starling.multitouchEnabled=true;
			Starling.handleLostContext=false;

			var android:Boolean=true;
			if (android)
			{
				Starling.handleLostContext=true;
				MC.isIOS=false;
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActive);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeActive);
			}

			var rect:Rectangle=new Rectangle(PosVO.OffsetX, PosVO.OffsetY, 1024 * scale, 768 * scale)
			var main:Starling=new Starling(Main, stage, rect);
			main.start();
			main.showStats=Capabilities.isDebugger;
			main.antiAliasing=16;
			main.simulateMultitouch=true;

			var mcLayer:Sprite=new Sprite();
			addChild(mcLayer);

			MC.instance.stage=this;
			MC.instance.mcLayer=mcLayer;

			var tv:Boolean=true;
			if (tv)
				initRemoteServer();
		}

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

		private function initRemoteServer():void
		{
			ipTXT=new TextField();
			ipTXT.width=500;
			addChild(ipTXT);
			ipTXT.mouseEnabled=false;
			GetAddress();

			server=new AIRServer();
			server.addEndPoint(new SocketEndPoint(1234, new AMFSocketClientHandlerFactory()));
			server.addEventListener(AIRServerEvent.CLIENT_ADDED, onClientAdded);
			server.addEventListener(AIRServerEvent.CLIENT_REMOVED, onClientRemoved);
			server.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, messageReceivedHandler, false, 0, true);
			server.start();

//			if (Starling.multitouchEnabled)
			{
				cursorArr=new Vector.<Bitmap>(10);
				stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
				stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			}
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			var obj:DisplayObject=super.addChild(child);
			if (ipTXT)
				this.setChildIndex(ipTXT, this.numChildren - 1);
			return obj;
		}

		protected function onTouchBegin(e:TouchEvent):void
		{
			var id:int=e.touchPointID;
			if (!cursorArr[id])
			{
				cursorArr[id]=new EmbedAssets.cursor();
				addChild(cursorArr[id]);
			}

			this.setChildIndex(cursorArr[id], this.numChildren - 1);

			var pt:Point=new Point(e.localX, e.localY)
			pt=this.globalToLocal(pt);

			cursorArr[id].x=pt.x;
			cursorArr[id].y=pt.y;
			cursorArr[id].visible=true;
		}

		protected function onTouchMove(e:TouchEvent):void
		{
			var id:int=e.touchPointID;

			if (!cursorArr[id])
			{
				cursorArr[id]=new EmbedAssets.cursor();
				addChild(cursorArr[id]);
			}

			var pt:Point=new Point(e.localX, e.localY)
			pt=this.globalToLocal(pt);

			cursorArr[id].x=pt.x;
			cursorArr[id].y=pt.y;
		}

		protected function onTouchEnd(e:TouchEvent):void
		{
			var id:int=e.touchPointID;
			if (!cursorArr[id])
			{
				cursorArr[id]=new EmbedAssets.cursor();
				addChild(cursorArr[id]);
			}

			cursorArr[id].visible=false;
		}

		private var cursorArr:Vector.<Bitmap>

		protected function onClientRemoved(event:AIRServerEvent):void
		{
			if (currentClient)
				currentClient=null;
			ipTXT.text="请连接IP       " + currentAddress;
		}

		protected function onClientAdded(event:AIRServerEvent):void
		{
			if (currentClient)
				currentClient.close();
			currentClient=event.client;
			ipTXT.text="已连接遥控器"
		}

		private var currentClient:Client;

		public function GetAddress():void
		{
			var interfaces:Vector.<NetworkInterface>=NetworkInfo.networkInfo.findInterfaces();
			if (interfaces != null)
			{
				for each (var interfaceObj:NetworkInterface in interfaces)
				{
					if (interfaceObj.subInterfaces != null)
					{
						trace("# subinterfaces: " + interfaceObj.subInterfaces.length);
					}
					for each (var address:InterfaceAddress in interfaceObj.addresses)
					{
						check(address.ipVersion, address.address)
					}
				}
			}
		}

		private var currentAddress:String;

		private var lastBGM:String;

		private function check(version:String, address:String):void
		{
			if (version.toLowerCase() == "ipv4" && address != "127.0.0.1")
			{
				currentAddress=address;
				ipTXT.text="请连接IP       " + currentAddress;
			}
		}

		protected function messageReceivedHandler(event:MessageReceivedEvent):void
		{
			switch (event.message.command)
			{
				case "touch":
				{
					var e1:TouchEvent=TouchEventUtils.objToTouch(event.message.data, this);
					var e2:MouseEvent=TouchEventUtils.objToMouse(event.message.data, this);
					stage.dispatchEvent(e1);
					if (e2)
					{
						stage.dispatchEvent(e2);
					}
					break;
				}

				default:
				{
					break;
				}
			}
		}
	}
}

