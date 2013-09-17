package views.global.userCenter.userInfo
{
	import feathers.controls.Button;
	import feathers.core.FeathersControl;
	
	import models.FontVo;
	
	import starling.display.Image;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	
	import views.global.userCenter.UserCenterManager;

	/**
	 * 游戏窗口
	 * @author Administrator
	 * 
	 */	
	public class W_Game extends FeathersControl
	{
		private static var INIT_COMPLETED:String = "init_completed";
		
		public function W_Game()
		{
			super();
		}
		
		override protected function draw():void
		{
			const change_all:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const change_completed:Boolean = this.isInvalid(INIT_COMPLETED);
			
			var image:Image;
			var i:int;
			if(change_completed)
			{
				line.x = 363;
				line.y = 125;
				button_start.x = 452;
				button_start.y = 303;
				button_close.x = 286;
				button_close.y = 382;
				nameLabel.x = 345;
				nameLabel.y = 66;
				resultLabel.x = 345;
				resultLabel.y = 120;
				icon.x = 33;
				icon.y = 58;
				for(i = 0;i<3;i++)
				{
					image = stars[i];
					image.x = 90 + i*(image.width+2);
					image.y = 304;
				}
			}
			if(change_all)
			{
				nameLabel.text = _data.name;
				resultLabel.text = getResultContent();
				icon.readjustSize();
				icon.texture = UserCenterManager.getTexture(_data.icon);
				for(i = 0;i<3;i++)
				{
					image = stars[i];
					image.texture = UserCenterManager.getTexture((i<_data.numStars)?"star_big_red":"star_big_gray");
				}
			}
		}
		
		private var nameLabel:TextField;			//菜名
		private var resultLabel:TextField;			//成绩单
		private var background:Image;				//背景图
		private var line:Image;
		private var icon:Image;						//游戏icon
		private var button_start:Button;			//开始游戏按钮
		private var button_close:Button;			//关闭按钮
		private var stars:Vector.<Image>;			//星星
		
		override protected function initialize():void
		{
			initFixedView();
			initOtherView();
			invalidate(INIT_COMPLETED);
		}
		
		private function initOtherView():void
		{
			nameLabel = new TextField(230, 80, _data.name, FontVo.PALACE_FONT, 32, 0x932720 );
			this.addChild( nameLabel );
			nameLabel.touchable = false;
			nameLabel.vAlign = "center";
			nameLabel.hAlign = "center";
			
			resultLabel = new TextField(230, 300, getResultContent(), FontVo.PALACE_FONT, 18, 0x932720);
			this.addChild( resultLabel );
			resultLabel.touchable = false;
			resultLabel.vAlign = "center";
			resultLabel.hAlign = "left";
			
			icon = new Image(UserCenterManager.getTexture(""));
			icon.touchable = false;
			this.addChild( icon );
			
			stars = new Vector.<Image>(3);
			var image:Image;
			for(var i:int = 0;i<3;i++)
			{
				image = new Image(UserCenterManager.getTexture((i<_data.numStars)?"star_big_red":"star_big_gray"));
				image.touchable = false;
			}
			
		}
		private function getResultContent():String
		{
			var str:String = "最好成绩\n简单模式： "+_data.resultEasy+"\n困难模式： "+_data.resultHard;
			return str;
		}
		
		private function initFixedView():void
		{
			background = new Image(UserCenterManager.getTexture(""));
			this.addChild( background );
			background.touchable = false;
			
			line = new Image(UserCenterManager.getTexture(""));
			this.addChild( line );
			line.touchable = false;
			
			button_start = new Button();
			button_start.defaultSkin = new Image(UserCenterManager.getTexture(""));
			button_start.defaultSelectedSkin = new Image(UserCenterManager.getTexture(""));
			this.addChild( button_start );
			button_start.addEventListener(TouchEvent.TOUCH, startGame);
			
			button_close = new Button();
			button_close.defaultSkin = new Image(UserCenterManager.getTexture("button_close_small"));
			this.addChild( button_close );
			button_close.addEventListener(TouchEvent.TOUCH, closeWindow);
		}
		
		override public function dispose():void
		{
			_data = null;
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
			if(background)
			{
				background.removeFromParent(true);
				background = null;
			}
			if(line)
			{
				line.removeFromParent(true);
				line = null;
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
					if(image)
					{
						this.removeChild( image );
						image.dispose();
						image = null;
					}
				}
				stars = null;
			}
			super.dispose();
		}
		
		private function startGame(e:TouchEvent):void
		{
		}
		private function closeWindow(e:TouchEvent):void
		{
		}
		
		/**
		 * {
		 * 		name
		 * 		icon
		 * 		resultEasy
		 * 		resultHard
		 * 		numStars
		 */		
		private var _data:Object;
		public function set data(value:Object):void
		{
			if(_data && _data == value)
				return;
			_data = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}
	}
}