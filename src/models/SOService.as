package models
{
	import flash.net.SharedObject;

	public class SOService
	{
		public function SOService()
		{
			so=SharedObject.getLocal("palace");
		}

		private static var _instance:SOService;

		private var so:SharedObject;

		public static function get instance():SOService
		{
			if (!_instance)
				_instance=new SOService();
			return _instance;
		}

		public function getSO(key:String):Object
		{
			return so.data[key];
		}

		public function setSO(key:String, value:Object):void
		{
			so.data[key]=value;
			so.flush();
		}
	}
}
