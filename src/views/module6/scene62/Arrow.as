package views.module6.scene62
{
	import starling.display.Image;
	import starling.display.Sprite;

	public class Arrow extends Sprite
	{
		public var hitted:Boolean;
		public function Arrow(img:Image)
		{
			addChild(img);
			pivotX=img.width;
		}
	}
}

