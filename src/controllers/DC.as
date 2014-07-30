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
//			return true;
			return so.getSO("collection_card_" + id + "collected");
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
			var t:Array;
			var _achidatas:Array=[];
			var arr:Array=AchieveVO.achieveList;
			const max:int=arr.length;
			var i:int;
			for (i=0; i < max; i++)
			{
				t=arr[i];
				if (t)
//					_achidatas.push([t[0], t[1], 1])
					_achidatas.push([t[0], t[1], (SOService.instance.getSO(i + "_achieve")) ? 1 : 0])
			}
			return _achidatas;
		}

		/**
		 * 游戏数据名称集合
		 */
		private const classNames:Array=["archergame", "menugame", "dishgame", "operagame"];
		private const gameNames:Array=["百步穿杨", "吉祥菜名", "银牌试毒", "粉墨登场"];
//		private const classNames:Array=["menugame", "dishgame", "jigsawgame", "operagame"];
//		private const gameNames:Array=["吉祥菜名", "银牌试毒", "地图拼图", "粉墨登场"];
		/**
		 * 游戏是否有难度区分:0 有， 1 没有
		 */
		private const gameLevels:Array=[1, 1, 1, 1];

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
			for (var i:int=0; i < classNames.length; i++)
			{
				obj={
						name: gameNames[i],
						className: classNames[i],
						iconIndex: i,
						numStars: 0
					};
				obj.isOpend=SOService.instance.getSO(obj.className);
				var ns:int=SOService.instance.getSO(obj.className + "NumStars") as int;
				obj.numStars=ns ? ns : 0;
				if (gameLevels[i] == 0) //无难度划分
				{
					if (SOService.instance.getSO(obj.className))
					{
						var res:int=SOService.instance.getSO(obj.className + "gameresult") as int;
						obj.resultEasy=res ? res.toString() : "000000";
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
					if (SOService.instance.getSO(obj.className))
					{
						var res2:int=SOService.instance.getSO(obj.className + "gameresult0") as int;
						obj.resultEasy=res2 ? res2.toString() : "000000";
						var res3:int=SOService.instance.getSO(obj.className + "gameresult1") as int;
						obj.resultHard=res3 ? res3.toString() : "000000";
					}
					else
					{
						obj.resultEasy="000000";
						obj.resultHard="000000";
					}
				}
				delete obj.className;
				datas.push(obj);
			}
			return datas;
		}
	}
}


