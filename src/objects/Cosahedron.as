function Cosahedron($e, $f)
{
	var Engine = $e;
	
	var Face = $f ? $f : new TFace(0xFF0000, 100, 0);
	
	var p0 = Engine.AddVertex(40, 0, 60);
	var p1 = Engine.AddVertex(-40, 0, 60);
	var p2 = Engine.AddVertex(40, 0, -60);
	var p3 = Engine.AddVertex(-40, 0, -60);
	var p4 = Engine.AddVertex(0, 60, 40);
	var p5 = Engine.AddVertex(0, -60, 40);
	var p6 = Engine.AddVertex(0, 60, -40);
	var p7 = Engine.AddVertex(0, -60, -40);
	var p8 = Engine.AddVertex(60, 40, 0);
	var p9 = Engine.AddVertex(-60, 40, 0);
	var p10 = Engine.AddVertex(60, -40, 0);
	var p11 = Engine.AddVertex(-60, -40, 0);
		
	Engine.AddFace(Face, p0, p4, p1, -1, true);
	Engine.AddFace(Face, p0, p1, p5, -1, true);
	Engine.AddFace(Face, p0, p5, p10,-1, true);
	Engine.AddFace(Face, p0, p10, p8,-1, true);
	Engine.AddFace(Face, p0, p8, p4, -1, true);
	Engine.AddFace(Face, p4, p8, p6, -1, true);
	Engine.AddFace(Face, p4, p6, p9, -1, true);
	Engine.AddFace(Face, p4, p9, p1, -1, true);
	Engine.AddFace(Face, p1, p9, p11,-1,  true);
	Engine.AddFace(Face, p1, p11, p5,-1,  true);
	Engine.AddFace(Face, p2, p7, p3, -1, true);
	Engine.AddFace(Face, p2, p3, p6, -1, true);
	Engine.AddFace(Face, p2, p6, p8, -1, true);
	Engine.AddFace(Face, p2, p8, p10, -1, true);
	Engine.AddFace(Face, p2, p10, p7, -1, true);
	Engine.AddFace(Face, p7, p10, p5, -1, true);
	Engine.AddFace(Face, p7, p5, p11, -1, true);
	Engine.AddFace(Face, p7, p11, p3, -1, true);
	Engine.AddFace(Face, p3, p11, p9, -1, true);
	Engine.AddFace(Face, p3, p9, p6, -1, true);
}