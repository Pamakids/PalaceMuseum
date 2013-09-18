package views.module4.scene41
{
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.base.PalaceGame;

	public class OperaGame extends PalaceGame
	{
		public function OperaGame(am:AssetManager=null)
		{
			super(am);
		}

		private var startHolder:Sprite;
		private var gameHolder:Sprite;
		private var endHolder:Sprite;

		private var gameLevel:int;

		private function initStart():void
		{
			startHolder=new Sprite();
			addChild(startHolder);
			startHolder.addChild(getImage("gamebg"));
			var startBtn:ElasticButton=new ElasticButton(getImage("game-start"));
			startBtn.shadow=getImage("game-start-down");
			startBtn.addEventListener(ElasticButton.CLICK, onStartClick);
			startHolder.addChild(startBtn);
			startBtn.x=512;
			startBtn.y=650;
		}

		private function onStartClick(e:Event):void
		{
			initGame();
		}

		private function initGame():void
		{
			removeChild(startHolder);
			startHolder.dispose();
			startHolder=null;

			gameHolder=new Sprite();
			addChild(gameHolder);
			gameHolder.addChild(getImage("bg-opera"));

			//0-2 从下往上
			for (var i:int=0; i < 3; i++)
			{
				var sp:Sprite=new Sprite();
				addChild(sp);
				sp.y=spYArr[i];
				spArr.push(sp);
			}
		}

		private var spYArr:Array=[];
		private var spArr:Array=[];

		private function initResult():void
		{
			removeChild(gameHolder);
			gameHolder.dispose();
			gameHolder=null;

			endHolder=new Sprite();
			addChild(endHolder);
		}
	}
}
