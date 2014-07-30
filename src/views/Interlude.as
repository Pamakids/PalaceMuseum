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
	import flash.events.SecurityErrorEvent;
	import flash.events.TouchEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.getClassByAlias;
	import flash.system.Capabilities;

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

		private var crtMCArr:Array;

		private var mcArr1:Array=[IntroPart1,IntroPart2,IntroPart3,IntroPart4,IntroPart5,
								  IntroPart6,IntroPart7,IntroPart8,IntroPart9,IntroPart10,
								  IntroPart11,IntroPart12,IntroPart13,IntroPart14,IntroPart15];


		private var cutArr1:Array=[0,9,17,20.5,24.5,
								   30,35,39,43,47,
								   53,60,65,72,77,
								   82];

		private var mcArr2:Array=[EndPart1,EndPart2,EndPart3,EndPart4,EndPart5];
		private var cutArr2:Array=[0,5,13,22,29,38];
//		private var gapArr:Array;

//		private var cutArr2:Array=[9,17,20,	24,	30,35,39,43,
//								   47, 53,60, 65, 72, 77];

		private var sndArr:Array=[introSnd,endSnd];

		[Embed(source="end.mp3")]
		private static var endSnd:Class;

		[Embed(source="intro.mp3")]
		private static var introSnd:Class;

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

		private var crtCutArr:Array;

		private function onStage(e:MouseEvent):void
		{
			dispose();
		}

		private function initialize():void
		{
//			var os:String=Capabilities.os;
//			if(os.toLowerCase().indexOf('iphone')>=0)
//			{
//				var version:String=os.charAt(10);
//				if(Number(version)<7)
//				{
//					needBG=false;
//				}
//			}

			if(index==0)
			{
				crtMCArr=mcArr1;
				crtCutArr=cutArr1;
			}else
			{
				crtMCArr=mcArr2;
				crtCutArr=cutArr2;
			}

//			if(needBG)
			initBG();
			initShape();
			initButton();

			stage.frameRate=24;
			mcHolder=new Sprite();
			mcHolder.x=123; 
			mcHolder.y=86;

			addChildAt(mcHolder,0);

			step=0;
			startPlayMC();

			snd=new sndArr[index]();
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
				TweenLite.delayedCall(seconds,showSkip);
			}
		} 

		private function startPlayMC():void
		{
			var nexttime:Number=crtCutArr[step+1]-crtCutArr[step];
			if(step<crtMCArr.length){

				if(preMC)
				{
					TweenLite.to(preMC,.5,{alpha:0,onComplete:switchMC});
				}

				crtMC=new crtMCArr[step]();
				crtMC.alpha=0;
				TweenLite.to(crtMC,.5,{alpha:1});
				mcHolder.addChild(crtMC);
				crtMC.play();
				crtMC.addEventListener(Event.FRAME_CONSTRUCTED,onPlay);
				TweenLite.delayedCall(nexttime,startPlayMC);
				step++;
			}else
			{
				TweenLite.delayedCall(nexttime,dispose);
			}
		}

		private var preMC:MovieClip;
		private var crtMC:MovieClip;

		private function switchMC():void
		{
			if(preMC)
			{
				preMC.stop();
				preMC.removeEventListener(Event.FRAME_CONSTRUCTED,onPlay);
				mcHolder.removeChild(preMC);
				preMC=null;
			}

			if(crtMC)
			{
				preMC=crtMC;
				crtMC=null;
			}
		}

		private function showSkip():void
		{
			button.visible=true;
		}

		protected function onPlay(event:Event):void
		{
			var mc:MovieClip=event.currentTarget as MovieClip;
			if(!mc)
				return ;
			if(mc.currentFrame==mc.totalFrames)
				mc.stop();
		}

		private function initBG():void
		{
			var bg:Bitmap=new BG();
			this.addChild(bg);
			bg.cacheAsBitmap=true;
		}

		private function initShape():void
		{
			shape=new Shape();
			this.addChild(shape);
			shape.graphics.beginFill(0);
			shape.graphics.drawRect(0, 0, 1024,768);
			shape.graphics.endFill();
			shape.cacheAsBitmap=true;
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
				button.cacheAsBitmap=true;
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
//		private var needBG:Boolean=true;

		private var mcHolder:Sprite;

		private var step:int;

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

//			if(mc)
//			{
//				mc.removeEventListener(Event.FRAME_CONSTRUCTED,onPlay);
//				mc.stop();
//				this.removeChild(mc);
//			}
//			mc=null;

			if(preMC)
			{
				preMC.stop();
				preMC.removeEventListener(Event.FRAME_CONSTRUCTED,onPlay);
				mcHolder.removeChild(preMC);
				preMC=null;
			}

			if(crtMC)
			{
				crtMC.stop();
				crtMC.removeEventListener(Event.FRAME_CONSTRUCTED,onPlay);
				mcHolder.removeChild(crtMC);
				crtMC=null;
			}

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


