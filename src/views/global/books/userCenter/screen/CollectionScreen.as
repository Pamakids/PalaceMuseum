package views.global.books.userCenter.screen
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;

	import flash.geom.Point;

	import controllers.DC;

	import models.CollectionVO;
	import models.PosVO;

	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	import views.global.books.BooksManager;
	import views.global.books.components.CollectionShow;
	import views.global.books.events.BookEvent;

	public class CollectionScreen extends BaseScreen
	{
		public function CollectionScreen()
		{
		}

		override protected function initialize():void
		{
			initPages();
			initDatas();
			initImages();

			dispatchEventWith(BookEvent.InitViewPlayed);
		}

		override protected function initPages():void
		{
			var image:Image=BooksManager.getImage("background_2");
			image.scaleX=image.scaleY=2;
			this.addChild(image);
		}

		private var vecImage:Vector.<Image>;

		private function initImages():void
		{
			var paddingLeft:int=50;
			var horizontalGap:int=15;
			var paddingTop:int=90;
			var verticalGap:int=60;
			var l:int=source.length;
			vecImage=new Vector.<Image>(l);
			var image:Image;
			var vo:CollectionVO;
			var textureUn:Texture=BooksManager.getTexture("card_collection_unfinish");
			itemWidth=textureUn.width;

			var texture:Texture;
			for (var i:int=0; i < l; i++)
			{
				vo=source[i];
				texture=vo.isCollected ? BooksManager.getTexture("card_collection_" + vo.id) : textureUn;
				image=new Image(texture);
				image.scaleX=image.scaleY=.8;
				image.x=int(paddingLeft + Math.floor(i / 3) % 2 * this.viewWidth / 2 + (i % 3) * (horizontalGap + image.width));
				image.y=int(paddingTop + Math.floor(i / 6) * (verticalGap + image.height));
				this.addChild(image);
				trace(image.x, image.y);
				vecImage[i]=image;
				image.addEventListener(TouchEvent.TOUCH, onTouch);
			}
		}

		private function onTouch(e:TouchEvent):void
		{
			if (container && container.visible)
				return;
			var touch:Touch=e.getTouch(this);
			if (touch)
			{
				switch (touch.phase)
				{
					case TouchPhase.MOVED:
						return;
					case TouchPhase.BEGAN:
						begin=e.currentTarget as Image;
						break;
					case TouchPhase.ENDED:
						if (begin == e.currentTarget)
						{
							selectedVo=source[vecImage.indexOf(begin as Image)];
							showImage();
						}
						break;
				}
			}
		}
		private var begin:Image;
		private var max:int;
		private var card:CollectionShow;
		private var container:Sprite;
		private var quad:Quad;
		private var selectedVo:CollectionVO;
		private var scale:Number=.3;
		private var alpha:Number=0;
		private var itemWidth:int;
		private var imageHeight:int;
		private var beginX:int;
		private var beginY:int;
		private var targetX:int;
		private var targetY:int;

		private function showImage():void
		{
			if (!card)
			{
				var point:Point=globalToLocal(new Point());
				container=new Sprite();
				this.addChild(container);
				container.x=point.x;
				container.y=point.y;

				quad=new Quad(1024, 768, 0x000000);
				quad.alpha=.4;
				container.addChild(quad);
				quad.addEventListener(TouchEvent.TOUCH, onTouchPop);

				card=new CollectionShow();
				container.addChild(card);
				imageHeight=card.height;
				container.touchable=false;
			}
			card.resetData(selectedVo);
			container.visible=true;
			move=true;
			targetX=512;
			targetY=768 - imageHeight >> 1;
			beginX=begin.x + 28 + itemWidth / 2;
			beginY=begin.y + 89;

			card.scaleX=card.scaleY=scale;
			card.alpha=alpha;
			card.x=beginX
			card.y=beginY;

			TweenLite.to(card, 0.3, {x: targetX, y: targetY, scaleX: 1, scaleY: 1, alpha: 1, ease: Cubic.easeInOut, onComplete: function():void {
				move=false;
				container.touchable=true;
			}});
		}
		private var move:Boolean=false;

		private function onTouchPop(e:TouchEvent):void
		{
			if (move)
				return;
			var touch:Touch;
			touch=e.getTouch(this);
			if (touch && touch.phase == TouchPhase.ENDED)
			{
				container.touchable=false;
				TweenLite.to(card, 0.3, {x: beginX, y: beginY, scaleX: scale, scaleY: scale, alpha: alpha, ease: Cubic.easeOut, onComplete: function():void {
					container.visible=false;
				}});
			}
		}

		private const order:Array=[0, 1, 2, 3, 4, 12, 5, 6, 7, 9, 8, 13, 10, 11, 14, 15];
//		private const order:Array=[0, 1, 2, 3, 12, 5, 6, 7, 9, 8, 13, 10, 11, 14, 15];
		private var source:Array;
//		private var source:Vector.<CollectionVO>;

		private function initDatas():void
		{
			var arr:Array=BooksManager.getAssetsManager().getObject("collection").source;
			max=arr.length;
			var tmpArr:Vector.<CollectionVO>=new Vector.<CollectionVO>(max);
//			source=new Vector.<CollectionVO>(max);
			var vo:CollectionVO;
			var id:String;
			for (var i:int=0; i < max; i++)
			{
				id=order[i];
				vo=new CollectionVO();
				vo.id=id;
				vo.name=arr[id].name;
				vo.content=arr[id].content;
				vo.explain=arr[id].explain;
				vo.isCollected=DC.instance.testCollectionIsOpend(id);
				tmpArr[i]=vo;
			}

			source=[];
			for (var j:int = 0; j < tmpArr.length; j++) 
			{
				if(j!=4)
					source.push(tmpArr[j]);
			}

			tmpArr=null;
		}

		override public function dispose():void
		{
			begin=null;
			if (card)
				card.removeFromParent(true);
			if (quad)
			{
				quad.removeEventListener(TouchEvent.TOUCH, onTouchPop);
				quad.removeFromParent(true);
			}
			if (container)
				container.removeFromParent(true);

			for each (var image:Image in vecImage)
			{
				image.removeEventListener(TouchEvent.TOUCH, onTouch);
				image.removeFromParent(true);
			}
			vecImage=null;
			super.dispose();
		}

	}
}

