package views.global.userCenter.userInfo
{
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import views.global.userCenter.UserCenterManager;

	/**
	 * 游戏窗口
	 * @author Administrator
	 */	
	public class W_Game extends FeathersControl
	{
		private static var DATA_CHANGED:String = "data_changed";
		/**
		 * @param value
		 * { name: "游戏名称", iconIndex: "0", resultEasy: "00:00", resultHard: "00:00", numStars: 2 }
		 */		
		public function W_Game(value:Object)
		{
			this._gameData = value;
		}
		
		public function updateView():void
		{
			const count:int = _gameData.numStars;
			const max:int = 3;
			
			nameLabel.text = _gameData.name;
			resultLabel.text = getResultContent();
			icon.texture = UserCenterManager.getTexture("card_game_" + _gameData.iconIndex);
			for(var i:int = 0;i<max;i++)
			{
				stars[i].texture = UserCenterManager.getTexture((i<count)?"icon_star_red":"icon_star_gray");
			}
		}
		
		private var nameLabel:TextField;			//菜名
		private var resultLabel:TextField;			//成绩单
		private var icon:Image;						//游戏icon
		private var button_start:Button;			//开始游戏按钮
		private var button_close:Button;			//关闭按钮
		private var stars:Vector.<Image>;			//星星
		
		override protected function initialize():void
		{
			initBackImages();
			initButtons();
			initLabels();
			initGameicon();
		}
		
		private function initLabels():void
		{
			nameLabel = new TextField(230, 80, _gameData.name, FontVo.PALACE_FONT, 32, 0x932720 );
			this.addChild( nameLabel );
			nameLabel.x = 345;
			nameLabel.y = 66;
			nameLabel.touchable = false;
			nameLabel.vAlign = "center";
			nameLabel.hAlign = "center";
			
			resultLabel = new TextField(230, 100, getResultContent(), FontVo.PALACE_FONT, 20, 0x932720);
			this.addChild( resultLabel );
			resultLabel.x = 345;
			resultLabel.y = 180;
			resultLabel.touchable = false;
			resultLabel.vAlign = "top";
			resultLabel.hAlign = "left";
		}
		
		private function initButtons():void
		{
			button_start = new Button();
			button_start.defaultSkin = new Image(UserCenterManager.getTexture("button_start_up"));
			button_start.downSkin = new Image(UserCenterManager.getTexture("button_start_down"));
			button_start.addEventListener(Event.TRIGGERED, startGame);
			this.addChild( button_start );
			button_start.x = 452;
			button_start.y = 303;
			
			button_close = new Button();
			button_close.defaultSkin = new Image(UserCenterManager.getTexture("button_close_small"));
			button_close.addEventListener(Event.TRIGGERED, closeWindow);
			this.addChild( button_close );
			button_close.x = 566;
			button_close.y = 20;
		}
		
		private function initBackImages():void
		{
			//背景
			var image:Image = new Image(UserCenterManager.getTexture("background_win_0"));
			this.addChild( image );
			this.width = image.width;
			this.height = image.height;
			//线条
			image = new Image(UserCenterManager.getTexture("line_other"));
			this.addChild( image );
			image.x = 363;
			image.y = 125;
			image.touchable = false;
			
			//星星
			const max:int = 3;
			const count:int = _gameData.numStars;
			stars = new Vector.<Image>(max);
			var texture:Texture = UserCenterManager.getTexture("icon_star_gray");
			for(var i:int = 0;i<max;i++)
			{
				image = new Image(texture);
				this.addChild(image);
				image.x = 90 + i*(image.width+2);
				image.y = 304;
				image.touchable = false;
				stars[i] = image;
			}
		}
		
		private function initGameicon():void
		{
			icon = new Image(UserCenterManager.getTexture("card_game_" + _gameData.iconIndex));
			this.addChild( icon );
			icon.x = 33;
			icon.y = 58;
			icon.touchable = false;
		}
		private function getResultContent():String
		{
			var str:String = "最好成绩\n简单模式： "+_gameData.resultEasy+"\n困难模式： "+_gameData.resultHard;
			return str;
		}
		
		override public function dispose():void
		{
			if(nameLabel)
			{
				nameLabel.removeFromParent(true);
				nameLabel = null;
			}
			if(resultLabel)
			{
				resultLabel.removeFromParent(true);
				resultLabel = null;
			}
			if(icon)
			{
				icon.removeFromParent(true);
				icon = null;
			}
			if(button_start)
			{
				button_start.removeEventListener(TouchEvent.TOUCH, startGame);
				this.removeChild( button_start );
				button_start.dispose();
				button_start = null;
			}
			if(button_close)
			{
				button_close.removeEventListener(TouchEvent.TOUCH, closeWindow);
				this.removeChild( button_close );
				button_close.dispose();
				button_close = null;
			}
			if(stars)
			{
				for each(var image:Image in stars)
				{
					image.removeFromParent(true);
				}
				stars = null;
			}
			_gameData = null;
			this.startGameHandler = null;
			this.closeWinHandler = null;
			super.dispose();
		}
		
		public var startGameHandler:Function;
		private function startGame(e:Event):void
		{
			if(startGameHandler)
			{
				
			}
		}
		
		public var closeWinHandler:Function = defaultCloseHandler;
		private function closeWindow(e:Event):void
		{
			closeWinHandler(this);
		}
		private function defaultCloseHandler(obj:Object):void
		{
			if(parent)
				parent.removeChild( this );
			this.dispose();
		}
		
		/**
		 * { name: "游戏名称", iconIndex: "0", resultEasy: "00:00", resultHard: "00:00", numStars: 2 }
		 */		
		private var _gameData:Object;
		/**
		 * @param value
		 * { name: "游戏名称", iconIndex: "0", resultEasy: "00:00", resultHard: "00:00", numStars: 2 }
		 */		
		public function resetData(value:Object):void
		{
			if(_gameData && _gameData == value)
				return;
			_gameData = value;
			updateView();
		}
	}
}