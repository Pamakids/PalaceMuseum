package modules
{
	import com.pamakids.palace.base.PalaceModule;
	import com.pamakids.palace.base.PalaceScean;
	import com.pamakids.manager.LoadManager;

	import flash.display.Bitmap;
	import flash.utils.getQualifiedClassName;

	import modules.module1.Scean11;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Module1 extends PalaceModule
	{

		private var xml:XML;

		private var ta:TextureAtlas;

		private var texturePath:String;

		private var xmlPath:String;
		public function Module1()
		{
			var clsName:String=getQualifiedClassName(this).toLocaleLowerCase();
			clsName=clsName.substring(clsName.lastIndexOf(':') + 1);
			var path:String="/assets/"+clsName+"/"+clsName;

			texturePath = path+".png";
			xmlPath = path+".xml";

			LoadManager.instance.loadText(xmlPath,onXmlLoaded);


		}

		private function onXmlLoaded(b:String):void
		{
			xml=new XML(b);
			LoadManager.instance.loadImage(texturePath,onTextrueLoaded);
		}

		private function onTextrueLoaded(b:Bitmap):void
		{
			ta=new TextureAtlas(Texture.fromBitmap(b),xml);
			var scean:PalaceScean=new Scean11();
			scean.ta=ta;
			addChild(scean);
		}
	}
}

