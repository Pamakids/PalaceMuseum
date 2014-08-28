package views.module4
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.module5.scene52.OperaBody;

	public class Scene43 extends PalaceScene
	{
		private var king:OperaBody;

		public function Scene43(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=12;
			addBG("bg43");
//			addChild(getImage("bg43"));

			king=new OperaBody();
			king.body=getImage("kingbody");
			king.head=getImage("kinghead");
			king.offsetsXY=new Point(36, 114);
			king.reset();
			addChild(king);
			king.x=pos1.x;
			king.y=pos1.y;
			king.touchable=false;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			TweenLite.delayedCall(1.5, kingSay);
		}

		override protected function init():void
		{
			super.init();
			assetManager.playSound("bird",0,2);
		}

		private function moveKing():void
		{
			king.startShakeHead(Math.PI / 20, 3);
			king.startShakeBody(Math.PI / 30, 3);
			TweenLite.to(king, 3, {x: pos2.x, y: pos2.y, onComplete: sceneOver});
		}

		private function kingSay():void
		{
			Prompt.showTXT(pos1.x + 10, pos1.y - 20, "又吃撑了，去皇帝的花园逛一逛", 20, moveKing);
		}

		private var pos1:Point=new Point(399, 663);
		private var pos2:Point=new Point(617, 302);

		private var count:int=0;

		private function onEnterFrame(e:Event):void
		{
			count++;
			if(count==45)
				kingSay();
			king.shake();
		}
	}
}


