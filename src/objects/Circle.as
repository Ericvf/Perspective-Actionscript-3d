function Circle($e, $xr, $yr, $d, $f)
{
	var Engine = $e;
	var XRadius = $xr;
	var YRadius = $yr;
	var Dots = $d;
	
	var Face = $f ? $f : new TFace(0xFF0000, 100, 0);
	
	for (var i = 1; i <= Dots; i++)
	{
		var X = Math.cos((i / Dots) * (Math.PI*2)) * (XRadius*2);
		var Y = Math.sin((i / Dots) * (Math.PI*2)) * (YRadius*2);
		var Z = 0;
		
		Engine.AddVertex(X, Y, Z);
	}
}