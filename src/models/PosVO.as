package models
{
	import utils.DPIUtil;

	public class PosVO
	{
		private static var arr:Array;

		public function PosVO()
		{
		}

		public static function init():void
		{
			arr=DPIUtil.getAndroidSize();
		}

		public static function get scale():Number
		{
			return arr[0];
		}

		public static function get OffsetX():Number
		{
			return arr[1];
		}

		public static function get OffsetY():Number
		{
			return arr[2];
		}
	}
}
