package views.global.userCenter.map
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.controls.Button;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	import views.global.map.Map;
	import views.global.userCenter.BaseScreen;
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
		}

		override protected function initPages():void
		{
			var image:Image=new Image(UserCenterManager.getTexture("background_map"));
			this.addChild(image);
			image.touchable=false;
		}

		private function initCacheImage():void
		{
			cache=new Image(mapTexture);
			this.addChild(cache);
			cache.touchable=false;
			cache.scaleX=cache.scaleY=mapButton.scaleX;
			cache.x=mapButton.x;
			cache.y=mapButton.y;
		}

		private function initMapButton():void
		{
			var texture:Texture=UserCenterManager.getTexture("mapBG");
			mapTexture=Texture.fromTexture(texture, new Rectangle(0, 0, texture.width, texture.height / 4));

			mapButton=new Button();
			mapButton.defaultSkin=new Image(mapTexture);
			mapButton.x=70;
			mapButton.y=320;
			mapButton.scaleX=mapButton.scaleY=0.8;
			addChild(mapButton);
			mapButton.addEventListener(Event.TRIGGERED, onTriggered);
		}


		private function onTriggered():void
		{
			mapButton.visible=false;

			if (cache)
			{
				cache.scaleX=cache.scaleY=mapButton.scaleX;
				cache.x=mapButton.x;
				cache.y=mapButton.y;
				cache.visible=true;

				var point:Point=this.globalToLocal(new Point(0, 0));
				UserCenterManager.disable();
				TweenLite.to(cache, 0.5, {x: point.x + 12, y: -cache.height + point.y - 88, scaleX: 1, scaleY: 1, ease: Cubic.easeOut, onComplete: function():void
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
				UserCenterManager.disable();
				Map.show(function():void {
					UserCenterManager.enable();
				}, -1, -1, true);
			}
		}

		override public function dispose():void
		{
			if (mapButton)
				mapButton.dispose();
			if (cache)
				cache.dispose();
			if (mapTexture)
				mapTexture.dispose();
			super.dispose();
		}
	}
}
