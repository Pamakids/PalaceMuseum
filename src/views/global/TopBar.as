package views.global
{
	import com.greensock.TweenLite;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import feathers.controls.Button;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	import views.global.books.BooksManager;
	import views.global.map.Map;

	public class TopBar extends Sprite
	{
		public function TopBar()
		{
			ribbon=new Button();
			var rimg:Image=new Image(MC.assetManager.getTexture("ribbon"));
			ribbon.defaultIcon=rimg;
			ribbon.addEventListener(Event.TRIGGERED, ribbonClickedHandler);
			addChild(ribbon);
			_RW=rimg.width;
			var rh:Number=rimg.height;

			book=new Button();
			var bimg:Image=new Image(MC.assetManager.getTexture("book"))
			book.defaultIcon=bimg;
			book.addEventListener(Event.TRIGGERED, bookClickedHandler);
			addChild(book);
			_BW=bimg.width;
			var bh:Number=bimg.height;

			avatar=new Button();
			var aimg:Image=new Image(MC.assetManager.getTexture("useravatar"));
			avatar.defaultIcon=aimg;
			avatar.addEventListener(Event.TRIGGERED, avatarClickedHandler);
			addChild(avatar);
			_AW=aimg.width;
			var ah:Number=aimg.height;

			ribbon.x=_RX;
			ribbon.y=ah - rh >> 1;

			book.x=-_BW;
			book.y=ah - bh >> 1;

			avatar.x=1024;
			avatar.y=0;
		}

		private function avatarClickedHandler():void
		{
			MC.instance.main.addMask(0);
			UserBehaviorAnalysis.trackEvent("click", "avatar");
			BooksManager.showBooks(0, 0);
		}

		private var hidding:Boolean;

		public function hideBookAndAvatar():void
		{
			if (hidding)
				return;
			TweenLite.killDelayedCallsTo(hideBookAndAvatar);
			TweenLite.killTweensOf(book);
			TweenLite.killTweensOf(avatar);
			TweenLite.killTweensOf(ribbon);

			hidding=true;
			TweenLite.to(ribbon, .8, {alpha: 1, onComplete: function():void {
				ribbon.touchable=true;
				hidding=false;
			}});
			TweenLite.to(book, .3, {x: -_BW});
			TweenLite.to(avatar, .3, {x: 1024});
		}

		private function showBookAndAvatar():void
		{
			TweenLite.killDelayedCallsTo(hideBookAndAvatar);
			TweenLite.killTweensOf(book);
			TweenLite.killTweensOf(avatar);
			TweenLite.killTweensOf(ribbon);

			ribbon.touchable=false;
			TweenLite.to(ribbon, .3, {alpha: 0});
			TweenLite.to(book, .8, {x: 0});
			TweenLite.to(avatar, .8, {x: 1024 - _AW});
			TweenLite.delayedCall(4, hideBookAndAvatar);
			hidding=false;
		}

		private static var _BW:Number;
		private static var _AW:Number;
		private static var _RW:Number;
		private static var _RX:Number=-45

		private function ribbonClickedHandler():void
		{
			UserBehaviorAnalysis.trackEvent("click", "ribbon");
			showBookAndAvatar();
		}

		private static var dx:Number=-90;

		private function bookClickedHandler():void
		{
			MC.instance.main.addMask(0);
			UserBehaviorAnalysis.trackEvent("click", "book");
			var index:int=-1;
			if (MC.instance.currentModule && MC.instance.currentModule.crtScene)
				index=MC.instance.currentModule.crtScene.crtKnowledgeIndex - 1;
			if (Map.map && Map.map.visible)
				index=-1;
			if (index == -1)
				BooksManager.showBooks(1, 0);
			else
				BooksManager.showBooks(1, 0, index);
		}

		public static var parent:Sprite;
		private static var _instance:TopBar

		private var book:Button;
		private var avatar:Button;
		private var ribbon:Button;

		public static function get instance():TopBar
		{
			if (!_instance)
			{
				_instance=new TopBar();
				parent.addChild(_instance);
			}
			return _instance;
		}

		public function show():void
		{
			hidding=false;
			visible=true;
			TweenLite.killTweensOf(ribbon);
			TweenLite.killTweensOf(book);
			TweenLite.killTweensOf(avatar);
			TweenLite.killDelayedCallsTo(hideBookAndAvatar);

			ribbon.x=_RX;
			ribbon.alpha=1;
			book.x=-_BW;
			avatar.x=1024;

			ribbon.touchable=true;
		}

		public static function show():void
		{
			instance.show();
			enable=true;
		}

		public static function hide():void
		{
			instance.visible=false;
		}

		public static function set enable(value:Boolean):void
		{
			MC.instance.contentEnable=value;
			if (instance)
				instance.touchable=value;
		}

		public static function tweenPlay(isOut:Boolean, cb:Function):void
		{
			instance.visible=true;
			instance.book.x=dx;
			instance.book.y=10;
			enable=true;
			TweenLite.to(instance, 1, {x: isOut ? 10 : dx, onComplete: cb});
		}
	}
}
