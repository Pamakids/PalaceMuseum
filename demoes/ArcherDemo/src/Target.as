package
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class Target extends Sprite
	{
		[Embed(source="assets/target.png")]
		private var target:Class;

		public function Target()
		{
			addChild(Image.fromBitmap(new target()));
			pivotX=width>>1;
			pivotY=height>>1;
		}
	}
}

