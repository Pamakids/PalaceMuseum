package views.global.userCenter.userInfo
{
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import views.global.userCenter.UserCenterManager;
	
	public class ItemForGameList extends FeathersControl
	{
		/**
		 * @param data { name: "游戏名称", iconIndex: "0", resultEasy: "00:00", resultHard: "00:00", numStars: 2, isOpend: false }
		 * @param callBack
		 */		
		public function ItemForGameList(data:Object, callBack:Function)
		{
			this._data = data;
			this.touchable = this.isOpend = _data.isOpend;
			this.callBakc = callBack;
		}
		
		private var _data:Object;
		/**
		 * { name: "游戏名称", iconIndex: "0", resultEasy: "00:00", resultHard: "00:00", numStars: 2, isOpend: false }
		 */		
		public function set data(value:Object):void
		{
			_data = value;
			this.touchable = this.isOpend = _data.isOpend;
			this.udpateStars();
		}
		private var label:TextField;
		private var gameIcon:Button;
		private var lock:Image;
		private var mask:Image;
		public var isOpend:Boolean;
		
		override protected function initialize():void
		{
			initBackImages();
			initLable();
			initButton();
			udpateStars();
		}
		/*
		 * 菜名
		*/
		private function initLable():void
		{
			label = new TextField(200, 60, _data.name, FontVo.PALACE_FONT, 38, 0x561a1a, true);
			this.addChild( label );
			label.x = 200;
			label.y = 10;
			label.vAlign = label.hAlign = "center";
			label.touchable = false;
		}
		/*
		* 星星
		*/
		private function udpateStars():void
		{
			const max:int = _stars.length;
			const count:int = _data.numStars;
			
			for(var i:int = 0; i<max; i++)
			{
				_stars[i].texture = (i<count)?UserCenterManager.getTexture("icon_star_red"):UserCenterManager.getTexture("icon_star_gray");
			}
		}
		/*
		* 游戏图标按钮
		*/
		private function initButton():void
		{
			gameIcon = new Button();
			gameIcon.width = 205;
			gameIcon.height = 159;
			gameIcon.defaultSkin = new Image(UserCenterManager.getTexture("card_game_"+_data.iconIndex));
			this.addChild( gameIcon );
			gameIcon.addEventListener(TouchEvent.TOUCH, onTouch);
			
			if(!isOpend)
			{
				mask = new Image(UserCenterManager.getTexture("card_game_mask"));
				mask.width = gameIcon.width;
				mask.height = gameIcon.height;
				this.addChild( mask );
				lock = new Image(UserCenterManager.getTexture("icon_lock"));
				lock.x = 15;
				lock.y = 96;
				this.addChild( lock );
				mask.touchable = lock.touchable = false;
			}
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(gameIcon);
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED)
				{
					callBakc( _data );
				}
			}
		}
		
		
		private var _stars:Vector.<Image>;
		private function initBackImages():void
		{
			var texture:Texture = UserCenterManager.getTexture("line_short");
			var image:Image = new Image(texture);
			this.addChild( image);
			image.x = 230;
			image.y = 64;
			image.touchable = false;
			
			const max:int = 3;
			const count:int = _data.numStars;
			_stars = new Vector.<Image>(max);
			texture = UserCenterManager.getTexture("icon_star_gray");
			for(var i:int = 0;i<max;i++)
			{
				image = new Image(texture);
				this.addChild(image);
				image.x = 230 + i*45;
				image.y = 94;
				image.scaleX = image.scaleY = .8;
				image.touchable = false;
				_stars[i] = image;
			}
		}
		
		
		override public function dispose():void
		{
			_data = null;
			callBakc = null;
			if(label)
				label.removeFromParent(true);
			if(mask)
				mask.removeFromParent(true);
			if(lock)
				lock.removeFromParent(true);
			if(gameIcon)
			{
				gameIcon.removeEventListener(TouchEvent.TOUCH, onTouch);
				gameIcon.removeFromParent(true);
			}
			for each(var image:Image in _stars)
			{
				image.removeFromParent(true);
			}
			super.dispose();
		}
		
		private var callBakc:Function;
		
		public function resetData(gameData:Object):void
		{
			this._data = gameData;
			udpateStars();
		}
	}
}