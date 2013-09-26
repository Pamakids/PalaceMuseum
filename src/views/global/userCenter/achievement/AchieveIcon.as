package views.global.userCenter.achievement
{
	import feathers.core.FeathersControl;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.text.TextField;
	
	import views.global.userCenter.UserCenterManager;
	
	public class AchieveIcon extends FeathersControl
	{
		private var _state:int;
		/**
		 * 成就图标
		 * @param size
		 * 0 小
		 * 1 大
		 */		
		public function AchieveIcon(state:int = 0)
		{
			this._state = state;
		}
		
		private var _name:TextField;
		override protected function draw():void
		{
			if(_state == 0)
				image.texture = (_data.achidata[2]==0)?UserCenterManager.getTexture("achievement_card_unfinish"):UserCenterManager.getTexture("achievement_card_finish");
			else
				image.texture = (_data.achidata[2]==0)?UserCenterManager.getTexture("achievement_card_unfinish_big"):UserCenterManager.getTexture("achievement_card_finish_big");
			_name.text = _data.achidata[0];
			_name.color = (_data.achidata[2]==0)?0xfffcee:0xfffe185;
			if(_content)
			{
				_content.text = _data.achidata[1];
				_content.color = (_data.achidata[2]==0)?0xfffcee:0xfffe185;
			}
		}
		
		override protected function initialize():void
		{
			initBackground();
			initName();
			initContent();
		}
		
		private var _content:TextField;
		private function initContent():void
		{
			if(_state == 0)
				return;
			_content = new TextField(296, 80, "", FontVo.PALACE_FONT, 24, 0xffe185, true);
			this.addChild( _content );
			_content.x = 100;
			_content.y = 250;
			_content.touchable = false;
		}
		
		private function initName():void
		{
			if(_state == 0)
			{
				_name = new TextField(this.width, 30, "", FontVo.PALACE_FONT, 20, 0xffe185, true);
				_name.y = 30;
			}
			else
			{
				_name = new TextField(this.width, 130, "", FontVo.PALACE_FONT, 106, 0xffe185, true);
				_name.y = 100;
			}
			this.addChild( _name );
			_name.touchable = false;
		}
		
		private var image:Image;
		private function initBackground():void
		{
			if(_state == 0)
				image = new Image(UserCenterManager.getTexture("achievement_card_unfinish"));
			else
				image = new Image(UserCenterManager.getTexture("achievement_card_unfinish_big"));
			this.width = image.width;
			this.height = image.height;
			this.addChild( image );
		}
		
		override public function dispose():void
		{
			if(_name)
				_name.removeFromParent(true);
			if(image)
				image.removeFromParent(true);
			if(_content)
				_content.removeFromParent(true);
			super.dispose();
		}
		
		
		/**
		 * id:	""
		 * achidata: 	["name", "content", ifCollected]
		 */
		private var _data:Object;
		public function set data(value:Object):void
		{
			if(_data && _data == value)
				return;
			_data = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}
		public function get data():Object
		{
			return _data;
		}
		
	}
}