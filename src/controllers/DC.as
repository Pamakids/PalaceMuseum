package controllers
{
	import com.pamakids.utils.Singleton;
	
	import models.AchieveVO;
	import models.CollectionVO;
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
		 * 			1	成就解锁
		 * 			2	物品收集
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
			so.setSO("","");
		}
		
		/**
		 * 物品收集数据：Array
		 * [
		 * 		["name", ifCollected],
		 * 		["name", ifCollected],
		 * 		...
		 * ]
		 */		
		public function getCollectionData():Array
		{
			var _collectionData:Array = [];
			var i:int;
			for each(var s:String in CollectionVO.vecCardName)
			{
				i = (SOService.instance.getSO(s + "collected"))?1:0;
				_collectionData.push( [s, i] );
			}
			return _collectionData;
		}
		
		/**
		 * 成就数据：Array
		 * [
		 * 		["name", "content", ifCollected],
		 * 		["name", "content", ifCollected],
		 * 		...
		 * ]
		 */	
		public function getAchievementData():Array
		{
			var _achidatas:Array = [];
			var arr:Array = AchieveVO.achieveList;
			const max:int = arr.length;
			var i:int;
			for(i = 0;i<max;i++)
			{
				_achidatas.push( [arr[i][0], arr[i][1], (SOService.instance.getSO(i + "_achieve"))?1:0] )
			}
			return _achidatas;
		}
	}
}
