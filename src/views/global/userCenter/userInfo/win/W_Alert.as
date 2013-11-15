package views.global.userCenter.userInfo.win
{
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	
	import views.global.userCenter.UserCenterManager;

	/**
	 * 切换用户提示窗口
	 * @author Administrator
	 */	
	public class W_Alert extends FeathersControl
	{
		public function W_Alert()
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
			var text:TextField = new TextField(380, 200, "是否要变更当前的游戏角色？", FontVo.PALACE_FONT, 26, 0x932720);
			this.addChild( text );
			text.x = 50;
			text.y = 80;
			text.touchable = false;
		}
		
		private var button_ok:Button;
		private var button_cancle:Button;
		
		private function initButtons():void
		{
			button_ok = new Button();
			button_ok.defaultSkin = new Image(UserCenterManager.getTexture("button_ok_up"));
			button_ok.downSkin = new Image(UserCenterManager.getTexture("button_ok_down"));
			button_ok.addEventListener(Event.TRIGGERED, ok_handler);
			this.addChild( button_ok );
			button_ok.x = 270;
			button_ok.y = 300;
			
			button_cancle = new Button();
			button_cancle.defaultSkin = new Image(UserCenterManager.getTexture("button_cancle_up"));
			button_cancle.downSkin = new Image(UserCenterManager.getTexture("button_cancle_down"));
			button_cancle.addEventListener(Event.TRIGGERED, cancle_handler);
			this.addChild( button_cancle );
			button_cancle.x = 100;
			button_cancle.y = 300;
		}
		
		public var ok_handler:Function;
		public var cancle_handler:Function;
		
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
				button_ok.removeEventListener(Event.TRIGGERED, ok_handler);
				button_ok.removeFromParent(true);
			}
			if(button_cancle)
			{
				button_cancle.removeEventListener(Event.TRIGGERED, cancle_handler);
				button_cancle.removeFromParent(true);
			}
			this.ok_handler = null;
			this.cancle_handler = null;
			super.dispose();
		}
	}
}