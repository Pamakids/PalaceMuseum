package views.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	import controllers.UserBehaviorAnalysis;

	import feathers.core.PopUpManager;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class ItemIntro extends Sprite
	{
		public var index:int;
		public var hotArea:Rectangle;
		public static const CLOSE:String="ItemIntroClose";
		public static const OPEN:String="ItemIntroOpen";

		public static const _W:Number=809;
		public static const _H:Number=656;
		private var initTime:int;
		private var disposeTime:int;

		public function ItemIntro(_index:int, rect:Rectangle)
		{
			index=_index;
			hotArea=rect;

			x=1024 - ItemIntro._W >> 1;
			y=768 - ItemIntro._H >> 1;

			PopUpManager.addPopUp(this, true, false);

			initTime=getTimer();
			UserBehaviorAnalysis.trackView("ItemIntro" + index);
		}

		public function addIntro(bg:Image, content:Image, close:ElasticButton):void
		{
			addChild(bg);
			addChild(content);
			addChild(close);
			close.x=800;
			close.y=30;
			close.addEventListener(ElasticButton.CLICK, onClose);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this, TouchPhase.BEGAN);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(this);
			if (hotArea && hotArea.containsPoint(pt))
			{
				disposeTime=getTimer();
				UserBehaviorAnalysis.trackTime("stayTime", disposeTime - initTime, "ItemIntro" + index);
				UserBehaviorAnalysis.trackEvent("click", "ItemIntro.OPEN");
				this.touchable=false;
				TweenLite.to(this, 1, {x: 512 - 10, y: 384 - 10, scaleX: .07, scaleY: .07, ease: Elastic.easeOut, onComplete: function():void
				{
					dispatchEvent(new Event(ItemIntro.OPEN));
				}});
			}
		}

		private function onClose(e:Event):void
		{
			disposeTime=getTimer();
			UserBehaviorAnalysis.trackTime("stayTime", disposeTime - initTime, "ItemIntro" + index);
			this.touchable=false;
			TweenLite.to(this, 1, {x: 512 - 10, y: 384 - 10, scaleX: .07, scaleY: .07, ease: Elastic.easeOut, onComplete: function():void
			{
				dispatchEvent(new Event(ItemIntro.CLOSE));
			}});
		}
	}
}
