package
{
	import flash.geom.Point;

	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.constraint.WeldJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
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

	public class Main extends Sprite
	{
		[Embed(source="assets/bg.jpg")]
		private var bg:Class;

		private var space:Space;
		private var crtArrow:Body;
		private var dpt:Point=new Point(400,300);
		private var cpt:Point;
		private var isMoving:Boolean;

		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE,inits);
		}

		private function inits(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,inits);
			addEventListener(TouchEvent.TOUCH,onTouch);
			addChild(Image.fromBitmap(new bg()));

			space=new Space(new Vec2(0,600));

			//下
			var fl:Body=new Body(BodyType.STATIC,new Vec2(0,700));
			fl.shapes.add(new Polygon(Polygon.rect(0,0,1000,100)));
			fl.space=space;

			//上
//			var fl1:Body=new Body(BodyType.STATIC,new Vec2(0,-100));
//			fl1.shapes.add(new Polygon(Polygon.rect(0,0,1000,100)));
//			fl1.space=space;

			//左
//			var fl2:Body=new Body(BodyType.STATIC,new Vec2(-100,-100));
//			fl2.shapes.add(new Polygon(Polygon.rect(0,0,100,800)));
//			fl2.space=space;

			//右
//			var fl3:Body=new Body(BodyType.STATIC,new Vec2(1000,-100));
//			fl3.shapes.add(new Polygon(Polygon.rect(0,0,100,800)));
//			fl3.space=space;

			arrowType=new CbType();
			targetType=new CbType();

			addTarget();
			addListeners();

			addEventListener(Event.ENTER_FRAME,loop);
		}

		private function addListeners():void
		{
			var arrowListener:InteractionListener=new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				arrowType,
				targetType,
				onHitTarget
				);
			space.listeners.add(arrowListener);
		}

		private function onHitTarget(cb:InteractionCallback):void {

			var anchor : Vec2
			var head:Vec2=new Vec2(47,0);
			var _arrow:Body;

			var body1:Body=cb.int1.castBody;
			var body2:Body=cb.int2.castBody;


			if(body1.cbTypes.has(arrowType)){
				_arrow=body1;
				anchor=body1.localPointToWorld(head);}
			else{
				_arrow=body2;
				anchor=body2.localPointToWorld(head);}
			//anchor节点相对于body1和body2本地系统的坐标
			var anchor1 : Vec2 = body1.worldPointToLocal(anchor);
			var anchor2 : Vec2 = body2.worldPointToLocal(anchor);
			//创建weldJoint关节
			var weldJoint:WeldJoint = new WeldJoint(
				body1, 
				body2, 
				anchor1, 
				anchor2,
				-_arrow.rotation//表示两个刚体的相对角度，默认值也是0
				);
			weldJoint.space=space;

			arrowArr.splice(arrowArr.indexOf(_arrow),1);
		}

		private function addTarget():void
		{
			target=new Body(BodyType.DYNAMIC,new Vec2(700,620));

			target.cbTypes.add(targetType);
			target.shapes.add(new Polygon(Polygon.rect(0,-75,3,150),Material.wood()));
			target.shapes.add(new Polygon(Polygon.rect(-100,75,200,20),Material.steel()));
			target.space=space;

			var grahpic:Sprite=new Target();

			target.userData.graphic=grahpic
			target.userData.graphicUpdate=updateGrap;
			grahpic.x=620;
			grahpic.y=250;
			addChild(grahpic);
		}

		private function addArrow():void
		{
			var arrow:Body=new Body(BodyType.DYNAMIC);
			arrow.cbTypes.add(arrowType);
			var vertices:Vector.<Vec2>=new Vector.<Vec2>();
			vertices.push(new Vec2(-110,0));
			vertices.push(new Vec2(0,-4));
			vertices.push(new Vec2(47,0));
			vertices.push(new Vec2(0,4));

			arrow.shapes.add(new Polygon(vertices,Material.steel()));
			arrow.space=space;
			arrow.userData.graphic=new Arrow();
			arrow.userData.graphicUpdate=updateGrap;
			arrow.userData.type="arrow";
			arrow.userData.isFlying=false;

			addChild(arrow.userData.graphic);

			crtArrow=arrow;
		}

		private var arrowArr:Vector.<Body>=new Vector.<Body>();

		private function onTouch(e:TouchEvent):void{
			var tc:Touch=e.getTouch(stage);
			if(!tc)return;
			var pt:Point=tc.getLocation(stage);

			switch(tc.phase)
			{
				case TouchPhase.BEGAN:
				{
					addArrow();
					isMoving=true;
					cpt=pt;
				}

				case TouchPhase.MOVED:
				{
					isMoving=true;
					cpt=pt;
					break;
				}

				case TouchPhase.ENDED:
				{
					isMoving=false;
					if(crtArrow&&dpt){
						var pulse:Vec2=calPulse();
						release(pulse);
					}
					break;
				}

				default:
				{
					break;
				}
			}
		}

		private function checkPOS():void
		{
			crtArrow.rotation=Math.PI+Math.atan2(cpt.y-dpt.y,cpt.x-dpt.x);
			crtArrow.position.x=cpt.x;
			crtArrow.position.y=cpt.y;
		}

		private function release(_pulse:Vec2):void
		{
			crtArrow.applyImpulse(_pulse,crtArrow.localPointToWorld(new Vec2(-110,0)),true);
			crtArrow.isBullet=true;
			arrowArr.push(crtArrow);
		}

		private function calPulse():Vec2
		{
			var multi:Number=3.8;
			var pos:Vec2=crtArrow.localPointToWorld(new Vec2(-110,0));
			var vec:Vec2=new Vec2((dpt.x-pos.x)*crtArrow.mass*multi,(dpt.y-pos.y+10)*crtArrow.mass*multi);
			return vec;
		}

		private function loop(e:Event):void
		{
			space.step(1/60);

			for each (var arrow:Body in arrowArr) 
			{
				fixPostrue(arrow);
			}

			if(dpt&&cpt&&isMoving&&crtArrow)
				checkPOS();

			for (var i:int = 0; i < space.liveBodies.length; i++) {
				var body:Body = space.liveBodies.at(i);

				if (body.userData.graphicUpdate) 
					body.userData.graphicUpdate(body);
			}
		}

		private var dragConstant:Number=0.00005;

		private var target:Body;

		private var arrowType:CbType;

		private var targetType:CbType;

		private function fixPostrue(arrow:Body):void
		{
			var flightSpeed:Number=Normalize2(arrow.velocity);

			var bodyAngle:Number=-arrow.rotation;

//			trace(bodyAngle%Math.PI)

			var pointingDirection:Vec2=new Vec2(Math.cos(bodyAngle),-Math.sin(bodyAngle));

			var flyingAngle:Number=Math.atan2(arrow.velocity.y,arrow.velocity.x);
			var flightDirection:Vec2=new Vec2(Math.cos(flyingAngle),Math.sin(flyingAngle));

//			trace(pointingDirection,flightDirection);

			var dot:Number=b2Dot(flightDirection,pointingDirection);

			var dragForceMagnitude:Number=(1-Math.abs(dot))*flightSpeed*flightSpeed*dragConstant*arrow.mass;
			var arrowTailPosition:Vec2=arrow.localPointToWorld(new Vec2(-110,0));

			arrow.applyImpulse(new Vec2(dragForceMagnitude*-flightDirection.x,dragForceMagnitude*-flightDirection.y),arrowTailPosition);
		}

		private function b2Dot(a:Vec2, b:Vec2):Number {
			return a.x * b.x + a.y * b.y;
		}
		private function Normalize2(b:Vec2):Number {
			return Math.sqrt(b.x * b.x + b.y * b.y);
		}

		private function addBall():void
		{
			var ball:Body=new Body(BodyType.DYNAMIC,new Vec2(Math.random()*700,-10));
			ball.shapes.add(new Circle(45,null,new Material(1.2,1,1,1,200)));
			ball.space=space;
			ball.userData.graphic=new CrimsonBird();
			ball.userData.graphicUpdate=updateGrap;
			addChild(ball.userData.graphic);
		}

		private function updateGrap(b:Body):void{
			if(!b.userData.graphic)return;
			b.userData.graphic.x=b.position.x;
			b.userData.graphic.y=b.position.y;
			b.userData.graphic.rotation=b.rotation;
		}
	}
}

