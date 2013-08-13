package
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class Arrow extends Sprite
	{
		[Embed(source="assets/arrow.png")]
		private static var arrow:Class;

		public function Arrow()
		{
			addChild(Image.fromBitmap(new arrow()));
			pivotX=110;
			pivotY=height>>1;
		}
	}
}

