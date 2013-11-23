package views
{
	import models.FontVo;

	import starling.events.Event;
	import starling.text.TextField;

	import views.components.base.PalaceGame;

	public class EndScene extends PalaceGame
	{
		private var callback:Function;

		public function EndScene(cb:Function)
		{
			callback=cb;
			addBG();
			addContent();
			addClose(950, 700);
			isWin=true;
		}

		private function addContent():void
		{
			var title:TextField=new TextField(800, 80, "恭喜你帮助小皇帝实现了心愿！", FontVo.PALACE_FONT, 50, 0xffff00, true);
			title.x=112;
			title.y=80;
			addChild(title);

			var achiveTF:TextField=new TextField(800, 50, "获得成就： xx / ", FontVo.PALACE_FONT, 36, 0xffffff);
			achiveTF.x=112;
			achiveTF.y=200;
			addChild(achiveTF);

			var cardTF:TextField=new TextField(800, 50, "收集卡片：xx / 15", FontVo.PALACE_FONT, 36, 0xffffff);
			cardTF.x=112;
			cardTF.y=300;
			addChild(cardTF);

			var birdTF:TextField=new TextField(800, 50, "抓住小鸟：xx / 10", FontVo.PALACE_FONT, 36, 0xffffff);
			birdTF.x=112;
			birdTF.y=400;
			addChild(birdTF);
		}

		override protected function onCloseClick(e:Event):void
		{
			if (callback != null)
				callback();
			callback=null;
			this.removeFromParent(true);
		}
	}
}
