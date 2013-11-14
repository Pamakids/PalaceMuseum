package views.global
{
	import com.greensock.TweenLite;

	import controllers.MC;

	import feathers.controls.Button;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	import views.global.map.Map;
	import views.global.userCenter.UserCenterManager;

	public class TopBar extends Sprite
	{
		[Embed(source="/assets/common/book.png")]
		public static var Book:Class

		public function TopBar()
		{
			var book:Button=new Button();
			book.defaultIcon=Image.fromBitmap(new Book());
			book.addEventListener(Event.TRIGGERED, bookClickedHandler);
			addChild(book);
		}

		private static var dx:Number=-90;

		private function bookClickedHandler():void
		{
			MC.instance.main.addMask(0);
			enable=false;
			TweenLite.to(bar, 1, {x: 10, onComplete: function():void {
				var index:int=-1;
				if (MC.instance.currentModule && MC.instance.currentModule.crtScene)
					index=MC.instance.currentModule.crtScene.crtKnowledgeIndex - 1;
				if (Map.map && Map.map.visible)
					index=-1;
				if (index == -1)
					UserCenterManager.showUserCenter();
				else
					UserCenterManager.showUserCenter(1, index);
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

		public static function tweenPlay(isOut:Boolean, cb:Function):void
		{
			if (!bar)
			{
				bar=new TopBar();
				if (parent)
					parent.addChild(bar);
				bar.visible=true;
				bar.x=dx;
				bar.y=10;
				enable=true;
			}
			TweenLite.to(bar, 1, {x: isOut ? 10 : dx, onComplete: cb});
		}
	}
}
