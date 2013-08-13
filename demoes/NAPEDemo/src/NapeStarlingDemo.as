package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import starling.core.Starling;

	[SWF(width="800",height="600",frameRate="60",backgroundColor="0x66ccff")]
	public class NapeStarlingDemo extends Sprite
	{
		public function NapeStarlingDemo()
		{
			var game:Starling=new Starling(StarlingGame,stage);
			game.start();
			game.showStats=true;
		}
	}
}

