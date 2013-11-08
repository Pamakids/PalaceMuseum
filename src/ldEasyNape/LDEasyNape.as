/**
 * Change log
 * 2013-02-28	v2
 * 		1.增加setFluidData方法，轻松设置刚体漂浮属性
 * 2013-02-03	v1
 * 		初版发行
 */
package ldEasyNape
{
	import flash.display.DisplayObject;
	import flash.display.Stage;

	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.ShapeDebug;


	public class LDEasyNape
	{
		private static const VER:String="LDEasyNape v1 2013-02-03";

		public function LDEasyNape()
		{
		}
		//定义Nape属性
		private static var world:Space;
		private static var napeDebug:ShapeDebug;
		private static var hand:PivotJoint;
		private static var mouseVec2:Vec2;
		//定义辅助属性
		private static var stage:Stage;
		private static var napeFps:uint=60;

		/**
		 * 初始化LDEasyNape的一些辅助属性
		 **/
		public static function initialize(stage:Stage, napeFps:uint=60):void
		{
			LDEasyNape.stage=stage;
			LDEasyNape.napeFps=napeFps;
		}

		/**
		 * 创建Nape物理世界
		 * @param gravityX
		 * @param gravityY
		 * @return
		 *
		 */
		public static function createWorld(gravityX:Number=0, gravityY:Number=500):Space
		{
			world=new Space(new Vec2(gravityX, gravityY));
			LDEasyNape.world=world;
			return world;
		}

		/**
		 * 创建Nape模拟视图对象
		 * @return
		 *
		 */
		public static function createDebug():ShapeDebug
		{
			napeDebug=new ShapeDebug(stage.stageWidth, stage.stageHeight);
			napeDebug.drawConstraints=true;
			return napeDebug;
		}

		/**
		 * 创建一个矩形刚体并返回
		 * @param posX
		 * @param posY
		 * @param width
		 * @param height
		 * @param isStatic
		 * @param graphic
		 * @return
		 *
		 */
		public static function createBox(posX:Number, posY:Number, width:Number, height:Number, isStatic:Boolean=false, isFixed:Boolean=false, graphic:LDEasyUserData=null):Body
		{
			var body:Body;
			body=initializeBody(posX, posY, isStatic, isFixed);
			var box:Polygon=new Polygon(Polygon.box(width, height), Material.glass());
			body.shapes.push(box);
			setGraphics(body, graphic);
			body.space=world;
			return body;
		}

		/**
		 *
		 * @param posX
		 * @param posY
		 * @param r
		 * @param rotation
		 * @param edgeCount
		 * @param isStatic
		 * @param graphic
		 * @return
		 *
		 */
		//创建指定边数的规则多边形刚体
		public static function createRegular(posX:Number, posY:Number, r:Number, edgeCount:int, rotation:Number, isStatic:Boolean=false, isFixed:Boolean=true, graphic:LDEasyUserData=null):Body
		{
			var regular:Body;
			regular=initializeBody(posX, posY, isStatic, isFixed);
			//通过Polygon预定义的regular方法绘制规则的5变形刚体
			var regularShape:Polygon=new Polygon(Polygon.regular(r, r, edgeCount), Material.glass());
			regularShape.rotate(rotation);
			regular.shapes.push(regularShape);

			setGraphics(regular, graphic);
			regular.space=world;
			return regular;
		}

		/**
		 *
		 * @param posX
		 * @param posY
		 * @param radius
		 * @param isStatic
		 * @param graphic
		 * @return
		 *
		 */
		public static function createCircle(posX:Number, posY:Number, radius:int, isStatic:Boolean=false, isFixed:Boolean=false, graphic:LDEasyUserData=null):Body
		{
			var circle:Body;
			circle=initializeBody(posX, posY, isStatic, isFixed);

			var shape:Circle=new Circle(radius, null, Material.glass());
			circle.shapes.push(shape);
			setGraphics(circle, graphic);
			circle.space=world;
			return circle;
		}

		/**
		 *
		 *
		 */
		public static function createWrapWall():void
		{
			var w:Number=LDEasyNape.stage.stageWidth;
			var h:Number=LDEasyNape.stage.stageHeight;
			var wallthickness:Number=20;

			createBox(w / 2, 0, w, wallthickness, true);
			createBox(w / 2, h, w, wallthickness, true);
			createBox(0, h / 2, wallthickness, h, true);
			createBox(w, h / 2, wallthickness, h, true);
		}

		/**
		 *
		 *
		 */
		public static function updateWorld():void
		{
			for (var i:int=0; i < world.liveBodies.length; i++)
			{
				var body:Body=world.liveBodies.at(i);
				var graphic:DisplayObject=body.userData.graphic;
				var position:Vec2=body.position;
				if (graphic != null)
				{
					graphic.x=position.x;
					graphic.y=position.y;
					graphic.rotation=(body.rotation * 180 / Math.PI) % 360;
				}
			}

			world.step(1 / LDEasyNape.napeFps);
			if (napeDebug != null)
			{
				napeDebug.clear();
				napeDebug.draw(world);
				napeDebug.flush();
			}
			if (hand != null)
			{
				if (hand.active)
					hand.anchor1.setxy(stage.mouseX, stage.mouseY);
			}
		}

		/**
		 *
		 * @param body
		 * @param graphic
		 *
		 */
		private static function setGraphics(body:Body, graphic:LDEasyUserData):void
		{
			if (graphic != null)
			{
				graphic.body=body;
				graphic.createGraphic();
				body.userData.graphic=graphic.graphic;

				stage.addChild(graphic.graphic);
			}
		}

		private static function initializeBody(posX:Number, posY:Number, isStatic:Boolean, isFixed:Boolean):Body
		{
			var body:Body;
			if (isStatic)
			{
				body=new Body(BodyType.STATIC, new Vec2(posX, posY));
			}
			else
			{
				body=new Body(BodyType.DYNAMIC, new Vec2(posX, posY));
			}
			if (isFixed)
			{
				fixBodyAt(body, posX, posY);
			}
			return body;
		}

		/**
		 *
		 * @param body
		 *
		 */
		public static function startDragBody(bodyPressed:Body):void
		{
			if (bodyPressed == null || !bodyPressed.isDynamic())
				return;

			if (hand == null)
			{
				hand=new PivotJoint(world.world, null, new Vec2(), new Vec2());
				hand.space=world;
				hand.stiff=false;
			}
			hand.active=true;
			hand.body2=bodyPressed;
			hand.anchor1.set(mouseVec2);
			hand.anchor2=bodyPressed.worldPointToLocal(mouseVec2);
		}

		/**
		 *
		 *
		 */
		public static function stopDragBody():void
		{
			if (hand != null)
			{
				hand.active=false;
			}
		}

		/**
		 *
		 * @return
		 *
		 */
		public static function getBodyAtMouse():Body
		{
			var bodyPressed:Body;
			mouseVec2=new Vec2(stage.mouseX, stage.mouseY);

			var bodiesUnderMouse:BodyList;
			bodiesUnderMouse=world.bodiesUnderPoint(mouseVec2);
			bodiesUnderMouse.foreach(function(body:Body):void {
				bodyPressed=body;
			});
			return bodyPressed;
		}

		public static function fixBodyAt(body:Body, posX:Number, posY:Number, localX:Number=0, localY:Number=0):void
		{
			var fixedJoint:PivotJoint=new PivotJoint(
				world.world,
				body,
				new Vec2(posX, posY),
				new Vec2(localX, localY));
			fixedJoint.space=world;
		}

		/**
		 *
		 *
		 */
		public static function version():void
		{
			trace(VER);
		}

		public static function setFluidData(body:Body, density:int=1, viscosity:int=1):void
		{
			var shape:Polygon=body.shapes.at(0) as Polygon;
			shape.fluidEnabled=true;
			shape.fluidProperties.density=density;
			shape.fluidProperties.viscosity=viscosity;
		}
	}
}
