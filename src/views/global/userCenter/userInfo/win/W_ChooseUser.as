package views.global.userCenter.userInfo.win
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	
	import models.SOService;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import views.global.userCenter.UserCenterManager;
	import views.global.userCenter.userInfo.ItemForUserList;

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
			initBackImages();
			initSeclectedTitle();
			initUserList();
			initButtons();
			initButtonGroup();
		}
		
		override protected function draw():void
		{
			initUserdatas();
			selectedTitle.x = 32;
			selectedTitle.y = 28 + SOService.instance.getLastUser()*116;
			for(var i:int = 0;i<maxUserNum;i++)
			{
				items[i].resetData(this.userDatas[i]);
			}
		}
		
		/**
		 * 被选中的标记
		 */		
		private var selectedTitle:Image;
		private function initSeclectedTitle():void
		{
			selectedTitle = new Image(UserCenterManager.getTexture("background_selected_icon"));
			this.addChild(selectedTitle);
			selectedTitle.touchable = false;
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
		
		public var editHandler:Function;
		private function onTriggered(e:Event):void
		{
			editHandler( buttons.getChildIndex( e.currentTarget as DisplayObject) );
		}
		
		private var button_close:Button;
		private function initButtons():void
		{
			button_close = new Button();
			button_close.defaultSkin = new Image(UserCenterManager.getTexture("button_close_small"));
			button_close.addEventListener(Event.TRIGGERED, closeWindow);
			this.addChild( button_close );
			button_close.x = 420;
			button_close.y = 20;
		}
		
		private var items:Vector.<ItemForUserList>;
		private function initUserList():void
		{
			var item:ItemForUserList;
			var data:Object;
			items = new Vector.<ItemForUserList>(maxUserNum);
			for(var i:int = 0;i<maxUserNum;i++)
			{
				item = new ItemForUserList(/*data*/);
				item.touchable = true;
				this.addChild( item );
				item.x = 46;
				item.y = 37 + i * 116;
				items[i] = item;
				item.addEventListener(Event.TRIGGERED, changeCtrUser);
			}
		}
		private function changeCtrUser(e:Event):void
		{
			//提示用户切换用户
			if(!e.data)		//无角色
				return;
			var index:int = items.indexOf(e.currentTarget as ItemForUserList);
			if(SOService.instance.getLastUser() == index)		//验证为当前用户
				return;
			changeCtrUserHandler(index);
		}
		public var changeCtrUserHandler:Function;
		
		private const maxUserNum:int = 3;
		
		/**
		 * [
		 * 		{ username: "name", avatarIndex: i, birthday: "2013-01-11"},
		 * 		{ username: "name", avatarIndex: i, birthday: "2013-01-11"},
		 * 		{ username: "name", avatarIndex: i, birthday: "2013-01-11"}
		 * ]
		 */		
		private var userDatas:Vector.<Object>;
		private function initUserdatas():void
		{
			//获取用户所有角色数据
			userDatas = SOService.instance.getUserInfoList();
		}
		
		private function initBackImages():void
		{
			var image:Image = new Image(UserCenterManager.getTexture("background_win_1"));
			this.addChild( image );
			this.width = image.width;
			this.height = image.height;
			image.touchable = false;
		}
		
		override public function dispose():void
		{
			if(button_close)
			{
				button_close.removeEventListener(Event.TRIGGERED, closeWindow);
				button_close.removeFromParent(true);
			}
			if(selectedTitle)
				selectedTitle.removeFromParent(true);
			if(buttons)
				buttons.removeFromParent(true);
			if(items)
			{
				for(var i:int = items.length-1;i>=0;i--)
				{
					items[i].removeEventListener(Event.TRIGGERED, changeCtrUser);
					items[i].removeFromParent(true);
					items[i] = null;
				}
				items = null;
			}
			this.userDatas = null;
			this.editHandler = null;
			this.closeWinHandler = null;
			super.dispose();
		}
		
		public var closeWinHandler:Function = defaultCloseHandler;
		private function closeWindow(e:Event):void
		{
			closeWinHandler(this);
		}
		private function defaultCloseHandler(obj:Object):void
		{
			if(parent)
				parent.removeChild( this );
			this.dispose();
		}
	}
}