class TVertex extends TVector
{
	// Publics
	public var ByIndex: Array;
	public var ox, oy, oz: Number;
	public var rx, ry, rz: Number;
	public var sx, sy: Number;
	
	// Constructor
	function TVertex($x: Number, $y: Number, $z: Number)
	{
		// Init
		ByIndex = new Array();
		
		// Handle parameters
		x = ox = rx = $x;
		y = oy = ry = $y;
		z = oz = rz = $z;
		
		// Fill Array
		FillArray();
	}
	
	function FillArray()
	{
		ByIndex = [x, y, z];
	}
	
	function FillItems()
	{
		x = ByIndex[0];
		y = ByIndex[1];
		z = ByIndex[2];
	}		
	
	function to2D($f)
	{
		var d = $f / ($f + rz);
		sx = rx * d;
		sy = ry * d;
	}
}