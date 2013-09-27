package views.global.userCenter.achievement
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	public class AchieveRenderer extends DefaultListItemRenderer
	{
		public function AchieveRenderer()
		{
			super();
		}
		
		override protected function initialize():void
		{
			achieveIcon = new AchieveIcon();
			this.addChild( achieveIcon );
		}
		
		private var achieveIcon:AchieveIcon;
		override protected function draw():void
		{
			const dataChange:Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			if(dataChange)
			{
				achieveIcon.data = this.data;
			}
		}
		
		override public function dispose():void
		{
			if(achieveIcon)
				achieveIcon.removeFromParent(true);
			super.dispose();
		}
	}
}