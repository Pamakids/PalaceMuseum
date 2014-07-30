package views.global.books.userCenter.screen
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import controllers.DC;
	import controllers.MC;
	
	import feathers.controls.Button;
	import feathers.controls.ToggleButton;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.core.PopUpManager;
	
	import models.FontVo;
	import models.SOService;
	
	import sound.SoundAssets;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import views.global.books.BooksManager;
	import views.global.books.components.CurrentUserView;
	import views.global.books.components.ModuleList;
	import views.global.books.events.BookEvent;
	import views.global.books.handbook.screen.BirdsScreen;
	import views.global.books.userCenter.win.W_Alert;
	import views.global.books.userCenter.win.W_ChooseUser;
	import views.global.books.userCenter.win.W_DeleteUser;
	import views.global.books.userCenter.win.W_EditUser;

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
			initPages();
			initTextfields();
			initCrtUserView();
			initButton();
			initModuleList();
			initSoundButton();

			TweenLite.delayedCall(0.1, dispatchEventWith, [BookEvent.InitViewPlayed]);
		}

		private var check_BGM:ToggleButton;
		private var check_effect:ToggleButton;
		private function initSoundButton():void
		{
			check_BGM = new ToggleButton();
			check_BGM.label = "  音乐";
			check_BGM.labelFactory = function():ITextRenderer{
				var render:TextFieldTextRenderer = new TextFieldTextRenderer();
				render.embedFonts = true;
				render.textFormat = new TextFormat(FontVo.PALACE_FONT, 24, 0x610c0c);
				return render;
			};
			check_BGM.defaultIcon = BooksManager.getImage("button_sound_0_up");
			check_BGM.defaultSelectedIcon = BooksManager.getImage("button_sound_0_down");
			this.addChild( check_BGM );
			check_BGM.isSelected = SoundAssets.bgmVol == 0;
			check_BGM.addEventListener(Event.TRIGGERED, onTriggered);
			check_BGM.x = 800;
			check_BGM.y = 80;

			check_effect = new ToggleButton();
			check_effect.label = "  音效";
			check_effect.labelFactory = function():ITextRenderer{
				var render:TextFieldTextRenderer = new TextFieldTextRenderer();
				render.embedFonts = true;
				render.textFormat = new TextFormat(FontVo.PALACE_FONT, 24, 0x610c0c);
				return render;
			};
			check_effect.defaultIcon = BooksManager.getImage("button_sound_1_up");
			check_effect.defaultSelectedIcon = BooksManager.getImage("button_sound_1_down");
			this.addChild( check_effect );
			check_effect.isSelected = SoundAssets.sfxVol == 0;
			check_effect.addEventListener(Event.TRIGGERED, onTriggered);
			check_effect.x = 800;
			check_effect.y = 130;
		}

		private function onTriggered(e:Event):void
		{
			switch(e.target)
			{
				case check_BGM:
//					check_BGM.isSelected = !check_BGM.isSelected;
					SoundAssets.bgmVol = (!check_BGM.isSelected) ? 0 : 0.6;
					trace(SoundAssets.bgmVol);
					break;
				case check_effect:
//					check_effect.isSelected = !check_effect.isSelected;
					SoundAssets.sfxVol = (!check_effect.isSelected) ? 0 : 0.6;
					break;
			}
		}

		private function initTextfields():void
		{
			var names:Array = ["成就", "卡片", "小鸟"];
			var nums:Array = [0, 0, 0];
			var maxs:Array = [
				DC.instance.getAchievementData().length,
				BooksManager.getAssetsManager().getObject("collection").source.length,
				BirdsScreen.MAX_NUM
				];

			var arr:Array = DC.instance.getAchievementData();
			for(var i:int = 0;i<maxs[0];i++)
			{
				if(arr[i][2])
					nums[0] ++;
			}
			for(i=0;i<maxs[1];i++)
			{
				if(DC.instance.testCollectionIsOpend(i.toString()))
					nums[1] ++;
			}
			for(i=0;i<maxs[2];i++)
			{
				if(SOService.instance.getSO("birdCatched" + i))
					nums[2] ++;
			}
			var tf:TextField;
			var txt:String;
			for(i=0;i<3;i++)
			{
				txt = names[i] + "： " + nums[i] + " / " + maxs[i];
				tf = new TextField(200, 40, txt, FontVo.PALACE_FONT, 26, 0x610c0c);
				tf.x = 540;
				tf.y = 60 + i*40;
				this.addChild( tf );
				tf.touchable = false;
				tf.hAlign = "left";
			}

		}

		private var moduleList:ModuleList;

		private function initModuleList():void
		{
			moduleList=new ModuleList();
			this.addChild(moduleList);
			moduleList.y=200;
		}

