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
		private var centerPt:Point=new Point(200,500);   
		private var radius:Number=100;
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

			arrowType=new CbType();
			targetType=new CbType();
			wallType=new CbType();

			addWalls();
			addBow();
			addTarget();
			addListeners();

			addEventListener(Event.ENTER_FRAME,loop);
		}

		private function addWalls():void
		{
			//下
			var fl:Body=new Body(BodyType.STATIC,new Vec2(0,700));
			fl.cbTypes.add(wallType);
			fl.shapes.add(new Polygon(Polygon.rect(0,0,1000,100),Material.sand()));
			fl.space=space;

			//上
			//			var fl1:Body=new Body(BodyType.STATIC,new Vec2(0,-100));
			//			fl1.shapes.add(new Polygon(Polygon.rect(0,0,1000,100)));
			//			fl1.space=space;

			//左
			//			var fl2:Body=new Body(BodyType.STATIC,new Vec2(-100,-100));
			//			fl2.shapes.add(new Polygon(Polygon.rect(0,0,100,800)));
			//			fl2.space=space;

//			右
			var fl3:Body=new Body(BodyType.STATIC,new Vec2(1000,-5000));
			fl3.cbTypes.add(wallType);
			fl3.shapes.add(new Polygon(Polygon.rect(0,0,100,6000)));
			fl3.space=space;
		}

		private function addBow():void
		{
			bow=new Bow();
			addChild(bow);
			bow.x=centerPt.x;
			bow.y=centerPt.y;
		}

		private function addListeners():void
		{
			var targetListener:InteractionListener=new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				arrowType,
				targetType,
				onHitTarget
				);
			space.listeners.add(targetListener);

			var wallListener:InteractionListener=new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				arrowType,
				wallType,
				onHitWall
				);
			space.listeners.add(wallListener);

			var arrowListener:InteractionListener=new InteractionListener(
				CbEvent.BEGIN,
				InteractionType.COLLISION,
				arrowType,
				arrowType,
				onHitArrow
				);
			space.listeners.add(arrowListener);
		}

		private function onHitArrow(cb:InteractionCallback):void
		{
			var body1:Body=cb.int1.castBody;
			var body2:Body=cb.int2.castBody;

			body1.userData.graphic.removeParticle();
			body2.userData.graphic.removeParticle();

//			var i1:int=arrowArr.indexOf(body1);
//			var i2:int=arrowArr.indexOf(body2);
//			if(i1<0&&i2<0)
//				return;
//
//			arrowArr.splice(Math.max(i1,i2),1);
//			arrowArr.splice(Math.min(i1,i2),1);

			body1.userData.isFlying=false;
			body2.userData.isFlying=false;
		}

		private function onHitWall(cb:InteractionCallback):void
		{
			var _arrow:Body;

			var body1:Body=cb.int1.castBody;
			var body2:Body=cb.int2.castBody;

			if(body1.cbTypes.has(arrowType))
				_arrow=body1;
			else
				_arrow=body2;

			_arrow.userData.graphic.removeParticle();
			_arrow.userData.isFlying=false;
//			arrowArr.splice(arrowArr.indexOf(_arrow),1);
		}

		private function onHitTarget(cb:InteractionCallback):void {

			var anchor : Vec2
			var head:Vec2=new Vec2(VO.ARROW_HEAD,0);
			var _arrow:Body;

			var body1:Body=cb.int1.castBody;
			var body2:Body=cb.int2.castBody;

			if(body1.cbTypes.has(arrowType)){
				_arrow=body1;
				anchor=body1.localPointToWorld(head);}
			else{
				_arrow=body2;
				anchor=body2.localPointToWorld(head);}

			_arrow.userData.graphic.removeParticle();

//			var index:int=arrowArr.indexOf(_arrow);
//			if(index<0)
//				return;

			if(!_arrow.userData.isFlying)
				return;

			var angle:Number=Math.atan2(_arrow.velocity.y,_arrow.velocity.x);

			if(anchor.x<=target.position.x+10&&anchor.x>=target.position.x-10&&Math.abs(angle)<Math.PI*.5)
			{
				//anchor节点相对于body1和body2本地系统的坐标
				var anchor1 : Vec2 = body1.worldPointToLocal(anchor);
				var anchor2 : Vec2 = body2.worldPointToLocal(anchor);
				//创建weldJoint关节
				var weldJoint:WeldJoint = new WeldJoint(
					body1, 
					body2, 
					anchor1, 
					anchor2,
					-angle//表示两个刚体的相对角度，默认值也是0
					);
				weldJoint.space=space;
			}

			_arrow.userData.isFlying=false;
		}

		private function addTarget():void
		{
			target=new Body(BodyType.DYNAMIC,new Vec2(900,620));

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
			var mid:Number=VO.ARROW_TAIL+(VO.ARROW_HEAD-VO.ARROW_TAIL)*14/20
			vertices.push(new Vec2(VO.ARROW_HEAD,0));
			vertices.push(new Vec2(mid,-2));
			vertices.push(new Vec2(VO.ARROW_TAIL,-2));
			vertices.push(new Vec2(VO.ARROW_TAIL,2));
			vertices.push(new Vec2(mid,2));

			arrow.shapes.add(new Polygon(vertices,Material.wood()));
			arrow.space=space;
			arrow.userData.graphic=new Arrow();
			arrow.userData.graphicUpdate=updateGrap;
			arrow.userData.type="arrow";
			arrow.userData.isFlying=false;

			addChild(arrow.userData.graphic);

			crtArrow=arrow;
		}

