package views.module6
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceGame;
	import views.components.base.PalaceScene;
	import views.module6.scene62.ArcherGame;

	public class Scene62 extends PalaceScene
	{

		private var game:ArcherGame;
		public function Scene62(am:AssetManager=null)
		{
			super(am);

			addBG('bg62');

//			initGame();

			initAreas();
			initKing();
		}

		private function initKing():void
		{
			var king:Image=getImage('kingxx');
			king.x=1024-king.width>>1;
			king.y=768-king.height;
			addChild(king);
			king.touchable=false;

//			king.addEventListener(TouchEvent.TOUCH,onKingTouch);

			bagSP=new Sprite();
			bagSP.touchable=false;
			addChild(bagSP);
			var bag:Image=getImage('bag1');

			var kx:Number=king.x;
			var ky:Number=king.y;

			bagSP.addChild(bag);
			bag.x=kx+130; 
			bag.y=ky+287;

			arrowPosArr.push(new Point(kx+1,ky+194));
			arrowPosArr.push(new Point(kx+2,ky+147));
			arrowPosArr.push(new Point(kx+42,ky+143));

			for each (var pt:Point in arrowPosArr) 
			{
				var arrow:Image=getImage('arrow1');
				bagSP.addChildAt(arrow,0);
				arrow.x=pt.x;
				arrow.y=pt.y;
			}
		}

//		private function onKingTouch(e:TouchEvent):void
//		{
//			var tc:Touch=e.getTouch(this,TouchPhase.ENDED);
//			if(tc)
//				Prompt.showTXT(580,540,'哇！好多兵器。');
//		}

		override protected function init():void
		{
			super.init();
			Prompt.showTXT(580,540,'哇！好多兵器。',20,lionSay);
		}

		private function lionSay():void
		{
			LionMC.instance.say('你知道射箭要用那一件兵器吗？',0,0,0,function():void{
				addEventListener(TouchEvent.TOUCH,onTouch);
			},20,true);
		}

		private var instrumentArea:Rectangle;
		private var instrumentText:String='为使皇帝及八旗子弟保持满族骑射传统，乾隆帝下令在紫禁城内景运门外修建箭亭，以供平时习武。殿试武进士时，皇帝在此试弓、舞刀、举大石等技。';
//		private var weaponsArr:Array=[];
		private var weaponArea:Rectangle;
		private var weaponsname:Array=['殳(shu)','偃(yan)月刀','镋(tang)','偃(yan)月刀','刀',
									   '阿虎枪', '矛', '镋(tang)', '戟(ji)','戟(ji)'];
		private var warriorArr:Array=[];
		private var warriorTexts:Array=['骑射的重点是要看好靶子的位置。','拉弓射箭，臂力很重要。'];

		private var gameArea:Rectangle;

		private var kingArea:Rectangle=new Rectangle(458,468,225,236);

		private function initAreas():void
		{
			instrumentArea=new Rectangle(167,68,696,167);
			gameArea=new Rectangle(842,218,61,352);
			warriorArr.push(new Rectangle(50,273,137,211));
			warriorArr.push(new Rectangle(858,261,137,211));

			weaponArea=new Rectangle(121,104,710,390);
		}

		private function getCenter(rect:Rectangle):Point
		{
			return new Point(rect.x+rect.width/2,rect.y+rect.height/2);
		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(bg,TouchPhase.ENDED);
			if(!tc)
				return;

			var pt:Point=tc.getLocation(this);

			if(gameArea.containsPoint(pt))
			{
				initGame();
				return;
			}

			if(kingArea.containsPoint(pt))
			{
				Prompt.showTXT(580,540,'哇！好多兵器。');
				return;
			}

			if(instrumentArea.containsPoint(pt))
			{
				Prompt.showTXT(instrumentArea.x+instrumentArea.width/3,instrumentArea.y+instrumentArea.height,
							   instrumentText,20,null,this,1,true);
				return;
			}

			if(weaponArea.containsPoint(pt))
			{
				var wi:int=(pt.x-weaponArea.x)/weaponArea.width*10;
				wi=Math.max(0,Math.min(9,wi));
				if(weaponP)
					weaponP.playHide();
				weaponP=Prompt.showTXT(pt.x,pt.y,weaponsname[wi]);
				return;
			}

			for (var i:int = 0; i < warriorArr.length; i++) 
			{
				var rec2:Rectangle=warriorArr[i];
				if(rec2.containsPoint(pt))
				{
					var t:String=warriorTexts[i];
					Prompt.showTXT(rec2.x+rec2.width/2,rec2.y+rec2.height/4,t,20,null,this,i==0?1:3);
					return;
				}
			}
		}

		private var weaponP:Prompt;
		private var bagSP:Sprite;
		private var arrowPosArr:Array=[];

		private function initGame():void
		{
			game=new ArcherGame(this.assetManager);
			addChild(game);
			game.addEventListener(PalaceGame.GAME_OVER,onGameOver);
			game.addEventListener(PalaceGame.GAME_RESTART,onRestart);
		}

		private function onGameOver(e:Event):void
		{
			if(game.isWin)
			{

			}

			game.removeFromParent(true);
			game=null;

			sceneOver();
		}

		private function onRestart(e:Event):void
		{
			game.removeFromParent(true);
			game=null;

			initGame();
		}
	}
}

