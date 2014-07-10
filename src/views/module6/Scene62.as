package views.module6
{
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;
	import views.module6.scene62.ArcherGame;

	public class Scene62 extends PalaceScene
	{
		public function Scene62(am:AssetManager=null)
		{
			super(am);

			addBG('bg62');

			initGame();

//			initAreas();
//			addEventListener(TouchEvent.TOUCH,onTouch);
		}

		private function initAreas():void
		{
			// TODO Auto Generated method stub

		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(bg,TouchPhase.ENDED);
			if(!tc)
				return;

		}

		private function initGame():void
		{
			var game:ArcherGame=new ArcherGame(this.assetManager);
			addChild(game);
		}
	}
}

