package views.global.userCenter.userInfo.win
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.geom.Point;

	import feathers.controls.Button;
	import feathers.core.FeathersControl;

	import models.SOService;

	import starling.display.Image;
	import starling.events.Event;

	import views.components.DateChangeDevice;
	import views.global.userCenter.UserCenterManager;
	import views.global.userCenter.userInfo.ItemForUserList;

	/**
	 * 用户编辑窗口
	 * 		修改头像
	 * 		修改用户名
	 * 		修改出生日期
	 * @author Administrator
	 * 新建或编辑用户将派发Event.CHANGE事件
	 */
	public class W_EditUser extends FeathersControl
	{
		/**
		 * @param userIndex
		 */
		public function W_EditUser(userIndex:int)
		{
			this.userIndex=userIndex;
			creatUserInfo();
		}
		private var userIndex:int;
		private var userdata:Object;
		private var isCreat:Boolean=false;

		override protected function initialize():void
		{
			initBackImages();
			initUserView();
			initButtons();
			initDateChangeDevice();
		}

		/**
		 * 日期修改组件
		 */
		private var dateView:DateChangeDevice;

		private function initDateChangeDevice():void
		{
			dateView=new DateChangeDevice(1960, 2016);
			this.addChild(dateView);
			dateView.x=65;
			dateView.y=169;
			//解析出生日期
			updateDateView();
		}

		private function updateDateView():void
		{
			var arr:Array=userdata.birthday.split("-");
			dateView.setCrtDate(new Date(arr[0], int(arr[1]) - 1, int(arr[2])));
		}

		private var button_close:Button;
		private var button_delete:Button;
		private var button_choose:Button;

		private function initButtons():void
		{
			button_close=new Button();
			button_close.defaultSkin=new Image(UserCenterManager.getTexture("button_close_small"));
			button_close.addEventListener(Event.TRIGGERED, closeWindow);
			this.addChild(button_close);
			button_close.x=420;
			button_close.y=20;

			button_delete=new Button();
			button_delete.defaultSkin=new Image(UserCenterManager.getTexture("button_deleteUser_up"));
			button_delete.downSkin=new Image(UserCenterManager.getTexture("button_deleteUser_down"));
			button_delete.addEventListener(Event.TRIGGERED, deleteUser);
			this.addChild(button_delete);
			button_delete.x=44;
			button_delete.y=310;
			if (isCreat || userIndex == SOService.instance.getLastUser() || userIndex == 0)
			{
				button_delete.alpha=0.5;
				button_delete.touchable=false;
			}

			button_choose=new Button();
			button_choose.defaultSkin=new Image(UserCenterManager.getTexture("button_agreeChange_up"));
			button_choose.downSkin=new Image(UserCenterManager.getTexture("button_agreeChange_down"));
			button_choose.addEventListener(Event.TRIGGERED, changeCrtUser);
			this.addChild(button_choose);
			button_choose.x=260;
			button_choose.y=310;
		}

		private function changeCrtUser():void
		{
			//重新获取生日数据
			this.userdata.birthday=SOService.dateToString(this.dateView.getCrtDate());

			SOService.instance.editUser(this.userIndex, this.userdata);
			dispatchEvent(new Event(Event.CHANGE));

//			closeWindow();
		}

		public var deleteHandler:Function;

		private function deleteUser():void
		{
			if (iconList)
				iconList.visible=false;
			deleteHandler(this.userIndex);
		}

		private var userview:ItemForUserList;

		private function initUserView():void
		{
			userview=new ItemForUserList(userdata, true);
			userview.editIconFactory=showIconList;
			this.addChild(userview);
			userview.x=46;
			userview.y=37;
			userview.addEventListener(Event.TRIGGERED, showIconList);
		}

		private var iconList:W_IconList;
		private var showPoint:Point;
		private var hidePoint:Point;

		private function showIconList(data:Object):void
		{
			if (!iconList)
			{
				iconList=new W_IconList();
				this.addChild(iconList);
				showPoint=globalToLocal(new Point((1024 - iconList.width) >> 1, 768 - iconList.height));
				hidePoint=new Point(showPoint.x, showPoint.y + iconList.height);
				iconList.addEventListener(Event.TRIGGERED, changeHeadIcon);
			}
			iconList.x=hidePoint.x;
			iconList.y=hidePoint.y;
			iconList.visible=true;
			TweenLite.to(iconList, 0.2, {y: showPoint.y});
		}

		private function changeHeadIcon(e:Event):void
		{
			this.userdata.avatarIndex=e.data;
			this.userview.resetData(userdata);
			this.hideIconList();
		}

		private function hideIconList():void
		{
			if (iconList && iconList.parent)
			{
				TweenLite.to(iconList, 0.2, {y: hidePoint.y, ease: Cubic.easeOut, onComplete: function remove():void
				{
					iconList.visible=false;
				}});
			}
		}

		private function initBackImages():void
		{
			var image:Image=new Image(UserCenterManager.getTexture("background_win_1"));
			this.addChild(image);
			this.width=image.width;
			this.height=image.height;
			image.touchable=false;
		}

		override public function dispose():void
		{
			if (iconList)
			{
				iconList.removeEventListener(Event.TRIGGERED, changeHeadIcon);
				iconList.removeFromParent(true);
			}
			if (userview)
			{
				userview.removeEventListener(Event.TRIGGERED, showIconList);
				userview.removeFromParent(true);
			}
			if (dateView)
				dateView.removeFromParent(true);
			if (button_close)
			{
				button_close.removeEventListener(Event.TRIGGERED, closeWindow);
				button_close.removeFromParent(true);
			}
			if (button_delete)
			{
				button_delete.removeEventListener(Event.TRIGGERED, deleteUser);
				button_delete.removeFromParent(true);
			}
			if (button_choose)
			{
				button_choose.removeEventListener(Event.TRIGGERED, changeCrtUser);
				button_choose.removeFromParent(true);
			}
			this.deleteHandler=null;
			this.closeWinHandler=null;
			super.dispose();
		}

		/**
		 * @param userIndex
		 */
		public function resetData(userIndex:int):void
		{
			this.userIndex=userIndex;
			creatUserInfo();
			this.userview.resetData(this.userdata);
			this.dateView.setCrtDate(SOService.StringToDate(this.userdata.birthday));
			if (isCreat || userIndex == SOService.instance.getLastUser() || userIndex == 0)
			{
				button_delete.alpha=0.5;
				button_delete.touchable=false;
			}
			else
			{
				button_delete.alpha=1;
				button_delete.touchable=true;
			}
		}

		private function creatUserInfo():void
		{
			this.userdata=SOService.instance.getUserInfo(userIndex);
			if (!userdata)
			{
				isCreat=true;
				userdata={
						username: "请输入",
						avatarIndex: 0,
						birthday: SOService.dateToString(new Date())
					};
			}
			else
			{
				isCreat=false;
			}
		}

		public var closeWinHandler:Function;

		private function closeWindow(e:Event=null):void
		{
			if (iconList)
				iconList.visible=false;
			closeWinHandler(this);
		}
	}
}
