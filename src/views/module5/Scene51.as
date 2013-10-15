package views.module5
{
	import flash.geom.Point;

	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.Prompt;
	import views.components.base.PalaceScene;
	import views.module5.scene51.Audience;

	/**
	 * 娱乐模块
	 * 对话场景
	 * @author Administrator
	 */
	public class Scene51 extends PalaceScene
	{
		private var avatarTypeArr:Array=["chancellor", "maid", "empressdowager"];
		private var txtArr:Array=["大臣：希望这次的座位别排在柱子后面",
			"大臣：唉，跪着听戏真不好受",
			"大臣：幸亏我年纪一把，能有个椅子坐",
			"宫女：今儿皇上听戏倒是积极",
			"太后：今演好了，重重有赏！"];

		private var posArr:Array=[new Point(229, 554), new Point(353, 624),
			new Point(810, 294), new Point(833, 447), new Point(731, 490)];
		private var count:int=0;

		public function Scene51(am:AssetManager=null)
		{
			super(am);
			crtKnowledgeIndex=12;
			addChild(getImage("bg41"));

			addAvatars();
		}

		private function addAvatars():void
		{
			for (var i:int=0; i < 3; i++)
			{
				var chancellor:Audience=new Audience();
				chancellor.addChild(getImage(avatarTypeArr[0]));
				chancellor.x=posArr[i].x;
				chancellor.y=posArr[i].y;
				chancellor.index=i;
				chancellor.addEventListener(TouchEvent.TOUCH, onAvatarTouch);
				addChild(chancellor);
			}

			var maid:Audience=new Audience(); //宫女
			maid.addChild(getImage(avatarTypeArr[1]));
			maid.x=posArr[3].x;
			maid.y=posArr[3].y;
			maid.index=3;
			maid.addEventListener(TouchEvent.TOUCH, onAvatarTouch);
			addChild(maid);

			var empressdowager:Audience=new Audience(); //太后
			empressdowager.addChild(getImage(avatarTypeArr[2]));
			empressdowager.x=posArr[4].x;
			empressdowager.y=posArr[4].y;
			empressdowager.index=4;
			empressdowager.addEventListener(TouchEvent.TOUCH, onAvatarTouch);
			addChild(empressdowager);
		}

		private function onAvatarTouch(e:TouchEvent):void
		{
			var audience:Audience=e.currentTarget as Audience;
			if (!audience)
				return;
			var tc:Touch=e.getTouch(audience, TouchPhase.ENDED);
			if (!tc)
				return;
			Prompt.showTXT(audience.x + audience.width - 20, audience.y, txtArr[audience.index]);
			if (!audience.isClicked)
			{
				audience.isClicked=true;
				count++;
				if (count == 3)
				{
					showAchievement(26);
					sceneOver();
				}
			}
		}
	}
}
