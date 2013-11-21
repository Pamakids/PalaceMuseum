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
	import views.global.TailBar;
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

			hand=getImage("memorial-hand");
			addChild(hand);
			handPosX=posX + memorialW - (hand.width);
			handOutPosY=outPosY + memorialH - (hand.height >> 1);
			handPosY=posY + memorialH - (hand.height >> 1);
			hand.x=handPosX;
			hand.y=handOutPosY;

			addMemorials();
		}

		private var handPosX:Number; //手 位置
		private var handPosY:Number;
		private var handOutPosY:Number;
		private var posX:Number=419; //奏折位置
		private var posY:Number=267;
		private var outPosY:Number=1024; // 初始位置
		private var memorialW:Number=241;
		private var memorialH:Number=435;

		private var hand:Image;
		private var indexArr:Array=[0, 1, 2, 3];

		private var drawScene:palace_paper;

		private var chooseWin:Sprite;
		private var memorialArr:Array=[];

		private var memorialHolder:Sprite;
		private var memorialBottom:Image;

		private var memorialTop:Image;
		private var bottomIndex:int;
		private var topIndex:int;
		private var gap:Number=5;

		private function addMemorials():void
		{
			memorialHolder=new Sprite();

			var index:int=Math.random() * indexArr.length;
			bottomIndex=indexArr[index];
			indexArr.splice(index, 1);
			memorialBottom=getImage("memorial" + (bottomIndex + 1).toString());
			memorialHolder.addChild(memorialBottom);

			for (var i:int=0; i < 8; i++)
			{
				var img:Image=getImage("memorialBlank");
				memorialHolder.addChild(img);
				img.x=-(i + 1) * gap;
				img.y=-(i + 1) * gap;
				memorialArr.push(img);
			}

			var index2:int=Math.random() * indexArr.length;
			topIndex=indexArr[index];
			indexArr.splice(index, 1);
			memorialTop=getImage("memorial" + (topIndex + 1).toString());
			memorialHolder.addChild(memorialTop);
			memorialTop.x=-9 * gap;
			memorialTop.y=-9 * gap;

			memorialHolder.x=posX;
			memorialHolder.y=outPosY;
			addChild(memorialHolder);
			TweenLite.to(hand, .5, {y: handPosY});
			TweenLite.to(memorialHolder, .5, {y: posY, onComplete: function():void {
				TweenLite.to(hand, .5, {y: handOutPosY})
				memorialTop.addEventListener(TouchEvent.TOUCH, onTopMemorialTouch);
			}});
		}

		private function onTopMemorialTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(memorialTop, TouchPhase.ENDED);
			if (tc)
			{
				memorialTop.removeEventListener(TouchEvent.TOUCH, onTopMemorialTouch);
				initDraw(topIndex);
			}
		}

		private function initDraw(isTop:Boolean):void
		{
			TopBar.hide();
			TailBar.hide();
			drawScene=new palace_paper(isTop ? topIndex : bottomIndex, callBack);
			MC.instance.stage.addChild(drawScene);
		}

		private var count:int=0;

		private function removeMemorial(img:Image, cb:Function=null):void
		{
			TweenLite.to(hand, .5, {y: handPosY, onComplete: function():void {
				TweenLite.to(hand, .5, {y: handOutPosY});
				TweenLite.to(img, .5, {y: outPosY, onComplete: function():void {
					img.removeFromParent(true);
					img=null;
					if (cb)
						cb();
				}
							 })
			}});
		}



		private function playLion():void
		{
			LionMC.instance.say("皇上辛苦了，这就传晚膳", 0, 0, 0, sceneOver, 20);
		}

		private function playEff():void
		{
			memorialTop.removeFromParent(true);
			for (var i:int=0; i < memorialArr.length; i++)
			{
				var img:Image=memorialArr[i];
				removeImg(img, i);
			}

			TweenLite.delayedCall((i + 1) * .2, addChoose);
		}

		private function removeImg(img:Image, i:int):void
		{
			TweenLite.delayedCall((memorialArr.length - i + 1) * .2, function():void {
				img.removeFromParent(true);
			});
		}

		private function callBack():void
		{
			count++;
			TopBar.show();

			if (count == 2)
			{
				endEff(function():void {
					MC.instance.stage.removeChild(drawScene);
					drawScene=null;
					showCard("9", function():void {
						showAchievement(23, playLion);
					});
				});
			}
			else
				playEff();
		}

		private function endEff(cb:Function):void
		{
			removeMemorial(memorialBottom, cb);
		}

		private function addChoose():void
		{
			chooseWin=new Sprite();

			var bar:Image=getImage("continue");
			bar.x=341;
			bar.y=453;
			chooseWin.addChild(bar);

			var yes:ElasticButton=new ElasticButton(getImage("yesBtn"));
			yes.shadow=getImage("yesBtn-down");
			yes.x=386 + 54;
			yes.y=596 + 40;
			chooseWin.addChild(yes);
			yes.addEventListener(ElasticButton.CLICK, onYes);

			var no:ElasticButton=new ElasticButton(getImage("noBtn"));
			no.shadow=getImage("noBtn-down");
			no.x=522 + 54;
			no.y=596 + 40;
			chooseWin.addChild(no);
			no.addEventListener(ElasticButton.CLICK, onNo);

			PopUpManager.addPopUp(chooseWin, true, false);
		}

		private function onYes(e:Event):void
		{
			chooseWin.touchable=false;
			PopUpManager.removePopUp(chooseWin);
			chooseWin.dispose();
			memorialBottom.addEventListener(TouchEvent.TOUCH, onBottonMemorialTouch);
		}

		private function onBottonMemorialTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(memorialBottom, TouchPhase.ENDED);
			if (!tc)
				return;
			memorialBottom.removeEventListener(TouchEvent.TOUCH, onBottonMemorialTouch);
			initDraw(bottomIndex);
		}

		private function onNo():void
		{
			memorialBottom.removeFromParent(true);
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
