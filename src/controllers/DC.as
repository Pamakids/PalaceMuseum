package controllers
{
	import com.pamakids.utils.Singleton;
	
	import models.AchieveVO;
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
			so.completeModule(mc.moduleIndex);
		}

		public static function get instance():DC
		{
			return Singleton.getInstance(DC);
		}

		public function testCollectionIsOpend(id:String):Boolean
		{
			return so.getSO("collection_card_" + id + "_collectioned");
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
			var _achidatas:Array=[];
			var arr:Array=AchieveVO.achieveList;
			const max:int=arr.length;
			var i:int;
			for (i=0; i < max; i++)
			{
				if(arr[i])
					_achidatas.push([arr[i][0], arr[i][1], (SOService.instance.getSO(i + "_achieve")) ? 1 : 0])
			}
			return _achidatas;
		}

		/**
		 * 游戏数据名称集合
		 */
		private const classNames:Array=["menugame", "dishgame", "jigSawgame", "operagame"];
		private const gameNames:Array=["吉祥菜名", "银牌试毒", "地图拼图", "粉墨登场"];
		/**
		 * 游戏是否有难度区分:0 有， 1 没有
		 */
		private const gameLevels:Array=[1, 0, 1, 1];

		/**
		 * 获取游戏数据
		 * @return
		 * 	[
		 * 		{name: "gameName", iconIndex: 1, resultEasy: "", resultHard: "", isOpend: false },
		 * 		{name: "gameName", iconIndex: 1, resultEasy: "", resultHard: "", isOpend: false },
		 * 		{name: "gameName", iconIndex: 1, resultEasy: "", resultHard: "", isOpend: false }
		 * 	]
		 */
		public function getGameDatas():Array
		{
			var datas:Array=[];
			var obj:Object;
			for (var i:int=0; i < 4; i++)
			{
				obj={
						name: gameNames[i],
						className: classNames[i],
						iconIndex: i,
						numStars: 0
					};
				obj.isOpend = SOService.instance.getSO(obj.className);
				if (gameLevels[i] == 0) //无难度划分
				{
					if (SOService.instance.getSO(obj.className))
					{
						obj.resultEasy=SOService.instance.getSO(obj.className + "gameresult");
						obj.resultHard="000000";
					}
					else
					{
						obj.resultEasy="000000";
						obj.resultHard="000000";
					}
				}
				else
				{
					if (SOService.instance.getSO(obj.className + 0))
						obj.resultEasy=SOService.instance.getSO(obj.className + "gameresult" + 0);
					else
						obj.resultEasy="000000";

					if (SOService.instance.getSO(obj.className + 1))
						obj.resultHard=SOService.instance.getSO(obj.className + "gameresult" + 1);
					else
						obj.resultHard="000000";
				}
				delete obj.className;
				datas.push(obj);
			}
			return datas;
		}
	}
}