//		private function initBirdView():void
//		{
//			var image:Image=UserCenterManager.getImage("icon_bird");
//			image.x=642;
//			image.y=65;
//			this.addChild(image);
//			image.touchable=false;
//
//			var num:uint = 0;
//			for(var i:int = BirdScreen.MAX_NUM-1;i>=0;i--)
//			{
//				if(SOService.instance.getSO("birdCatched" + i))
//					num ++;
//			}
//			var text:TextField=new TextField(200, 40, "x " + num, FontVo.PALACE_FONT, 26, 0x932720);
//			text.hAlign="left";
//			text.vAlign="center";
//			this.addChild(text);
//			text.x=750;
//			text.y=140;
//			text.touchable=false;
//		}

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
			TweenLite.to(win, 0.3, {x: 1024 - win.width >> 1, ease: Cubic.easeIn, onComplete:function():void{
				if(win == w_editUser &&　MC.needGuide)
				{
					w_editUser.showGuide();
				}
			}});
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
			button_change.defaultSkin=BooksManager.getImage("button_changeUser_up");
			button_change.downSkin=BooksManager.getImage("button_changeUser_down");
			this.addChild(button_change);
			button_change.x=366;
			button_change.y=118;
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

		public function show_w_chooseUser():void
		{
			if (!w_chooseUser)
			{
				w_chooseUser=new W_ChooseUser();
				w_chooseUser.closeWinHandler=hideWinHandler;
				w_chooseUser.editHandler=show_w_editUser;
				w_chooseUser.changeCtrUserHandler=show_W_alert;
			}
			showWinHandler(w_chooseUser);
			
			if(MC.needGuide)
			{
				MC.instance.addGuide(8,function():void{
					MC.instance.main.touchable=true;
					var ui:int=SOService.instance.getLastUser();
					if(!ui)
						ui=0;
					w_chooseUser.editHandler(ui);
				});
			}
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
			w_editUser.addEventListener("editUser", function():void{
				crtUserView.resetData();
			});
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

		private var mapVisible:Boolean;

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

		override protected function initPages():void
		{
			var image:Image=BooksManager.getImage("background_2");
			image.scaleX=image.scaleY=2;
			this.addChild(image);
			var texture:Texture=BooksManager.getTexture("line_long");
			image=new Image(texture);
			image.x=60;
			image.y=197;
			this.addChild(image);
			image.touchable=false;
			image=new Image(texture);
			image.x=519;
			image.y=197;
			this.addChild(image);
			image.touchable=false;

			image = BooksManager.getImage("tf_bg");
			image.x = 519;
			image.y = 60;
			image.alpha = .4;
			image.touchable = false;
			this.addChild( image );
			image = BooksManager.getImage("tf_bg");
			image.x = 519;
			image.y = 100;
			image.alpha = .4;
			image.touchable = false;
			this.addChild( image );
			image = BooksManager.getImage("tf_bg");
			image.x = 519;
			image.y = 140;
			image.alpha = .4;
			image.touchable = false;
			this.addChild( image );
		}

		override public function dispose():void
		{
			TweenLite.killTweensOf(this);
			for each (var t:TweenLite in twDic)
			{
				TweenLite.killTweensOf(t);
				delete twDic[t];
			}
			if (moduleList)
				moduleList.removeFromParent(true);
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


