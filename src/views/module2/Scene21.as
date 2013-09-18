package views.module2
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.core.PopUpManager;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;

	public class Scene21 extends PalaceScene
	{

		private var chefB:Image;

		private var chefF:Image;
		private var _chefTurn:Boolean;

		public function get chefTurn():Boolean
		{
			return _chefTurn;
		}

		public function set chefTurn(value:Boolean):void
		{
			_chefTurn=value;
			chefB.visible=!value;
			chefF.visible=value;
		}


		public function Scene21(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=7;
			addChild(getImage("bg21"));

			chefB=getImage("chef-back");
			chefF=getImage("chef-front");
			chefF.visible=false;
			var chef:Sprite=new Sprite();
			chef.addChild(chefB);
			chef.addChild(chefF);

			addChild(chef);
			chef.x=628;
			chef.y=62;

			var desk:Image=getImage("fg21");
			desk.y=768 - 496;
			addChild(desk);
			desk.touchable=false;

			king=getImage("king21");
			addChild(king);
			king.x=714;
			king.y=768;
			TweenLite.to(king, 1, {x: 714, y: 519, onComplete: function():void
			{
				addEventListener(TouchEvent.TOUCH, onTouch);
				chef.addEventListener(TouchEvent.TOUCH, onChefTouch);
			}});
		}

		private var fish_hint:String="皇帝的饭菜，用料讲究，营养丰富";
		private var dish_hint:String="身为一国之君，当然要尝遍天下美食";
		private var area1:Rectangle=new Rectangle(931, 179, 69, 102);
		private var area2:Rectangle=new Rectangle(482, 426, 386, 115);

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (tc)
			{
				var pt:Point=tc.getLocation(this);
				if (hotarea.containsPoint(pt))
					openBook()
				else if (area1.containsPoint(pt))
					Prompt.showTXT(area1.x + area1.width / 2, area1.y + area1.height / 2, fish_hint, 20, null, null, 3)
				else if (area2.containsPoint(pt))
					Prompt.showTXT(area2.x + area2.width / 2, area2.y + area2.height / 2, dish_hint)
			}
		}

		private function openBook():void
		{
			book=new Sprite();
			book.addChild(getImage("book21"));
			close=getImage("close");
			close.x=850;
			close.y=50;
			book.addChild(close);
			book.x=46;
			book.y=2;
			PopUpManager.addPopUp(book, true, false);
			close.addEventListener(TouchEvent.TOUCH, onClose);
		}

		private function onClose(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (tc)
			{
				close.removeEventListener(TouchEvent.TOUCH, onClose);
				close.visible=false;
				TweenLite.to(book, 1, {x: 408, y: 363, scaleX: .07, scaleY: .07, ease: Elastic.easeOut, onComplete: function():void
				{
					PopUpManager.removePopUp(book);
					TweenLite.delayedCall(1, endEff);
				}});
			}
		}

		private function endEff():void
		{
			TweenLite.to(king, 1, {x: 1044, onComplete: sceneOver});
		}

		private var hotarea:Rectangle=new Rectangle(280, 140, 210, 290);

		private var book:Sprite;

		private var king:Image;

		private var close:Image;

		private function onChefTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.BEGAN);
			if (tc)
			{
				if (!chefTurn)
				{
					chefTurn=true;
					TweenLite.delayedCall(5, function():void
					{
						chefTurn=false;
					});
				}
			}
		}
	}
}
