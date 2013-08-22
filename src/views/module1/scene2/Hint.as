package views.module1.scene2
{
	import com.greensock.TweenLite;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Hint extends Sprite
	{
		public function Hint()
		{
			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function onTouch(event:TouchEvent):void
		{
			var tc:Touch=event.getTouch(stage, TouchPhase.ENDED);
			if (tc && isShow)
			{
				event.stopImmediatePropagation();
				hide();
			}
		}

		private var _img:Image;
		public var isShow:Boolean=false;
		public var registration:int;

		public function get img():Image
		{
			return _img;
		}

		public function set img(value:Image):void
		{
			if (!_img)
			{
				_img=value;
				addChild(_img);
			}
			else if (_img != value)
			{
				removeChild(_img);
				_img.dispose();
				_img=value;
				addChild(_img);
			}

			this.pivotX=(_img.width >> 1) * ((registration - 1) % 3);
			this.pivotY=(_img.height >> 1) * (2 - int((registration - 1) / 3));
		}

		private var _label:Image;

		public function get label():Image
		{
			return _label;
		}

		public function set label(value:Image):void
		{
			if (!_label)
			{
				_label=value;
				addChild(_label);
			}
			else if (_label != value)
			{
				removeChild(_label);
				_label.dispose();
				_label=value;
				addChild(_label);
			}
			_label.pivotX=_label.width >> 1;
			_label.pivotY=_label.height >> 1;
			_label.x=_img.width / 2;
			_label.y=_img.height / 2;
		}

		public function show():void
		{
			isShow=false;
			this.visible=true;
			TweenLite.killTweensOf(this);
			TweenLite.killDelayedCallsTo(hide);
			this.scaleX=this.scaleY=0.1;
			this.alpha=0.5;
			TweenLite.to(this, .5, {scaleX: 1, scaleY: 1, alpha: 1, onComplete: function():void
			{
				isShow=true;
				TweenLite.delayedCall(delay, hide);
			}});
		}

		public function hide():void
		{
			TweenLite.killTweensOf(this);
			TweenLite.killDelayedCallsTo(hide);
			TweenLite.to(this, .5, {alpha: 0, onComplete: function():void
			{
				isShow=false;
				this.visible=false;
				if (callback != null)
				{
					callback();
					callback=null;
				}
			}});
		}

		public var callback:Function;
		public var delay:Number=3;
	}
}

