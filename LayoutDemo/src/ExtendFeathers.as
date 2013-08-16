package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import starling.core.Starling;
	[SWF(width="768",height="1024",frameRate="60",backgroundColor="#4a4137")]
	public class ExtendFeathers extends Sprite
	{
		private var _star:Starling;
		public function ExtendFeathers()
		{
			if(!stage)
				addEventListener(Event.ADDED_TO_STAGE, initialize);
			else
				initialize();
		}
		
		private function initialize(e:Event=null):void
		{
			if(e)
				removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_star = new Starling(Main, stage);
			_star.showStats = true;
			_star.enableErrorChecking = true;
			_star.start();
		}
	}
}