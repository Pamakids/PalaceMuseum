package
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class CrimsonBird extends Sprite
	{
		[Embed(source="assets/crimson.png")]
		private var crimson:Class;

		public function CrimsonBird()
		{
			addChild(Image.fromBitmap(new crimson()));
			pivotX=pivotY=55;
		}
	}
}

