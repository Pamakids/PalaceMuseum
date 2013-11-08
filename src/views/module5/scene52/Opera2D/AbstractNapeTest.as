package views.module5.scene52.Opera2D
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	import ldEasyNape.LDEasyNape;

	import nape.constraint.PivotJoint;
	import nape.space.Space;
	import nape.util.BitmapDebug;

	public class AbstractNapeTest extends Sprite
	{

		protected var napeWorld:Space;
		protected var debug:BitmapDebug;

		protected var isCtrlDown:Boolean;
		protected var isShiftDown:Boolean;

		protected var mouseJoint:PivotJoint;

		public function AbstractNapeTest(gravity:Number=600)
		{
			//1.create Nape World
			createNapeWorld(gravity);
			//2.add relative event listeners 
			setUpEvents();
			//3.add system performance monitor
			//addChild(new Stats());
			//4.call onNapeWorldReady which will be override in subclass
			onNapeWorldReady();

			graphics.beginFill(0xD6D6D6);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			stage.frameRate=60;
		}

		/**
		 * create Nape world with gravtiy and debug
		 **/
		protected function createNapeWorld(g:Number=600):void
		{
			LDEasyNape.initialize(stage);
			napeWorld=LDEasyNape.createWorld(0, g);
			addChild(LDEasyNape.createDebug().display);
			LDEasyNape.createWrapWall();
		}

		//add relative event listeners
		protected function setUpEvents():void
		{
			//listening to the EnterFrame Event to update the Nape world
			stage.addEventListener(Event.ENTER_FRAME, loop);
			//add listener to MouseEvent,like mouseDown or MouseUp
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHanlder);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseEventHanlder);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHanlder);
			//add event lisenter for KeyBoard interaction
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyBoardEventHanlder);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyBoardEventHanlder);
		}

		protected function keyBoardEventHanlder(event:KeyboardEvent):void
		{
			//在键盘按下时，记录Ctrl和Shift键的状态
			isCtrlDown=event.ctrlKey;
			isShiftDown=event.shiftKey;
		}

		protected function mouseEventHanlder(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.MOUSE_DOWN:
				{
					LDEasyNape.startDragBody(LDEasyNape.getBodyAtMouse());
					break;
				}
				case MouseEvent.MOUSE_UP:
				{
					LDEasyNape.stopDragBody();
					break;
				}
				default:
				{
					break;
				}
			}
		}

		protected function loop(event:Event):void
		{
			LDEasyNape.updateWorld();
		}

		protected function onNapeWorldReady():void
		{

		}

	}
}
