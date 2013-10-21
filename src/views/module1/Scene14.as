package views.module1
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.module5.scene52.OperaBody;

	/**
	 * 早起模块
	 * 过场对话场景
	 * @author Administrator
	 */
	public class Scene14 extends PalaceScene
	{
		public function Scene14(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=4;
			addChild(getImage("bg14"));

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
			TweenLite.delayedCall(1, moveKing);
		}

		private function moveKing():void
		{
			king.startShakeHead(Math.PI / 20, 3);
			king.startShakeBody(Math.PI / 30, 3);
			TweenLite.to(king, 3, {x: pos2.x, y: pos2.y, onComplete: kingSay});
		}

		private function onEnterFrame(e:Event):void
		{
			king.shake();
		}

		private function kingSay():void
		{
//			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			Prompt.showTXT(pos2.x + 10, pos2.y - 20, txt1, 20, momSay);
		}

		private function momSay():void
		{
			Prompt.showTXT(pos3.x, pos3.y, txt2, 20, kingSay2);
		}

		private function kingSay2():void
		{
			Prompt.showTXT(pos2.x + 10, pos2.y - 20, txt3, 20, moveKingBack);
		}

		private function moveKingBack():void
		{
//			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			king.startShakeHead(Math.PI / 20, 3);
			king.startShakeBody(Math.PI / 30, 3);
			TweenLite.to(king, 3, {x: pos1.x, y: pos1.y, onComplete: sceneOver});
		}

		private var txt1:String="母后，孩儿给您请安";
		private var txt2:String="你政务繁忙，就早点回去吧。";
		private var txt3:String="孩儿告退";

		private var pos1:Point=new Point(747, 275);
		private var pos2:Point=new Point(527, 492);
		private var pos3:Point=new Point(372, 445);
		private var king:OperaBody;
	}
}
