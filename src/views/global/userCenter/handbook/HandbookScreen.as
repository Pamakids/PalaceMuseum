package views.global.userCenter.handbook
{
	import feathers.controls.Screen;
	import feathers.events.FeathersEventType;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import views.global.userCenter.UserCenterManager;

	/**
	 * 用户中心速成手册场景
	 * @author Administrator
	 * 
	 */	
	public class HandbookScreen extends Screen
	{
		private var leftTexture:Texture;
		private var rightTexture:Texture;
		private var left:Image;
		private var right:Image;
		
		public function HandbookScreen()
		{
			super();
		}
		
		private function initializeHandler(e:Event):void
		{
		}
		
		override protected function initialize():void
		{
			this.touchable = false;
			leftTexture = UserCenterManager.assetsManager.getTexture("content_left");
			rightTexture = UserCenterManager.assetsManager.getTexture("content_right");
			left = new Image(leftTexture);
			this.addChild(left);
			right = new Image(rightTexture);
			this.addChild(right);
		}
		
		override protected function draw():void
		{
			right.x = leftTexture.frame.width;
		}
		
		override public function dispose():void
		{
			if(left)
				left.dispose();
			if(right)
				right.dispose();
			if(leftTexture)
				leftTexture.dispose();
			if(rightTexture)
				rightTexture.dispose();
			super.dispose();
		}
	}
}