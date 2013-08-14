package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Rectangle;

	import starling.display.Image;
	import starling.display.Shape;
	import starling.display.Sprite;

	public class Bow extends Sprite
	{
		[Embed(source="assets/bow.png")]
		private var bow:Class;

		private var w:Number;
		private var h:Number;

		private var line:starling.display.Shape;

		public function Bow()
		{
			addChild(Image.fromBitmap(new bow()));

			w=width;
			h=height;

			pivotX=w-5;
			pivotY=h>>1;

			line=new starling.display.Shape();
			addChild(line);
			line.x=7;
			clear();
		}

		public function drag(strength:Number):void{
			line.graphics.clear();
			line.graphics.lineStyle(2,0xffcc66);
			line.graphics.moveTo(0,4);
			line.graphics.lineTo(-strength+20,h/2);
			line.graphics.lineTo(0,h-4);
		}

		public function clear():void{
			line.graphics.clear();
			line.graphics.lineStyle(2,0xffcc66);
			line.graphics.moveTo(0,4);
			line.graphics.lineTo(0,h-4);
		}
	}
}

