package views.module3
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;

	import flash.geom.Point;

	import particle.PalaceParticle;

	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.module5.scene52.OperaBody;

	public class Scene34 extends PalaceScene
	{
		private var king:OperaBody;

		private var pos1:Point=new Point(815, 350);
		private var pos2:Point=new Point(387, 515);
		private var ptcl:PalaceParticle;

		public function Scene34(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=7;
			addBG("bg30");
//			addChild(getImage("bg30"));

			ptcl=new PalaceParticle();
			ptcl.init(2);
			addChild(ptcl);
			ptcl.x=380;
			ptcl.y=470;

			king=new OperaBody();
			king.body=getImage("kingBody");
			king.head=getImage("kingHead");
			king.offsetsXY=new Point(41, 95);
			king.reset(false);
			addChild(king);
			king.x=pos1.x;
			king.y=pos1.y;
			king.touchable=false;
			king.alpha=0;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			TweenLite.delayedCall(2.5, function():void {
				TweenLite.to(king, 1, {alpha: 1, onComplete: moveKing});
			}
			);
		}

		override public function dispose():void
		{
			if (ptcl)
				ptcl.removeFromParent(true);
			super.dispose();
		}

		private function moveKing():void
		{
			king.startShakeHead(Math.PI / 20, 5);
			king.startShakeBody(Math.PI / 30, 5);
			TweenLite.to(king, 5, {x: pos2.x, y: pos2.y, onComplete: hideKing, ease: Quad.easeInOut});
		}

		private function onEnterFrame(e:Event):void
		{
			king.shake();
		}

		private function hideKing():void
		{
			TweenLite.to(king, 2, {scaleX: .2, scaleY: .2, alpha: 0, onComplete: sceneOver});
		}
	}
}
