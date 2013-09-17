package models
{

	public class FontVo
	{
		[Embed(source="/font/palaceFont.ttf", embedAsCFF="false", fontName="palaceFont")]
		public static const myFont:Class;

		public function FontVo()
		{
		}

//		public function registerFont():void
//		{
//			var fontTexture:Texture=Texture.fromBitmap(new myFont());
//			var fontXml:XML=new XML(new myFont_fnt());
//			var bitmapFont:BitmapFont=new BitmapFont(fontTexture, fontXml);
//			TextField.registerBitmapFont(bitmapFont, PALACE_FONT);
//		}




//		public function registerFont():void
//		{
//			//图片
//			var fontTexture:Texture=Texture.fromBitmap(new myFont());
//			//xml
//			var fontXml:XML=new XML(new myFont_fnt());
//			//位图字体
//			var bitmapFont:BitmapFont=new BitmapFont(fontTexture, fontXml);
//			//注册
//			TextField.registerBitmapFont(bitmapFont, PALACE_FONT);
//		}
		public static const PALACE_FONT:String="palaceFont";
	}
}
