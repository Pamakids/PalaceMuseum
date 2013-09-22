package views.global.userCenter.userInfo
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import views.global.userCenter.UserCenterManager;

	/**
	 * 选择用户窗口
	 * @author Administrator
	 */	
	public class W_ChooseUser extends FeathersControl
	{
		public function W_ChooseUser()
		{
		}
		
		override protected function initialize():void
		{
			initUserdatas();
			initBackImages();
			initUserList();
			initButtons();
			initButtonGroup();
		}
		
		private var buttons:ButtonGroup;
		private function initButtonGroup():void
		{
			var textureU:Texture = UserCenterManager.getTexture("button_editUser_up");
			var textureD:Texture = UserCenterManager.getTexture("button_editUser_down");
			buttons = new ButtonGroup();
			buttons.dataProvider = new ListCollection([
				{
					defaultIcon: new Image(textureU), downIcon: new Image(textureD), triggered: onTriggered
				},
				{
					defaultIcon: new Image(textureU), downIcon: new Image(textureD), triggered: onTriggered
				},
				{
					defaultIcon: new Image(textureU), downIcon: new Image(textureD), triggered: onTriggered
				}
			]);
			this.addChild( buttons );
			buttons.x = 324;
			buttons.y = 58;
			buttons.gap = 55;
		}
		
		
		private function onTriggered():void
		{
		}
		
		private var button_close:Button;
		private function initButtons():void
		{
			button_close = new Button();
			button_close.defaultSkin = new Image(UserCenterManager.getTexture("button_close_small"));
			button_close.addEventListener(TouchEvent.TOUCH, closeWindow);
			this.addChild( button_close );
			button_close.x = 420;
			button_close.y = 20;
		}
		
		private var items:Vector.<ItemForUserList>;
		private function initUserList():void
		{
			var item:ItemForUserList;
			const max:int = userDatas.length;
			items = new Vector.<ItemForUserList>(max);
			for(var i:int = 0;i<max;i++)
			{
				item = new ItemForUserList(userDatas[i]);
				this.addChild( item );
				item.x = 46;
				item.y = 37 + i * 116;
				items[i] = item;
			}
		}
		
		/**
		 * [
		 * 		{ username: "name", iconIndex: i, birthday: "2013-01-11"},
		 * 		{ username: "name", iconIndex: i, birthday: "2013-01-11"},
		 * 		{ username: "name", iconIndex: i, birthday: "2013-01-11"}
		 * ]
		 */		
		private var userDatas:Array;
		private function initUserdatas():void
		{
			userDatas = [];
			for(var i:int = 0;i<3;i++)
			{
				userDatas.push(
					{ username: "name", iconIndex: i, birthday: "2013-01-11"}
				);
			}
		}
		
		private function initBackImages():void
		{
			var image:Image = new Image(UserCenterManager.getTexture("background_win_1"));
			this.addChild( image );
			this.width = image.width;
			this.height = image.height;
		}
		
		override public function dispose():void
		{
		}
		
		public var closeWinHandler:Function = defaultCloseHandler;
		private function closeWindow(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this.button_close);
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				closeWinHandler(this);
			}
		}
		private function defaultCloseHandler(obj:Object):void
		{
			if(parent)
				parent.removeChild( this );
			this.dispose();
		}
	}
}