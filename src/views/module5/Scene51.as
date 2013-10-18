package views.module5
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;

	/**
	 * 娱乐模块
	 * 对话场景
	 * @author Administrator
	 */
	public class Scene51 extends PalaceScene
	{
//		private var avatarTypeArr:Array=["chancellor", "maid", "empressdowager"];
		private var txtArr:Array=["大臣：希望这次的座位别排在柱子后面",
			"大臣：唉，跪着听戏真不好受",
			"大臣：幸亏我年纪一把，能有个椅子坐",
			"宫女：今儿皇上听戏倒是积极",
			"太后：今演好了，重重有赏！"];

		private var count:int=0;
		private var areaArr:Array=[new Rectangle(247, 567, 43, 48), new Rectangle(280, 626, 44, 59),
			new Rectangle(368, 685, 44, 59), new Rectangle(696, 564, 29, 61), new Rectangle(771, 553, 45, 76)];
		private var checkArr:Vector.<Boolean>=new Vector.<Boolean>(5);

		public function Scene51(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=12;
			addChild(getImage("bg51"));

			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(this, TouchPhase.ENDED);
			if (!tc)
				return;

			for (var i:int=0; i < areaArr.length; i++)
			{
				var rect:Rectangle=areaArr[i];
				if (rect && rect.containsPoint(tc.getLocation(this)))
				{
					checkArr[i]=true;
					if (p)
						p.playHide();
					p=Prompt.showTXT(rect.x + rect.width - 20, rect.y, txtArr[i]);
					checkAll();
					return;
				}
			}
		}

		private var p:Prompt;

		private function checkAll():void
		{
			var count:int=0;
			for each (var b:Boolean in checkArr)
			{
				if (b)
					count++;
			}
			if (count == 3)
				sceneOver();
		}
	}
}
