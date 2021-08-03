class TFace 
{
	// Publics
	public var Engine: TEngine3D;
	public var Vertices: Array;
	private var VClip: MovieClip;
	public var Style: TStyle;
	public var Type: Number;

	// Constructor
	function TFace($fcolor, $falpha, $lthick, $lcolor, $lalpha)
	{
		// Init Array
        Vertices = new Array();
        Style    = new TStyle(true, $lthick, $lcolor, $lalpha, true, $fcolor, $falpha);
		Type = 0;
	}
	
	// Getters and Setters
	function get length(): Number { return Vertices.length; }
	function get Clip(): MovieClip { return VClip; }
	function set Clip($mc: MovieClip) 
	{
		var i = this;
		VClip = $mc; 
		VClip.onPress = function()
		{
			trace(this);
			if (Key.isDown(Key.SHIFT))
			{
				_root.SelectedShapes.push(i);
				return;
			} 
			else 
			{
				_root.SelectedShapes = new Array();
				_root.SelectedShapes.push(i);
			}
		}
		VClip.useHandCursor = false;
	}
	
	public function Reverse()
	{
		var p1 = Vertices[0];
		var p3 = Vertices[2];
		Vertices[0] = p3;
		Vertices[2] = p1;
	}
	
	public function ChangePlane()
	{
		var p1 = Vertices[0];
		var p2 = Vertices[1];
		var p3 = Vertices[2];
		Vertices[0] = p2;
		Vertices[1] = p3;
		Vertices[2] = p1;
	}
	
	public function FaceCulling(): Boolean
	{
		var p0 = Engine.Vertices[Vertices[0]];
		var p1 = Engine.Vertices[Vertices[1]];
		var p2 = Engine.Vertices[Vertices[2]];
											
		var p0x = p0.sx, p0y = p0.sy;
		var p1x = p1.sx, p1y = p1.sy;
		var p2x = p2.sx, p2y = p2.sy;
		
		return (p1x - p0x) * (p2y - p0y) - (p1y - p0y) * (p2x - p0x) > 0;
	}
	
	public function FindNormal(): TVector
	{
		var v1 = Engine.Vertices[Vertices[0]];
		var v2 = Engine.Vertices[Vertices[1]];
		var v3 = Engine.Vertices[Vertices[2]];
		
		var p0 = new TVector(v1.rx, v1.ry, v1.rz);
		var p1 = new TVector(v2.rx, v2.ry, v2.rz);
		var p2 = new TVector(v3.rx, v3.ry, v3.rz);
		
		var d1 = p0.New_SubtractVector(p1);
		var d2 = p1.New_SubtractVector(p2);
		
		d1.Normalize();
		d2.Normalize();
		
		return d2.CrossProduct(d1);
	}
	
	public function Copy(): TFace
	{
		return new TFace(Style.fill_color, Style.fill_alpha, Style.line_thick, Style.line_color, Style.line_alpha);
	}
}