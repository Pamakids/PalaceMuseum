package views.components
{
	import com.greensock.TweenMax;
	import com.pamakids.utils.DPIUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import controllers.MC;

	public class LionMC extends Sprite
	{
		public function LionMC()
		{
			lion=new LionTalk();
			lion.scaleX=lion.scaleY=.5;
			this.addChild(lion);
			MC.instance.stage.addChild(this);
			lion.addEventListener(Event.FRAME_CONSTRUCTED, onMCPlaying);
			mcWidth=lion.width * .5;
			mcHeight=lion.height * .5;
			trace(lion.width, lion.height)
			this.visible=false;
			lion.stop();
//			addEventListener(MouseEvent.CLICK, onClick);
		}

		protected function onClick(event:MouseEvent):void
		{
			if (p)
				p.playHide();
			else
				isSayingOver=true;
		}

		protected function onMCPlaying(event:Event):void
		{
			if (isSayingOver && lion.currentFrame == lion.totalFrames)
			{
				lion.stop();
				isSayingOver=false;
				playHide();
			}
		}

		private function playHide():void
		{
			tl.reverse();
//			TweenLite.to(this, .7, {alpha: 0, onComplete: function():void {
//				if (callBack != null)
//					callBack();
//				callBack=null;
//			}});
		}

		private static var _instance:LionMC;

		public static function get instance():LionMC
		{
			if (!_instance)
				_instance=new LionMC();
			return _instance;
		}

		private var p:Prompt;
		private var mcWidth:Number;

		private var lion:MovieClip;
		private var isSayingOver:Boolean;
		private var callBack:Function;

		private var tl:TweenMax;
		private var mcHeight:Number;

		public function say(content:String, _x:Number=0, _y:Number=0, _callBack:Function=null, fontSize:int=20):void
		{
			visible=true;
			if (!_x && !_y)
			{
				var s:Stage=MC.instance.stage.stage;
				var sc:Number=DPIUtil.getDPIScale();
				_x=(s.fullScreenWidth / sc - mcWidth) / 2;
				_y=(s.fullScreenHeight / sc - mcHeight) / 2;
			}
			x=_x < 512 ? -mcWidth * 2 : 1024 + mcWidth;
			y=_y - 200;
			callBack=_callBack;
			if (p)
			{
				p.visible=true;
				p.callback=null;
				p.playHide();
			}

			tl=TweenMax.to(this, .5, {x: _x, y: _y, motionBlur: true, onComplete: function():void
			{
				lion.gotoAndPlay(1);
				p=Prompt.showTXT(x + mcWidth - 10, y + 10, content, fontSize, function():void
				{
					isSayingOver=true;
				}, MC.instance.main);
			}});
		}

		public function hide():void
		{
			visible=false;
			p.visible=false;
		}
	}
}
