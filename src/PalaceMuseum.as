package
{
	import com.greensock.plugins.MotionBlurPlugin;
	import com.greensock.plugins.ShakeEffect;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.utils.DPIUtil;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	import controllers.MC;
	import controllers.UserBehaviorAnalysis;

	import models.PosVO;

	import starling.core.Starling;

	[SWF(width="1024", height="768", frameRate="30", backgroundColor="0x663333")]
	public class PalaceMuseum extends Sprite
	{
		public function PalaceMuseum()
		{
			PosVO.init();
//			var scale:Number=DPIUtil.getDPIScale();
			this.scaleX=this.scaleY=PosVO.scale;
			this.x=PosVO.OffsetX;
			this.y=PosVO.OffsetY;

			var msk:Shape=new Shape();
			this.addChild(msk);
			msk.graphics.beginFill(0);
			msk.graphics.drawRect(0, 0, 1024, 768)
			this.mask=msk;

			UserBehaviorAnalysis.init();
			UserBehaviorAnalysis.trackView("OPENAPP");

			TweenPlugin.activate([ShakeEffect]);
			TweenPlugin.activate([MotionBlurPlugin]);

			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;

			Starling.multitouchEnabled=true;
			Starling.handleLostContext=false;
			var main:Starling=new Starling(Main, stage);
			main.start();
			main.showStats=Capabilities.isDebugger;
			main.antiAliasing=16;
			main.viewPort=new Rectangle(0, 0, 1024, 768);

			var mcLayer:Sprite=new Sprite();
			addChild(mcLayer);

			MC.instance.stage=this;
			MC.instance.mcLayer=mcLayer;
		}
	}
}

