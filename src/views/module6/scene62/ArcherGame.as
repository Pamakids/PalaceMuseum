package views.module6.scene62
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;

	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	import controllers.MC;

	import models.FontVo;
	import models.SOService;

	import sound.SoundAssets;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.LionMC;
	import views.components.base.PalaceGame;
	import views.components.share.ShareVO;
	import views.components.share.ShareView;

	public class ArcherGame extends PalaceGame
	{
		public function ArcherGame(am:AssetManager=null)
		{
			super(am);

			bigGame=true;
//			closeBtn.visible=false;
			addBG();
			initStart();

			addClose();
		}

		private function initStart():void
		{
			startHolder=new Sprite();
			addChild(startHolder);
			var title:Image=getImage('archery-title');
			startHolder.addChild(title);
			title.x=119;
			title.y=25;

			sbH=new Sprite();
			hbH=new Sprite();
			startHolder.addChild(sbH);
			startHolder.addChild(hbH);
			sbH.x=325;
			sbH.y=405;
			hbH.x=325;
			hbH.y=496;

			sbH.addChild(getImage('simple'));
			sbH.addChild(getImage('simple-on'));
			hbH.addChild(getImage('hard'));
			hbH.addChild(getImage('hard-on'));

			sbH.addEventListener(TouchEvent.TOUCH,onSBTouch);
			hbH.addEventListener(TouchEvent.TOUCH,onHBTouch);

			level=0;

			var sbBtn:ElasticButton=new ElasticButton(getImage('start'),getImage('start-shadow'));
			sbBtn.x=734;
			sbBtn.y=506;
			startHolder.addChild(sbBtn);
			sbBtn.addEventListener(ElasticButton.CLICK,onStart);
		}

		private function onStart(e:Event):void
		{
			startHolder.removeFromParent(true);
			initGame();
		}

		private function onHBTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(hbH,TouchPhase.ENDED);
			if(tc)
				level=1;
		}

		private function onSBTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(sbH,TouchPhase.ENDED);
			if(tc)
				level=0;
		}

		private function initData():void
		{
			var multi:Number=level==1?1.3:1;

			cloudSpeed*=multi;
			constructionSpeed*=multi;
			wallSpeed*=multi;
			fieldSpeed*=multi;
			targetGAP*=multi;

			targetY=arrowSY-(level==2?distance2:distance1);
			targetScale=level==1?.7:1;
		}

		private function initGame():void
		{
//			level=2;
			initData();

			gameHolder=new Sprite();
			addChild(gameHolder);

			initSky();
			initConstruction();
			initWall();

			initField();
			initTargets();

			initKing();

			enterKing();

			startMove();
			kingJump();

			initInfo();
		}

		override protected function init():void
		{
			MC.instance.stage.stage.frameRate=60;
			super.init();
		}

		override public function dispose():void
		{
			ShareView.instance.hide();
			MC.instance.stage.stage.frameRate=30;
			super.dispose();
		}

		private var maxtime:Number=40;
		private var hz:Number=60;

		private function initTargets():void
		{
			totalTime=hz*maxtime;
			var distance:Number=totalTime*fieldSpeed;
			var num:int=distance/targetGAP;

//			trace(totalTime,fieldSpeed,distance,num)

			for (var i:int = 0; i < num; i++) 
			{
				var target:Target=new Target(getImage('target-base'),getImage('target'),targetScale);
				targetsHolder.addChild(target);
				target.x=1024+(i+1)*targetGAP;
				target.y=targetY;
				targetArr.push(target);

				if(i==num-1)
					totalLength=target.x;
			}
		}

		private var targetGAP:Number=800;

		private var _level:int;

		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;

			if(level==0)
			{
				sbH.getChildAt(0).visible=false;
				sbH.getChildAt(1).visible=true;

				hbH.getChildAt(0).visible=true;
				hbH.getChildAt(1).visible=false;
			}else
			{
				sbH.getChildAt(1).visible=false;
				sbH.getChildAt(0).visible=true;

				hbH.getChildAt(1).visible=true;
				hbH.getChildAt(0).visible=false;
			}
		}


		private function initKing():void
		{
			king=new Sprite();

			king.y=557;
			king.x=-800;

			gameHolder.addChild(king);

			king.addChild(getImage('horse'));
			var kingMC:MovieClip=new MovieClip(assetManager.getTextures('king'),1);
			king.addChild(kingMC);
			kingMC.x=114;
			kingMC.y=-157;
			Starling.juggler.add(kingMC);
			kingMC.stop();
		}

		private function kingJump():void
		{
			var land:Boolean=(king.y==580);
			var dy:Number=land?557:580;
			var fun:Function=land?Quad.easeOut:Quad.easeIn;
			var obj:Object={y:dy,ease:fun,onComplete:kingJump}
			TweenLite.to(king,.25,obj);
		}

		private function kingShoot():void
		{
			SoundAssets.playSFX('shoot');
			shooting=true;
			var mc:MovieClip=king.getChildAt(1) as MovieClip;
			mc.currentFrame=1;
			Starling.juggler.delayCall(function():void{
				mc.currentFrame=0;
			},.15);

			TweenLite.delayedCall(1,function():void{
				shooting=false;
			});
		}

		private var kingX:Number=-150

		private function enterKing():void
		{
			SoundAssets.playSFX('horse');
			TweenLite.to(king,2,{x:kingX,ease:Quad.easeOut,onComplete:function():void{
				bgMoving=true;
				iniContrller();
//				timer.start();
			}});
		}

		private function initInfo():void
		{
			infoHolder=new Sprite();
			gameHolder.addChild(infoHolder);
			infoHolder.touchable=false;

			var scoreboard:Image=getImage("scoreboard");
			scoreboard.x=1024 - scoreboard.width;
			infoHolder.addChild(scoreboard);

			var timebg:Image=getImage("progressbg");
			timeprogress=new Sprite(); 
			timeprogress.addChild(getImage("progress"));
			timebg.x=timeprogress.x=246;
			timebg.y=timeprogress.y=9;
			infoHolder.addChild(timebg);
			infoHolder.addChild(timeprogress);
			timeprogress.clipRect=new Rectangle(30, 0, 0, 51);

			initScore();
//			initTimer();
		}

		private function initScore():void
		{
			scoreTF=new TextField(100, 40, '0',FontVo.PALACE_FONT);
			scoreTF.fontSize=24;
			scoreTF.color=0xb83d00;
			infoHolder.addChild(scoreTF);
			scoreTF.x=885;
			scoreTF.y=20;
			score=0;
		}

