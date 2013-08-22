package
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.OldFadeNewSlideTransitionManager;
	
	import screens.MainMenuScreen;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import themes.MetalWorksMobileTheme;
	
	public class Main extends Sprite
	{
		private static const MENU_SCREEN:String = "menuScreen";
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private var _navigator:ScreenNavigator;
		private var _transitionManager:OldFadeNewSlideTransitionManager;
		
		private function addedToStageHandler(event:Event):void
		{
//			new ShowAlertThemes();
			new MetalWorksMobileTheme();
			
			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);
			
			this._navigator.addScreen(MENU_SCREEN, new ScreenNavigatorItem(MainMenuScreen));
			
			this._transitionManager = new OldFadeNewSlideTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;
			this._navigator.showScreen(MENU_SCREEN);
		}
	}
}