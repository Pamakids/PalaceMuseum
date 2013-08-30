package views.module2
{
	import com.greensock.TweenLite;

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
			TweenLite.to(king, 1, {x: 714, y: 519, onComplete:
					function():void {
						addEventListener(TouchEvent.TOUCH, onTouch);
						chef.addEventListener(TouchEvent.TOUCH, onChefTouch);
					}});
		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage, TouchPhase.ENDED);
			if (tc)
			{
				var pt:Point=tc.getLocation(this);
				if (hotarea.containsPoint(pt))
				{
					removeEventListener(TouchEvent.TOUCH, onTouch);
					openBook();
				}
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
				TweenLite.to(book, 1, {x: 408, y: 363, scaleX: .07, scaleY: .07,
						onComplete: function():void {
							PopUpManager.removePopUp(book);
							TweenLite.delayedCall(1, nextScene);
						}
					});
			}
		}

		private function nextScene():void
		{
			TweenLite.to(king, 1, {x: 1044, onComplete: function():void {
				dispatchEvent(new Event("gotoNext", true));
			}});
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
					TweenLite.delayedCall(5, function():void {
						chefTurn=false;
					});
				}
			}
		}
	}
}
