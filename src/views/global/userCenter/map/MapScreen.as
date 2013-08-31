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
	import starling.events.Event;
	import starling.textures.Texture;
	
	import views.global.Map;

	/**
	 * 用户中心map场景
	 * @author Administrator
	 * 
	 */	
	public class MapScreen extends Screen
	{
		private var mapButton:Button;
		private var map:Map;
		private var mapTexture:Texture;
		private var cache:Image;

		public function MapScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			map = new Map(stage.stageWidth, stage.stageHeight);
			mapButton = new Button();
			
			LoadManager.instance.loadImage('assets/global/mapBG.jpg', bgLoadedHandler);
		}
		
		private function bgLoadedHandler(bitmap:Bitmap):void
		{
			var bd:BitmapData = bitmap.bitmapData;
			var newBD:BitmapData = new BitmapData(bd.width, bd.height/4);
			newBD.copyPixels(bd, new Rectangle(0,0,bd.width,bd.height/4), new Point());
			
			mapTexture = Texture.fromBitmapData(newBD);
			
			mapButton.defaultSkin = new Image(mapTexture);
			mapButton.x = 70;
			mapButton.y = 380;
			mapButton.scaleX = mapButton.scaleY = 0.8;
			addChild(mapButton);
			mapButton.addEventListener(Event.TRIGGERED, onTriggered);
			
			cache = new Image( Texture.fromBitmapData(newBD) );
			this.addChild(cache);
			cache.touchable = false;
			cache.visible = false;
			
			newBD.dispose();
			bd.dispose();
		}
		
		private function onTriggered():void
		{
			mapButton.visible = false;
			
			if(cache)
			{
				cache.scaleX = cache.scaleY = mapButton.scaleX;
				cache.x = mapButton.x;
				cache.y = mapButton.y;
				cache.visible = true;
				
				var point:Point = this.globalToLocal(new Point(0,0));
				TweenLite.to(cache, 0.5, {
					x:point.x+12, y:point.y, scaleX: 1, scaleY: 1, ease: Cubic.easeOut, onComplete: function():void
					{
						showMap();
						cache.visible = false;
					}
				});
			}else
			{
				showMap();
			}
		}
		
		private function showMap():void
		{
			stage.addChild(map);
		}
		
		override public function dispose():void
		{
			if(mapButton)
				mapButton.dispose();
			if(map)
				map.dispose();
			if(cache)
				cache.dispose();
			if(mapTexture)
				mapTexture.dispose();
			super.dispose();
		}
	}
}