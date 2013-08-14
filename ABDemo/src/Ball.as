package
{
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class Ball extends Sprite
	{
		[Embed(source="assets/ball.png")]
		private var ball:Class;
		
		public function Ball()
		{
			addChild(Image.fromBitmap(new ball()));
			pivotX=width>>1;
			pivotY=height>>1;
		}
	}
}