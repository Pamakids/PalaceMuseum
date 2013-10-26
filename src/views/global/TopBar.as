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
	
	import views.global.map.Map;
	import views.global.userCenter.UserCenterManager;

	public class TopBar extends Sprite
	{
		public function TopBar()
		{
			LoadManager.instance.loadImage('assets/common/book.png', loadedHandler);
		}

		private static var dx:Number=-122;

		private function loadedHandler(b:Bitmap):void
		{
			var book:Button=new Button();
			book.defaultIcon=new Image(Texture.fromBitmap(b));
			book.addEventListener(Event.TRIGGERED, bookClickedHandler);
			addChild(book);
		}

		private function bookClickedHandler():void
		{
			MC.instance.main.addMask(0);
			enable=false;
			TweenLite.to(bar, 1, {x: 10, onComplete: function():void {
				var index:int=-1;
				if (MC.instance.currentModule && MC.instance.currentModule.crtScene)
					index=MC.instance.currentModule.crtScene.crtKnowledgeIndex - 1;
				if(Map.map && Map.map.visible)
					index = -1;
				if(index == -1)
					UserCenterManager.showUserCenter();
				else
					UserCenterManager.showUserCenter(2, index);
			}});
		}

		public static var parent:Sprite;
		public static var bar:TopBar;

		public static function show():void
		{
			if (!MC.isTopBarShow)
			{
				hide();
				return;
			}
			trace("show")
			if (!bar)
			{
				bar=new TopBar();
				if (parent)
					parent.addChild(bar);
			}
			bar.visible=true;
			bar.x=dx;
			bar.y=10;
			enable=true;
		}

		public static function hide():void
		{
			if (MC.isTopBarShow)
			{
				show();
				return;
			}
			trace("hide")
			if (bar)
			{
				bar.x=dx;
				bar.y=10;
				bar.visible=false;
			}
		}

		public static function set enable(value:Boolean):void
		{
			MC.instance.contentEnable=value;
			if (bar)
				bar.touchable=value;
		}
	}
}
