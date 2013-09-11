package models
{
	import com.pamakids.models.BaseVO;

	/**
	 * 用户信息
	 * @author mani
	 */
	public class UserVO extends BaseVO
	{
		public function UserVO()
		{
			super();
		}

		/**
		 * 用户设备唯一ID号
		 */
		public var udid:String;
		/**
		 * 用户生日
		 */
		public var birthday:String;
		/**
		 * 运行次数
		 */
		public var runTimes:int;
	}
}
