package {
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="800",height="600",backgroundColor="0x66ccff")]
	public class NAPEDemo extends Sprite {
		
		public function NAPEDemo():void {
			if (stage != null) {
				initialise(null);
			}
			else {
				addEventListener(Event.ADDED_TO_STAGE, initialise);
			}
		}
		
		private function initialise(ev:Event):void {
			if (ev != null) {
				removeEventListener(Event.ADDED_TO_STAGE, initialise);
			}
			
			this.addChild(new HelloNape());
		}
	}
}