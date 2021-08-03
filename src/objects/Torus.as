function Torus($e, $s, $t, $r, $r2, $f, $df)
{	
	var Engine = $e;
	var Tubes  = $t;
	var Sides  = $s;
	var Radius = $r;
	var TRadius = $r2;
	
	var Face = $f ? $f : new TFace(0xFF0000, 100, 0);
	
	var Sarray = new Array();
	var Tarray = new Array();
	
	var r1 = Math.PI / (Tubes / 2);
	var r2 = Math.PI / (Sides / 2);
	var X, Y, Z;
	
    for (var i = 0; i < Tubes; i++)
	{
		Sarray = new Array();
		
        for (var j = 0; j < Sides; j++)
        {
            X = (TRadius + Radius * Math.cos(j * r2)) * Math.cos(i * r1);
            Y = (TRadius + Radius * Math.cos(j * r2)) * Math.sin(i * r1);
            Z = Radius * Math.sin(j * r2);

			var V = Engine.AddVertex(X, Y, Z);
			Sarray.push(V);
        }
		
		Tarray.push(Sarray);
    }
	
	for (var i = 0; i < Tarray.length; i++)
	{
		var Sarray1 = Tarray[i];
		var Sarray2 = Tarray[(i + 1) % Tarray.length];
		
		for (var j = 0; j < Sarray1.length; j++)
		{
			var j2 = (j + 1) % Sarray1.length;
			var p1 = Sarray1[j];
			var p2 = Sarray1[j2];
			var p3 = Sarray2[j];
			var p4 = Sarray2[j2];
			
			if (!$df) 
			{
				// Quads
				Engine.AddFace(Face, p1, p2, p4, p3); 

				// Triangles
				//Engine.AddFace(Face, p1, p2, p3);
				//Engine.AddFace(Face, p2, p3, p4);
			}
		}

	}
}