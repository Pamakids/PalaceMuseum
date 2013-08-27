package controls
{

	public class MainCtrl
	{
		public function MainCtrl()
		{
		}

		private static var _instance:MainCtrl;

		public static function get instance():MainCtrl
		{
			if (!_instance)
				_instance=new MainCtrl();
			return _instance;
		}

		public var main:Main;
	}
}
