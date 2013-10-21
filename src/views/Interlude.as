package views
{
	import com.pamakids.manager.SoundManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Rectangle;
	import flash.media.StageVideo;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Capabilities;
	
	import models.Const;
	
	import starling.core.Starling;

	/**
	 * 引子
	 * @author Administrator
	 */	
	public class Interlude extends Sprite
	{
		[Embed(source="../assets/video/pass.png")]
		private static const BtnSkin:Class;
		
		private var videoURL:String;
		private var stream:NetStream;
		private var stageVideo:StageVideo;
		private var video:Video;
		private var connection:NetConnection;
		private var button:Sprite;
		
		private var viewWidth:int;
		private var viewHeight:int;
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
		public function Interlude(videoURL:String, passable:Boolean=true, onStart:Function=null, onStop:Function=null, width:int=Const.WIDTH, height:int=Const.HEIGHT)
		{
			this.videoURL = videoURL;
			this.passable = passable;
			this.startHandler = onStart;
			this.stopHandler = onStop;
			this.viewWidth = width;
			this.viewHeight = height;
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			SoundManager.instance.stop("main");
			Starling.current.stage3D.x = 0;
			Starling.current.stage3D.y = -stage.stageHeight;
			initialize();
			if(Capabilities.isDebugger)
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
					dispose();
				});
			}
		}
		
		private function initialize():void
		{
			initButton();
			initConnection();
		}
		
		private function initButton():void
		{
			if(passable)
			{
				const gap:int = 20;
				const bitmap:Bitmap = new BtnSkin();
				bitmap.width = 122;
				bitmap.height = 56;
				button = new Sprite();
				button.x = viewWidth - bitmap.width - gap;
				button.y = viewHeight - bitmap.height - gap;
				button.addChild( bitmap );
				this.addChild( button );
				button.addEventListener(MouseEvent.CLICK, passHandler);
			}
		}
		
		//跳过
		protected function passHandler(event:Event):void
		{
			trace("哎呦");
		}
		
		private function initConnection():void
		{
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void
		{
			trace("securityErrorHandler: " + event);
		}
		
		protected function netStatusHandler(e:NetStatusEvent):void
		{
			switch (e.info.code) {
				case "NetConnection.Connect.Success" :
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound" :
					trace("Unable to locate video: " + videoURL);
					break;
				case "NetStream.Play.Start":
					trace("NetStream.Play.Start");
					if(startHandler)
						startHandler();
					break;
				case "NetStream.Play.Stop":
					trace("NetStream.Play.Stop");
					dispose();
					break;
			}
		}
		
		private function connectStream():void
		{
			stream = new NetStream(connection);
			stream.client = {
				onMetaData:	onMetaData
			};
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			stageVideo = stage.stageVideos[0];
			stageVideo.attachNetStream( stream );
			stream.play( videoURL );
			stageVideo.viewPort = new Rectangle(0, 0 ,stage.stageWidth,stage.stageHeight);
			
//			video = new Video(viewWidth, viewHeight);
//			video.attachNetStream( stream );
//			this.addChildAt( video, 0 );
//			stream.play( videoURL );
		}
		
		private function onMetaData(_obj:Object):void
		{
			if (_obj.duration)
				trace(_obj.duration);
		}
		
		
		protected function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			trace ("asyncError");
		}
		
		
		public function dispose():void
		{
			Starling.current.stage3D.x = 0;
			Starling.current.stage3D.y = 0;
			SoundManager.instance.play("main");
			if(connection)
			{
				connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				connection.close();
				connection=null
			}
			if(stream)
			{
				stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				stream.pause();
			}
			if(stageVideo)
			{
				stageVideo.viewPort = new Rectangle(0, 0, 0, 0);
				stageVideo=null;
			}
			if(video)
			{
				this.removeChild( video );
				video.clear();
				video=null;
			}
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			if(stopHandler)
				stopHandler();
			this.startHandler=null;
			this.stopHandler=null;
			if(parent)
				parent.removeChild(this);
		}
	}
}