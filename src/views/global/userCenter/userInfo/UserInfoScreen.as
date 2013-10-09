package views.global.userCenter.userInfo
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import controllers.DC;
	import controllers.MC;
	
	import feathers.controls.Button;
	import feathers.core.PopUpManager;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import views.global.userCenter.BaseScreen;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 用户信息
	 * @author Administrator
	 */	
	public class UserInfoScreen extends BaseScreen
	{
		public function UserInfoScreen()
		{
		}
		
		override protected function initialize():void
		{
			initGameDatas();
			initBackgroundImage();
			initCrtUserView();
			initButton();
			initGameList();
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
		private function initGameDatas():void
		{
			gameDatas = DC.instance.getGameDatas();
		}
		
		private var gameList:Vector.<ItemForGameList>;
		private function initGameList():void
		{
			const count:int = gameDatas.length;
			gameList = new Vector.<ItemForGameList>(count);
			var item:ItemForGameList;
			for(var i:int = 0;i<count;i++)
			{
				item = new ItemForGameList(gameDatas[i], show_W_game);
				this.addChild( item );
				item.x = 55 + (i%2) * 470;
				item.y = 240 + int(i/2) * 200;
				gameList[i] = item;
			}
		}
		
		private var w_game:W_Game;
		private var w_editUser:W_EditUser;
		private var w_chooseUser:W_ChooseUser;
		private var w_deleteUser:W_DeleteUser;
		
		private function show_W_deleteUser(userdata:Object):void
		{
			if(!w_deleteUser)
				init_w_deleteUser();
			w_deleteUser.userdata = userdata;
			w_deleteUser.deleteHandler = deleteHandler;
			hideWinHandler(w_editUser, showWinHandler, w_deleteUser);
		}
		
		private function init_w_deleteUser():void
		{
			w_deleteUser = new W_DeleteUser();
			w_deleteUser.closeWinHandler = hideWinHandler;
		}
		
		private function show_W_game(value:Object):void
		{
			(!w_game)?init_w_game(value):w_game.resetData(value);
			showWinHandler(w_game);
		}
		
		private function showWinHandler(win:DisplayObject):void
		{
			PopUpManager.addPopUp(win, true, false);
			win.y = 768 - win.height >> 1;
			win.x = 1024;
			TweenLite.to(win, 0.3, {x: 1024 - win.width >> 1, ease: Cubic.easeIn});
		}
		
		private function init_w_game(value:Object):void
		{
			w_game = new W_Game(value);
			w_game.closeWinHandler = hideWinHandler;
			w_game.startGameHandler = startGameHandler;
		}
		
		private var gameScene:GameScene;
		private function startGameHandler(gameIndex:int):void
		{
			gameScene = new GameScene(gameIndex);
			gameScene.playedCallBack = gamePlayedForW_game;
			MC.instance.main.addChild( gameScene );
		}
		private function gamePlayedForW_game():void
		{
			initGameDatas();
			const max:int = gameDatas.length;
			for(var i:int = 0;i<max;i++)
			{
				gameList[i].data = gameDatas[i];
			}
			gameScene.removeFromParent(true);
		}
		
		private function hideWinHandler(win:DisplayObject, onCompleted:Function=null, paras:Object=null):void
		{
			TweenLite.to(win, 0.3, {x: 1024, ease: Cubic.easeOut, onComplete:function():void{
					PopUpManager.removePopUp(win);
					if(onCompleted)
						onCompleted(paras);
			}});
		}
		
		/**
		 * 切换角色按钮
		 */		
		private var button:Button;
		private function initButton():void
		{
			button = new Button();
			button.defaultSkin = new Image( UserCenterManager.getTexture("button_changeUser_up") );
			button.downSkin = new Image( UserCenterManager.getTexture("button_changeUser_down") );
			this.addChild( button );
			button.x = 814;
			button.y = 143;
			button.addEventListener( TouchEvent.TOUCH, onTouch );
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(button);
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				show_w_chooseUser();
			}
		}
		
		private function show_w_chooseUser():void
		{
			if(!w_chooseUser)
			{
				w_chooseUser = new W_ChooseUser();
				w_chooseUser.closeWinHandler = hideWinHandler;
				w_chooseUser.editHandler = show_w_editUser;
			}
			showWinHandler(w_chooseUser);
		}
		
		/**
		 * 
		 * @param data
		 * 
		 */		
		private function show_w_editUser(userdata:Object):void
		{
			(!w_editUser)?init_w_editUser(userdata):w_editUser.resetData(userdata);
			hideWinHandler(w_chooseUser, showWinHandler, w_editUser);
		}
		private function init_w_editUser(userdata:Object):void
		{
			w_editUser = new W_EditUser(userdata);
			w_editUser.closeWinHandler = hideWinHandler;
			w_editUser.deleteHandler = show_W_deleteUser;
			w_editUser.changeHandler = changeHandler;
		}
		
		/**
		 * 删除角色
		 * @param userdata
		 * 
		 */		
		private function deleteHandler(userdata:Object):void
		{
		}
		
		/**
		 * 变更角色
		 * @param userdata
		 * 
		 */		
		private function changeHandler(userdata:Object):void
		{
		}
		
		private var crtUser:CurrentUser;
		private function initCrtUserView():void
		{
			crtUser = new CurrentUser({ username: "我是小皇帝", iconIndex: 0, birthday: "2013-01-11"});
			this.addChild( crtUser );
			crtUser.x = 55;
			crtUser.y = 42;
		}
		
		private function initBackgroundImage():void
		{
			var texture:Texture =  UserCenterManager.getTexture("page_left");
			var image:Image = new Image( texture );
			this.addChild( image );
			image.touchable = false;
			texture = UserCenterManager.getTexture("page_right")
			image = new Image( texture );
			image.x = width/2;
			this.addChild( image );
			image.touchable = false;
			texture = UserCenterManager.getTexture("line_long");
			image = new Image( texture );
			image.x = 60;
			image.y = 197;
			this.addChild( image );
			image.touchable = false;
			image = new Image( texture );
			image.x = 519;
			image.y = 197;
			this.addChild( image );
			image.touchable = false;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}