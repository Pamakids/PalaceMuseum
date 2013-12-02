package views.global.books.userCenter.win
{
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	import views.global.books.BooksManager;

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
			resultLabel_1.text = "简单模式： "+_gameData.resultEasy;
			resultLabel_2.text = "困难模式： "+_gameData.resultHard;
			icon.texture = BooksManager.getTexture("card_game_" + _gameData.iconIndex);
			for(var i:int = 0;i<max;i++)
			{
				stars[i].texture = BooksManager.getTexture((i<count)?"icon_star_red":"icon_star_gray");
			}
		}
		
		private var nameLabel:TextField;			//菜名
		private var resultLabel_0:TextField;			//成绩单
		private var resultLabel_1:TextField;			//成绩单
		private var resultLabel_2:TextField;			//成绩单
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
		
		private var leading:int = 10;
		private function initLabels():void
		{
			nameLabel = new TextField(230, 80, _gameData.name, FontVo.PALACE_FONT, 32, 0x932720 );
			this.addChild( nameLabel );
			nameLabel.x = 345;
			nameLabel.y = 66;
			
			resultLabel_0 = new TextField(230, 30, "最好成绩", FontVo.PALACE_FONT, 24, 0x932720);
			this.addChild( resultLabel_0 );
			resultLabel_0.x = 345;
			resultLabel_0.y = 180;
			resultLabel_1 = new TextField(230, 30, "简单模式： "+_gameData.resultEasy, FontVo.PALACE_FONT, 24, 0x932720);
			this.addChild( resultLabel_1 );
			resultLabel_1.x = 345;
			resultLabel_1.y = resultLabel_0.y + resultLabel_0.height + leading;
			resultLabel_2 = new TextField(230, 30, "困难模式： "+_gameData.resultHard, FontVo.PALACE_FONT, 24, 0x932720);
			this.addChild( resultLabel_2 );
			resultLabel_2.x = 345;
			resultLabel_2.y = resultLabel_1.y + resultLabel_1.height + leading;
			
			nameLabel.touchable = resultLabel_0.touchable = resultLabel_1.touchable = resultLabel_2.touchable = false;
			nameLabel.vAlign = resultLabel_0.vAlign = resultLabel_1.vAlign = resultLabel_2.vAlign = "center";
			nameLabel.hAlign = "center";
			resultLabel_0.hAlign = resultLabel_1.hAlign = resultLabel_2.hAlign = "left";
			
//			resultLabel_0.border = resultLabel_1.border = resultLabel_2.border = true;
		}
		
		private function initButtons():void
		{
			button_start = new Button();
			button_start.defaultSkin = BooksManager.getImage("button_start_up");
			button_start.downSkin = BooksManager.getImage("button_start_down");
			button_start.addEventListener(Event.TRIGGERED, startGame);
			this.addChild( button_start );
			button_start.x = 452;
			button_start.y = 303;
			
			button_close = new Button();
			button_close.defaultSkin = BooksManager.getImage("button_close_small");
			button_close.addEventListener(Event.TRIGGERED, closeWindow);
			this.addChild( button_close );
			button_close.x = 566;
			button_close.y = 20;
		}
		
		private function initBackImages():void
		{
			//背景
			var image:Image = BooksManager.getImage("background_win_0");
			this.addChild( image );
			this.width = image.width;
			this.height = image.height;
			//线条
			image = BooksManager.getImage("line_other");
			this.addChild( image );
			image.x = 363;
			image.y = 125;
			image.touchable = false;
			
			//星星
			const max:int = 3;
			const count:int = _gameData.numStars;
			stars = new Vector.<Image>(max);
			var texture:Texture = BooksManager.getTexture("icon_star_gray");
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
			icon = BooksManager.getImage("card_game_" + _gameData.iconIndex);
			this.addChild( icon );
			icon.x = 33;
			icon.y = 58;
			icon.touchable = false;
		}
		
		override public function dispose():void
		{
			if(nameLabel)
				nameLabel.removeFromParent(true);
			if(resultLabel_0)
				resultLabel_0.removeFromParent(true);
			if(resultLabel_1)
				resultLabel_1.removeFromParent(true);
			if(resultLabel_2)
				resultLabel_2.removeFromParent(true);
			if(icon)
				icon.removeFromParent(true);
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
			this.closeWinHandler = null;
			super.dispose();
		}
		
		public var startGameHandler:Function;
		
		private function startGame(e:Event):void
		{
			closeWinHandler(this);
			startGameHandler(_gameData.iconIndex);
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