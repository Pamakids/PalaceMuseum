package controllers
{
	public class ShareService
	{
		public function ShareService()
		{
//			UMSocial.instance.init();
		}

		private static var _instance:ShareService;

		public static function get instance():ShareService
		{
			if(!_instance)
				_instance=new ShareService();
			return _instance;
		}

		public function share():void
		{
//			UMSocial.instance.share('test','testStr');
		}
	}
}

