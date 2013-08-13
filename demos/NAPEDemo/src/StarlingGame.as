package
{
	import flash.geom.Point;

	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class StarlingGame extends Sprite
	{
		[Embed(source="assets/bg.jpg")]
		private var bg:Class;

		private var space:Space;

		public function StarlingGame()
		{
			addEventListener(Event.ADDED_TO_STAGE,inits);
		}

		private function inits(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,inits);
			addEventListener(TouchEvent.TOUCH,onTouch);
			addChild(Image.fromBitmap(new bg()));

			space=new Space(new Vec2(0,1000));
			var fl:Body=new Body(BodyType.STATIC,new Vec2(0,550));
			fl.shapes.add(new Polygon(Polygon.rect(0,0,800,1)));
			fl.space=space;

			addEventListener(Event.ENTER_FRAME,loop);
		}

		private function onTouch(e:TouchEvent):void{
			var tc:Touch=e.getTouch(stage);
			if(!tc)return;
			if(tc.phase==TouchPhase.BEGAN){
				var pt:Point=tc.getLocation(stage);

				var bodiesList:BodyList = space.bodiesUnderPoint(new Vec2(pt.x,pt.y));
				//遍历每个刚体
				bodiesList.foreach(
					function( bb:Body):void{
						if(bb.isDynamic()){
							//如果刚体是非静止的，则删除刚体
							if(bb.userData.graphic)
								removeChild(bb.userData.graphic);
							space.bodies.remove(bb);
						}
					}
					);
			}
		}

		private function loop(e:Event):void
		{
			space.step(1/60);

			if(Math.random()<0.05)
				addBall();

			for (var i:int = 0; i < space.liveBodies.length; i++) {
				var body:Body = space.liveBodies.at(i);
				if (body.userData.graphicUpdate) {
					body.userData.graphicUpdate(body);
				}
			}
		}

		private function addBall():void
		{
			var ball:Body=new Body(BodyType.DYNAMIC,new Vec2(Math.random()*700,-10));
			ball.shapes.add(new Circle(32,null,new Material(1.7)));
			ball.space=space;
			ball.userData.graphic=new Ball();
			ball.userData.graphicUpdate=updateGrap;
			addChild(ball.userData.graphic);
		}

		private function updateGrap(b:Body):void{
			b.userData.graphic.x=b.position.x;
			b.userData.graphic.y=b.position.y;
			b.userData.graphic.rotation=b.rotation;

			if(b.userData.graphic.x<-32||b.userData.graphic.x>832)
			{
				removeChild(b.userData.graphic);
				space.bodies.remove(b);
			}
		}
	}
}

