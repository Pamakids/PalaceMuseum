package views.global.userCenter.userInfo
{
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import views.global.userCenter.UserCenterManager;
	
	public class W_DeleteUser extends FeathersControl
	{
		public function W_DeleteUser()
		{
		}
		
		override protected function initialize():void
		{
			initBackImages();
			initButtons();
			initTextField();
		}
		
		private function initTextField():void
		{
			var text:TextField = new TextField(380, 200, "删除角色后，该角色的游戏进度也将一并删除！", FontVo.PALACE_FONT, 26, 0x932720);
			this.addChild( text );
			text.x = 50;
			text.y = 80;
			text.touchable = false;
		}
		
		public var userdata:Object;
		private var button_close:Button;
		private var button_ok:Button;
		private var button_cancle:Button;
		
		private function initButtons():void
		{
			button_close = new Button();
			button_close.defaultSkin = new Image(UserCenterManager.getTexture("button_close_small"));
			button_close.addEventListener(Event.TRIGGERED, closeWindow);
			this.addChild( button_close );
			button_close.x = 420;
			button_close.y = 20;
			
			button_ok = new Button();
			button_ok.defaultSkin = new Image(UserCenterManager.getTexture("button_ok_up"));
			button_ok.downSkin = new Image(UserCenterManager.getTexture("button_ok_down"));
			button_ok.addEventListener(Event.TRIGGERED, deleteUser);
			this.addChild( button_ok );
			button_ok.x = 270;
			button_ok.y = 300;
			
			button_cancle = new Button();
			button_cancle.defaultSkin = new Image(UserCenterManager.getTexture("button_cancle_up"));
			button_cancle.downSkin = new Image(UserCenterManager.getTexture("button_cancle_down"));
			button_cancle.addEventListener(Event.TRIGGERED, closeWindow);
			this.addChild( button_cancle );
			button_cancle.x = 100;
			button_cancle.y = 300;
		}
		
		private function deleteUser():void
		{
			deleteHandler(this.userdata);
			closeWindow();
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
			if(button_ok)
			{
				button_ok.removeEventListener(Event.TRIGGERED, deleteUser);
				button_ok.removeFromParent(true);
			}
			if(button_cancle)
			{
				button_cancle.removeEventListener(Event.TRIGGERED, closeWindow);
				button_cancle.removeFromParent(true);
			}
			if(button_close)
			{
				button_close.removeEventListener(Event.TRIGGERED, closeWindow);
				button_close.removeFromParent(true);
			}
			this.userdata = null;
			this.closeWinHandler = null;
			this.deleteHandler = null;
			super.dispose();
		}
		
		public var closeWinHandler:Function = defaultCloseHandler;
		private function closeWindow():void
		{
			closeWinHandler(this);
		}
		private function defaultCloseHandler(obj:Object):void
		{
			if(parent)
				parent.removeChild( this );
			this.dispose();
		}
		
		public var deleteHandler:Function;
	}
}