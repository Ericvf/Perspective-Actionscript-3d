function Cylinder($e, $h, $r, $d, $f)
{
	var Engine = $e;
	var Height = $h;
	var Radius = $r;
	var Dots   = $d;
	var X, Y, Z;
	
	var Face = $f ? $f : new TFace(0xFF0000, 100, 0);	
	Engine.Culling = true;
	
	var bottom = Engine.AddVertex(0,-(Height/2), 0);
	var top    = Engine.AddVertex(0, (Height/2), 0);
	
	for (var i=0; i<=Dots; i++)
	{
		X = Math.cos((i / Dots) * (Math.PI*2));
		Z = Math.sin((i / Dots) * (Math.PI*2));
		
		X = X * Radius;
		Z = Z * Radius;
		
		Y = -(Height / 2);
		var a = Engine.AddVertex(X, Y, Z);
				Y = (Height / 2);
		var b = Engine.AddVertex(X, Y, Z);
		
		if (i > 0) 
		{
			Engine.AddFace(Face, bottom, a, a-2, -1);
			Engine.AddFace(Face, top, b, b-2, -1, true);
			Engine.AddFace(Face, a, a-2, b-2, b, -1);
		}
	}
	
}
	
	
	
	