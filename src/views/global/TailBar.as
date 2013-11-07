package views.global
{
	import com.greensock.TweenLite;

	import feathers.controls.Button;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	import views.components.LionMC;

	public class TailBar extends Sprite
	{
		[Embed(source="/assets/common/tail.png")]
		public static var tail:Class

		public function TailBar()
		{
			if (_parent)
				_parent.addChild(this);
			var book:Button=new Button();
			book.defaultIcon=Image.fromBitmap(new tail());
			book.addEventListener(Event.TRIGGERED, tailClickedHandler);
			addChild(book);
			dx=163;
			x=-dx;
			y=768 - 35;
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
			trace("hide")
			instance.touchable=false;
			TweenLite.to(instance, .2, {x: -dx});
			LionMC.instance.playHide();
		}

		public static function show():void
		{
			trace("show")
			instance.x=-dx;
			instance.visible=true;
			TweenLite.to(instance, 1, {x: -dx / 3, onComplete: function():void {
				instance.touchable=true;
			}});
		}

		private function tailClickedHandler():void
		{
			LionMC.instance.replay();
		}
	}
}
