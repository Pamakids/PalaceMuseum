package views.global.userCenter.userInfo
{
	import models.FontVo;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	import views.global.userCenter.UserCenterManager;
	
	public class CurrentUser extends Sprite
	{
		/**
		 * @param data
		 * { username: "name", iconIndex: 0, birthday: "2013-01-11"}
		 */		
		public function CurrentUser(data:Object)
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
			_icon = new HeadIcon(_data.iconIndex);
			this.addChild( _icon );
			_icon.x = 74;
			_icon.y = 74;
		}
		
		/**
		 * 
		 * @param data
		 * { username: "name", iconIndex: 0, birthday: "2013-01-11"}
		 */		
		public function resetData(data:Object = null):void
		{
			if(data)	_data = data;
			_textfield.text = _data.username;
			_icon.resetIcon(_data.iconIndex);
		}
		
		override public function dispose():void
		{
			this._data = null;
			this._icon.removeFromParent(true);
			this._textfield.removeFromParent(true);
			super.dispose();
		}
	}
}