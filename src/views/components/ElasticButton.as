package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;

	import flash.geom.Point;
	import flash.utils.setTimeout;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ElasticButton extends Sprite
	{
		private var _enable:Boolean=true;

		private var downPoint:Point;
		protected var downAndMoved:Boolean;

		private var upCompleted:Boolean;
		private var downCompleted:Boolean;
		private var playingEffect:Boolean;

		/**
		 * use listener ElasticButton.CLICK
		 * img:starling.display.Image
		 * */
		public function ElasticButton(img:Image)
		{
			addChild(img);
			pivotX=img.width >> 1;
			pivotY=img.height >> 1;
			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		public var shadow:Image;

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this);
			if (!tc)
				return;

			if (!enable)
			{
				e.stopImmediatePropagation();
				return;
			}

			var pt:Point=tc.getLocation(this);
			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					if (playingEffect)
						return;
					if (enable)
					{
						if (shadow)
						{
							addChild(shadow);
							shadow.visible=true;
						}
						downPoint=pt;
					}
					playingEffect=true;
					var vars:Object={scaleX: 0.6, scaleY: 0.6, onComplete: downComplete, ease: Cubic.easeIn}
					TweenLite.to(this, 0.3, vars);

					break;
				}

				case TouchPhase.MOVED:
				{

					break;
				}

				case TouchPhase.STATIONARY:
				{

					break;
				}

				case TouchPhase.ENDED:
				{
					if (downPoint)
					{
						var distance:Number=Point.distance(downPoint, pt);
						if (distance > 38) //38 pixel
							downAndMoved=true;
					}
					downPoint=null;

					upCompleted=true;
					if (downCompleted)
						doUp();
					break;
				}

				default:
				{
					break;
				}
			}

		}

		private function downComplete():void
		{
			downCompleted=true;
			if (upCompleted)
				doUp();
		}

		private function upComplete():void
		{
			if (shadow)
				shadow.visible=false;

			setTimeout(function():void
			{
				playingEffect=false;
				upCompleted=false;
				downCompleted=false;
			}, 500);

			if (!downAndMoved)
			{
				stopClickEvent=false;
				dispatchEvent(new Event(ElasticButton.CLICK));
			}
			else
			{
				stopClickEvent=true;
				downAndMoved=false;
			}
		}

		public static const CLICK:String="ElasticButtonClick";

		private function doUp():void
		{
			var vars:Object={scaleX: 1, scaleY: 1, onComplete: upComplete, ease: Elastic.easeOut}
			TweenLite.to(this, 0.5, vars);
		}

		private var stopClickEvent:Boolean=true;

		public function get enable():Boolean
		{
			return _enable;
		}

		public function set enable(value:Boolean):void
		{
			_enable=value;
			touchable=value;
		}
	}
}
