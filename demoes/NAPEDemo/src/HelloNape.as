package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	
	/**
	 * ...
	 * @author ladeng6666
	 */
	public class HelloNape extends Sprite
	{
		private var ga:Class;
		private var space:Space;
		private var debug:ShapeDebug;
		private var cls:Class;
		public function HelloNape()
		{
			//1.创建一个基本的Nape空间
			//声明空间重力
			var gravity:Vec2 = new Vec2(0, 3000);
			space = new Space(gravity);
			
			//2.创建静态的Nape刚体
			//        a.创建一个Body对象，并指定它的类型和坐标
			var body:Body = new Body(BodyType.STATIC, new Vec2(stage.stageWidth/2, stage.stageHeight-10));
			//        b.创建刚体的形状shape，可以接收的形状有两种Cirle和Polygon，后者通过指定不同的顶点来创建任何非圆形的形状。
			var shape:Polygon = new Polygon(Polygon.box(stage.stageWidth, 10));
			body.shapes.add(shape);
			//        c.指定刚体所存在的空间，即第一部分提到的空间。
			body.space = space;
			
			//3.创建模拟视图
			debug = new ShapeDebug(400, 200);
			addChild(debug.display);
			
			//4.在ENTER_FRAME事件处理器中进行Nape模拟
			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
		}
		
		private function mouseEventHandler(e:MouseEvent):void
		{
			//        a.创建一个Body对象，并指定它的类型和坐标
			var body:Body = new Body(BodyType.DYNAMIC, new Vec2(mouseX, mouseY));
			//        b.创建刚体的形状shape，可以接收的形状有两种Cirle和Polygon，后者通过指定不同的顶点来创建任何非圆形的形状。
			var shape:Polygon = new Polygon(Polygon.box(Math.random()*30+30,Math.random()*30+30),Material.wood());
			body.shapes.add(shape);
			//        c.指定刚体所存在的空间，即第一部分提到的空间。
			body.space = space;
			trace(body.userData)
			body.userData.graphics=new cls();
		}
		
		private function loop(e:Event):void
		{
			//Nape空间模拟
			space.step(1 / 60, 30);
			//清除视图
			debug.clear();
			//优化显示图像
			debug.flush();
			//绘制空间
			debug.draw(space);
			
		}
	}
	
}