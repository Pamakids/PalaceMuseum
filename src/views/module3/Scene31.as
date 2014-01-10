package views.module3
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;

	import feathers.core.PopUpManager;

	import sound.SoundAssets;

	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.global.TailBar;

	/**
	 * 早膳模块
	 * 偷看场景
	 * @author Administrator
	 */
	public class Scene31 extends PalaceScene
	{

		public function Scene31(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=6;
			addBG("bg21");

			addChief();

			var desk:Image=getImage("fg21");
			desk.y=768 - 496;
			addChild(desk);
			desk.touchable=false;

			var dishes:Image=getImage("dishes");
			dishes.touchable=false;
			dishes.x=472;
			dishes.y=375;
			addChild(dishes);

			addKing();

			addCraw(new Point(443, 349));

			birdIndex=4;
		}

		private function addKing():void
		{
			king=new MovieClip(assetManager.getTextures("kingDrag"), 18);
			addChild(king);
			king.loop=0;
			Starling.juggler.add(king);
			king.stop();
			king.x=714;
			king.y=768;
			TweenLite.to(king, 1, {x: 714, y: 519, onComplete: kingSay});
		}

		private function kingSay():void
		{
			Prompt.showTXT(king.x + 20, king.y + 135, "好香！御膳房真是个好地方啊！", 20, lionSay, this, 3);
		}

		private function lionSay():void
		{
			LionMC.instance.say("皇帝怎么能进御膳房呢！", 2, 0, 0, function():void {
				bg.addEventListener(TouchEvent.TOUCH, onTouch);
			});
		}

		private function addChief():void
		{
			chef=new MovieClip(assetManager.getTextures("chief"), 18);
			chef.addEventListener(Event.COMPLETE, onChiefPlayed);
			Starling.juggler.add(chef);
			chef.loop=0;
			chef.x=500;
			chef.y=62;
			chef.stop();
			addChild(chef);
			chef.touchable=false;
		}

		override public function dispose():void
		{
			if (chef)
			{
				chef.stop()
				Starling.juggler.remove(chef);
				chef.removeFromParent(true);
				chef=null;
			}
			super.dispose();
		}

		private function onChiefPlayed(e:Event):void
		{
			chef.stop();
			Prompt.showTXT(chefArea.x + chefArea.width - 50, chefArea.y + chefArea.height / 4, chef_hint, 20, function():void {
				showAchievement(15);
			})
		}

		private var fish_hint:String="两只羊，五只鸡……皇帝每天的食材都是有分例的";
		private var dish_hint:String="皇帝的饭菜，用料讲究，营养丰富";
		private var chef_hint:String="被皇帝钦点的御厨拿手菜，可是莫大的荣耀。";
		private var area1:Rectangle=new Rectangle(931, 179, 69, 102);
		private var area2:Rectangle=new Rectangle(879, 311, 145, 185);

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(bg, TouchPhase.ENDED);
			if (tc)
			{
				var pt:Point=tc.getLocation(this);
				if (hotarea.containsPoint(pt))
					openBook()
				else if (chefArea.containsPoint(pt) && chef.currentFrame == 0)
				{
					assetManager.playSound("chefclick", 0, 0, new SoundTransform(SoundAssets.sfxVol));
					assetManager.playSound("chef2", 0, 0, new SoundTransform(SoundAssets.sfxVol));
					chef.play();
				}
				else if (area1.containsPoint(pt))
					Prompt.showTXT(area1.x + area1.width / 2, area1.y + area1.height / 2, fish_hint, 20, null, null, 3)
				else if (area2.containsPoint(pt))
					Prompt.showTXT(area2.x + area2.width / 2, area2.y + area2.height / 2, dish_hint, 20, null, null, 3)
			}
		}

		private function openBook():void
		{
			SoundAssets.playSFX("popup");
			book=new Sprite();
			book.addChild(getImage("book21"));
			close=new ElasticButton(getImage("button_close"));
			close.shadow=getImage("button_close_down");
			close.x=900;
			close.y=100;
			book.addChild(close);
			book.x=46;
			book.y=2;
			PopUpManager.addPopUp(book, true, false);
			close.addEventListener(ElasticButton.CLICK, onClose);
		}

		private function onClose(e:Event):void
		{
			close.removeFromParent(true);
			TweenLite.to(book, 1, {x: 408, y: 363, scaleX: .07, scaleY: .07, ease: Elastic.easeOut, onComplete: function():void
			{
				showAchievement(14);
				PopUpManager.removePopUp(book);
				TweenLite.delayedCall(1, endEff);
			}});
		}

		private function endEff():void
		{
			if (king)
			{
				TailBar.hide();
				king.addEventListener(Event.COMPLETE, onKingPlayed);
				king.play();
				TweenLite.delayedCall(1.3, function():void {
					Prompt.showTXT(864, 617, "急什么，再让我看一会儿…", 20, sceneOver, null, 3, false);
					SoundAssets.playSFX("kingdragged");
				});
			}
		}

		private function onKingPlayed(e:Event):void
		{
			king.removeEventListener(Event.COMPLETE, onKingPlayed);
			Starling.juggler.remove(king);
			king.removeFromParent(true);
			king=null;
//			sceneOver();
		}

		private var hotarea:Rectangle=new Rectangle(280, 140, 210, 290);
		private var chefArea:Rectangle=new Rectangle(626, 127, 200, 280);
		private var book:Sprite;
		private var king:MovieClip;
		private var close:ElasticButton;
		private var chef:MovieClip;
	}
}
