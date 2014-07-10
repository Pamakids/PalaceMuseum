package views.module6.scene62
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceGame;

	public class ArcherGame extends PalaceGame
	{
		public function ArcherGame(am:AssetManager=null)
		{
			super(am);

			addBG();

			initGame();
		}

		private function initGame():void
		{
			level=2;

			initSky();
			initConstruction();
			initWall();

			initField();
			initTargets();

			initKing();

			enterKing();

			startMove();
			kingJump();
		}

		private var totaltime:Number=60;
		private var rate:Number=30;

		private function initTargets():void
		{
			var totals:Number=rate*totaltime;
			var distance:Number=totals*fieldSpeed;
			var num:int=distance/targetGAP;

			for (var i:int = 0; i < num; i++) 
			{
				var target:Target=new Target(getImage('target-base'),getImage('target'));
				field.addChild(target);
				target.x=1024+(i+1)*targetGAP;
				target.y=500;
				targetArr.push(target);
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

			var multi:Number=_level==2?1.3:1;

			cloudSpeed=4*multi;
			constructionSpeed=5*multi;
			wallSpeed=7*multi;
			fieldSpeed=9*multi;
		}


		private function initKing():void
		{
			king=new Sprite();

			king.y=557;
			king.x=-800;

			addChild(king);

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
			var mc:MovieClip=king.getChildAt(1) as MovieClip;
			mc.currentFrame=1;
			Starling.juggler.delayCall(function():void{
				mc.currentFrame=0;
			},.15);
		}

		private var kingX:Number=-150

		private function enterKing():void
		{
			TweenLite.to(king,2,{x:kingX,ease:Quad.easeOut,onComplete:function():void{
				bgMoving=true;
				iniContrller();
			}});
		}

		private var arrowX:Number=458;

		private function iniContrller():void
		{
			addEventListener(TouchEvent.TOUCH,onTouch);
		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this,TouchPhase.ENDED);
			if(tc)
			{
				initArrow();
				kingShoot();
			}
		}

		private function initArrow():void
		{
			var arrow:Arrow=new Arrow(getImage('arrow'));
			arrow.x=arrowX+king.x;
			arrow.y=564;
			field.addChild(arrow);
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
			addChild(construction1);
			addChild(construction2);
			construction2.x=construction1.width;
		}

		private function initWall():void
		{
			for (var i:int = 0; i < 3; i++) 
			{
				var wall:Image=getImage('wall');
				addChild(wall);
				wall.x=i*wall.width;
				wall.y=133;
				wallArr.push(wall);
			}
		}

		private function initField():void
		{
			field=new Sprite();
			addChild(field);
			for (var i:int = 0; i < 3; i++) 
			{
				var f:Image=getImage('field');
				field.addChild(f);
				f.x=i*(f.width-1);
				f.y=255;
				fieldArr.push(f);
			}
		}

		private function initSky():void
		{
			sky=new Sprite();
			addChild(sky);
			var sky1:Image=getImage('sky');
			sky.addChild(sky1);
			var sky2:Image=getImage('sky');
			sky.addChild(sky2);
			sky2.x=sky1.width;
		}

		private var bgMoving:Boolean=false;
		private var targetArr:Array=[];

		private function onEnterFrame(e:Event):void
		{
			if(!bgMoving)
				return;
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
			field.addChildAt(jar,3);
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

		private function moveTargetsAndArrows():void
		{
			for each (var target:Target in targetArr) 
			{
				target.x-=fieldSpeed;
			}

			for each (var arrow:Arrow in arrowArr) 
			{
				arrow.x+=arrowSpeedX;
				arrow.y+=arrowSpeedY;
				var scale:Number=arrow.scaleX-.02;
				if(scale>=.5)
					arrow.scaleX=arrow.scaleY=scale;
				else
					arrow.removeFromParent(true);
			}
		}

		private function checkHit(arrow:Arrow):Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
	}
}

