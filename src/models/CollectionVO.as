package models
{
	/**
	 * 物品收集数据
	 * @author Administrator
	 */	
	public class CollectionVO
	{
		public function CollectionVO()
		{
		}
		
		public var id:String;
		public var content:String;
		public var name:String;
		public var explain:String;
		public var isCollected:Boolean = false;
		
	}
}