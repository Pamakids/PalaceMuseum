package views.global.userCenter.collection
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.geom.Point;
	
	import controllers.DC;
	
	import models.CollectionVO;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import views.global.userCenter.BaseScreen;
	import views.global.userCenter.UserCenterManager;
	
	public class CollectionScreen extends BaseScreen
	{
		public function CollectionScreen()
		{
		}
		
		override protected function initialize():void
		{
			super.initialize();
			initDatas();
			initImages();
		}
		
		private var vecImage:Vector.<Image>;
		private function initImages():void
		{
			var paddingLeft:int = 50;
			var horizontalGap:int = 15;
			var paddingTop:int = 150;
			var verticalGap:int = 90;
			
			vecImage = new Vector.<Image>(max);
			var image:Image;
			var vo:CollectionVO;
			var textureUn:Texture = UserCenterManager.getTexture("card_collection_unfinish");
			
			var texture:Texture;
			for(var i:int = 0;i<max;i++)
			{
				vo = source[i];
				texture = vo.isCollected?UserCenterManager.getTexture("card_collection_"+vo.id):textureUn;
				image = new Image(texture);
				image.scaleX = image.scaleY = .8;
				image.x = int( paddingLeft + Math.floor(i/6) * this.viewWidth/2 + (i%3) * (horizontalGap + image.width) );
				image.y = int( paddingTop + Math.floor( (i%6)/3 ) * (verticalGap + image.height) );
				this.addChild( image );
				vecImage[i] = image;
				image.addEventListener(TouchEvent.TOUCH, onTouch);
			}
		}
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if(touch)
			{
				switch(touch.phase)
				{
					case TouchPhase.MOVED:
						return;
					case TouchPhase.BEGAN:
						begin = e.currentTarget as Image;
						break;
					case TouchPhase.ENDED:
						if(begin == e.currentTarget)
						{
							selectedVo = source[vecImage.indexOf(begin as Image)];
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
		private var point:Point;
		private var scale:Number = .3;
		private var alpha:Number = 0;
		private var imageHeight:int;
		
		private function showImage():void
		{
			point = globalToLocal(new Point());
			if(!card)
			{
				container = new Sprite();
				this.addChild( container );
				container.x = point.x;
				container.y = point.y;
				
				quad = new Quad(1024, 768, 0x000000);
				quad.alpha = .4;
				container.addChild( quad );
				quad.addEventListener(TouchEvent.TOUCH, onTouchPop);
				
				card = new CollectionShow();
				container.addChild( card );
				imageHeight = card.height;
			}
			card.resetData(selectedVo);
			container.visible = true;
			move = true;
			begin.localToGlobal(new Point(), point);
			const X:int = 512;
			const Y:int = 768-imageHeight >> 1;
			
			card.scaleX = card.scaleY = scale;
			card.alpha = alpha;
			card.x = point.x + card.width/2;
			card.y = point.y;
			
			TweenLite.to(card, 0.3, {x: X, y: Y, scaleX: 1, scaleY: 1, alpha: 1, ease:Cubic.easeInOut, onComplete: function():void{ 
				move=false;
			}});
		}
		private var move:Boolean = false;
		
		private function onTouchPop(e:TouchEvent):void
		{
			if(move)
				return;
			var touch:Touch;
			touch = e.getTouch(stage);
			if(touch && touch.phase == TouchPhase.ENDED)
			{
				TweenLite.to(card, 0.3, {x: point.x+card.width*scale/2, y:point.y, scaleX: scale, scaleY: scale, alpha: alpha, ease:Cubic.easeOut, onComplete:function():void{
					container.visible = false;
				}});
			}
		}
		
		private var source:Vector.<CollectionVO>;
		private function initDatas():void
		{
			var arr:Array = UserCenterManager.getAssetsManager().getObject("collection").source;
			max = arr.length;
			source = new Vector.<CollectionVO>(max);
			var vo:CollectionVO;
			for(var i:int = 0;i<max;i ++)
			{
				vo = new CollectionVO();
				vo.id = i.toString();
				vo.name = arr[i].name;
				vo.content = arr[i].content;
				vo.explain = arr[i].explain;
				vo.isCollected = DC.instance.testCollectionIsOpend(vo.id);
				source[i] = vo;
			}
		}
			
		override public function dispose():void
		{
			begin=null;
			if(card)
				card.removeFromParent(true);
			if(quad)
			{
				quad.removeEventListener(TouchEvent.TOUCH, onTouchPop);
				quad.removeFromParent(true);
			}
			if(container)
				container.removeFromParent(true);
			
			for each(var image:Image in vecImage)
			{
				image.removeEventListener(TouchEvent.TOUCH, onTouch);
				image.removeFromParent(true);
			}
			vecImage=null;
			super.dispose();
		}
		
	}
}

