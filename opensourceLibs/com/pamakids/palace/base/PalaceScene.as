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
	import starling.textures.TextureAtlas;

	public class PalaceScene extends Sprite
	{
		public var ta:TextureAtlas;

		public function PalaceScene()
		{
		}

		public function init():void
		{
		}

		override public function dispose():void
		{
			super.dispose();
		}

		protected function getImage(name:String):Image
		{
			if(ta)
			{
				var t:Texture=ta.getTexture(name);
				if(t)
					return new Image(t);
				else
					return null;
			}
			return null;
		}
	}
}