//		private function initTimer():void
//		{
//			timer=new Timer(1000 / hz);
//			timer.addEventListener(TimerEvent.TIMER, onTimer);
//		}

		protected function onTimer(event:TimerEvent):void
		{
		}

		private var arrowX:Number=458;

		private function iniContrller():void
		{
			addEventListener(TouchEvent.TOUCH,onTouch);
			addEventListener('targetHitted',onHitted);
		}

		private function onHitted(e:Event):void
		{
			var target:Target=e.target as Target;
			target.playScore(getImage('plus'+target.score.toString()));
			score+=target.score;
			scoreTF.text=score.toString();
		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this,TouchPhase.ENDED);
			if(tc&&!shooting)
			{
				initArrow();
				kingShoot();
			}
		}

		private function initArrow():void
		{
			var arrow:Arrow=new Arrow(getImage('arrow'));
			arrow.x=arrowX+kingX;
			arrow.y=arrowSY;
			frontHolder.addChild(arrow);
			arrowArr.push(arrow);

			arrow.rotation=-Math.PI/6;
		}

		private var arrowArr:Array=[];

		private function startMove():void
		{
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}

		private var cloudSpeed:Number=4;
		private var constructionSpeed:Number=5;
		private var wallSpeed:Number=7;
		private var fieldSpeed:Number=9;

		private var cloudArr:Array=[];
		private var jarArr:Array=[];

		private var wallArr:Array=[];
		private var fieldArr:Array=[];

		private var sky:Sprite;

		private var construction1:Image;
		private var construction2:Image;

		private var field:Sprite;

		private var king:Sprite;

		private function initConstruction():void
		{
			construction1=getImage('construction1');
			construction2=getImage('construction2');
			gameHolder.addChild(construction1);
			gameHolder.addChild(construction2);
			construction2.x=construction1.width;
		}

		private function initWall():void
		{
			for (var i:int = 0; i < 3; i++) 
			{
				var wall:Image=getImage('wall');
				gameHolder.addChild(wall);
				wall.x=i*wall.width;
				wall.y=133;
				wallArr.push(wall);
			}
		}

		private var totalLength:Number;

		private function initField():void
		{
			field=new Sprite();
			gameHolder.addChild(field);

			for (var i:int = 0; i < 3; i++) 
			{
				var f:Image=getImage('field');
				field.addChild(f);
				f.x=i*(f.width-1);
				f.y=255;
				fieldArr.push(f);
			}

			backHolder=new Sprite();
			targetsHolder=new Sprite();
			frontHolder=new Sprite();
			field.addChild(backHolder);
			field.addChild(targetsHolder);
			field.addChild(frontHolder);
		}

		private var gameHolder:Sprite;

		private function initSky():void
		{
			sky=new Sprite();
			gameHolder.addChild(sky);
			var sky1:Image=getImage('sky');
			sky.addChild(sky1);
		}

		private var bgMoving:Boolean=false;
		private var targetArr:Array=[];

		private function onEnterFrame(e:Event):void
		{
			if(!bgMoving)
				return;

			totalTime--;
//			if (totalTime > 0)
			var lastTarget:Target=targetArr[targetArr.length-1];
			if(lastTarget.x>0)
			{
				timeprogress.clipRect.width=(1-lastTarget.x/totalLength)*470
			}
//				timeprogress.clipRect.width=(1-totalTime / (maxtime * hz)) * 470;
			else
			{
				gameOverHandler();
				return;
			}

			moveConstruction();
			moveWall();
			moveFiled();

			var r1:Number=Math.random();
			var r2:Number=Math.random();

			if(r1*1000<9)
				addCloud();


			if(r2*1000<12)
				addJar();

			moveCloudsAndJars();
			moveTargetsAndArrows();

		}

		private function moveCloudsAndJars():void
		{
			for each (var jar:Image in jarArr) 
			{
				jar.x-=fieldSpeed;
				if(jar.x<-jar.width)
				{
					jar.removeFromParent(true);
					jarArr.pop();
					jar=null;
				}
			}

			for each (var cloud:Image in cloudArr) 
			{
				cloud.x-=cloudSpeed;
				if(cloud.x<-cloud.width)
				{
					cloud.removeFromParent(true);
					cloudArr.pop();
					cloud=null;
				}
			}

		}

		private function addJar():void
		{
			if(jarArr.length>0)
			{
				if(jarArr[0].x>1000)
					return;
			}
			var jar:Image=getImage('jar');
			backHolder.addChild(jar);
			jar.x=1024+100;
			jar.y=208;
			jarArr.unshift(jar);
		}

		private function addCloud():void
		{
			var i:int=int(Math.random()*3)+1;
			var cloud:Image=getImage('cloud'+i);
			sky.addChild(cloud);

			cloud.x=1024+100;
			cloud.y=Math.random()*100-30;

			cloudArr.unshift(cloud);
		}

		private function moveFiled():void
		{
			for each (var filed:Image in fieldArr) 
			{
				filed.x-=fieldSpeed;
				if(filed.x<-filed.width)
					filed.x+=(filed.width-1)*3
			}
		}

		private function moveWall():void
		{
			for each (var wall:Image in wallArr) 
			{
				wall.x-=wallSpeed;
				if(wall.x<-wall.width)
					wall.x+=wall.width*3
			}
		}

		private function moveConstruction():void
		{
			construction1.x-=constructionSpeed;
			construction2.x-=constructionSpeed;

			if(construction1.x<-construction1.width)
				construction1.x=construction2.x+construction2.width;

			if(construction2.x<-construction2.width)
				construction2.x=construction1.x+construction1.width;
		}

		private var arrowSpeedX:Number=10;
		private var arrowSpeedY:Number=-15;
		private var shooting:Boolean;

		private var targetY:Number;
		private var distance1:Number=300;
		private var distance2:Number=360;
		private var arrowSY:Number=564;
		private var targetScale:Number;
		private var backHolder:Sprite;
		private var frontHolder:Sprite;
		private var targetsHolder:Sprite;

		private var startHolder:Sprite;

		private var sbH:Sprite;

		private var hbH:Sprite;
		private var timeprogress:Sprite;
		private var infoHolder:Sprite;
