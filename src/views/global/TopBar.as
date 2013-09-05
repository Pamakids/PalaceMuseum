package views.global
{
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;

	import feathers.controls.Button;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	import views.global.userCenter.UserCenterManager;

	public class TopBar extends Sprite
	{
		public function TopBar()
		{
			LoadManager.instance.loadImage('assets/common/book.png', loadedHandler);
		}

		private function loadedHandler(b:Bitmap):void
		{
			var book:Button=new Button();
			book.defaultIcon=new Image(Texture.fromBitmap(b));
			book.addEventListener(Event.TRIGGERED, bookÇlickedHandler);
			addChild(book);
		}

		private function bookÇlickedHandler():void
		{
			UserCenterManager.showUserCenter();
		}

		public static var parent:Sprite;
		public static var bar:TopBar;

		public static function show():void
		{
			if (!bar)
			{
				bar=new TopBar();
				bar.x=10;
				bar.y=10;
				if (parent)
					parent.addChild(bar);
			}
//			var p:Sprite=parent ? parent : TopBar.parent;
//			p.addChild(bar);
			bar.visible=true;
		}

		public static function hide():void
		{
			if (bar)
				bar.visible=false;
		}
	}
}
