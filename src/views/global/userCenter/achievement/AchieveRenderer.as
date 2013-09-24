package views.global.userCenter.achievement
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	
	public class AchieveRenderer extends DefaultListItemRenderer
	{
		public function AchieveRenderer()
		{
			super();
		}
		
		public var source:Object;
		/**
		 * [name, content, isCompleted]
		 */		
		private var _achieveData:String;
		public function set achieveData(value:String):void
		{
			if(_achieveData && _achieveData == value)
				return;
			_achieveData = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		public function get achieveData():String
		{
			return _achieveData;
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
		}
	}
}