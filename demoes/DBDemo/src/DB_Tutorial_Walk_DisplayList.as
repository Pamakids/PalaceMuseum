package  
{
	import dragonBones.Armature;
	import dragonBones.factorys.BaseFactory;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(width="800", height="600", frameRate="30", backgroundColor="#999999")]
	
	public class DB_Tutorial_Walk_DisplayList extends Sprite 
	{
		[Embed(source = "../assets/Dragon1.swf", mimeType = "application/octet-stream")]
		private static const ResourcesData:Class;
		
		private var factory:BaseFactory;
		private var armature:Armature;
		private var armatureClip:Sprite
		
		public function DB_Tutorial_Walk_DisplayList()
		{
			factory = new BaseFactory();
			factory.addEventListener(Event.COMPLETE, textureCompleteHandler);
			factory.parseData(new ResourcesData());
		}
		private function textureCompleteHandler(e:Event):void 
		{
			armature = factory.buildArmature("Dragon");
			armatureClip = armature.display as Sprite;
			armatureClip.x = 50;
			armatureClip.y = 50;
			addChild(armatureClip);
			armature.animation.gotoAndPlay("walk");
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		private function onEnterFrameHandler(_e:Event):void 
		{
			armature.update();
		}
	}
}