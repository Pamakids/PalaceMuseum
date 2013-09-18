package views.global.userCenter.map
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.controls.Button;
	import feathers.controls.Screen;

	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;

	import views.global.map.Map;
	import views.global.userCenter.IUserCenterScreen;
	import views.global.userCenter.UserCenter;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 用户中心map场景
	 * @author Administrator
	 */
	public class MapScreen extends Screen implements IUserCenterScreen
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
			initContainer();
			initMapButton();
			initCacheImage();
//			initScreenTextures();
		}

		private function initContainer():void
		{
			var image:Image=new Image(UserCenterManager.getTexture("background_map"));
			this.addChild(image);
			image.touchable=false;
		}

		public var viewWidth:Number;
		public var viewHeight:Number;

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
				TweenLite.to(cache, 0.5, {x: point.x + 12, y: -cache.height + point.y - 88, scaleX: 1, scaleY: 1, ease: Cubic.easeOut, onComplete: function():void
				{
					Map.show(function(status:int):void
					{
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
				Map.show(null, -1, -1, true);
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

		public function getScreenTexture():Vector.<Texture>
		{
			if (UserCenterManager.getScreenTexture(UserCenter.MAP) == null)
				initScreenTextures();
			return UserCenterManager.getScreenTexture(UserCenter.MAP);
		}

		private function initScreenTextures():void
		{
			var sts:Vector.<Texture>=UserCenterManager.getScreenTexture(UserCenter.MAP);
			if (!sts)
			{
				var render:RenderTexture=new RenderTexture(viewWidth, viewHeight, true);
				render.draw(this);
				sts=new Vector.<Texture>(2);
				sts[0]=Texture.fromTexture(render, new Rectangle(0, 0, viewWidth / 2, viewHeight));
				sts[1]=Texture.fromTexture(render, new Rectangle(viewWidth / 2, 0, viewWidth / 2, viewHeight));
				UserCenterManager.setScreenTextures(UserCenter.MAP, sts);
			}
		}
	}
}
