package views.module2.scene23
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import starling.display.Image;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;

	public class ShootGame extends PalaceGame
	{

		private var bgW:Number;

		private var bg1:Image;

		private var bg2:Image;
		public function ShootGame(am:AssetManager=null)
		{
			super(am);

			initBG();
			initPlayer();

			initTargets();

			startPlay();
		}

		private function placeTarget():void
		{

		}

		private function startPlay():void
		{
//			timer=new Timer(17);
//			timer.addEventListener(TimerEvent.TIMER,onTimer);
//			timer.start();
			addEventListener(Event.ENTER_FRAME,onPlaying);
		}

		protected function onTimer(event:TimerEvent):void
		{
			onPlaying();
		}

		private function onPlaying():void
		{
			bg1.x-=speed;
			bg2.x-=speed;

			if(bg1.x<-bgW)
				bg1.x=bg2.x+bgW;

			else if(bg2.x<-bgW)
				bg2.x=bg1.x+bgW;
		}

		private var speed:Number=10;

		private function initBG():void
		{
			bg1=getImage('bg');
			bg2=getImage('bg');
			bgW=bg1.width;

			bg2.x=bgW;

			addChild(bg1);
			addChild(bg2);
		}

		private function initPlayer():void
		{

		}

		private function initTargets():void
		{

		}

	}
}

