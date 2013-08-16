package com.pamakids.palace.utils
{
	import starling.display.Sprite;

	public class SPUtils
	{
		public function SPUtils()
		{
		}

		public static function registSPCenter(sp:Sprite,registration:uint=5):void{
			sp.pivotX=(sp.width>>1)*((registration-1)%3);
			sp.pivotY=(sp.height>>1)*(2-int((registration-1)/3));
		}
	}
}

