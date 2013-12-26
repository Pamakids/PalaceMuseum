package views
{
	import flash.text.TextFormat;

	import assets.embed.EmbedAssets;

	import controllers.DC;
	import controllers.UserBehaviorAnalysis;

	import feathers.controls.TextInput;
	import feathers.controls.text.TextFieldTextEditor;

	import models.FontVo;
	import models.SOService;

	import sound.SoundAssets;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;

	public class EndScene extends PalaceGame
	{
		private var callback:Function;

		private var messageHolder:Sprite;

		private var ti:TextInput;

		private var countTF:TextField;

		public function EndScene(cb:Function)
		{
			callback=cb;

			messageHolder=new Sprite();
			addChild(messageHolder);

			var messageBG:Image=Image.fromBitmap(new EmbedAssets.messageBG());
			messageHolder.addChild(messageBG);

			countTF=new TextField(86, 29, "0/120", FontVo.PALACE_FONT, 22, 0x409b92);
			messageHolder.addChild(countTF);
			countTF.x=625;
			countTF.y=323;
			countTF.touchable=false;

			ti=new TextInput();
			ti.x=336;
			ti.y=130;
			ti.width=369;
			ti.height=191;
			ti.textEditorFactory=function stepperTextEditorFactory():TextFieldTextEditor {
				var tf:TextFieldTextEditor=new TextFieldTextEditor();
				tf.textFormat=new TextFormat(FontVo.PALACE_FONT, 18);
				tf.textFormat.leading=11;
				tf.embedFonts=true;
				tf.multiline=true;
				tf.wordWrap=true;
				return tf;
			};
			ti.maxChars=120;
			messageHolder.addChild(ti);

			var sendBtn:ElasticButton=new ElasticButton(getImage("send"), getImage("send-shadow"));
			messageHolder.addChild(sendBtn);
			sendBtn.x=508;
			sendBtn.y=350;
			sendBtn.addEventListener(ElasticButton.CLICK, sendMessage);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);

			SoundAssets.playBGM("gameBGM");
		}

		private function onEnterFrame(e:Event):void
		{
			countTF.text=ti.text.length.toString() + "/200"
		}

		private function sendMessage(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);

			var message:String=ti.text;
			UserBehaviorAnalysis.trackEvent("message", message);

			messageHolder.removeFromParent(true);

//			SoundAssets.playBGM("fireworks");

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
//			SoundAssets.stopBGM(true);
			if (callback != null)
				callback();
			callback=null;
			this.removeFromParent(true);
		}
	}
}
