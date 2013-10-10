package views.global.userCenter.userInfo
{
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.core.FeathersControl;
	import feathers.data.ListCollection;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
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
			initTitle();
			initUserList();
			initButtons();
			initButtonGroup();
		}
		
		/**
		 * 被选中的标记
		 */		
		private var seclectedTitle:Image;
		private function initTitle():void
		{
			seclectedTitle = new Image(UserCenterManager.getTexture("background_selected_icon"));
			this.addChild(seclectedTitle);
			seclectedTitle.visible = false;
			seclectedTitle.touchable = false;
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
			var info:Object = userDatas[buttons.getChildIndex( e.currentTarget as DisplayObject)];
			editHandler( info );
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
				data = userDatas[i];
				item = new ItemForUserList(data);
				item.touchable = true;
				this.addChild( item );
				item.x = 46;
				item.y = 37 + i * 116;
				items[i] = item;
				item.addEventListener(Event.TRIGGERED, changeCtrUser);
				
				//检测是否为当前用户，是则将选中标记位置移动至item位置
				if(true)
				{
					seclectedTitle.x = 32;
					seclectedTitle.y = 28;
					seclectedTitle.visible = true;
				}
			}
		}
		private function changeCtrUser(e:Event):void
		{
			//提示用户切换用户
			if(!e.data)		//无角色
				return;
//			if(true)		//验证为当前用户
//				return;
			trace("切换用户");
			changeCtrUserHandler(e.data)
		}
		
		public var changeCtrUserHandler:Function;
		
		private const maxUserNum:int = 3;
		
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
			//获取用户所有角色数据
			userDatas = [];
			for(var i:int = 0;i<2;i++)
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
			image.touchable = false;
		}
		
		override public function dispose():void
		{
			if(button_close)
			{
				button_close.removeEventListener(Event.TRIGGERED, closeWindow);
				button_close.removeFromParent(true);
			}
			if(buttons)
				buttons.removeFromParent(true);
			if(items)
			{
				for(var i:int = items.length-1;i>=0;i--)
				{
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