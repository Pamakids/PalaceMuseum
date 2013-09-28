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
		
		/**
		 * 游戏数据名称集合
		 */	
		private const classNames:Array = ["jigSawGame", "menuGame", "dishGame", "operaGame" ];
		private const gameNames:Array = [ "地图拼图", "吉祥菜名", "银牌试毒", "粉墨登场" ];
		/**
		 * 游戏是否有难度区分:0 有， 1 没有
		 */		
		private const gameLevels:Array = [1, 0, 1, 1];
		/**
		 * 获取游戏数据
		 * @return 
		 * 	[
		 * 		{name: "gameName", iconIndex: 1, resultEasy: "", resultHard: "" },
		 * 		{name: "gameName", iconIndex: 1, resultEasy: "", resultHard: "" },
		 * 		{name: "gameName", iconIndex: 1, resultEasy: "", resultHard: "" }
		 * 	]
		 */		
		public function getGameDatas():Array
		{
			var datas:Array = [];
			var obj:Object;
			for(var i:int = 0;i<4;i++)
			{
				obj = {
					name:		gameNames[i],
					className:	classNames[i],
					iconIndex:	i,
					numStars:	0
				};
				if(gameLevels[i] == 0)		//无难度划分
				{
					if(SOService.instance.getSO(obj.className))
					{
						obj.resultEasy = SOService.instance.getSO(obj.className);
						obj.resultHard = "----------";
					}
					else
					{
						obj.resultEasy = "----------";
						obj.resultHard = "----------";
					}
				}
				else
				{
					if(SOService.instance.getSO(obj.className + 0))
						obj.resultEasy = SOService.instance.getSO(obj.className + 0);
					else
						obj.resultEasy = "----------";
					
					if(SOService.instance.getSO(obj.className + 1))
						obj.resultHard = SOService.instance.getSO(obj.className + 1);
					else
						obj.resultHard = "----------";
				}
				delete obj.className;
				datas.push( obj );
			}
			return datas;
		}
	}
}
