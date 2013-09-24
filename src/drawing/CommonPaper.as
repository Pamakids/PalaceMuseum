package drawing {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.utils.ByteArray;
	
	import drawing.supportClasses.BrushBase;
	import drawing.supportClasses.CopyPixelsBrush;
	import drawing.supportClasses.EraseBrush;
	import drawing.supportClasses.PaperBase;
	import drawing.supportClasses.TransformationBrush;
	
	import org.agony2d.core.IProcess;
	import org.agony2d.core.ProcessManager;
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	
	use namespace agony_internal;
	
	/** [ CommonPaper ]
	 *  [◆]
	 * 		1.  content
	 *  	2.  bytes
	 *  	3.  brushIndex
	 *  [◆◆]
	 *  	1.  createCopyPixelsBrush
	 *  	2.  createTransformationBrush
	 *  	3.  createEraseBrush
	 *  	4.  getBrushByIndex
	 * 
	 *  	5.  drawPoint
	 *  	6.  drawLine
	 * 
	 * 		7.  addCommand
	 *  	8.  undo
	 *  	9.  redo
	 *  	10. clear
	 */
public class CommonPaper extends PaperBase implements IProcess {
	
	public function CommonPaper( paperWidth:int, paperHeight:int, pixelRatio:Number = 1, base:BitmapData = null, maxSize:int = 1024 ) {
		var width:Number, height:Number, ratio:Number
		
		super(pixelRatio)
		
		width = paperWidth / pixelRatio
		height = paperHeight / contentRatio
		if(width > maxSize || height > maxSize){
			ratio = maxSize / Math.max(width, height)
			m_fitRatio = ratio / m_contentRatio
			m_contentRatio = ratio
			width  *= m_contentRatio
			height *= m_contentRatio
		}
		else{
			m_contentRatio = 1
			m_fitRatio = 1 / pixelRatio
		}
		m_content = new BitmapData(width, height, true, 0x0)
		if (base) {
			if (base.width == width && base.height == height) {
				cachedPoint.setTo(0, 0)
				m_content.copyPixels(base, base.rect, cachedPoint, null, null, true)
			}
			else {
				cachedMatrix.identity()
				cachedMatrix.scale(width / base.width, height / base.height)
				m_content.draw(base, cachedMatrix, null, null, null, true)
			}
			m_base = m_content.clone()
		}
		Logger.reportMessage(this, "width: " + width + "...height: " + height + "...contentRatio: " + m_contentRatio + "...fitRatio: " + m_fitRatio + "...")
		m_bytesA = new ByteArray
	}
	
	public function get isStarted() : Boolean {
		return m_isStarted
	}
	
	public function set isStarted( b:Boolean ) : void{
		if(m_isStarted == b){
			return
		}
		m_isStarted = b
		if(b){
			ProcessManager.addFrameProcess(this, 80000)
		}
		else{
			ProcessManager.removeFrameProcess(this)
		}
	}
	
	public function get isEraseState() : Boolean{
		return m_isEraseState
	}
	
	public function get isDrawing() : Boolean {
		return m_isDrawing
	}
	
	public function get currBrush() : IBrush{
		return m_currBrush
	}
	
	public function get brushIndex() : int {
		return m_brushIndex
	}
	
	public function set brushIndex( v:int ) : void {
		m_brushIndex = v
		m_currBrush = m_brushList[v]
		if(!m_currBrush){
			Logger.reportError(this, "set brushIndex", "an inexistent brush...!!")
		}
		m_isEraseState = (m_currBrush is EraseBrush)
	}
	
	public function get bytes() : ByteArray {
		return m_bytesB
	}
	
	public function set bytes( v:ByteArray ) : void {
		m_bytesB = v
	}
	
	public function createCopyPixelsBrush( source:IBitmapDrawable, index:int, density:Number ) : IBrush {
		var brush:IBrush
		
		m_brushList[index] = brush = new CopyPixelsBrush(m_contentRatio, m_fitRatio, m_content, source, density)
		Logger.reportMessage(this, "Add copy-pixels brush [ " + index + " ]...")
		return brush
	}
	
	public function createTransformationBrush( sourceList:Array, index:int, density:Number, appendScaleLow:Number = 0, appendScaleHigh:Number = 0, rotatable:Boolean = true) :IBrush {
		var brush:IBrush
		
		m_brushList[index] = brush = new TransformationBrush(m_contentRatio, m_fitRatio, m_content, sourceList, density, appendScaleLow, appendScaleHigh, rotatable)
		Logger.reportMessage(this, "Add transformation brush [ " + index + " ]...")
		return brush 
	}
	
	public function createEraseBrush( source:DisplayObject, index:int, density:Number ) : IBrush {
		return m_brushList[index] = new EraseBrush(m_contentRatio, m_fitRatio, density, m_content, source)
	}
	
	public function startDraw( destX:Number, destY:Number ) : Boolean {
		var brushType:int
		
		if(m_isDrawing){
			return false
		}
		m_isDrawing = true
		m_bytesA.writeByte(0) // type
		m_bytesA.writeShort(m_brushIndex) // brush index
		if(m_currBrush is EraseBrush){
			brushType = 1
		}
		else if(m_currBrush is CopyPixelsBrush){
			brushType = 2
		}
		else if(m_currBrush is TransformationBrush){
			brushType = 3
		}
		m_bytesA.writeByte(brushType)
		m_bytesA.writeShort(int(m_currBrush.m_density * 100.0))
		m_bytesA.writeShort(int(m_currBrush.m_scale * 100.0))
		if(brushType > 1){
			m_bytesA.writeUnsignedInt(m_currBrush.m_color)
			m_bytesA.writeShort(int(m_currBrush.m_alpha * 100.0))
			if (brushType == 3) {
				cachedAngle = Math.random() * cachedTwoPI
				m_bytesA.writeShort(int(cachedAngle * 1000.0))
			}
		}
		destX = int(destX * 10.0)
		destY = int(destY * 10.0)
		m_bytesA.writeShort(destX)
		m_bytesA.writeShort(destY)
		m_bytesA.writeInt(m_currTime + (++m_count))
		m_currBrush.drawPoint(destX * m_contentRatio * .1, destY * m_contentRatio * .1)
		return true
	}
	
	public function drawLine( currX:Number, currY:Number, prevX:Number, prevY:Number ) : void {
		var brushType:int
		
		m_bytesA.writeByte(1) // type
		m_bytesA.writeShort(brushIndex) // brush index
		if(m_currBrush is EraseBrush){
			brushType = 1
		}
		else if(m_currBrush is CopyPixelsBrush){
			brushType = 2
		}
		else if(m_currBrush is TransformationBrush){
			brushType = 3
		}
		m_bytesA.writeByte(brushType)
		m_bytesA.writeShort(int(m_currBrush.m_density * 100.0))
		m_bytesA.writeShort(int(m_currBrush.m_scale * 100.0))
		if(brushType > 1){
			m_bytesA.writeUnsignedInt(m_currBrush.m_color)
			m_bytesA.writeShort(int(m_currBrush.m_alpha * 100.0))
			if (brushType == 3) {
				cachedAngle = Math.random() * cachedTwoPI
				m_bytesA.writeShort(int(cachedAngle * 1000.0))
			}
		}
		currX = int(currX * 10.0)
		currY = int(currY * 10.0)
		prevX = int(prevX * 10.0)
		prevY = int(prevY * 10.0)
		m_bytesA.writeShort(currX)
		m_bytesA.writeShort(currY)
		m_bytesA.writeShort(prevX)
		m_bytesA.writeShort(prevY)
		m_bytesA.writeInt(m_currTime + (++m_count))
		m_currBrush.drawLine(currX * m_contentRatio * .1, currY * m_contentRatio * .1, prevX * m_contentRatio * .1, prevY * m_contentRatio * .1)
	}
	
	/** -1[ none ]...0[ position ]...1[ position ]...2[ position ]...3[ position ]... */
	public function endDraw() : void {
		var position:int
		
		trace("end draw...")
		// check and clear...
		if (m_commandIndex == -1) {
			m_commandList.length = m_bytesB.length = 0
		}
		else if (m_commandIndex < m_commandLength - 1) {
			position = m_commandList[m_commandIndex]
			m_bytesB.length = position + 1
			m_commandList.splice(m_commandIndex + 1, m_commandLength - 1 - m_commandIndex)
			m_commandLength = m_commandIndex + 1
		}
		// flush buffer...
		m_bytesB.writeBytes(m_bytesA)
		m_bytesA.length = 0
		m_commandList[++m_commandIndex] = m_bytesB.length - 1
		m_commandLength++
		m_isDrawing = false
	}
	
	public function undo() : void {
		var position:int
		
		if (m_commandIndex >= 0) {
			position = (m_commandIndex-- == 0) ? 0 : m_commandList[m_commandIndex]
			this.redraw(position, 0)
		}
	}
	
	public function redo() : void {
		var position:int, startPosition:int
		
		if (m_commandIndex < m_commandLength - 1) {
			//startPosition = (m_commandIndex < 0) ? 0 : m_commandList[m_commandIndex]
			position = m_commandList[++m_commandIndex]
			this.redraw(position, 0)
		}
	}
	
	public function reset( containsbrush:Boolean = false ) : void {
		var brush:BrushBase
		var l:int
		
		m_content.fillRect(m_content.rect, 0x0)
		m_commandList.length = m_commandLength = m_bytesB.length = m_currTime = 0
		m_commandIndex = -1
//		if(containsbrush){
//			l = m_brushList.length
//			while(--l>-1){
//				brush = m_brushList[l]
//				if(brush){
//					brush.reset()
//				}
//			}
//		}
	}
	
	override public function dispose() : void {
		this.isStarted = false
	}
	
	public function update( deltaTime:Number ) : void {
		m_currTime += deltaTime
		
		//Logger.reportMessage(this, "count: " + m_count)
		m_count = 0
//		if (m_currTime) {
//			
//		}
	}
	
	agony_internal var m_currBrush:BrushBase
	agony_internal var m_commandList:Vector.<int> = new <int>[] // command index:bytes position
	agony_internal var m_cachedList:Vector.<int> = new <int>[] // cached image index:bytes position
	agony_internal var m_commandLength:int, m_commandIndex:int = -1 // 命令所在指针位置表示该命令刚刚完成...
	agony_internal var m_isDrawing:Boolean, m_isEraseState:Boolean, m_isStarted:Boolean
	
	agony_internal var m_currTime:int, m_count:int
	agony_internal var m_bytesA:ByteArray // action buffer bytes...
}
}