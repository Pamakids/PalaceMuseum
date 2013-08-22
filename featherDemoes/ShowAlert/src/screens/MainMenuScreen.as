package screens
{
	import flash.events.KeyboardEvent;
	
	import controls.Alert;
	
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Screen;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class MainMenuScreen extends Screen
	{
		public static const DEFAULT_NAME_SHOW_BUTTON:String = "menuShowButton";
		public static const DEFAULT_NAME_HIDE_BUTTON:String = "menuHideButton";
		
		public function MainMenuScreen()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private var _header:Header;
		private var _showBtn:Button;
		private var _hideBtn:Button;
		private var _alert:Alert;
		
		override protected function initialize():void
		{
			_header = new Header();
			_header.title = "Menu";
			addChild( _header );
			
			_showBtn = new Button();
			_showBtn.label = "SHOW";
			_showBtn.addEventListener(Event.TRIGGERED, onTriggered);
			_header.leftItems = new <DisplayObject>[_showBtn];
			
			_hideBtn = new Button();
			_hideBtn.label = "HIDE";
			_hideBtn.addEventListener(Event.TRIGGERED, onTriggered);
			_header.rightItems = new <DisplayObject>[_hideBtn];
			
		}
		private var _i:int = 0;
		private function onTriggered(e:Event):void
		{
			switch(e.currentTarget)
			{
				case _showBtn:
					_i = 1 - _i;
					if(_i == 0)
						Alert.getInstance().showAlert("An alert has started! hahahahahahahahahahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhafsdfasdfasdfasdfasdfasdfaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhhhhhhhhhhhhh", "Titlehahahahahahahahahahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhafsdfasdfasdfasdfasdfasdfaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhhhhhhhhhhhhh","ok", [okFunc, cancleFunc], []);
					else
						Alert.getInstance().showAlert("Witch one?", "Titleshahahahahahahahahahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhafsdfasdfasdfasdfasdfasdfaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhhhhhhhhhhhhh", "ok_cancle", [okFunc, cancleFunc], []);
					this.invalidate(INVALIDATION_FLAG_STYLES);
					break;
				case _hideBtn:
					break;
			}
		}
		
		private function okFunc(obj:Object=null):void
		{
			trace("ok");
		}
		private function cancleFunc(obj:Object=null):void
		{
			trace("cancle");
		}
		
		override protected function draw():void
		{
			this._header.width = this.originalHeight;
			
			const stylesInvalidate:Boolean = isInvalid(INVALIDATION_FLAG_STYLES);
			if(stylesInvalidate)
			{
				if(this.contains(_alert))
				{
					_alert.y = 300;
					_alert.x = 768 - _alert.width >> 1;
				}
			}
		}
		
		private function addedToStageHandler():void
		{
			Starling.current.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler, false, 0, true);
		}
		
		private function removedFromStageHandler():void
		{
			Starling.current.nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, nativeStage_keyDownHandler);
		}
		
		protected function nativeStage_keyDownHandler(event:KeyboardEvent):void
		{
			
		}
	}
}