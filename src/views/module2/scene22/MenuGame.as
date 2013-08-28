package views.module2.scene22
{
	import com.pamakids.palace.utils.SPUtils;
	import com.pamakids.utils.DPIUtil;

	import flash.events.AccelerometerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sensors.Accelerometer;

	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.AssetManager;

	import views.components.base.PalaceScene;

	public class MenuGame extends PalaceScene
	{
		public static var boxW:int=201;
		public static var boxH:int=82;

		public static var blockW:int=183;
		public static var blockH:int=64;

		private var dx:Number;
		private var dy:Number;

		private var scale:Number;

		private var space:Space;

		private var menuArr:Array=["1", "2", "3", "4", "5", "6"];

		private var hotareaArr:Array=[];
		private var checkArr:Array=[];

		private var acc:Accelerometer;

		public function MenuGame(am:AssetManager=null)
		{
			super(am);

			scale=DPIUtil.getDPIScale();
			addBG();
			addWorld();

			acc=new Accelerometer();
			acc.addEventListener(AccelerometerEvent.UPDATE, onUpdate);
			addEventListener(Event.ENTER_FRAME, loop);
			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function addBG():void
		{
			addChild(getImage("bg-menu"));
			return;
			for (var i:int=0; i < menuArr.length; i++)
			{
				var menuCheck:MenuCheckBar=new MenuCheckBar();
				var check1:Image=getImage("menu-check");
				menuCheck.addChild(check1);

				var lineCheck:Image=getImage("menu-line-check");
				lineCheck.x=check1.width;
				menuCheck.addChild(lineCheck);

				var check2:Image=getImage("menu-check");
				check2.x=lineCheck.x + check1.x;
				menuCheck.addChild(check2);

				addChild(menuCheck);

				checkArr.push(menuCheck);

				var menuBar:Image=getImage("menu-" + menuArr[i]);
				addChild(menuBar);
			}
		}

		private function addWorld():void
		{
			space=new Space(new Vec2(0, 600));

			var wallW:int=200;
			var posArr:Array=[new Rectangle(-wallW, -wallW, 1224, wallW), new Rectangle(-wallW, 768, 1224, wallW),
				new Rectangle(-wallW, 0, wallW, 768), new Rectangle(1024, 0, wallW, 768)];

			for (var i:int=0; i < 4; i++)
			{
				var rect:Rectangle=posArr[i];
				var wall:Body=new Body(BodyType.STATIC);
				wall.shapes.add(new Polygon(Polygon.rect(rect.x, rect.y, rect.width, rect.height), Material.wood()));
				wall.space=space;
			}

			for (var j:int=0; j < 6; j++)
			{
				var block:Body=new Body(BodyType.DYNAMIC, new Vec2(100 + Math.random() * 800, 200));

				block.shapes.add(new Polygon(Polygon.rect(-blockW / 2, -blockH / 2, blockW, blockH), Material.wood()));
				block.cbTypes.add(blockType);
				block.space=space;

				var blockGraphic:MenuBlock=new MenuBlock();
				blockGraphic.index=j;
				blockGraphic.addChild(getImage("menu-" + menuArr[j] + "-block"));

				block.userData.graphic=blockGraphic;
				block.userData.graphicUpdate=updateGrap;
				block.userData.matched=false;
				block.userData.inBox=false;
				block.userData.dragging=false;

				addChild(block.userData.graphic);

				blockArr.push(block);
			}
		}

		private var blockArr:Vector.<Body>=new Vector.<Body>();

		private function onTouch(e:TouchEvent):void
		{
			var tc:Touch=e.getTouch(stage);
			if (!tc)
				return;

			var pt:Point=tc.getLocation(this);

			switch (tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					var bodiesList:BodyList=space.bodiesUnderPoint(new Vec2(pt.x, pt.y));
					bodiesList.foreach(
						function(body:Body):void {
							if (body.cbTypes.has(blockType))
								if (!body.userData.matched)
								{
									body.userData.dragging=true;
									body.space=null;
									body.rotation=0;
									draggingBlock=body;
								}
						}
						);
					break;
				}

				case TouchPhase.MOVED:
				{
					if (draggingBlock)
					{
						draggingBlock.position.x=pt.x;
						draggingBlock.position.y=pt.y;
					}
					break;
				}

				case TouchPhase.ENDED:
				{
//					if (!checkPOS(pt))
					//					{
					//						draggingBlock.userData.matched=false;
					//						draggingBlock.userData.inBox=false;
					//					}
					//					else
					//					{
					//						draggingBlock.userData.dragging=false;
					//						draggingBlock=null;
					//					}

					if (draggingBlock)
					{
						draggingBlock.userData.matched=false;
						draggingBlock.userData.inBox=false;
						draggingBlock.userData.dragging=false;
						draggingBlock.space=space;
						draggingBlock=null;
					}
					break;
				}

				default:
				{
					break;
				}
			}

		}

		private var blockType:CbType=new CbType();
		private var draggingBlock:Body;

		private function loop(e:Event):void
		{
			space.step(1 / 60);

			for (var i:int=0; i < blockArr.length; i++)
			{
				var body:Body=blockArr[i];

				if (body.userData.graphicUpdate)
					body.userData.graphicUpdate(body);
			}
		}

		protected function onUpdate(event:AccelerometerEvent):void
		{
			dx=event.accelerationX;
			dy=event.accelerationY;
			space.gravity=new Vec2(-dx * 600, dy * 600)
		}

		private function updateGrap(b:Body):void
		{
			if (!b.userData.graphic)
				return;
			b.userData.graphic.x=b.position.x;
			b.userData.graphic.y=b.position.y;
			b.userData.graphic.rotation=b.rotation;
		}
	}
}
