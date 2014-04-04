package particle
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class PalaceParticle extends Sprite
	{

		private var particleSystem:PDParticleSystem;

		public function PalaceParticle()
		{
		}

		/**
		 *
		 * @param 0,1:fire 2:smoke
		 */
		public function init(type:int=0):void
		{
			var config:XML=XML(new ParticleAsset["particleXML" + type.toString()]());
			var texture:Texture=Texture.fromBitmap(new ParticleAsset.particleTextrue());

			particleSystem=new PDParticleSystem(config, texture);
			particleSystem.touchable=false;
			particleSystem.start();

			addChild(particleSystem);
			Starling.juggler.add(particleSystem);
		}

		override public function dispose():void
		{
			if (particleSystem)
			{
				particleSystem.stop(true);
				Starling.juggler.remove(particleSystem);
				particleSystem.removeFromParent(true);
				particleSystem=null;
			}
			super.dispose();
		}
	}
}

