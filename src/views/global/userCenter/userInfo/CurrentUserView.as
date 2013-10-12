package views.global.userCenter.userInfo
{
	import models.FontVo;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	import views.global.userCenter.UserCenterManager;
	
	public class CurrentUserView extends Sprite
	{
		/**
		 * @param data
		 * { username: "name", avatarIndex: 0, birthday: "2013-01-11"}
		 */		
		public function CurrentUserView(data:Object)
		{
			_data = data;
			init();
		}
		private var _data:Object;
		
		private function init():void
		{
			this.touchable = false;
			
			var image:Image = new Image(UserCenterManager.getTexture("background_crtuserinfo"));
			this.addChild( image );
			
			initHeadicon();
			initTextField();
		}
		
		private var _textfield:TextField;
		private function initTextField():void
		{
			_textfield = new TextField(160, 30, _data.username, FontVo.PALACE_FONT, 26, 0xfeffcf);
			_textfield.hAlign = "center";
			_textfield.vAlign = "center";
			this.addChild( _textfield );
			_textfield.touchable = false;
			_textfield.x = 155;
			_textfield.y = 54;
		}
		
		private var _icon:HeadIcon;
		private function initHeadicon():void
		{
			_icon = new HeadIcon(_data.avatarIndex);
			this.addChild( _icon );
			_icon.x = 74;
			_icon.y = 74;
		}
		
		/**
		 * 
		 * @param data
		 * { username: "name", avatarIndex: 0, birthday: "2013-01-11"}
		 */		
		public function resetData(data:Object = null):void
		{
			if(data)	
				_data = data;
			_textfield.text = _data.username;
			_icon.resetIcon(_data.avatarIndex);
		}
		
		override public function dispose():void
		{
			this._data = null;
			if(_icon)
				_icon.removeFromParent(true);
			if(_textfield)
				_textfield.removeFromParent(true);
			super.dispose();
		}
	}
}