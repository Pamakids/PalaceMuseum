package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import starling.core.Starling;

	[SWF(width="1024",height="768",frameRate="60",backgroundColor="black")]
	public class ABDemo extends Sprite
	{
		public function ABDemo()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			Starling.multitouchEnabled = true;

			var game:Starling=new Starling(Main,stage);
//			var game:Starling=new Starling(MultiDemo,stage);
			game.start();
			game.showStats=true;
		}
	}
}

