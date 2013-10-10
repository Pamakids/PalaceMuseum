package models
{
	import flash.net.SharedObject;

	/**
	 *
	 * @author Administrator
	 */
	public class SOService
	{
		/**
		 *
		 */
		public function SOService()
		{
			init();
		}

		/**
		 * 加载流程
		 * |- initUsers 初始化userInfo;
		 * |- getLastUser 获取上个用户索引;
		 * |- initSO 通过用户索引初始化用户数据
		 * |-
		 */
		public function init():void
		{
			initUsers();
			var index:int=getLastUser();
			if (!index)
				index=0
			initSO(index.toString());
		}

		/**
		 * 初始化用户
		 */
		public function initUsers():void
		{
			userInfo=SharedObject.getLocal("userInfo");
		}

		/**
		 * 初始化用户数据
		 */
		public function initSO(index:String):void
		{
			so=SharedObject.getLocal("userdata" + index);
		}

		/**
		 *
		 * @default
		 */
		public static var userInfo:SharedObject;

		/**
		 * 获取用户
		 * @return
		 */
		public function getUserSO(key:String):Object
		{
			return userInfo.data[key];
		}

		/**
		 * 设置用户
		 * @param value
		 */
		public function setUserSO(key:String, value:Object):void
		{
			userInfo.data[key]=value;
			userInfo.flush();
		}

		/**
		 * 获取最后用户的索引
		 * @return
		 */
		public function getLastUser():int
		{
			return getUserSO("lastUser") as int;
		}

		/**
		 * 编辑用户
		 * 切换用户
		 * @param index
		 * @param value
		 */
		public function editUser(index:int, value:Object):void
		{
			var arr:Vector.<Object>=getUserSO("users") as Vector.<Object>;
			arr[index]=value;
			setUserSO("users", arr);
			if (value)
				setUserSO("lastUser", index);
			else
				changeUser(0);
		}

		public function deleteUser(index:int):Boolean
		{
			if (index == getLastUser())
				return false;
			else
			{
				editUser(index, null);
				return true;
			}
		}

		/**
		 * 切换用户
		 * @param index
		 */
		public function changeUser(index:int):void
		{
			if (index == getLastUser())
				return;
			setUserSO("lastUser", index);
			init();
		}

		/**
		 * 获取用户信息(生日,头像)
		 * @param index
		 * @return
		 */
		public function getUserInfo(index:int):Object
		{
			var arr:Vector.<Object>=getUserSO("users") as Vector.<Object>;
			if (!arr)
				arr=new Vector.<Object>(3);
			if (!arr[0])
			{
				var info:UserVO=new UserVO();
				info.username="我是小皇帝";
				info.birthday=new Date().getTime();
				info.avatarIndex=0;
				arr[0]=info;
				editUser(0, info);
			}
			return arr[index];
		}

		private static var _instance:SOService;

		private var so:SharedObject;

		/**
		 *
		 * @return
		 */
		public static function get instance():SOService
		{
			if (!_instance)
				_instance=new SOService();
			return _instance;
		}

		/**
		 *
		 * @param key
		 * @return
		 */
		public function getSO(key:String):Object
		{
			return so.data[key];
		}

		/**
		 *
		 * @param key
		 * @param value
		 */
		public function setSO(key:String, value:Object):void
		{
			so.data[key]=value;
			so.flush();
		}

		/**
		 *
		 * @param value
		 * @return
		 */
		public function checkHintCount(value:String):Boolean
		{
			var hintCount:int=getSO(value) as int;
			if (!hintCount)
			{
				setSO(value, 1);
				return true;
			}
			else if (hintCount <= 3)
			{
				hintCount++;
				setSO(value, hintCount);
				return true;
			}
			return false;
		}

		/**
		 *
		 * @param index
		 * @return
		 */
		public function isModuleCompleted(index:int):Boolean
		{
			//			return false;
			var arr:Array=getSO('completedModules') as Array;
			return arr && arr.indexOf(index) != -1;
		}

		/**
		 *
		 */
		public function completeModule(value:int):void
		{
			var arr:Array=getSO('completedModules') as Array;
			if (!arr)
				arr=[];
			if (arr.indexOf(value) == -1)
				arr.push(value);
			setSO('completedModules', arr);
		}

		/**
		 *
		 */
		public function clear():void
		{
			userInfo.clear();
			so.clear();
		}
	}
}
