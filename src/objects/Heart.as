function Heart($e)
{
	var Engine = $e;
	Engine.RemoveLines = true;
	Engine.Culling     = true;
	Editor.Scale       = 100;
	
	var p0 = Engine.AddVertex(0, -0, 8);
	var p1 = Engine.AddVertex(-5, -0, 11.6 );
	var p2 = Engine.AddVertex(-10.0, -0, 7.0 );
	var p3 = Engine.AddVertex(-5.5, 0, -1.0 );
	var p4 = Engine.AddVertex(0, 0, -7.0 );
	var p5 = Engine.AddVertex(0, 2.9, 4.0 );
	var p6 = Engine.AddVertex(-6.0, 3.0, 5.4 );
	var p7 = Engine.AddVertex(-5.5, 2.6, 9.3 );
	var p8 = Engine.AddVertex(-1.7, -0, 10.4 );
	var p9 = Engine.AddVertex(-2.6, 2.4, 8.6 );
	var p10 = Engine.AddVertex(0, 2.0, 6.9 );
	var p11 = Engine.AddVertex(-3.2, 3.4, 4.7 );
	var p12 = Engine.AddVertex(-8.6, 1.8, 6.2 );
	var p13 = Engine.AddVertex(-8.5, -0, 10.5 );
	var p14 = Engine.AddVertex(-5.9, 1.8, 1.8 );
	var p15 = Engine.AddVertex(-8.5, -0, 2.4 );
	var p16 = Engine.AddVertex(0, 1.8, -2.6 );
	var p17 = Engine.AddVertex(-2.0, 0, -4.7 );
	var p18 = Engine.AddVertex(-2.7, 2.0, -.7 );

	var Face = new TFace(0xFF0000, 100, 0);
	
	Engine.AddFace(Face, 6,7 ,9  ,-1,true );
	Engine.AddFace(Face, 1,8 , 7, -1, true);
	Engine.AddFace(Face, 0,9 , 8, -1, true);
	Engine.AddFace(Face, 7,8, 9, -1, true);
	Engine.AddFace(Face, 0,10, 9, -1, true);
	Engine.AddFace(Face, 5,11, 10, -1, true);
	Engine.AddFace(Face, 6,9 , 11, -1, true);
	Engine.AddFace(Face, 10, 11 , 9 , -1, true);
	Engine.AddFace(Face, 6,12, 7, -1, true);
	Engine.AddFace(Face, 2,13, 12, -1, true);
	Engine.AddFace(Face, 1,7 , 13 , -1, true);
	Engine.AddFace(Face, 12,13 , 7 , -1, true);
	Engine.AddFace(Face, 6,14 , 12 , -1, true);
	Engine.AddFace(Face, 3,15 , 14 , -1, true);
	Engine.AddFace(Face, 2,12 , 15 , -1, true);
	Engine.AddFace(Face, 14,15 , 12, -1, true);
	Engine.AddFace(Face, 6,11 , 18 , -1, true);
	Engine.AddFace(Face, 18,14, 6, -1, true);
	Engine.AddFace(Face, 16,18,11  , -1, true);
	Engine.AddFace(Face, 11,5,16, -1, true);
	Engine.AddFace(Face, 4,17,18, -1, true);
	Engine.AddFace(Face, 18,16,4, -1, true);
	Engine.AddFace(Face, 14,18,17, -1, true);
	Engine.AddFace(Face, 17,3,14, -1, true);

	var v = Engine.Vertices;
	var f = Engine.Faces;
	
	var s = v.length; 
	var g = f.length;
	start = 0;
	for (var i=0; i<s; i++)
	{

			var mm = Engine.AddVertex(-v[i].x, v[i].y, v[i].z);
			if (!start) start = mm;

	}
	
	for (var i=0; i<g; i++)
	{
		var fa = f[i].Vertices;
		Engine.AddFace(new TFace(0xFF0000), fa[0]+start, fa[1]+start, fa[2]+start, -1, true);
	}
	
	var v = Engine.Vertices;
	var f = Engine.Faces;
	
	var s = v.length; 
	var g = f.length;
	start = 0;
	for (var i=0; i<s; i++)
	{

			var mm = Engine.AddVertex(v[i].x, -v[i].y, v[i].z);
			if (!start) start = mm;

	}
	
	for (var i=0; i<g; i++)
	{
		var fa = f[i].Vertices;
		Engine.AddFace(new TFace(0xFF0000), fa[0]+start, fa[1]+start, fa[2]+start, -1, true);
	}

	
	
}