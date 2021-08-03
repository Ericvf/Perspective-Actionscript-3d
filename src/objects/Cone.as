function Cone($e, $h, $r, $d, $f)
{
	var Engine = $e;
	var Height = $h;
	var Radius = $r;
	var Dots   = $d;
	var X, Y, Z;

	Engine.Culling = true;
	
	var Face = $f ? $f : new TFace(0xFF0000, 100, 0);	
	
	var bottom = Engine.AddVertex(0,-(Height/2), 0);
	var top    = Engine.AddVertex(0, (Height/2), 0);
	
	for (var i=0; i<=Dots; i++)
	{
		X = Math.cos((i / Dots) * (Math.PI*2));
		Y = -(Height / 2);
		Z = Math.sin((i / Dots) * (Math.PI*2));
		
		X = X * Radius;
		Z = Z * Radius;
		
		var s = c = Engine.AddVertex(X, Y, Z);
		if (i > 0) 
		{
			var p = c - 1;
			if (i == Dots) c = s;
			
			Engine.AddFace(Face, bottom, c, p, -1);
			Engine.AddFace(Face, top, c, p, -1, true);
		}
	}
}
	
	
	
	