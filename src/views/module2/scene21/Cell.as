package views.module2.scene21
{
	import flash.display.Bitmap;

	import starling.display.Image;
	import starling.display.Sprite;

	public class Cell extends Sprite
	{
		public var tx:Number;
		public var ty:Number;

		public function Cell(i:int, j:int, img:Image)
		{
			super();
			addChild(img);
		}
	}
}
