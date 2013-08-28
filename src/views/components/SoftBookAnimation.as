package views.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	/**
	 * 书本软翻页动画
	 * @author Administrator
	 */	
	public class SoftBookAnimation extends Sprite
	{
		private var leftImage:Image;
		private var rightImage:Image;
		
		private var duration:Number;
		private var leftToRight:Boolean = true;
		
		/**
		 * 显示
		 */		
		private var line:Sprite;
		private var containerLeft:Sprite;
		private var containerRight:Sprite;
		
		/**
		 * @param bitmap	显示
		 * @param duration	动画时长
		 * @param leftToRight	向左翻
		 */		
		public function SoftBookAnimation(bitmap:Bitmap, duration:Number=3, leftToRight:Boolean=true)
		{
			var bd:BitmapData = bitmap.bitmapData;
			var w:Number = bd.width >> 1;
			var h:Number = bd.height;
			var leftBD:BitmapData = new BitmapData(w, h);
			var rightBD:BitmapData = new BitmapData(w, h);
			leftBD.copyPixels(bd, new Rectangle(0,0,w,h), new Point());
			rightBD.copyPixels(bd,new Rectangle(w,h,w,h), new Point());
			
			leftImage = new Image(Texture.fromBitmapData(leftBD));
			rightImage = new Image(Texture.fromBitmapData(rightBD));
			
			containerLeft = new Sprite();
			containerLeft.addChild( leftImage );
			containerRight = new Sprite();
			containerRight.addChild( rightImage );
			
			
			//create line
			createLine();
			//create pageOne
			createPageA();
			//create pageTwo
			createPageB();
			
			advanceTimeFunc();
		}
		
		/**
		 * 时间轴方法
		 */		
		private function advanceTimeFunc():void
		{
			
		}
		
		private function createPageB():void
		{
			
		}
		
		private function createPageA():void
		{
			
		}
		
		private function createLine():void
		{
			
		}		
		
	}
}