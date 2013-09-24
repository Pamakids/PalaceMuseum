package views.components
{
	import flash.text.TextFormat;
	
	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	
	import models.FontVo;
	
	import starling.display.Image;
	
	import views.global.userCenter.UserCenterManager;

	/**
	 * 时间更改组件，时间单位最小至“天”
	 * @author Administrator
	 */	
	public class DateChangeDevice extends FeathersControl
	{
		public function DateChangeDevice()
		{
		}
		
		override protected function initialize():void
		{
			initImages();
			initLists();
		}
		
		private var loopnumY:LoopNumList;
		private var loopnumM:LoopNumList;
		private var loopnumD:LoopNumList;
		private function initLists():void
		{
			loopnumY = new LoopNumList(1960, 2014);
			this.addChild( loopnumY );
			loopnumY.x = 68;
			loopnumY.y = 2;
			
			loopnumM = new LoopNumList(1, 12);
			this.addChild( loopnumM );
			loopnumM.x = 184;
			loopnumM.y = 2;
			
			loopnumD = new LoopNumList(1, 30);
			this.addChild( loopnumD );
			loopnumD.x = 276;
			loopnumD.y = 2;
		}		
		
		private function initImages():void
		{
			var image:Image = new Image(UserCenterManager.getTexture("background_date"));
			this.addChild( image );
			image.y = 35;
			image.touchable = false;
			
			image = new Image(UserCenterManager.getTexture("background_date_year"));
			this.addChild( image );
			image.x = 60;
			image.touchable = false;
			
			image = new Image(UserCenterManager.getTexture("background_date_day"));
			this.addChild( image );
			image.x = 174;
			image.touchable = false;
			
			image = new Image(UserCenterManager.getTexture("background_date_day"));
			this.addChild( image );
			image.x = 266;
			image.touchable = false;
		}
		
		/**
		 * 设置时间显示范围
		 * @param min
		 * @param max
		 */		
		public function setMinToMax(min:Date, max:Date):void
		{
		}
		
		private var _crtDate:Date = new Date();
		public function get crtDate():Date
		{
			return crtDate;
		}
		public function set crtDate(date:Date):void
		{
			_crtDate = date;
		}
		
		private var _maxDate:Date = new Date(2014, 12, 31);;
		public function set maxDate(date:Date):void
		{
			_maxDate = date;
		}
		
		private var _minDate:Date = new Date(1960, 01, 01);
		public function set minDate(date:Date):void
		{
			_minDate = date;
		}
		
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}