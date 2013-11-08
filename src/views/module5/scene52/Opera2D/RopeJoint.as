package views.module5.scene52.Opera2D
{
	import flash.display.Graphics;

	import ldEasyNape.LDEasyNape;

	import nape.constraint.ConstraintList;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.Compound;
	import nape.space.Space;

	/**
	 * @author yangfei
	 */
	public class RopeJoint
	{

		private var rope:Compound;
		private var segmentNum:uint;
		private var segmentHeight:Number=20;
		private var segmentWidth:Number=2;

		private var startPoint:Vec2;
		private var endPoint:Vec2;
		private var startBody:Body;
		private var endBody:Body;

		private var bodyList:BodyList;
		private var jointList:ConstraintList;
		private var anchor1:Vec2;
		private var anchor2:Vec2;

		public function RopeJoint(_body1:Body, _body2:Body, segmentSize:Number=20, ropeLenth:Number=0,
			_anchor1:Vec2=null, _anchor2:Vec2=null)
		{
			anchor1=_anchor1;
			anchor2=_anchor2;
			if (!anchor1)
				anchor1=new Vec2();
			if (!anchor2)
				anchor2=new Vec2();
			body1=_body1;
			body2=_body2;

			if (ropeLenth == 0)
			{
				ropeLenth=Vec2.distance(startPoint, endPoint);
			}
			segmentNum=Math.ceil(ropeLenth / segmentHeight);
			segmentHeight=segmentSize;

			bodyList=new BodyList();
			jointList=new ConstraintList();

			rope=new Compound();
			init();
		}

		private function init():void
		{
			var joint:PivotJoint=new PivotJoint(startBody, endBody, anchor1, anchor2);
			joint.compound=rope;
			jointList.unshift(joint);

			for (var i:int=0; i < segmentNum; i++)
			{
				addSegment();
			}
		}
		// used in addSegment();
		private var px:Number;
		private var py:Number;
		private var joint:PivotJoint;
		private var segment:Body;
		private var firstJoint:PivotJoint;

		public function addSegment():void
		{
			//定义刚体的初始坐标
			px=startPoint.x;
			py=startPoint.y + segmentHeight / 2;
			//创建刚体
			segment=LDEasyNape.createBox(px, py, segmentWidth, segmentHeight);
			segment.shapes.at(0).sensorEnabled=true;
			//如果不是第一节刚体，则设置新刚体为第一节刚体的坐标
			if (bodyList.length > 0)
			{
				segment.position.set(bodyList.at(0).position);
				segment.rotation=bodyList.at(0).rotation;
			}
			//调整第一个关节
			firstJoint=jointList.at(0) as PivotJoint;
			firstJoint.body1=segment;
			firstJoint.anchor1=Vec2.weak(0, segmentHeight / 2);
			//创建新的关节，将新增刚体连接到body1上
			joint=new PivotJoint(startBody, segment, anchor1, Vec2.weak(0, -segmentHeight / 2));
			joint.stiff=true;
			joint.ignore=true;
			joint.compound=rope;

			bodyList.unshift(segment);
			jointList.unshift(joint);

		}

		public function removeSegment():void
		{
			if (jointList.length < 5)
				return;
			bodyList.shift().compound=null;
			jointList.shift().compound=null;

			var joint:PivotJoint=jointList.at(0) as PivotJoint;
			joint.body1=startBody;
			joint.anchor1=Vec2.weak();
		}

		public function set space(value:Space):void
		{
			rope.space=value;
		}

		public function get space():Space
		{
			return rope.space;
		}

		public function set active(value:Boolean):void
		{
			var firstJoint:PivotJoint=jointList.at(0) as PivotJoint;
			var lastJoint:PivotJoint=jointList.at(jointList.length - 1) as PivotJoint;
			firstJoint.active=value;
			lastJoint.active=value;
		}

		public function get active():Boolean
		{
			var firstJoint:PivotJoint=jointList.at(0) as PivotJoint;
			return firstJoint.active;
		}

		public function set body1(value:Body):void
		{
			if (jointList)
			{
				var joint:PivotJoint=jointList.at(0) as PivotJoint;
				joint.body1=value;
			}
			startBody=value;
			startPoint=startBody.position.add(anchor1);
		}

		public function set body2(value:Body):void
		{
			if (jointList)
			{
				var joint:PivotJoint=jointList.at(jointList.length - 1) as PivotJoint;
				joint.body2=value;
			}
			endBody=value;
			endPoint=endBody.position.add(anchor2);
		}

		public function drawLine(graphic:Graphics):void
		{
			if (!active)
				return;

			graphic.moveTo(startPoint.x, startPoint.y);

			var px:Number, py:Number;
			var ax:Number, ay:Number;

			var body:Body;
			var joint:PivotJoint;

			for (var i:int=1; i < jointList.length; i++)
			{
				joint=jointList.at(i) as PivotJoint;
				body=joint.body1;

				px=body.position.x;
				py=body.position.y;
//				ax=body.localPointToWorld(joint.anchor2).x;
//				ay=body.localPointToWorld(joint.anchor2).y;
//				graphic.curveTo(ax, ay, px, py);
				graphic.lineTo(px, py);
			}
//			graphic.curveTo(joint.body2.position.x, joint.body2.position.y, endBody.position.add(anchor2).x, endBody.position.add(anchor2).y);
//			graphic.lineTo(joint.body2.position.x, joint.body2.position.y);
		}
	}
}
