package views.module5
{
	import com.greensock.TweenLite;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import feathers.core.PopUpManager;

	import sound.SoundAssets;

	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.ElasticButton;
	import views.components.ItemIntro;
	import views.components.LionMC;
	import views.components.Prompt;
	import views.components.base.PalaceScene;

	/**
	 * 娱乐模块
	 * 对话场景
	 * @author Administrator
	 */
	public class Scene51 extends PalaceScene
	{
		private var txtArr:Array=[
			"幸亏我年纪一把，能有个椅子坐",
			"希望这次的座位别排在柱子后面",
			"今演好了，重重有赏！"];

		private var pArr:Array=["dachen1", "dachen2", "taihou"];
		private var posArr:Array=[new Point(228, 562),
								  new Point(836, 414), new Point(624, 517)];
		private var movArr:Array=[new Point(-25, 25),
								  new Point(-5, -60), new Point(30, 5)];
		private var txtOffset:Array=[new Point(65, 60),
									 new Point(17, 15), new Point(147, 62)];
		private var imgArr:Array=[];

		private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(5);

		public function Scene51(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=12;
			addBG("bg51");

			addPeople();

			LionMC.instance.say(" 待各位落座，演出就\n正式开始。", 0, 0, 0, function():void {
				ready=true;
				bg.addEventListener(TouchEvent.TOUCH, onBGTouch);
			}, 20, .6, true);

		}

		private function onBGTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(bg, TouchPhase.BEGAN);
			if (!tc)
				return;
			var pt:Point=tc.getLocation(bg);
			if (rect.containsPoint(pt))
				openBook();
		}

		private function openBook():void
		{
			SoundAssets.playSFX("popup");
			book=new ItemIntro(0, null);
			var close:ElasticButton=new ElasticButton(getImage("button_close"), getImage("button_close_down"));
			book.addIntro(getImage("intro-bg"), getImage("intro-stage"), close);
			book.addEventListener(ItemIntro.CLOSE, onClose);
		}

		private var rect:Rectangle=new Rectangle(313, 121, 343, 336);

		private function onClose(e:Event):void
		{
			PopUpManager.removePopUp(book, true);
			book=null;

//			showCard("14");
		}

		private function addPeople():void
		{
			for (var i:int=0; i < pArr.length; i++)
			{
				var img:Image=getImage(pArr[i]);
				img.x=posArr[i].x;
				img.y=posArr[i].y;
				addChild(img);
				img.addEventListener(TouchEvent.TOUCH, onClick);
				imgArr.push(img);

				var label:Image=getImage("label" + (i < 2 ? 0 : 1).toString());
				label.touchable=false;
				label.x=labelPosArr[i].x;
				label.y=labelPosArr[i].y;
				addChild(label);
				labelArr.push(label);
			}
		}

		private var labelPosArr:Array=[new Point(352, 574),
									   new Point(891, 391), new Point(818, 560)];
		private var labelArr:Array=[];

		private function onClick(e:TouchEvent):void
		{
			if (!ready)
				return;
			var img:Image=e.currentTarget as Image;
			if (!img)
				return;
			var tc:Touch=e.getTouch(img, TouchPhase.ENDED);
			if (!tc)
				return;
			var index:int=imgArr.indexOf(img);
			img.removeEventListener(TouchEvent.TOUCH, onClick);
			var dx:Number=img.x + movArr[index].x;
			var dy:Number=img.y + movArr[index].y;
			var cb:Function=function():void {
				TweenLite.to(img, 1.5, {x: dx, y: dy, onComplete: function():void {
					TweenLite.to(img, .5, {alpha: 0});
					TweenLite.to(labelArr[index], .5, {alpha: 0});
					checkAll(index);
				}});}
			Prompt.showTXT(img.x + txtOffset[index].x,
						   img.y + txtOffset[index].y, txtArr[index], 20, cb);
			if (index == 0)
				SoundAssets.playSFX("cough");
			else if (index == 1)
				SoundAssets.playSFX("sigh");
			else if (index == 2)
				SoundAssets.playSFX("taihou");
		}

		private var ready:Boolean;
		private var book:ItemIntro;

		private function checkAll(index:int):void
		{
			checkArr[index]=true;
			var count:int=0;
			for each (var b:Boolean in checkArr)
			{
				if (b)
					count++;
			}
			if (count == 3)
				showAchievement(26, sceneOver);
		}
	}
}
