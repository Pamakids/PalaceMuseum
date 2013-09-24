package drawing {
	
public interface IBrush {
	
	function get density() : Number
	function set density( v:Number ) : void
	
	function get scale() : Number
	function set scale( v:Number ) : void
	
	function get color() : uint
	function set color( v:uint ) : void
	
	function get alpha() : Number
	function set alpha( v:Number ) : void
}
}