//		private var arrowArr:Vector.<Body>=new Vector.<Body>();

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
					if(crtArrow){
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
			//抵消重力
			crtArrow.applyImpulse(new Vec2(0,-10*crtArrow.mass));

			var angle:Number=Math.PI+Math.atan2(cpt.y-centerPt.y,cpt.x-centerPt.x);
			crtArrow.rotation=angle;

			var distance:Number=Point.distance(cpt,centerPt)-20;

			var strength:Number=Math.max(20,Math.min(distance,100));

			var dx:Number=centerPt.x-Math.cos(angle)*strength;
			var dy:Number=centerPt.y-Math.sin(angle)*strength;

			crtArrow.position.x=dx;
			crtArrow.position.y=dy;

			bow.rotation=angle;
			bow.drag(strength);
		}

		//射箭
		private function release(_pulse:Vec2):void
		{
			var pt:Vec2=crtArrow.localPointToWorld(new Vec2(VO.ARROW_TAIL,0))
			crtArrow.applyImpulse(_pulse,pt);
			crtArrow.userData.graphic.addParticle();
			crtArrow.userData.isFlying=true;
//			arrowArr.push(crtArrow);
			crtArrow=null;
			bow.clear();
		}

		private function calPulse():Vec2
		{
			var multi:Number=10;
			var pos:Vec2=crtArrow.localPointToWorld(new Vec2(VO.ARROW_TAIL,0));
			var vec:Vec2=new Vec2((centerPt.x-pos.x)*crtArrow.mass*multi,(centerPt.y-pos.y)*crtArrow.mass*multi);
			return vec;
		}

		private function loop(e:Event):void
		{
			space.step(1/60);

//			for each (var arrow:Body in arrowArr) 
//			{
//				var flyingAngle:Number=Math.atan2(arrow.velocity.y,arrow.velocity.x);
//				arrow.rotation=flyingAngle;
//				fixPostrue(arrow);
//			}

			if(cpt&&isMoving&&crtArrow)
				checkPOS();

			for (var i:int = 0; i < space.liveBodies.length; i++) {
				var body:Body = space.liveBodies.at(i);

//				if(body.cbTypes.has(arrowType))
				if(body.userData.isFlying)
					fixPostrue(body);
//					if(Normalize2(body.velocity)<1)
//						if(body!=crtArrow){
//							//移除静止刚体
//						}

				if (body.userData.graphicUpdate) 
					body.userData.graphicUpdate(body);
			}
		}

		private var dragConstant:Number=0.0005;

		private var target:Body;

		private var arrowType:CbType;

		private var targetType:CbType;

		private var wallType:CbType;

		private var bow:Bow;

		private function fixPostrue(arrow:Body):void
		{
			var flightSpeed:Number=Normalize2(arrow.velocity);
			var bodyAngle:Number=-arrow.rotation;
			var pointingDirection:Vec2=new Vec2(Math.cos(bodyAngle),-Math.sin(bodyAngle));

			var flyingAngle:Number=Math.atan2(arrow.velocity.y,arrow.velocity.x);
			arrow.rotation=flyingAngle;

			var flightDirection:Vec2=new Vec2(Math.cos(flyingAngle),Math.sin(flyingAngle));
			var dot:Number=b2Dot(flightDirection,pointingDirection);
			var dragForceMagnitude:Number=(1-Math.abs(dot))*flightSpeed*flightSpeed*dragConstant*arrow.mass;
			var arrowTailPosition:Vec2=arrow.localPointToWorld(new Vec2(VO.ARROW_TAIL,0));

			arrow.applyImpulse(new Vec2(dragForceMagnitude*-flightDirection.x,dragForceMagnitude*-flightDirection.y),arrowTailPosition);
		}

		private function b2Dot(a:Vec2, b:Vec2):Number {
			return a.x * b.x + a.y * b.y;
		}
		private function Normalize2(b:Vec2):Number {
			return Math.sqrt(b.x * b.x + b.y * b.y);
		}

		private function updateGrap(b:Body):void{
			if(!b.userData.graphic)return;
			b.userData.graphic.x=b.position.x;
			b.userData.graphic.y=b.position.y;
			b.userData.graphic.rotation=b.rotation;
		}
	}
}

