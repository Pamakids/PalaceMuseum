package models
{
	import org.agony2d.Agony;
	import org.agony2d.input.KeyboardManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.enum.LayoutType;
	
	import states.GameBottomUIState;
	import states.GameSceneUIState;
	import states.GameTopUIState;
	import states.PlayerSceneUIState;
	import states.PlayerTopAndBottomUIState;

	public class StateManager
	{
		
		private static var mGameSceneExists:Boolean
		public static function setGameScene( enabled:Boolean ) : void{
			if(!mGameSceneExists){
				mGameSceneExists = true
				AgonyUI.addModule("GameScene", GameSceneUIState)
//				AgonyUI.addModule("GameBottom", GameBottomUIState)
				AgonyUI.addModule("GameTop", GameTopUIState)
			}
			
			if(enabled){
				//Agony.stage.frameRate = 30
				AgonyUI.getModule("GameTop").init(-1, null, false,false)
				AgonyUI.getModule("GameScene").init(-1, [0], false,false)
//				if(!Agony.isMoblieDevice){
//					AgonyUI.getModule("GameBottom").init(-1, null, false, false, 0, -100, 1, LayoutType.F__AF)
//				}
//				else{
//					AgonyUI.getModule("GameBottom").init(-1, null, false, false, 0, 0, 1, LayoutType.F__AF)
//				}
				
				
			}
			else{
				//Agony.stage.frameRate = 45
				AgonyUI.getModule("GameScene").exit()
//				AgonyUI.getModule("GameBottom").exit()
				AgonyUI.getModule("GameTop").exit()
				DrawingManager.getInstance().paper.dispose()
				
			}
		}
	}
}