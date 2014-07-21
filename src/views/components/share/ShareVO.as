package views.components.share
{
	public class ShareVO
	{
		public function ShareVO()
		{
		}

		public static const SINA_APPKEY:String='2283744102';
		public static const SINA_SECRET:String='6bf4d57c23f44e5b50c95b63c39876d8';

		public static const TENCENT_APPKEY:String='801524590';
		public static const TENCENT_SECRET:String='7c6e3e628325141a328f40022c2e3bd5';

		public static const WEIXIN_APPKEY:String='wx37c9faa53505cfd9';
		public static const WEIXIN_SECRET:String='49817632d63abc08a33dc41575b7bdfd';

		public static const HOST:String='http://palacemuseum.qiniudn.com/';

		public static function getIMG(key:String):String
		{
			return HOST+key+'.jpg';
		}
	}
}

