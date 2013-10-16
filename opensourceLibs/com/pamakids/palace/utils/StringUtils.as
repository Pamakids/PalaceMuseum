package com.pamakids.palace.utils
{
	import flash.utils.getQualifiedClassName;

	public class StringUtils
	{
		public function StringUtils()
		{
		}

		public static function getClassName(cls:Object):String
		{
			var clsName:String=getQualifiedClassName(cls).toLowerCase();
			clsName=clsName.substring(clsName.lastIndexOf(':') + 1);
			return clsName;
		}
	}
}

