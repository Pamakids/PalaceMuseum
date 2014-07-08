package views.module6.scene62
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
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

			initKing();

			startMove();
		}

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
		}

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

		private function onEnterFrame(e:Event):void
		{
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
			field.addChild(jar);
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
	}
}

