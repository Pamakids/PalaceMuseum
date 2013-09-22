package views.global.userCenter.userInfo
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import feathers.core.PopUpManager;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	import views.components.Prompt;
	import views.global.userCenter.IUserCenterScreen;
	import views.global.userCenter.UserCenter;
	import views.global.userCenter.UserCenterManager;

	/**
	 * 用户信息
	 * @author Administrator
	 */	
	public class UserInfoScreen extends Screen implements IUserCenterScreen
	{
		public function UserInfoScreen()
		{
		}
		
		override protected function initialize():void
		{
			initBackgroundImage();
			initCrtUserView();
			initButton();
			initGameList();
		}
		
		private var gameList:Vector.<ItemForGameList>;
		private function initGameList():void
		{
			const count:int = 4;
			gameList = new Vector.<ItemForGameList>(count);
			var item:ItemForGameList;
			for(var i:int = 0;i<count;i++)
			{
				item = new ItemForGameList({name:"拼图游戏", numStars: Math.floor(Math.random()*4), iconIndex:i, resultEasy: "00:00", resultHard: "00:00"}, show_W_game);
				this.addChild( item );
				item.x = 55 + (i%2) * 470;
				item.y = 240 + int(i/2) * 200;
				gameList[i] = item;
			}
		}
		
		private var w_game:W_Game;
		private var w_editUser:W_EditUser;
		private var w_chooseUser:W_ChooseUser;
		
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
		}
		private function hideWinHandler(win:DisplayObject):void
		{
			TweenLite.to(win, 0.3, {x: 1024, ease: Cubic.easeOut, onComplete:function():void{
					PopUpManager.removePopUp(win);
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
			}
			showWinHandler(w_chooseUser);
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
		
		public function getScreenTexture():Vector.<Texture>
		{
			if(!UserCenterManager.getScreenTexture(UserCenter.USERINFO))
				initScreenTextures();
			return UserCenterManager.getScreenTexture(UserCenter.USERINFO);
		}
		
		public var viewWidth:Number;
		public var viewHeight:Number;
		private function initScreenTextures():void
		{
			if(UserCenterManager.getScreenTexture(UserCenter.USERINFO))
				return;
			var render:RenderTexture = new RenderTexture(viewWidth, viewHeight, true);
			render.draw( this );
			var ts:Vector.<Texture> = new Vector.<Texture>(2);
			ts[0] = Texture.fromTexture( render, new Rectangle( 0, 0, viewWidth/2, viewHeight) );
			ts[1] = Texture.fromTexture( render, new Rectangle( viewWidth/2, 0, viewWidth/2, viewHeight) );
			UserCenterManager.setScreenTextures(UserCenter.USERINFO, ts);
		}
	}
}