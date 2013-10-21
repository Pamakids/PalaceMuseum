package
{
	import com.greensock.plugins.MotionBlurPlugin;
	import com.greensock.plugins.ShakeEffect;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.utils.DPIUtil;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;
	
	import controllers.MC;
	
	import models.SOService;
	
	import starling.core.Starling;
	
	import views.Interlude;
	import views.global.map.Map;

	[SWF(width="1024", height="768", frameRate="30", backgroundColor="0x333333")]
	public class PalaceMuseum extends Sprite
	{
		public function PalaceMuseum()
		{
			SOService.instance.clear();
			var lastScene:String=SOService.instance.getSO("lastScene") as String;
			if(!lastScene)
				initIntro();
			else
				startGame();
		}

		private function startGame():void
		{
			setTimeout(setTimeoutFunction, 1000);
		}
		private var inito:Interlude;

		private function initIntro():void
		{
			inito = new Interlude("assets/intro/intro.mp4", false, null, startGame);
			this.addChild( inito );
		}
		
		protected function setTimeoutFunction():void
		{
			// TODO Auto Generated method stub
			this.scaleX=this.scaleY=DPIUtil.getDPIScale();
			TweenPlugin.activate([ShakeEffect]);
			TweenPlugin.activate([MotionBlurPlugin]);
			
			var scale:Number=DPIUtil.getDPIScale();
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			
			Starling.multitouchEnabled=true;
			Starling.handleLostContext=false;
			var main:Starling=new Starling(Main, stage);
			main.start();
			main.showStats=Capabilities.isDebugger;
			main.antiAliasing=16;
			
			MC.instance.stage=this;
		}
	}
}

