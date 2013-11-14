package views.global.userCenter.userInfo
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import controllers.MC;
	
	import feathers.controls.Button;
	import feathers.core.PopUpManager;
	
	import models.FontVo;
	import models.SOService;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import views.global.userCenter.BaseScreen;
	import views.global.userCenter.UserCenter;
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
			super.initialize();
			initBackgroundImage();
			initCrtUserView();
			initButton();
			initBirdView();
			initModuleButton();

			TweenLite.delayedCall(0.1, dispatchEventWith, [UserCenter.InitViewPlayed]);
		}
		
		private var vecButton:Vector.<Button>;
		private function initModuleButton():void
		{
			const num:uint = 8;
			const center:Point = new Point(this.viewWidth/2, this.viewHeight + 400);
			const radius:uint = 800;
//			const r:Number = 
			
			var s:Sprite = new Sprite();
			Starling.current.nativeStage.addChild( s );
			s.x = 28;
			s.y = 89;
			s.graphics.beginFill(0x003366, 0.3);
			s.graphics.drawCircle( center.x, center.y, radius );
			s.graphics.endFill();
			
			vecButton = new Vector.<Button>(num);
			
		}
		
		private function initBirdView():void
		{
			var image:Image=new Image(UserCenterManager.getTexture("icon_bird"));
			image.x=642;
			image.y=65;
			this.addChild(image);
			image.touchable=false;

			var num:String=int(SOService.instance.getSO("bird_count")).toString();
			var text:TextField=new TextField(200, 40, "x " + num, FontVo.PALACE_FONT, 26, 0x932720);
			text.hAlign="left";
			text.vAlign="center";
			this.addChild(text);
			text.x=750;
			text.y=140;
			text.touchable=false;
		}

		private var w_editUser:W_EditUser;
		private var w_chooseUser:W_ChooseUser;
		private var w_deleteUser:W_DeleteUser;
		private var w_alert:W_Alert;

		private function show_W_deleteUser(userIndex:int):void
		{
			deleteIndex=userIndex;
			if (!w_deleteUser)
				init_w_deleteUser();
			hideWinHandler(w_editUser, showWinHandler, w_deleteUser);
		}
		private var deleteIndex:int;

		private function init_w_deleteUser():void
		{
			w_deleteUser=new W_DeleteUser();
			w_deleteUser.closeWinHandler=hideWinHandler;
			w_deleteUser.deleteHandler=deleteHandler;
		}

		private function showWinHandler(win:DisplayObject):void
		{
			PopUpManager.addPopUp(win, true, false);
			win.y=768 - win.height >> 1;
			win.x=1024;
			TweenLite.to(win, 0.3, {x: 1024 - win.width >> 1, ease: Cubic.easeIn});
		}

		private var twDic:Dictionary=new Dictionary();

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

		/**
		 * 切换角色按钮
		 */
		private var button_change:Button;

		private function initButton():void
		{
			button_change=new Button();
			button_change.defaultSkin=new Image(UserCenterManager.getTexture("button_changeUser_up"));
			button_change.downSkin=new Image(UserCenterManager.getTexture("button_changeUser_down"));
			this.addChild(button_change);
			button_change.x=346;
			button_change.y=143;
			button_change.addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch=e.getTouch(button_change);
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				show_w_chooseUser();
			}
		}

		private function show_w_chooseUser():void
		{
			if (!w_chooseUser)
			{
				w_chooseUser=new W_ChooseUser();
				w_chooseUser.closeWinHandler=hideWinHandler;
				w_chooseUser.editHandler=show_w_editUser;
				w_chooseUser.changeCtrUserHandler=show_W_alert;
			}
			showWinHandler(w_chooseUser);
		}

		private var nextUser:int;

		private function show_W_alert(index:int):void
		{
			nextUser=index;
			if (!w_alert)
			{
				w_alert=new W_Alert();
				w_alert.ok_handler=okForAlert;
				w_alert.cancle_handler=cancleForAlert;
			}

			hideWinHandler(w_chooseUser, showWinHandler, w_alert);
		}

		private function okForAlert():void
		{
			SOService.instance.changeUser(nextUser);
			changeUserHandler();
			hideWinHandler(w_alert);
		}

		private function cancleForAlert():void
		{
			hideWinHandler(w_alert);
		}

		/**
		 * 切换用户执行方法
		 */
		private function changeUserHandler():void
		{
			MC.instance.restart();
		}

		/**
		 *
		 * @param userIndex
		 *
		 */
		private function show_w_editUser(userIndex:int):void
		{
			(!w_editUser) ? init_w_editUser(userIndex) : w_editUser.resetData(userIndex);
			hideWinHandler(w_chooseUser, showWinHandler, w_editUser);
		}

		private function init_w_editUser(userIndex:int):void
		{
			w_editUser=new W_EditUser(userIndex);
			w_editUser.closeWinHandler=hideWinHandler;
			w_editUser.deleteHandler=show_W_deleteUser;
			w_editUser.addEventListener(Event.CHANGE, changeUserHandler);
		}

		/**
		 * 删除角色
		 * @param userdata
		 *
		 */
		private function deleteHandler():void
		{
			SOService.instance.deleteUser(deleteIndex);
			if (w_chooseUser)
				w_chooseUser.invalidate(INVALIDATION_FLAG_ALL);
		}

		private var crtUserData:Object;
		private var crtUserView:CurrentUserView;

		private function initCrtUserView():void
		{
			//获取用户当前角色数据
			crtUserData=SOService.instance.getUserInfo(SOService.instance.getLastUser());
			//初始化角色显示组件
			crtUserView=new CurrentUserView(crtUserData);
			this.addChild(crtUserView);
			crtUserView.x=55;
			crtUserView.y=42;
		}

		private function initBackgroundImage():void
		{
			var texture:Texture=UserCenterManager.getTexture("line_long");
			var image:Image=new Image(texture);
			image.x=60;
			image.y=197;
			this.addChild(image);
			image.touchable=false;
			image=new Image(texture);
			image.x=519;
			image.y=197;
			this.addChild(image);
			image.touchable=false;
		}

		override public function dispose():void
		{
			TweenLite.killTweensOf(this);
			for each (var t:TweenLite in twDic)
			{
				TweenLite.killTweensOf(t);
				delete twDic[t];
			}

			if (w_editUser)
			{
				w_editUser.addEventListener(Event.CHANGE, changeUserHandler);
				w_editUser.removeFromParent(true);
			}
			if (w_chooseUser)
				w_chooseUser.removeFromParent(true);
			if (w_deleteUser)
				w_deleteUser.removeFromParent(true);
			if (w_alert)
				w_alert.removeFromParent(true);
			if (button_change)
			{
				button_change.removeEventListener(TouchEvent.TOUCH, onTouch);
				button_change.removeFromParent(true);
			}
			if (crtUserView)
				crtUserView.removeFromParent(true);
			super.dispose();
		}
	}
}
