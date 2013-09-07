package views.global.userCenter.map
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.pamakids.manager.LoadManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import views.global.Map;
	import views.global.userCenter.IUserCenterScreen;
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
		
		private var containerL:Sprite;
		private var containerR:Sprite;
		
		public function MapScreen()
		{
			super();
		}

		override protected function initialize():void
		{
			LoadManager.instance.loadImage('assets/global/mapBG.jpg', bgLoadedHandler);
		}
		
		private function initContainer():void
		{
			var image:Image = new Image(UserCenterManager.assetsManager.getTexture("page_left"));
			this.addChild( image );
			image = new Image(UserCenterManager.assetsManager.getTexture("page_right"));
			this.addChild( image );
			image.x = this.viewWidth/2;
		}
		
		public var viewWidth:Number;
		public var viewHeight:Number;
		
		private function bgLoadedHandler(bitmap:Bitmap):void
		{
			initContainer();
			initMapButtonTexture(bitmap);
			initMapButton();
			initCacheImage();
			initScreenTextures();
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
			mapButton=new Button();
			mapButton.defaultSkin=new Image(mapTexture);
			mapButton.x=70;
			mapButton.y=320;
			mapButton.scaleX=mapButton.scaleY=0.8;
			addChild(mapButton);
			mapButton.addEventListener(Event.TRIGGERED, onTriggered);
		}
		
		private function initMapButtonTexture(bitmap:Bitmap):void
		{
			var bd:BitmapData=bitmap.bitmapData;
			var newBD:BitmapData=new BitmapData(bd.width, bd.height / 4);
			newBD.copyPixels(bd, new Rectangle(0, 0, bd.width, bd.height / 4), new Point());
			mapTexture=Texture.fromBitmapData(newBD);
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
					});
					cache.visible=false;
				}});
			}
			else
			{
				Map.show();
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
		
		private var screenTexture:Vector.<Texture>;
		public function getScreenTexture():Vector.<Texture>
		{
			return screenTexture;
		}
		private var texturesInitialized:Boolean = false;
		public function testTextureInitialized():Boolean
		{
			return texturesInitialized;
		}
		
		private function initScreenTextures():void
		{
			if(texturesInitialized)
				return;
			screenTexture = new Vector.<Texture>(2);
			var render:RenderTexture = new RenderTexture(viewWidth, viewHeight, true);
			render.draw( this );
			screenTexture[0] = Texture.fromTexture( render, new Rectangle( 0, 0, viewWidth/2, viewHeight) );
			screenTexture[1] = Texture.fromTexture( render, new Rectangle( viewWidth/2, 0, viewWidth/2, viewHeight) );
			texturesInitialized = true;
		}
	}
}
