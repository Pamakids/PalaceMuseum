package views
{
	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.StageVideo;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	import flash.utils.getTimer;

	import models.PosVO;

	import sound.SoundAssets;

	import starling.core.Starling;

	/**
	 * 引子
	 * @author Administrator
	 */
	public class Interlude extends Sprite
	{
		[Embed(source="../assets/video/pass.png")]
		private static const BtnSkin:Class;

		[Embed(source="../assets/video/bg.png")]
		private static const BG:Class;

//		private var videoURL:String;
//		private var stream:NetStream;
//		private var stageVideo:StageVideo;
//		private var video:Video;
//		private var connection:NetConnection;
		private var button:Sprite;

		private var startHandler:Function;
		private var stopHandler:Function;
		private var passable:Boolean

		/**
		 * 过场动画：引子/结尾
		 * @param videoURL		视频路径
		 * @param passable		是否存在跳过按钮
		 * @param onStart		视频开始时回调
		 * @param onStop		视频结束时回调
		 */
		public function Interlude(_index:int, passable:Boolean=true, onStart:Function=null, onStop:Function=null)
		{
			this.index=_index;
//			this.videoURL=videoURL;
			this.passable=passable;
			this.startHandler=onStart;
			this.stopHandler=onStop;
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);

//			this.scaleX=this.scaleY=PosVO.scale;
//			this.x=PosVO.OffsetX;
//			this.y=PosVO.OffsetY;
		}

		private var arr:Array=[IntroMC,EndMC];
		private var arr2:Array=[introSnd,endSnd];

		[Embed(source="end.mp3")]
		private static var endSnd:Class;

		[Embed(source="intro.mp3")]
		private static var introSnd:Class;

		private var mc:MovieClip;
		private var snd:Sound;
		private var sndC:SoundChannel;

		private var index:int=0;

		private var shape:Shape;

		private function onAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);

			lastBGM=SoundAssets.crtBGM;
			SoundAssets.stopBGM(true);

			Starling.current.stage3D.visible=false;
			Starling.current.stage.touchable=false;
			initialize();
			if (Capabilities.isDebugger)
			{
//				stage.addEventListener(MouseEvent.CLICK, onStage);
			}
		}

		private function onStage(e:MouseEvent):void
		{
			dispose();
		}

		private function initialize():void
		{
			initBG();
			initShape();
			initButton();

			stage.frameRate=24;
			mc=new arr[index]();
			mc.x=123; 
			mc.y=86;
//			mc.scaleX=mc.scaleY=PosVO.scale;
			addChildAt(mc,0);
			mc.addEventListener(Event.FRAME_CONSTRUCTED,onPlay);
			snd=new arr2[index]();
			sndC=snd.play();

			TweenLite.to(shape, 1.5, {alpha: 0, onComplete: function():void {
				shape.graphics.clear();
				removeChild(shape);
				shape=null;
			}});

			if (startHandler)
				startHandler();
			if (passable)
			{
//				start=getTimer();
//				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				TweenLite.delayedCall(seconds,showSkip);
			}

//			initConnection();
		} 

		private function showSkip():void{
			button.visible=true;
		}

		protected function onPlay(event:Event):void
		{
			if(!mc)
				return ;
			if(mc.currentFrame==mc.totalFrames)
				dispose();
		}

		private function initBG():void
		{
			var bg:Bitmap=new BG();
			this.addChild(bg);
		}

		private function initShape():void
		{
			shape=new Shape();
			this.addChild(shape);
			shape.graphics.beginFill(0);
			shape.graphics.drawRect(0, 0, 1024,768);
			shape.graphics.endFill();
		}

		private function initButton():void
		{
			if (passable)
			{
				const gap:int=20;
				const bitmap:Bitmap=new BtnSkin();
				button=new Sprite();
				button.x=839
				button.y=673
				button.addChild(bitmap);
				this.addChild(button);
				button.visible=false;
				button.addEventListener(TouchEvent.TOUCH_BEGIN, passHandler);
				button.addEventListener(MouseEvent.CLICK, passHandler);
			}
		}

		//跳过
		protected function passHandler(event:Event):void
		{
			this.dispose();
		}

//		private function initConnection():void
//		{
//			connection=new NetConnection();
//			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
//			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
//			connection.connect(null);
//		}

		protected function securityErrorHandler(event:SecurityErrorEvent):void
		{
			trace("securityErrorHandler: " + event);
		}

//		protected function netStatusHandler(e:NetStatusEvent):void
//		{
//			switch (e.info.code)
//			{
//				case "NetConnection.Connect.Success":
//					connectStream();
//					break;
//				case "NetStream.Play.StreamNotFound":
//					trace("Unable to locate video: " + videoURL);
//					break;
//				case "NetStream.Play.Start":
//					trace("NetStream.Play.Start");
//					TweenLite.to(shape, 1.5, {alpha: 0, onComplete: function():void {
//						shape.graphics.clear();
//						removeChild(shape);
//						shape=null;
//					}});
//					if (startHandler)
//						startHandler();
//					if (passable)
//					{
//						start=getTimer();
//						this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//					}
//					break;
//				case "NetStream.Play.Stop":
//					trace("NetStream.Play.Stop");
//					dispose();
//					break;
//			}
//		}

//		private var start:uint;
		private const seconds:uint=8;
		private var lastBGM:String;

//		private function onEnterFrame(e:Event):void
//		{
//			if (getTimer() - start >= seconds * 1000)
//			{
//				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
//				button.visible=true;
//			}
//		}

//		private function connectStream():void
//		{
//			stream=new NetStream(connection);
//			stream.client={
//					onMetaData: onMetaData
//				};
//			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
//			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
//
//			stageVideo=stage.stageVideos[0];
//
//			var sc:Number=PosVO.scale;
//			stageVideo.viewPort=new Rectangle(123 * sc + PosVO.OffsetX, 86 * sc + PosVO.OffsetY, 704 * sc, 528 * sc);
//			stageVideo.attachNetStream(stream);
//			stream.play(videoURL);
//		}

		private function onMetaData(_obj:Object):void
		{
			if (_obj.duration)
				trace(_obj.duration);
		}


		protected function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			trace("asyncError");
		}


		public function dispose():void
		{
			if (!stage)
				return;

			if (lastBGM)
				SoundAssets.playBGM(lastBGM);
			lastBGM="";

			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStage);
			Starling.current.stage3D.visible=true;
			Starling.current.stage.touchable=true;
			TweenLite.killTweensOf(shape);
//			if (connection)
//			{
//				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
//				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
//				connection.close();
//				connection=null
//			}
//			if (stream)
//			{
//				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
//				stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
//				stream.pause();
//				stream.close();
//				stream=null;
//			}
//			if (stageVideo)
//			{
//				stageVideo.viewPort=new Rectangle(0, 0, 0, 0);
//				stageVideo=null;
//			}
//			if (video)
//			{
//				this.removeChild(video);
//				video.clear();
//				video=null;
//			}
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);

			if(mc)
			{
				mc.removeEventListener(Event.FRAME_CONSTRUCTED,onPlay);
				mc.stop();
				this.removeChild(mc);
			}
			mc=null;
			snd=null;
			if(sndC)
			{
				sndC.stop();
			}
			sndC=null;

			stage.frameRate=30;

			if (stopHandler)
				stopHandler();
			this.startHandler=null;
			this.stopHandler=null;
			if (parent)
				parent.removeChild(this);
		}
	}
}


