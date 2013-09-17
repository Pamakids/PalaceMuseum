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
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import views.global.userCenter.UserCenterManager;
	
	public class ItemGameInfo extends FeathersControl
	{
		/*
		 * 369(+1) 160
		 */		
		/**
		 * @param width
		 * @param height
		 * @param data{
		 * 				name		//游戏名称 
		 * 				numStars	//星星数
		 * 				icon		//游戏icon纹理名称
		 * 			}
		 */		
		public function ItemGameInfo(width:Number, height:Number, data:Object)
		{
//			this.width = width;
//			this.height = height;
			this.width = 370;
			this.height = 160;
			this.data = data;
		}
		
		private var data:Object;
		private var label:TextField;
		private var image:Image
		private var gameIcon:Button;
		
		override protected function initialize():void
		{
			initLable();
			initImages();
			initButton();
			initStars();
		}
		/*
		 * 菜名
		*/
		private function initLable():void
		{
			label = new TextField(160, 50, data.name, FontVo.PALACE_FONT, 20, 0x561a1a, true);
			this.addChild( label );
			label.x = 210;
			label.y = 20;
			label.hAlign = HAlign.CENTER;
			label.vAlign = VAlign.CENTER;
			label.touchable = false;
		}
		/*
		* 星星
		*/
		private function initStars():void
		{
			var count:int = data.numStars;
			var star:Image;
			var t:Texture;
			for(var i:int = 0; i<3; i++)
			{
				(i<count)?t = UserCenterManager.getTexture("star_small_light"):UserCenterManager.getTexture("star_small_gray");
				star = new Image(t);
				star.x = 230 + i * (45);
				star.y = 104;
				star.touchable =false;
				this.addChild( star );
			}
		}
		/*
		* 游戏图标按钮
		*/
		private function initButton():void
		{
			gameIcon = new Button();
			gameIcon.defaultSkin = new Image(UserCenterManager.getTexture("card_game_"+data.icon));
			this.addChild( gameIcon );
			gameIcon.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(gameIcon);
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED)
				{
					callBakc( data.name );
				}
			}
		}
		/*
		* 分割线
		*/
		private function initImages():void
		{
			image = new Image(UserCenterManager.getTexture("line_short"));
			this.addChild( image);
			image.x = 230;
			image.y = 64;
			image.touchable = false;
		}
		
		
		override public function dispose():void
		{
			data = null;
			callBakc = null;
			if(label)
				label.removeFromParent(true);
			label = null;
			if(gameIcon)
			{
				gameIcon.removeEventListener(TouchEvent.TOUCH, onTouch);
				gameIcon.removeFromParent(true);
				gameIcon = null;
			}
			if(image)
				image.removeFromParent(true);
			image = null;
			super.dispose();
		}
		
		public var callBakc:Function;
	}
}