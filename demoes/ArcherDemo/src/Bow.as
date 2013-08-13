package
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class Bow extends Sprite
	{
		[Embed(source="assets/bow.png")]
		private var bow:Class;
		public function Bow()
		{
			addChild(Image.fromBitmap(new bow()));
			pivotY=height>>1;
		}
	}
}

