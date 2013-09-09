package controllers
{
	import com.pamakids.utils.Singleton;
	
	import models.SOService;

	/**
	 * 数据中心，除了本地数据缓存之外也包括同服务器通信
	 * @author mani
	 */
	public class DC extends Singleton
	{

		private var so:SOService;
		private var mc:MC;

		public var taskes:Array;

		public function DC()
		{
			so=SOService.instance;
			mc=MC.instance;
		}

		/**
		 * 模块完成
		 */
		public function completeModule():void
		{
			so.completeModule();
		}

		public static function get instance():DC
		{
			return Singleton.getInstance(DC);
		}
		
		/**
		 * 用户中心相关数据变更
		 * @param type
		 * 			0	用户属性变化
		 * 			1	成就
		 * 			2	物品收集数据
		 * 			3	小游戏数据
		 * @param value
		 */		
		public function setDatas(type:int, value:Object):void
		{
			
			switch(type)
			{
				case 0:		//用户数据变更
					break;
				case 1:		//用户新成就
					break;
				case 2:		//新收集到物品
					break;
				case 3:		//小游戏数据
					break;
			}
			
			SOService.instance.setSO("","");
		}
	}
}
