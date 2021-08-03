class TDragPoint extends MovieClip
{
	// Publics
	public var Viewport: TViewport;
	public var Editor: TEditor;

	var Drag: Boolean;

	public var Points: Object;
	public var xp, yp, zp: Number;
	public var ID: Number;

	// Constructor
	function TDragPoint()
	{
		var self = this;
		_visible = false;
		Drag = true;
	}
	
	function Init($e: TEditor, $v: TViewport, $p: Number): Void
	{
		Points = $e.Vertices[$p];
		
		xp = $v.XYZ_arr[0]; 
		yp = $v.XYZ_arr[1]; 
		zp = $v.XYZ_arr[3];

		Viewport = $v;
		Editor   = $e;
		ID 		 = $p;
		
		this.onRollOver = function(){this.nextFrame()};
		this.onRollOut = this.onReleaseOutside = this.onMouseUp = function(){this.prevFrame()};
		this.onPress = function(){Press()}
		if ($v)
		{
			this.onMouseUp   = function(){this.onEnterFrame = EnterFrame;}		
			this.onEnterFrame = EnterFrame;
		}
		else Drag = false;
		EnterFrame();
		_visible = true;
	}
	
	private function EnterFrame(): Void
	{
		Points.FillArray();
		this._x = Points.ByIndex[xp] * Editor.Gridsize;
		this._y = Points.ByIndex[yp] * Editor.Gridsize;
	}
	
	private function Press(): Void
	{
		if (_root.Action == "addshape")
		{
			var pts_left = _root.RemainPoints.push(ID);				
			if (pts_left == 4)
			{
				var Points = _root.RemainPoints;
				var Shape  = new TFace(Number("0x" + _root.Scolor.text), Number("0x" + _root.Salpha.text), 0);
				Shape.Type = 1;
				Editor.AddFace(Shape, Points[0], Points[1], Points[2], Points[3]);	
				
				
				_root.RemainPoints = new Array();
				_root.status_txt.text = "Ready...";
				_root.Action = "";
			}
			
			_root.status_txt.text = _root.status_txt.text.split("#"+pts_left).join("#"+(pts_left+1));
		} 
		else if (Drag) this.onEnterFrame = PressEnterFrame;
	}
	
	private function PressEnterFrame(): Void
	{
		var xm = _parent._xmouse;
		var ym = _parent._ymouse;
		
		xm = Editor.SnapToGrid(xm);
		ym = Editor.SnapToGrid(ym);
		
		SetPoint(xm, ym);
	}
	
	public function SetPoint($x, $y: Number): Void
	{
		Points.ByIndex[xp] = $x / Editor.Gridsize;
		Points.ByIndex[yp] = $y / Editor.Gridsize;	
		Points.FillItems();
		
		this._x = $x;
		this._y = $y;
	}
}