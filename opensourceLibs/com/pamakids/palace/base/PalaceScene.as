/**
 * 故宫项目
 * 场景
 * starling
 *
 * */

package com.pamakids.palace.base
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class PalaceScene extends Sprite
	{
		public var assets:AssetManager;

		public function PalaceScene()
		{
		}

		public function init():void
		{

		}

		override public function dispose():void
		{
			if(assets){
				removeChildren();
				assets.dispose();
			}
			super.dispose();
		}

		protected function getImage(name:String):Image
		{
			if(assets)
			{
				var t:Texture=assets.getTexture(name);
				if(t)
					return new Image(t);
				else
					return null;
			}
			return null;
		}
	}
}

