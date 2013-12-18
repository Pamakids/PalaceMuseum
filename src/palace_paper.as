package
{
	import flash.display.Sprite;
	import flash.events.Event;

	import Firefly.Paper;

	import models.Config;
	import models.DrawingManager;
	import models.PosVO;
	import models.StateManager;

	import org.agony2d.Agony;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.enum.ButtonEffectType;

	public class palace_paper extends Sprite
	{
		public function palace_paper(index:int=0, onComplete:Function=null)
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			trace(index)
			Config.SCENE_INDEX=index
			Config.onComplete=onComplete
		}

		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage)

			if (!mInited)
			{
				this.doInitAgony2d()
				this.doInitAgonyUI()
				mInited=true
			}
			this.doInitModel()
		}

		private static var mInited:Boolean

		private function doInitAgony2d():void
		{
			Agony.startup(stage, 1024, 768, "medium")
		}

		private function doInitAgonyUI():void
		{
			AgonyUI.startup(false, true)
			AgonyUI.setButtonEffectType(ButtonEffectType.LEAVE_PRESS)
		}


		private function doInitModel():void
		{
//			DrawingManager.getInstance().initialize()
			StateManager.setGameScene(true)


//			var paper:Paper = new Paper()
//			paper.y = 35 + 127
//			stage.addChild(paper)
		}

	}
}
