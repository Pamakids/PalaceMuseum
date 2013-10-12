package views.components
{
	import feathers.core.FeathersControl;
	
	import starling.display.Image;
	import starling.events.Event;
	
	import views.global.userCenter.UserCenterManager;

	/**
	 * 时间更改组件，时间单位最小至“天”
	 * @author Administrator
	 */	
	public class DateChangeDevice extends FeathersControl
	{
		/**
		 * 时间修改组件
		 * @param minY	年份下限
		 * @param maxY	年份上限
		 * 
		 */		
		public function DateChangeDevice(minY:int, maxY:int)
		{
			this._maxDate = new Date(maxY, 11, 31);
			this._minDate = new Date(minY, 0, 1);
		}
		
		override protected function initialize():void
		{
			initImages();
			initLists();
			
			if(!cacheDate)
				cacheDate = new Date(loopnumY.getCrtNum(), loopnumM.getCrtNum()-1, loopnumD.getCrtNum());
		}
		
		private var loopnumY:LoopNumList;
		private var loopnumM:LoopNumList;
		private var loopnumD:LoopNumList;
		private function initLists():void
		{
			loopnumY = new LoopNumList(_minDate.fullYear, _maxDate.fullYear);
			this.addChild( loopnumY );
			loopnumY.x = 68;
			loopnumY.y = 2;
			
			loopnumM = new LoopNumList(1, 12);
			this.addChild( loopnumM );
			loopnumM.x = 184;
			loopnumM.y = 2;
			
			loopnumD = new LoopNumList(1, 31);
			this.addChild( loopnumD );
			loopnumD.x = 276;
			loopnumD.y = 2;
			
			loopnumY.addEventListener(Event.CHANGE, onChanged);
			loopnumM.addEventListener(Event.CHANGE, onChanged);
			loopnumD.addEventListener(Event.CHANGE, onChanged);
		}		
		
		/**
		 * 临时存储的日期
		 */		
		private var cacheDate:Date;
		private function onChanged(e:Event):void
		{
			var date:Date;
			switch(e.currentTarget)
			{
				case loopnumY:		//年份变更
					cacheDate.fullYear = int(e.data);
					if(cacheDate.month == 1)		//2月需变更天数
					{
						date = new Date(cacheDate.fullYear, cacheDate.month+1);
						date.time-=1;
						loopnumD.resetMinToMax(1, date.date);
					}
					break;
				case loopnumM:		//月份变更，并计算该月总天数
					cacheDate.month = int(e.data)-1;
					date = new Date(cacheDate.fullYear, cacheDate.month+1);
					date.time-=1;
					loopnumD.resetMinToMax(1, date.date);
					break;
				case loopnumD:		//日期变更
					cacheDate.date = int(e.data)-1;
					break;
			}
			dispatchEventWith(Event.CHANGE, false, cacheDate);
		}
		
		public function getCrtDate():Date
		{
			return cacheDate;
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
		
		private var _maxDate:Date;
		private var _minDate:Date;
		
		/**
		 * 当前时间
		 */		
		public function setCrtDate(date:Date):void
		{
			if(date > _maxDate || date < _minDate)
				throw new Error("范围超出");
			cacheDate = new Date(date.fullYear, date.month, date.date);
			loopnumY.setCrtNum(cacheDate.fullYear);
			loopnumM.setCrtNum(cacheDate.month+1);
			loopnumD.setCrtNum(cacheDate.date);
		}
		
		override public function dispose():void
		{
			if(cacheDate)
				cacheDate = null;
			if(loopnumY)
				loopnumY.removeFromParent(true);
			if(loopnumM)
				loopnumM.removeFromParent(true);
			if(loopnumD)
				loopnumD.removeFromParent(true);
			super.dispose();
		}
	}
}