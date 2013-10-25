package views.module4
{
	import com.greensock.TweenLite;

	import controllers.MC;

	import feathers.core.PopUpManager;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.LionMC;
	import views.components.base.PalaceScene;
	import views.global.TopBar;

	/**
	 * 上朝模块
	 * 批奏折场景(批奏折/as3)
	 * @author Administrator
	 */
	public class Scene42 extends PalaceScene
	{
		public function Scene42(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=11;
			addBG("bg52");
//			addChild(getImage("bg52"));

			hand=getImage("memorial-hand");
			addChild(hand);
			handPosX=posX + memorialW - (hand.width >> 1);
			handOutPosY=outPosY + memorialH - (hand.height >> 1);
			handPosY=posY + memorialH - (hand.height >> 1);
			hand.x=handPosX;
			hand.y=handOutPosY;

			addOneMemorial();
		}

		private var handPosX:Number; //手 位置
		private var handPosY:Number;
		private var handOutPosY:Number;
		private var posX:Number=526; //奏折位置
		private var posY:Number=384;
		private var outPosY:Number=1024; // 初始位置
		private var memorialW:Number=183;
		private var memorialH:Number=379;

		private var hand:Image;
		private var crtMemorial:Image;
		private var crtIndex:int;
		private var indexArr:Array=[0, 1, 2, 3];

		private var drawScene:palace_paper;

		private var chooseWin:Sprite;

		private function addOneMemorial():void
		{
			var index:int=Math.random() * indexArr.length;
			crtIndex=indexArr[index];
			indexArr.splice(index, 1);
			var memorial:Image=getImage("memorial" + (crtIndex + 1).toString());
			memorial.x=posX;
			memorial.y=outPosY;
			crtMemorial=memorial;
			addChild(crtMemorial);
			TweenLite.to(hand, .5, {y: handPosY});
			TweenLite.to(crtMemorial, .5, {y: posY, onComplete: function():void {
				TweenLite.to(hand, .5, {y: handOutPosY})
				crtMemorial.addEventListener(TouchEvent.TOUCH, onMemorialTouch);
			}});
		}

		private function onMemorialTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(crtMemorial, TouchPhase.ENDED);
			if (tc)
			{
				crtMemorial.removeEventListener(TouchEvent.TOUCH, onMemorialTouch);
				initDraw();
			}
		}

		private function initDraw():void
		{
			MC.isTopBarShow=false;
			TopBar.hide();
			drawScene=new palace_paper(crtIndex, removeMemorial);
			MC.instance.stage.addChild(drawScene);
		}

		private function removeMemorial():void
		{
			MC.isTopBarShow=true;
			TopBar.show();
			TweenLite.to(hand, .5, {y: handPosY, onComplete: function():void {

				TweenLite.to(hand, .5, {y: handOutPosY});

				TweenLite.to(crtMemorial, .5, {y: outPosY, onComplete: function():void {
					crtMemorial.removeFromParent(true);
					crtMemorial=null;
					trace(indexArr.length)
					if (indexArr.length == 2) {
						MC.instance.stage.removeChild(drawScene);
						drawScene=null;
						showCard("9", function():void {
							showAchievement(23, playLion);
						});

					}
					else
						addChoose();
				}});
			}});

		}

		private function playLion():void
		{
			LionMC.instance.say("皇上辛苦了，这就传晚膳", 0, 200, 500, sceneOver);
		}

		private function addChoose():void
		{
			chooseWin=new Sprite();

			var bar:Image=getImage("continue");
			bar.x=321;
			bar.y=466;
			chooseWin.addChild(bar);

			var yes:ElasticButton=new ElasticButton(getImage("yesBtn"));
			yes.shadow=getImage("yesBtn-down");
			yes.x=394 + 36;
			yes.y=592 + 36;
			chooseWin.addChild(yes);
			yes.addEventListener(ElasticButton.CLICK, onYes);

			var no:ElasticButton=new ElasticButton(getImage("noBtn"));
			no.shadow=getImage("noBtn-down");
			no.x=528 + 36;
			no.y=592 + 36;
			chooseWin.addChild(no);
			no.addEventListener(ElasticButton.CLICK, onNo);

			PopUpManager.addPopUp(chooseWin, true, false);
		}

		private function onYes(e:Event):void
		{
			chooseWin.touchable=false;
			PopUpManager.removePopUp(chooseWin);
			chooseWin.dispose();
			addOneMemorial();
		}

		private function onNo():void
		{
			chooseWin.touchable=false;
			PopUpManager.removePopUp(chooseWin);
			chooseWin.dispose();
			MC.instance.stage.removeChild(drawScene);
			drawScene=null;
//			LionMC.instance.say("皇上辛苦了，这就传晚膳", 0, 200, 500, sceneOver);
			showCard("8", function():void {
				showAchievement(22, playLion);
			});
		}
	}
}
