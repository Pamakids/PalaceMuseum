package views.global.userCenter.userInfo
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	import starling.display.Image;
	
	import views.global.userCenter.UserCenterManager;
	
	public class IconListRenderer extends DefaultListItemRenderer
	{
		public function IconListRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			var image:Image = UserCenterManager.getImage("background_icon_1");
			this.width = image.width;
			this.height = image.height;
			this.addChild( image );
			image.touchable = false;
			
			headIcon = new HeadIcon("0");
			this.addChild( headIcon );
			headIcon.x = headIcon.y = 60;
			headIcon.scaleX = headIcon.scaleY = 100/137;
			headIcon.touchable = true
		}
		
		private var headIcon:HeadIcon;
		override protected function draw():void
		{
			const dataChange:Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			if(dataChange)
			{
				headIcon.resetIcon(data.icon);
			}
		}
		
		override public function dispose():void
		{
			if(headIcon)
				headIcon.removeFromParent(true);
			super.dispose();
		}
	}
}