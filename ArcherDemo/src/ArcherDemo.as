package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import starling.core.Starling;

	[SWF(width="1024",height="768",frameRate="60",backgroundColor="black")]
	public class ArcherDemo extends Sprite
	{
		public function ArcherDemo()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			var game:Starling=new Starling(Main,stage);
			game.showStats=true;
			game.start();
		}
	}
}

