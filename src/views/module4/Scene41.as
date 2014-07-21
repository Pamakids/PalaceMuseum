package views.module4
{
	import com.greensock.TweenLite;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	import controllers.UserBehaviorAnalysis;

	import sound.SoundAssets;

	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Craw;
	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.global.TailBar;

	/**
	 * 上朝模块
	 * 上朝场景
	 * @author Administrator
	 */
	public class Scene41 extends PalaceScene
	{
		public function Scene41(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=10;
			addBG("bg41");
			bg.touchable=false;
			bg.addEventListener(TouchEvent.TOUCH,onBGTouch);

			lionChat1();
		}

		private var kingArea:Rectangle=new Rectangle(486,329,78,86);

		private function onBGTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(bg,TouchPhase.ENDED);
			if(!tc)
				return;
			var pt:Point=tc.getLocation(this);
			if(kingArea.containsPoint(pt)){
				if (chatP)
					chatP.playHide();
				chatP=Prompt.showTXT(490, 335, chat2, 20,null,this,3);
			}
		}

		override protected function init():void
		{
			initTime=getTimer();
			UserBehaviorAnalysis.trackView(sceneName);
			SoundAssets.playBGM("s41bgm");
		}

		private function lionChat1():void
		{
			LionMC.instance.say2(chat1,0, 50, 520, kingChat1, 20,false,3,0);
		}

		private function kingChat1():void
		{
			LionMC.instance.say3(chat2,0, 537, 335, lionChat2, 20,false,3,0,false,true,true);
		}

		private function lionChat2():void
		{
			LionMC.instance.say3(chat3,0, 50, 520, lionChat3, 20,false,3,0,false,false,false);
		}

		private function lionChat3():void
		{
			LionMC.instance.say3(chat4,0, 50, 520, chatOver, 20,true,3,0,true,false,true);
		}

		private function chatOver():void
		{
			birdIndex=9;
			getReady();
		}

		private var chatP:Prompt;
		private var chat1:String="御门听政也叫“上早朝”，就在这儿\n举行。";
		private var chat2:String="皇帝为什么在室外办公呢？"
		private var chat3:String="这是皇帝在向天地彰显他的公正和勤勉！"
		private var chat4:String="对于皇帝来说御门听政是很严肃的工作，你要熟悉整个过程，绝对不能马虎。" //task

		private function getReady():void
		{
			bg.touchable=true;
			chancellor=getImage("chancellor");
			chancellor.x=1024;
			chancellor.y=378;
			addChild(chancellor);
			addCraws();
			TailBar.show();
		}


		private var crawPosArr:Array=[new Point(900, 590)];

		private var hintArr:Array=["大臣们奏事时，依次来到皇帝的龙案前跪下，汇报工作，接受指令。"];

		private function addCraws():void
		{
			for (var i:int=0; i < crawPosArr.length; i++)
			{
				addCraw(crawPosArr[i], onCrowTouch, this, i);
			}
		}

		private function onCrowTouch(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			var craw:Craw=e.currentTarget as Craw;
			if (!craw)
				return;
			var tc:Touch=e.getTouch(craw, TouchPhase.ENDED);
			if (!tc)
				return;
			showChancellor(craw);
		}

		private function showChancellor(craw:Craw):void
		{
			var index:int=craw.index;
			craw.removeEventListener(TouchEvent.TOUCH, onCrowTouch);
			craw.deActive();
			craw.touchable=false;

			var dx:Number=craw.x+30;
			TweenLite.to(craw,.5,{x:dx});

			showCard("9",showAchieve);

			SoundAssets.playSFX("popup");
		}

		private function showAchieve():void
		{
			showAchievement(21, playEnter);
		}

		private function playEnter():void
		{
			TweenLite.to(chancellor,.5,{x:762,onComplete:function():void{
				sceneOver();
				showHint(chancellor.x + 50, chancellor.y, hintArr[0],3,function():void{
					chancellor.addEventListener(TouchEvent.TOUCH,onChancellorTouch);
				});
			}});
		}

		private function onChancellorTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(chancellor, TouchPhase.ENDED);
			if (tc)
				showHint(chancellor.x + 50, chancellor.y, hintArr[0],3);
		}

		private function showHint(_x:Number, _y:Number, content:String, align:int=1,cb:Function=null):void
		{
			Prompt.showTXT(_x, _y, content, 20, cb, this, align, true);
		}

		private var chancellor:Image;
	}
}


