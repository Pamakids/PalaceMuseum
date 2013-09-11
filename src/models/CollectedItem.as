package models
{
	import com.pamakids.models.BaseVO;

	/**
	 * 收集物品
	 * @author mani
	 */
	public class CollectedItem extends BaseVO
	{
		public function CollectedItem()
		{
			super();
		}

		/**
		 * 物品ID
		 */
		public var id:String;
		/**
		 * 物品名称
		 */
		public var name:String;
		/**
		 * 物品相对路径
		 */
		public var url:String;
		/**
		 * 物品等级
		 */
		public var level:int;
	}
}
