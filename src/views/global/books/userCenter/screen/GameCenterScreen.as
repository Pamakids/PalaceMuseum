package views.global.books.userCenter.screen
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.utils.Dictionary;
	
	import controllers.DC;
	import controllers.MC;
	
	import feathers.core.PopUpManager;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	
	import views.global.books.BooksManager;
	import views.global.books.components.GameScene;
	import views.global.books.components.ItemForGameList;
	import views.global.books.events.BookEvent;
	import views.global.books.userCenter.win.W_Game;

	/**
	 * 游戏中心
	 * @author Administrator
	 */
	public class GameCenterScreen extends BaseScreen
	{
		public function GameCenterScreen()
		{
			super();
		}

		override protected function initialize():void
		{
			initPages();
			getGameDatas();
			initGameList();

			dispatchEventWith(BookEvent.InitViewPlayed);
		}
		
		override protected function initPages():void
		{
			var image:Image = BooksManager.getImage("background_2");
			image.scaleX=image.scaleY=2;
			this.addChild( image );
		}

		/**
		 * 游戏数据
		 * @return
		 * 	[
		 * 		{name: "gameName", iconIndex: 1, resultEasy: "", resultHard: "", numStars: 0},
		 * 		{name: "gameName", iconIndex: 1, resultEasy: "", resultHard: "", numStars: 0},
		 * 		{name: "gameName", iconIndex: 1, resultEasy: "", resultHard: "", numStars: 0}
		 * 	]
		 */
		private var gameDatas:Array;
		
		private function getGameDatas():void
		{
			gameDatas=DC.instance.getGameDatas();
		}
		private var gameList:Vector.<ItemForGameList>;
		
		private function initGameList():void
		{
			const count:int=gameDatas.length;
			gameList=new Vector.<ItemForGameList>(count);
			var item:ItemForGameList;
			for (var i:int=0; i < count; i++)
			{
				item=new ItemForGameList(gameDatas[i], show_W_game);
				this.addChild(item);
				item.x=55 + (i % 2) * 470;
				item.y=120 + int(i / 2) * 270;
				gameList[i]=item;
			}
		}
		
		private var w_game:W_Game;
		
		private function init_w_game(value:Object):void
		{
			w_game=new W_Game(value);
			w_game.closeWinHandler=hideWinHandler;
			w_game.startGameHandler=startGameHandler;
		}
		
		private function show_W_game(value:Object):void
		{
			(!w_game) ? init_w_game(value) : w_game.resetData(value);
			showWinHandler(w_game);
		}
		
		private function showWinHandler(win:DisplayObject):void
		{
			PopUpManager.addPopUp(win, true, false);
			win.y=768 - win.height >> 1;
			win.x=1024;
			TweenLite.to(win, 0.3, {x: 1024 - win.width >> 1, ease: Cubic.easeIn});
		}
		
		private function hideWinHandler(win:DisplayObject, onCompleted:Function=null, paras:Object=null):void
		{
			
			var tween:TweenLite=TweenLite.to(win, 0.3, {x: 1024, ease: Cubic.easeOut, onComplete: function():void {
				if (win) {
					if (PopUpManager.isPopUp(win))
						PopUpManager.removePopUp(win);
					else
						win.removeFromParent(true);
				}
				if (onCompleted)
					onCompleted(paras);
				delete twDic[win];
			}});
			
			twDic[win]=tween;
		}
		private var twDic:Dictionary=new Dictionary();
		private var gameScene:GameScene;
		
		private function startGameHandler(gameIndex:int):void
		{
			gameScene=new GameScene(gameIndex);
			gameScene.playedCallBack=gamePlayedForW_game;
			MC.instance.main.addChild(gameScene);
		}
		
		private function gamePlayedForW_game():void
		{
			getGameDatas();
			const max:int=gameDatas.length;
			for (var i:int=0; i < max; i++)
			{
				gameList[i].data=gameDatas[i];
			}
			gameScene.removeFromParent(true);
		}
		

		override public function dispose():void
		{
			for each (var item:ItemForGameList in gameList)
			{
				item.removeFromParent(true);
			}
			if (w_game)
				w_game.removeFromParent(true);
			if (gameScene)
				gameScene.removeFromParent(true);
			super.dispose();
		}
	}
}
