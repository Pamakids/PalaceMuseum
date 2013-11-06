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

	import models.Const;

	import views.global.TailBar;

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
			addEventListener(MouseEvent.CLICK, onClick);
		}

		protected function onClick(event:MouseEvent):void
		{
			if (p)
				p.playHide();
		}

		public static var scale:Number=.5;

		private function showLion(type:int=0):void
		{
			if (lion)
			{
				lion.stopAllMovieClips();
				removeChild(lion);
				lion=null;
			}
			lion=new mcArr[type];
			lion.scaleX=lion.scaleY=scale;
			mcWidth=lion.width * scale;
			mcHeight=lion.height * scale;
			lion.stopAllMovieClips();
			addChild(lion);
			visible=true;
		}

		public function replay():void
		{
			if (lastContent)
				say(lastContent, lastType, lastX, lastY, null, 20, true);
			else
				play(int(Math.random() * mcArr.length));
		}

		public function play(type:int=0, _x:Number=0, _y:Number=0, needMask:Boolean=true):void
		{
			TailBar.hide();
			showLion(type);
			if (!_x && !_y)
			{
				var s:Stage=MC.instance.stage.stage;
				_x=(Const.WIDTH - mcWidth) / 2;
				_y=(Const.HEIGHT - mcHeight) / 2;
			}
			x=_x < 512 ? -100 - mcWidth * 2 : 1124 + mcWidth;
			y=_y - 200;
			if (needMask)
				MC.instance.main.addMask();
			tl=TweenMax.to(this, .5, {x: _x, y: _y, motionBlur: true, onComplete: function():void
			{
				lion.gotoAndPlay(1);
				var compFunc:Function=function(e:Event):void {
					if (lion.currentFrame == lion.totalFrames) {
						lion.stopAllMovieClips();
						TailBar.show();
						lion.removeEventListener(Event.FRAME_CONSTRUCTED, compFunc);
						isSayingOver=true;
						if (needMask)
							MC.instance.main.removeMask();
					}
				}
				lion.addEventListener(Event.FRAME_CONSTRUCTED, compFunc);
			}});
		}

		private function playHide():void
		{
			if (tl)
				tl.reverse();
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
		private var mcArr:Array=[LionTalk, LionHappy, LionUnHappy, LionNaughty, LionSad, LionThink, LionPeep];

		private var lastType:int;
		private var lastX:Number;
		private var lastY:Number;
		private var lastContent:String;
		private var lastMask:Boolean;
		private var lastTask:Boolean

		/**
		 *
		 * @param content
		 * @param type 0:说话 1:开心 2:不满 3:调皮 4:悲伤 5:思考 6:偷看
		 * @param _x
		 * @param _y
		 * @param _callBack
		 * @param fontSize
		 */
		public function say(content:String, _type:int=0, _x:Number=0, _y:Number=0, _callBack:Function=null, fontSize:int=20, needMask:Boolean=true, isTask:Boolean=false):void
		{
			TailBar.hide();
			lastType=_type;
			lastX=_x;
			lastY=_y;
			lastContent=content;
			lastMask=needMask;
			lastTask=isTask;

			showLion(_type);
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
					TailBar.show();
					isSayingOver=true;
					if (callBack != null) {
						callBack();
						callBack=null;
					}
					if (needMask)
						MC.instance.main.removeMask();
				}, MC.instance.main, 1, false, 3, isTask);
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

		public function show():void
		{
			visible=true;
			if (p)
				p.visible=true;
		}

		public function clear():void
		{
			lastType=0;
			lastX=0;
			lastY=0;
			lastContent="";
			lastMask=false;
			lastTask=false;
		}
	}
}
