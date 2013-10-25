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
			addBG("bg14");
//			addChild(getImage("bg14"));

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

		override public function dispose():void
		{
			if (king)
			{
				TweenLite.killTweensOf(king);
				king.removeFromParent(true);
				king=null;
			}
			super.dispose();
		}

		private function moveKing():void
		{
			if (!king)
				return;
			king.startShakeHead(Math.PI / 20, 3);
			king.startShakeBody(Math.PI / 30, 3);
			TweenLite.to(king, 3, {x: pos2.x, y: pos2.y, onComplete: sayNext});
		}

		private function onEnterFrame(e:Event):void
		{
			if (king)
				king.shake();
		}

		private function kingSay():void
		{
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

		private var talkIndex:int=0;

		private function sayNext():void
		{
			var pos:Point=this["pos" + (talkIndex % 2 + 2).toString()]
			talkIndex++;
			if (talkIndex > 7)
				moveKingBack();
			else
			{
				var txt:String=this["txt" + talkIndex.toString()]
				Prompt.showTXT(pos.x + 10, pos.y - 20, txt, 20, sayNext);
			}
		}

		private function moveKingBack():void
		{
			if (!king)
				return;
			king.startShakeHead(Math.PI / 20, 3);
			king.startShakeBody(Math.PI / 30, 3);
			TweenLite.to(king, 3, {x: pos1.x, y: pos1.y, onComplete: sceneOver});
		}

		private var txt1:String="母后，孩儿给您请安。";
		private var txt2:String="皇儿最近可好？";
		private var txt3:String="回母后，最近孩儿一切安好，母后放心。";
		private var txt4:String="皇儿声音怎么有些变化？";
		private var txt5:String="可能孩儿前些天偶感风寒，还没有痊愈。";
		private var txt6:String="你政务繁忙，就早点回去吧，一定注意身体。";
		private var txt7:String="多谢母后关心，孩儿告退";

		private var pos1:Point=new Point(747, 275);
		private var pos2:Point=new Point(527, 492);
		private var pos3:Point=new Point(372, 445);
		private var king:OperaBody;
	}
}
