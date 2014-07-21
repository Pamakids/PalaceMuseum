package views.global.books.components
{
	import flash.geom.Point;

	import feathers.core.FeathersControl;

	import models.FontVo;

	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	import views.global.books.BooksManager;

	public class AchieveIcon extends FeathersControl
	{
		private var _state:int;
		/**
		 * 成就图标
		 * @param state
		 * 0 小
		 * 1 大
		 */		
		public function AchieveIcon(state:int = 0)
		{
			this._state = state;
		}

		public function get achieved():Boolean
		{
			return _data.achidata[2]!=0;
		}

		override protected function draw():void
		{
			if(_data)
			{
				if(_state == 0)
					image.texture = (_data.achidata[2]==0)?BooksManager.getTexture("achievement_card_unfinish"):BooksManager.getTexture("achievement_card_finish");
				else
					image.texture = (_data.achidata[2]==0)?BooksManager.getTexture("achievement_card_unfinish_big"):BooksManager.getTexture("achievement_card_finish_big");
				_name.text = _data.achidata[0];
				_name.color = (_data.achidata[2]==0)?0xfffcee:0xfffe185;
				if(_content)
				{
					_content.text = _data.achidata[1];
					_content.color = (_data.achidata[2]==0)?0xfffcee:0xfffe185;
				}
				this.visible = true;
			}
			else
			{
				this.visible = false;
			}
		}

		override protected function initialize():void
		{
			initBackground();
			initName();
			initContent();

			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private var begin:Point
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			var point:Point;
			if(touch)
			{
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
						begin = touch.getLocation(this);
						break;
					case TouchPhase.ENDED:
						point = touch.getLocation(this);
						if(Math.sqrt((begin.x - point.x)*(begin.x - point.x) + (begin.y - point.y)*(begin.y - point.y)) <= 20)
							dispatchEvent(new Event(Event.TRIGGERED));
						break;
				}
			}
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

		private var _name:TextField;
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
				image = BooksManager.getImage("achievement_card_unfinish");
			else
				image = BooksManager.getImage("achievement_card_unfinish_big");
			this.width = image.width;
			this.height = image.height;
			this.addChild( image );
		}

		override public function dispose():void
		{
			if(this.hasEventListener(TouchEvent.TOUCH))
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
			if(_name)
				_name.removeFromParent(true);
			if(image)
				image.removeFromParent(true);
			if(_content)
				_content.removeFromParent(true);
			super.dispose();
		}


		/**
		 * {
		 * 		id:	""
		 * 		achidata: 	["name", "content", ifCollected]
		 * }
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

