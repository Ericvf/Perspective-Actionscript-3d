function Sphere($e, $l, $r, $f)
{
	var Engine = $e;
	var Layers = $l;
	var Radius = $r;

	var Xarray = new Array();
	var Yarray = new Array();
	
	var Face = $f ? $f : new TFace(0xFF0000, 100, 0);

	Engine.Culling = true;


	var bottom = Engine.AddVertex(0, -Radius*2, 0);
	var top = Engine.AddVertex(0, Radius*2, 0);
	//

	for (var ya = 1;ya  <= Layers; ya++)
	{

		Xarray = new Array();
		var X, Y, Z;
		
        var rad = ya / (Layers + 1) * 3.141593;
        Y = Math.cos(rad) * Radius * 2;
        var R = Math.sin(rad) * Radius * 2;
		
		for (var i = 0; i < Layers; i++)
		{
			X = Math.cos((i / Layers) * (Math.PI*2)) * R;
			Z = Math.sin((i / Layers) * (Math.PI*2)) * R;
			
			var b = Engine.AddVertex(X, Y, -Z);
			Xarray.push(b);
		}
		
		Yarray.push({Verts:Xarray, ID:Y});
	}

	Yarray.sortOn("ID", Array.NUMERIC);
	
	for (var i=0; i<Yarray.length-1; i++)
	{
		var Xarr1 = Yarray[i].Verts;
		var Xarr2 = Yarray[i+1].Verts;
		
		for (var j=0; j<Xarr1.length; j++)
		{
			var p1 = Xarr1[j];
			var p3 = Xarr2[j];
			var p2 = (j == Xarr1.length -1) ? Xarr1[0] : Xarr1[j+1];
			var p4 = (j == Xarr2.length -1) ? Xarr2[0] : Xarr2[j+1];
			
			if (i == 0) Engine.AddFace(Face, bottom, p1, p2, -1, false);
			if (i == Yarray.length-2) Engine.AddFace(Face, top, p3, p4, -1, true);

			Engine.AddFace(Face, p1, p2, p4, p3, true);
		}
	}
}