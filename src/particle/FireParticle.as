package particle
{
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class FireParticle extends Sprite
	{

		private var particleSystem:PDParticleSystem;

		public function FireParticle()
		{
		}

		public function init(type:int=0):void
		{
			var config:XML=XML(new ParticleAsset["particleXML" + type.toString()]());
			var texture:Texture=Texture.fromBitmap(new ParticleAsset.particleTextrue());

			particleSystem=new PDParticleSystem(config, texture);
			particleSystem.start();

			addChild(particleSystem);
			Starling.juggler.add(particleSystem);
		}

		override public function dispose():void
		{
			super.dispose();
			if (particleSystem)
			{
				particleSystem.stop(true);
				removeChild(particleSystem);
				Starling.juggler.remove(particleSystem);
				particleSystem=null;
			}
		}
	}
}

