package views.global.books.components
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import models.CollectionVO;
	import models.FontVo;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;

	import views.global.books.BooksManager;

	public class CollectionShow extends Sprite
	{
		public function CollectionShow():void
		{
			initialize();
		}

		private var vo:CollectionVO;
		public function resetData(value:CollectionVO):void
		{
			TweenLite.killTweensOf(this);
			this.scaleX = this.scaleY = 1;

			vo = value;
			haveTurned = !vo.isCollected;
			isTurning = false;
			isBack = false;
			updateView();
			TweenLite.delayedCall( 2, completeFunc);
		}

		public function get id():String
		{
			return vo.id;
		}

		public function get collected():Boolean
		{
			return vo.isCollected;
		}

		private function updateView():void
		{
			if(vo.isCollected)
			{
				background.texture = BooksManager.getTexture("background_collection_1");
				label_1.color = 0x782c14;
				label_1.fontSize = 30;
				label_1.text = vo.name;
			}
			else
			{
				background.texture = BooksManager.getTexture("background_collection_0");
				label_1.color = 0x694313;
				label_1.fontSize = 22;
				label_1.text = vo.explain;
			}
			updateViewByIsBack();
		}
		/**
		 * @param isBack
		 */		
		public function updateViewByIsBack():void
		{
			if(!isBack)		//正面
			{
				if(vo.isCollected)
				{
					if(!icon)
					{
						icon = BooksManager.getImage("icon_collection_" + vo.id);
						this.addChild( icon );
						icon.touchable = false;
					}
					else
					{
						icon.texture = BooksManager.getTexture("icon_collection_" + vo.id);
						icon.readjustSize();
					}
					icon.x = this.viewWidth - icon.width>> 1;
					icon.y = 190 - icon.height/2;
					icon.visible = true;
				}else
				{
					if(icon)
						icon.visible = false;
				}
				label_0.visible = false;
			}
			else
			{
				label_0.visible = true;
				label_0.text = vo.content;
				if(icon)
					icon.visible = false;
			}
		}

		private var viewWidth:int;
		private function initialize():void
		{
			background = BooksManager.getImage("background_collection_0");
			this.addChild( background );
			viewWidth = background.width;

			label_0 = new TextField(246, 220, "", FontVo.PALACE_FONT, 20, 0x492115);
			this.addChild( label_0 );
			label_0.x = (background.width - label_0.width >> 1) + 4;
			label_0.y = 80;
			label_0.hAlign = "left";
			label_0.vAlign = "center";

			label_1 = new TextField(300, 50, "", FontVo.PALACE_FONT, 30, 0x782c14);
			this.addChild( label_1 );
			label_1.x = ( background.width - label_1.width >> 1 ) + 2;
			label_1.y = 330;

			label_1.touchable = label_0.touchable = false;

			this.addEventListener(TouchEvent.TOUCH, onTouch);

			this.pivotX = this.width >> 1;
		}

		private var haveTurned:Boolean = false;
		private function completeFunc():void
		{
			if(haveTurned)
				return;
			turnHandler();
		}

		private function turnHandler():void
		{
			isBack = !isBack;
			haveTurned = true;
			isTurning = true;
			TweenLite.to(this, 0.5, {
							 scaleX: 0, ease: Cubic.easeIn, onComplete: onTweenComplete
						 });
		}

		private var isBack:Boolean = false;
		private var isTurning:Boolean = false;
		private function onTouch(e:TouchEvent):void
		{
			if(!vo.isCollected || isTurning)
				return;
			var touch:Touch = e.getTouch(this);
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				turnHandler();
			}

		}
		private function onTweenComplete():void
		{
			updateViewByIsBack();
			TweenLite.to(this, 0.5, {
							 x: x - this.width/2, scaleX: 1, ease: Cubic.easeInOut, onComplete: function():void{ isTurning = false; }
						 });
		}

		private var background:Image;
		private var icon:Image;
		private var label_0:TextField;
		private var label_1:TextField;

		override public function dispose():void
		{
			if(background)
				background.removeFromParent(true);
			if(label_0)
				label_0.removeFromParent(true);
			if(label_1)
				label_1.removeFromParent(true);
			if(icon)
				icon.removeFromParent(true);
			super.dispose();
		}
	}
}

