package views.module5
{
	import com.greensock.TweenLite;

	import flash.geom.Point;

	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

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
			"大臣：幸亏我年纪一把，能有个椅子坐",
			"大臣：希望这次的座位别排在柱子后面",
			"太后：今演好了，重重有赏！"];

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
			addChild(getImage("bg51"));

			addPeople();

			LionMC.instance.say("等大家入座，演出就开始了。", 0, 200, 500, function():void {
				ready=true;
			}, 20, false);
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
			}
		}

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
					checkAll(index);
				}});}
			Prompt.showTXT(img.x + txtOffset[index].x,
				img.y + txtOffset[index].y, txtArr[index], 20, cb);
		}

		private var ready:Boolean;

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
