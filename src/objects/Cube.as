function Cube($e, $h, $f)
{
	var Editor = $e;
	var Height = $h / 2;
	
	var Face = $f ? $f : new TFace(0xFF0000, 100, 0);
	
	var p1 = Editor.AddVertex(-Height, -Height, -Height);
	var p2 = Editor.AddVertex(-Height,  Height, -Height);
	var p3 = Editor.AddVertex( Height,  Height, -Height);
	var p4 = Editor.AddVertex( Height, -Height, -Height);
	var p5 = Editor.AddVertex(-Height, -Height, Height);
	var p6 = Editor.AddVertex(-Height,  Height, Height);
	var p7 = Editor.AddVertex( Height,  Height, Height);
	var p8 = Editor.AddVertex( Height, -Height, Height);

	Editor.AddFace(Face, p3, p2, p1, p4);
	Editor.AddFace(Face, p5, p6, p7, p8);
	Editor.AddFace(Face, p2, p6, p5, p1);
	Editor.AddFace(Face, p4, p8, p7, p3);
	Editor.AddFace(Face, p7, p6, p2, p3);
	Editor.AddFace(Face, p8, p4, p1, p5);
}

function ColorCube($e, $h)
{
	var Editor = $e;
	var Height = $h / 2;
	
	var p1 = Editor.AddVertex(-Height, -Height, -Height);
	var p2 = Editor.AddVertex(-Height,  Height, -Height);
	var p3 = Editor.AddVertex( Height,  Height, -Height);
	var p4 = Editor.AddVertex( Height, -Height, -Height);
	var p5 = Editor.AddVertex(-Height, -Height, Height);
	var p6 = Editor.AddVertex(-Height,  Height, Height);
	var p7 = Editor.AddVertex( Height,  Height, Height);
	var p8 = Editor.AddVertex( Height, -Height, Height);

	Editor.AddFace(new TFace(0xFF0000, 50, 0), p3, p2, p1, p4);
	Editor.AddFace(new TFace(0xFFAA00, 50, 0), p5, p6, p7, p8);
	Editor.AddFace(new TFace(0xFFFF00, 50, 0), p2, p6, p5, p1);
	Editor.AddFace(new TFace(0x00FF00, 50, 0), p4, p8, p7, p3);
	Editor.AddFace(new TFace(0x0000FF, 50, 0), p7, p6, p2, p3);
	Editor.AddFace(new TFace(0xCC00FF, 50, 0), p8, p4, p1, p5);
}