//		private var timer:Timer;
		private var totalTime:int;
		private var endHolder:Sprite;

		private function moveTargetsAndArrows():void
		{
//			targetsHolder.x-=fieldSpeed;
			for each (var target:Target in targetArr) 
			{
				target.x-=fieldSpeed;
				if(target.x<arrowX+kingX&&!target.missed&&target.score==0)
				{
					target.miss(getImage('target-miss'))
				}
			}

			for each (var arrow:Arrow in arrowArr) 
			{
				if(arrow.hitted)
				{
					arrow.x-=fieldSpeed;
					if(arrow.x<-200)
					{
						arrow.removeFromParent(true);
					}
				}else
				{
					arrow.x+=arrowSpeedX;
					arrow.y+=arrowSpeedY;

					var scale:Number=arrow.scaleX-.02;
					if(scale>=.2)
						arrow.scaleX=arrow.scaleY=scale;
					else
						arrow.removeFromParent(true);
				}

				if(arrow.y==targetY&&!arrow.hitted)
				{
					if(checkHit(arrow))
					{
						arrow.hitted=true;
					}else
						backHolder.addChild(arrow);
				}
			}
		}

		private function checkHit(arrow:Arrow):Boolean
		{
			for each (var target:Target in targetArr) 
			{
				if(target.checkArrow(arrow))
					return true;
			}
			return false;
		}

		private function gameOverHandler():void
		{
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			removeEventListener(TouchEvent.TOUCH,onTouch);
			removeEventListener('targetHitted',onHitted);

			MC.instance.stage.stage.frameRate=30;
			SoundAssets.stopBGM();
//			timer.stop();

			SoundAssets.playSFX("gameWin");
			lowerBGM();
			TweenLite.delayedCall( 6.5, resumeBGM);
			LionMC.instance.play(1, 0, 0, initResult, 2);
		}

		private var score:Number=0;
		private var rsBtn:ElasticButton;
		private var scoreTF:TextField;

		private function initResult():void
		{
			gameHolder.removeFromParent(true);
			endHolder=new Sprite();
			addChild(endHolder);
			var isRecord:Boolean=false;
			isWin=true;
			var win:Image=getImage("win-panel");
			endHolder.addChild(win);
			win.x=1024 - win.width >> 1;
			win.y=30;

			var operagameresult:int=SOService.instance.getSO(gameResult + level.toString()) as int;

			var t1:TextField=new TextField(200, 100, "得分：", FontVo.PALACE_FONT, 48, 0xb83d00);
			t1.vAlign="top";
			t1.hAlign="left";
			t1.x=332;
			t1.y=283;
			endHolder.addChild(t1);
			var t2:TextField=new TextField(200, 40, "最高：", FontVo.PALACE_FONT, 26, 0xb83d00);
			t2.vAlign="top";
			t2.hAlign="left";
			t2.x=362;
			t2.y=370;
			endHolder.addChild(t2);

			var scoreTXT:String;
			var recordTXT:String;

			if (!operagameresult || operagameresult < score)
			{
				scoreTXT=score.toString();
				recordTXT=score.toString();
				isRecord=true;
				SOService.instance.setSO(gameResult + level.toString(), score);
			}
			else
			{
				scoreTXT=score.toString();
				recordTXT=operagameresult.toString();
			}

//			TweenLite.delayedCall(1, function():void {
			var scoreTF:TextField=new TextField(300, 100, scoreTXT,FontVo.PALACE_FONT);
			scoreTF.fontSize=48;
			scoreTF.color=0xb83d00;
			scoreTF.x=500 - 40;
			scoreTF.y=285 - 22;
			endHolder.addChild(scoreTF);
//			});

			var recordTF:TextField=new TextField(100, 40, recordTXT,FontVo.PALACE_FONT);
			recordTF.fontSize=24;
			recordTF.color=0xb83d00;
			recordTF.x=520;
			recordTF.y=370;
			endHolder.addChild(recordTF);

			if(level==1)
			{
				var starnum:Number=1;
				if(score>=200)
					starnum=3;
				else if(score>=100)
					starnum=2;
				addStars(starnum,endHolder);
			}

			rsBtn=new ElasticButton(getImage("restart"));
			rsBtn.shadow=getImage("restart-light");
			rsBtn.x=512;
			rsBtn.y=512;
			endHolder.addChild(rsBtn);
			rsBtn.addEventListener(ElasticButton.CLICK,onRestart);

			closeBtn.touchable=closeBtn.visible=true;
			setChildIndex(closeBtn, numChildren - 1);

			if(isRecord)
				showRecord();
			if(isWin)
				ShareView.instance.show('分享',getShareContent('百步穿杨',score.toString()),shareImg);
		}

		private function onRestart(e:Event):void
		{
			dispatchEvent(new Event(PalaceGame.GAME_RESTART));
		}

		private function showRecord():void
		{
			var recordIcon:Image=getImage("record");
			endHolder.addChild(recordIcon);
			recordIcon.x=636;
			recordIcon.y=327;
			recordIcon.scaleX=recordIcon.scaleY=3;
			TweenLite.to(recordIcon, .2, {scaleX: 1, scaleY: 1, ease: Quad.easeOut, onComplete: function():void {
				SoundAssets.playSFX("gamerecord");
			}});
		}
	}
}

