package views.global.userCenter.map
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.geom.Point;

	import controllers.MC;

	import feathers.controls.Button;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	import views.global.map.Map;
	import views.global.userCenter.BaseScreen;
	import views.global.userCenter.UserCenter;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 用户中心map场景
	 * @author Administrator
	 */
	public class MapScreen extends BaseScreen
	{
		private var mapButton:Button;
		private var mapTexture:Texture;
		private var cache:Image;

		public function MapScreen()
		{
			super();
		}

		override protected function initialize():void
		{
			super.initialize();
			initMapButton();
			initCacheImage();

			dispatchEventWith(UserCenter.InitViewPlayed);
		}

		override protected function initPages():void
		{
			var image:Image=new Image(UserCenterManager.getTexture("background_1"));
			this.addChild(image);
			image.touchable=false;
		}

		private function initCacheImage():void
		{
			cache=new Image(mapTexture);
			this.addChild(cache);
			cache.scaleX=cache.scaleY=mapButton.scaleX;
			cache.x=mapButton.x;
			cache.y=mapButton.y;
			
			cache.touchable=false;
		}

		private function initMapButton():void
		{
			mapTexture=UserCenterManager.getTexture("button_map_skin");
			mapButton=new Button();
			mapButton.defaultSkin=new Image(mapTexture);
			mapButton.x=70;
			mapButton.y=173;
			addChild(mapButton);
			mapButton.addEventListener(Event.TRIGGERED, onTriggered);
		}


		private function onTriggered():void
		{
			UserCenterManager.disable();
			if (Map.map && Map.map.visible)
			{
				MC.instance.switchLayer(true);
				return;
			}

			if (cache)
			{
				cache.scaleX=cache.scaleY=mapButton.scaleX;
				cache.x=mapButton.x;
				cache.y=mapButton.y;
				cache.visible=true;

				var point:Point=this.globalToLocal(new Point(0, 0));
				TweenLite.to(cache, 0.5, {y: -cache.height + point.y - 88, ease: Cubic.easeOut, onComplete: function():void
				{
					Map.show(function(status:int):void
					{
						UserCenterManager.enable();
						if (status == 1)
							mapButton.visible=true;
						else if (status == 2)
							UserCenterManager.closeUserCenter();
					}, -1, -1, true);
					cache.visible=false;
				}});
			}
			else
			{
				Map.show(function():void {
					UserCenterManager.enable();
				}, -1, -1, true);
			}
		}

		override public function dispose():void
		{
			if (mapButton)
			{
				mapButton.removeEventListener(Event.TRIGGERED, onTriggered);
				mapButton.removeFromParent(true);
			}
			if (cache)
				cache.removeFromParent(true);
			if (mapTexture)
				mapTexture.dispose();
			super.dispose();
		}
	}
}
