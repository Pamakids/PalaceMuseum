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

	[SWF(width="1024", height="768", frameRate="30", backgroundColor="0x554040")]
	public class PalaceMuseum extends Sprite
	{
		public function PalaceMuseum()
		{
			if (Capabilities.isDebugger)
			{
//				DPIUtil.testType="pad"
//				DPIUtil.testType="s1"
//				DPIUtil.testType="tv"
//				DPIUtil.testType="pad3"
//				DPIUtil.testType="gs3"
			}
			PosVO.init();

			var scale:Number=PosVO.scale;
			this.scaleX=this.scaleY=scale;
			this.x=PosVO.OffsetX;
			this.y=PosVO.OffsetY;

			var isFit:Boolean=PosVO.OffsetX == 0 && PosVO.OffsetY == 0

			if (!isFit)
			{
				var msk:Shape=new Shape();
				addChild(msk);
				msk.graphics.beginFill(0);
				msk.graphics.drawRect(0, 0, 1024, 768)
				mask=msk;
			}

			UserBehaviorAnalysis.init();
			UserBehaviorAnalysis.trackView("OPENAPP");

			TweenPlugin.activate([ShakeEffect]);
			TweenPlugin.activate([MotionBlurPlugin]);

			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;

			MC.isIOS=Capabilities.os.toLowerCase().indexOf("iphone") >= 0;

			Starling.multitouchEnabled=true;
			Starling.handleLostContext=!MC.isIOS;

			var main:Starling=new Starling(Main, stage);
			main.start();
			main.showStats=Capabilities.isDebugger;
			main.antiAliasing=16;
			main.viewPort=new Rectangle(PosVO.OffsetX, PosVO.OffsetY, 1024 * scale, 768 * scale);

			var mcLayer:Sprite=new Sprite();
			addChild(mcLayer);

			MC.instance.stage=this;
			MC.instance.mcLayer=mcLayer;
		}
	}
}

