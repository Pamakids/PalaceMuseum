package models
{
	import com.pamakids.models.BaseVO;

	/**
	 * 游戏记录，玩一次提交一次
	 * @author mani
	 */
	public class GameVO extends BaseVO
	{
		public function GameVO()
		{
			super();
		}

		/**
		 * 游戏编号
		 */
		public var id:String;

		/**
		 * 游戏时间
		 */
		public var time:String;
		/**
		 * 游戏分数
		 */
		public var score:String;
	}
}
