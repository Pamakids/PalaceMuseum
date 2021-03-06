package views.global
{
	import com.greensock.TweenLite;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import views.components.LionMC;

	public class TailBar extends Sprite
	{
		public function TailBar()
		{
			if (_parent)
				_parent.addChild(this);
			var tail:MovieClip=new MovieClip(MC.assetManager.getTextures("tail"), 30);
//			this.scaleX=this.scaleY=tail.scaleX=tail.scaleY=1;
			Starling.juggler.add(tail);
			tail.loop=true;
			tail.play();
			tail.addEventListener(TouchEvent.TOUCH, tailClickedHandler);
			addChild(tail);
			dx=100;
			x=-dx;
			y=768 - 100;
			touchable=false;
		}

		private static var dx:Number;
		private static var _instance:TailBar;
		public static var _parent:Sprite;

		public static function get instance():TailBar
		{
			if (!_instance)
				_instance=new TailBar();
			return _instance;
		}

		public static function hide():void
		{
			TweenLite.killTweensOf(instance);
			instance.touchable=false;
			TweenLite.to(instance, .2, {x: -dx});
			LionMC.instance.playHide();
		}

		public static function show():void
		{
			TweenLite.killTweensOf(instance);
			instance.x=-dx;
			instance.visible=true;
			TweenLite.to(instance, 1, {x: -15, onComplete: function():void {
				instance.touchable=true;
			}});
		}

		private function tailClickedHandler(e:TouchEvent):void
		{
			var tail:MovieClip=e.currentTarget as MovieClip;
			if (!tail)
				return;
			var tc:Touch=e.getTouch(tail, TouchPhase.ENDED);
			if (!tc)
				return;
			UserBehaviorAnalysis.trackEvent("click", "tail");
			LionMC.instance.replay();
		}
	}
}
