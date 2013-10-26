package views.global
{
	import com.greensock.TweenLite;
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;

	import controllers.MC;

	import feathers.controls.Button;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

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
			dx=73;
			x=-dx;
			y=768 - 85;
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
			instance.touchable=false;
			TweenLite.to(instance, .2, {x: -dx});
		}

		public static function show():void
		{
			instance.x=-dx;
			TweenLite.to(instance, 1, {x: -10, onComplete: function():void {
				instance.touchable=true;
			}});
		}

		private function tailClickedHandler():void
		{
			LionMC.instance.replay();
		}
	}
}
