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
		public function TailBar()
		{
			if (parent)
				parent.addChild(this);
			LoadManager.instance.loadImage('assets/common/tail.png', loadedHandler);
		}

		private static var dx:Number;
		private static var _instance:TopBar;
		public static var parent:Sprite;

		public static function get instance():TopBar
		{
			if (!_instance)
				_instance=new TopBar();
			return _instance;
		}

		private function loadedHandler(b:Bitmap):void
		{
			dx=b.width;
			var book:Button=new Button();
			book.defaultIcon=new Image(Texture.fromBitmap(b));
			book.addEventListener(Event.TRIGGERED, tailClickedHandler);
			addChild(book);
			x=-dx / 2
			y=768 - b.height;
			visible=false;
		}

		public static function hide():void
		{
			instance.visible=false;
		}

		public static function show():void
		{
			instance.visible=true;
			instance.x=-dx;
			TweenLite.to(instance, .5, {x: -dx / 2});
		}

		private function tailClickedHandler():void
		{
			MC.instance.main.addMask(0);
			TweenLite.to(instance, 1, {x: -dx, onComplete: function():void {
				LionMC.instance.play();
			}});
		}
	}
}
