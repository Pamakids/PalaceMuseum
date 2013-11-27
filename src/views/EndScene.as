package views
{
	import controllers.DC;

	import models.FontVo;
	import models.SOService;

	import starling.display.Image;
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
			addPanel();
			addContent();
			addClose(950, 700);
			isWin=true;
		}

		private function addPanel():void
		{
			var panel:Image=getImage("endpanel");
			panel.x=226;
			panel.y=46;
			addChild(panel);
		}

		private function addContent():void
		{
			var achieveNum:int=0;
			for (var ai:int=0; ai < 30; ai++)
			{
				if (SOService.instance.getSO(ai + "_achieve"))
					achieveNum++;
			}

			var achiveTxt:String="成就：  " + achieveNum + " / 29";
			var achiveTF:TextField=new TextField(242, 60, achiveTxt, FontVo.PALACE_FONT, 32, 0xb83d00, true);
			achiveTF.x=403;
			achiveTF.y=415;
			addChild(achiveTF);

			var cardNum:int=0;
			for (var ci:int=0; ci < 13; ci++)
			{
				if (DC.instance.testCollectionIsOpend(ci.toString()))
					cardNum++;
			}

			var cardTxt:String="卡片：  " + cardNum + " / 13";
			var cardTF:TextField=new TextField(242, 60, cardTxt, FontVo.PALACE_FONT, 32, 0xb83d00, true);
			cardTF.x=403;
			cardTF.y=485;
			addChild(cardTF);

			var birdNum:int=0;
			for (var bi:int=0; bi < 10; bi++)
			{
				if (SOService.instance.getSO("birdCatched" + bi))
					birdNum++;
			}

			var birdTxt:String="小鸟：  " + birdNum + " / 10";
			var birdTF:TextField=new TextField(242, 60, birdTxt, FontVo.PALACE_FONT, 32, 0xb83d00, true);
			birdTF.x=403;
			birdTF.y=555;
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
