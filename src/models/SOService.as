package models
{
	import flash.net.SharedObject;

	import controllers.MC;

	public class SOService
	{
		public function SOService()
		{
			so=SharedObject.getLocal("palace");
			mc=MC.instance;
		}

		private static var _instance:SOService;

		private var so:SharedObject;
		private var mc:MC;

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

		public function isModuleCompleted(index:int):Boolean
		{
//			return false;
			var arr:Array=getSO('completedModules') as Array;
			return arr && arr.indexOf(index) != -1;
		}

		public function completeModule():void
		{
			var arr:Array=getSO('completedModules') as Array;
			if (!arr)
				arr=[];
			if (arr.indexOf(mc.moduleIndex) == -1)
				arr.push(mc.moduleIndex);
			setSO('completedModules', arr);
		}
	}
}
