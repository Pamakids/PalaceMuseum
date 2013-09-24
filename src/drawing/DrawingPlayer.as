package drawing {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import drawing.supportClasses.BrushBase;
	import drawing.supportClasses.PaperBase;
	
	
	import org.agony2d.debug.Logger;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
	/** [ DrawingPlayer ]
	 *  [◆]
	 *  	1.  paused
	 *  	2.  timeScale
	 *  	3.  intervalTime
	 *  	4.  totalTime
	 *  [◆◆]
	 *		1.  play
	 * 		2.  stop
	 * 		3.  skip
	 */
public class DrawingPlayer extends PaperBase {
	
	public function DrawingPlayer( paper:CommonPaper, sourceBytes:ByteArray, intervalLength:Number = 8.0, callback:Function = null ) {
		super(paper.contentRatio)
		
		if (!sourceBytes){
			Logger.reportError(this, "constructor", "source bytes can't be null!!")
		}
		m_content = paper.m_content
		m_content.fillRect(m_content.rect, 0x0)
		m_base = paper.m_base ? paper.m_base.clone() : null
		m_brushList = paper.m_brushList
		m_bytesB.writeBytes(sourceBytes)
		m_bytesB.position = m_bytesB.length - 4
		m_totalTime = m_bytesB.readInt()
		m_intervalLength = intervalLength
		m_callback = callback
	}
	
	public function get timeScale() : Number {
		return m_delay.timeScale
	}
	
	public function set timeScale( v:Number ) : void {
		m_delay.timeScale = v
	}
	
	public function get paused() : Boolean { 
		return m_delay.paused 
	}
	
	public function set paused( b:Boolean ) : void {
		m_delay.paused = b
	}
	
	public function get intervalTime() : Number {
		return m_delay.internalTime
	}
	
	public function get totalTime() : Number {
		return m_totalTime * .001
	}
	
	public function play( time:Number = 0 ) : void {
		this.stop()
		this.doPlayNext(m_intervalLength)
	}
	
	public function stop() : void {
		if (m_delay.numDelay > 0) {
			m_delay.killAll()
		}
		m_goalTime = m_bytesB.position = 0
		m_content.fillRect(m_content.rect, 0x0)	
	}
	
	
	override public function dispose():void{
		this.stop()
		m_content.fillRect(m_content.rect, 0x0)
	}
	
	
	
	
	////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////
	
	agony_internal var m_delay:DelayManager = new DelayManager
	agony_internal var m_intervalLength:Number
	agony_internal var m_totalTime:int, m_goalTime:int
	agony_internal var m_callback:Function
	
	
	
		
	protected function doPlayNext( intervalLength:Number ):void{
		var currX:Number, currY:Number, prevX:Number, prevY:Number, density:Number, scale:Number, alpha:Number, completeTime:Number
		var brushIndex:int, type:int, brushType:int
		var color:uint, position:uint
		var BA:ByteArray = m_bytesB
		var beginningTime:int, currTime:int
		var finished:Boolean
		
		beginningTime = m_goalTime
		m_goalTime += intervalLength * 1000.0
		if(m_goalTime > m_totalTime){
			m_goalTime = m_totalTime
		}
		position = BA.position
			
		type = BA.readByte()
		brushIndex = BA.readShort()
		brushType = BA.readByte()
		density = BA.readShort() * .01
		scale = BA.readShort() * .01
		if(brushType > 1){
			color = BA.readUnsignedInt()
			alpha = BA.readShort() * .01
			if(brushType == 3){
				cachedAngle = BA.readShort() * .001
			}
		}
		if(type == 0){
			currX = BA.readShort() * .1 * m_contentRatio
			currY = BA.readShort() * .1 * m_contentRatio
		}
		else if(type == 1){
			currX = BA.readShort() * .1 * m_contentRatio
			currY = BA.readShort() * .1 * m_contentRatio
			prevX = BA.readShort() * .1 * m_contentRatio
			prevY = BA.readShort() * .1 * m_contentRatio
		}
		currTime = BA.readInt()
		if(currTime > m_goalTime){
			BA.position = position
		}
		else {
			if(type == 0){
				m_delay.delayedCall((currTime - beginningTime) * .001, doDrawPoint, m_brushList[brushIndex], currX, currY, density, scale, color, alpha)
			}
			else if(type == 1){
				m_delay.delayedCall((currTime - beginningTime) * .001, doDrawLine, m_brushList[brushIndex], currX, currY, prevX, prevY, density, scale, color, alpha)
			}
			while(currTime < m_totalTime){
				position = BA.position
				type = BA.readByte()
				brushIndex = BA.readShort()
				brushType = BA.readByte()
				density = BA.readShort() * .01
				scale = BA.readShort() * .01
				if(brushType > 1){
					color = BA.readUnsignedInt()
					alpha = BA.readShort() * .01
					if(brushType == 3){
						cachedAngle = BA.readShort() * .001
					}
				}
				if(type == 0){
					currX = BA.readShort() * .1 * m_contentRatio
					currY = BA.readShort() * .1 * m_contentRatio
				}
				else if(type == 1){
					currX = BA.readShort() * .1 * m_contentRatio
					currY = BA.readShort() * .1 * m_contentRatio
					prevX = BA.readShort() * .1 * m_contentRatio
					prevY = BA.readShort() * .1 * m_contentRatio
				}
				currTime = BA.readInt()
				if(currTime > m_goalTime){
					BA.position = position
					break
				}
				else if(type == 0){
					m_delay.delayedCall((currTime - beginningTime) * .001, doDrawPoint, m_brushList[brushIndex], currX, currY, density, scale, color, alpha)
				}
				else if(type == 1){
					m_delay.delayedCall((currTime - beginningTime) * .001, doDrawLine, m_brushList[brushIndex], currX, currY, prevX, prevY, density, scale, color, alpha)
				}
				
//				if(currTime > m_goalTime + 5)
//				{
//					trace('ddddddd')
//				}
			}
		}
		if(m_goalTime < m_totalTime){
			Logger.reportMessage(this, '[ drawing action number ]: ' + m_delay.numDelay + "...[ goalTime ]: " + m_goalTime * .001)
			m_delay.delayedCall((m_goalTime - beginningTime + 1) * .001, doNextRoundDraw)
		}
		else{
			if(m_callback!=null){
				m_delay.delayedCall((m_goalTime - beginningTime + 1) * .001, m_callback)
			}
			Logger.reportMessage(this, '[ drawing action number ]: ' + m_delay.numDelay + "...[ goalTime(finish) ]: " + m_goalTime * .001)
		}
	}
	
	protected function doNextRoundDraw() : void{
		this.doPlayNext(m_intervalLength)
	}
	
	protected function doDrawPoint( brush:BrushBase, currX:Number, currY:Number, density:Number, scale:Number, color:uint, alpha:Number ):void{
		brush.m_density = density
		brush.m_scale = scale
		brush.m_color = color
		brush.m_alpha = alpha
		brush.drawPoint(currX, currY)
	}
	
	protected function doDrawLine( brush:BrushBase, currX:Number, currY:Number, prevX:Number, prevY:Number, density:Number, scale:Number, color:uint, alpha:Number ):void{
		brush.m_density = density
		brush.m_scale = scale
		brush.m_color = color
		brush.m_alpha = alpha
		brush.drawLine(currX, currY, prevX, prevY)
	}
	
}
}