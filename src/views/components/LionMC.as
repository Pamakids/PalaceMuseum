package views.components
{
	import com.greensock.TweenMax;
	import com.pamakids.utils.DPIUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;

	import controllers.MC;

	/**
	 *
	 * @author Administrator
	 */
	public class LionMC extends Sprite
	{
		public function LionMC()
		{
			MC.instance.stage.addChild(this);
			this.visible=false;
		}

		private function showLion(type:int=0):void
		{
			if (lion)
			{
				lion.stop();
				removeChild(lion);
				lion=null;
			}
			lion=new mcArr[type];
			lion.scaleX=lion.scaleY=.5;
			mcWidth=lion.width * .5;
			mcHeight=lion.height * .5;
			lion.stop();
			trace(lion.width, lion.height)
			addChild(lion);
//			lion.addEventListener(Event.FRAME_CONSTRUCTED, onMCPlaying);
		}

//		protected function onMCPlaying(event:Event):void
//		{
//			if (isSayingOver && lion.currentFrame == lion.totalFrames)
//			{
//				lion.stop();
//				isSayingOver=false;
//				playHide();
//			}
//		}

		private function playHide():void
		{
			if (tl)
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
		private var _isSayingOver:Boolean;

		public function get isSayingOver():Boolean
		{
			return _isSayingOver;
		}

		/**
		 *
		 * @param value
		 */
		public function set isSayingOver(value:Boolean):void
		{
			_isSayingOver=value;
			if (value)
			{
				if (lion)
					lion.stop();
				isSayingOver=false;
				playHide();
			}
		}

		private var callBack:Function;

		private var tl:TweenMax;
		private var mcHeight:Number;
		private var mcArr:Array=[LionTalk, LionHappy, LionUnHappy, LionNaughty];

		/**
		 *
		 * @param content
		 * @param type 0:说话 1:开心 2:不满 3:调皮
		 * @param _x
		 * @param _y
		 * @param _callBack
		 * @param fontSize
		 */
		public function say(content:String, _type:int=0, _x:Number=0, _y:Number=0, _callBack:Function=null, fontSize:int=20, needMask:Boolean=true):void
		{
			showLion(_type);
			trace('lion say:', content);
			visible=true;
			if (!_x && !_y)
			{
				var s:Stage=MC.instance.stage.stage;
				var sc:Number=DPIUtil.getDPIScale();
				_x=(s.fullScreenWidth / sc - mcWidth) / 2;
				_y=(s.fullScreenHeight / sc - mcHeight) / 2;
			}
			x=_x < 512 ? -100 - mcWidth * 2 : 1124 + mcWidth;
			y=_y - 200;
			callBack=_callBack;
			if (p)
			{
				p.visible=true;
				p.callback=null;
				p.playHide();
			}

			if (needMask)
				MC.instance.main.addMask();
			tl=TweenMax.to(this, .5, {x: _x, y: _y, motionBlur: true, onComplete: function():void
			{
				lion.gotoAndPlay(1);
				p=Prompt.showTXT(x + mcWidth - 10, y + 10, content, fontSize, function():void
				{
					isSayingOver=true;
					if (callBack != null) {
						callBack();
						callBack=null;
					}
					if (needMask)
						MC.instance.main.removeMask();
				}, MC.instance.main);
			}});
		}

		/**
		 *
		 */
		public function hide():void
		{
			visible=false;
			if (p)
				p.visible=false;
		}
	}
}
