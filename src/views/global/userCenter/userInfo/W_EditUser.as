package views.global.userCenter.userInfo
{
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	
	import starling.display.Image;
	import starling.events.Event;
	
	import views.components.DateChangeDevice;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 用户编辑窗口
	 * 		修改头像
	 * 		修改用户名
	 * 		修改出生日期
	 * @author Administrator
	 */	
	public class W_EditUser extends FeathersControl
	{
		/**
		 * @param value
		 * { username: "name", iconIndex: i, birthday: "2013-01-11"},
		 */		
		public function W_EditUser(value:Object)
		{
			this.userdata = value;
		}
		private var userdata:Object;
		
		override protected function initialize():void
		{
			initBackImages();
			initUserView();
			initButtons();
			initDateChangeDevice();
		}
		
		/**
		 * 日期修改组件
		 */		
		private var dateView:DateChangeDevice;
		private function initDateChangeDevice():void
		{
			dateView = new DateChangeDevice();
			dateView.setMinToMax(new Date(1960, 1, 1), new Date(2013, 12, 31));
			this.addChild( dateView );
			dateView.x = 65;
			dateView.y = 169;
		}
		
		private var button_close:Button;
		private var button_delete:Button;
		private var button_choose:Button;
		private function initButtons():void
		{
			button_close = new Button();
			button_close.defaultSkin = new Image(UserCenterManager.getTexture("button_close_small"));
			button_close.addEventListener(Event.TRIGGERED, closeWindow);
			this.addChild( button_close );
			button_close.x = 420;
			button_close.y = 20;
			
			button_delete = new Button();
			button_delete.defaultSkin = new Image(UserCenterManager.getTexture("button_deleteUser_up"));
			button_delete.downSkin = new Image(UserCenterManager.getTexture("button_deleteUser_down"));
			button_delete.addEventListener(Event.TRIGGERED, deleteUser);
			this.addChild( button_delete );
			button_delete.x = 44;
			button_delete.y = 310;
			
			button_choose = new Button();
			button_choose.defaultSkin = new Image(UserCenterManager.getTexture("button_agreeChange_up"));
			button_choose.downSkin = new Image(UserCenterManager.getTexture("button_agreeChange_down"));
			button_choose.addEventListener(Event.TRIGGERED, changeCrtUser);
			this.addChild( button_choose );
			button_choose.x = 260;
			button_choose.y = 310;
		}
		
		public var changeHandler:Function;
		private function changeCrtUser():void
		{
		}
		
		public var deleteHandler:Function;
		private function deleteUser():void
		{
			deleteHandler(this.userdata);
		}
		
		private var userview:ItemForUserList;
		private function initUserView():void
		{
			userview = new ItemForUserList(userdata, true, true);
			this.addChild( userview );
			userview.x = 46;
			userview.y = 37;
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
			if(userview)
				userview.removeFromParent(true);
			if(dateView)
				dateView.removeFromParent(true);
			if(button_close)
			{
				button_close.removeEventListener(Event.TRIGGERED, closeWindow);
				button_close.removeFromParent(true);
			}
			if(button_delete)
			{
				button_delete.removeEventListener(Event.TRIGGERED, deleteUser);
				button_delete.removeFromParent(true);
			}
			if(button_choose)
			{
				button_choose.removeEventListener(Event.TRIGGERED, changeCrtUser);
				button_choose.removeFromParent(true);
			}
			this.changeHandler = null;
			this.deleteHandler = null;
			this.closeWinHandler = null;
			super.dispose();
		}
		
		/**
		 * @param value
		 * { username: "name", iconIndex: i, birthday: "2013-01-11"},
		 */		
		public function resetData(value:Object):void
		{
			if(userdata && userdata == value)
				return;
			userdata = value;
			updateView();
		}
		
		private function updateView():void
		{
			userview.updateView();
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