class TViewport
{
	private var Instance, Grid_container, Shps_container, Pnts_container: MovieClip;
	private var Gridsize: Number;
	private var Name: String;
	private var Editor: TEditor;
	private var Point, ID: Number;
	public var XYZ_arr: Array;

	function TViewport($editor: TEditor, $instance: MovieClip, $name: String)
	{
		// Init
		XYZ_arr  = new Array(0, 1, 2);
		var self = this;
		
		// Handle Parameters
		Gridsize = $editor.Gridsize;
		Instance = $instance;
		Editor   = $editor;
		Name     = $name;

		// Add Viewport
		ID = Editor.AddViewport(this);

		Instance.onEnterFrame = function()
		{
			var xm = this._xmouse;
			var ym = this._ymouse;
				
			if ((Math.abs(xm) <= this._width / 2) and (Math.abs(ym) <= this._height / 2))
			{
				_root.viewport_txt.text = self.Name;
				_root.xpos_txt.text = self.Editor.SnapToGrid(xm);
				_root.ypos_txt.text = self.Editor.SnapToGrid(ym);
			}
		}
		
		// Draw Grid
		Grid_container = Instance.createEmptyMovieClip("Grid", Instance.getNextHighestDepth());
		Shps_container = Instance.createEmptyMovieClip("Shps", Instance.getNextHighestDepth());
		Pnts_container = Instance.createEmptyMovieClip("Pnts", Instance.getNextHighestDepth());
		Grid_container.onPress = function()
		{
			self.GridClick(this, self);
			_root.SelectedShapes = new Array();
		};
		Grid_container.useHandCursor = false;
		
		var iw = Math.round(Instance._width) - 3;
		var ih = Math.round(Instance._height) - 3;
		DrawGrid(Grid_container, iw, ih);
	}
	
	public function GridClick($MC: MovieClip, $self): Void
	{
		if (_root.Action == "addpoint")
		{
			var x = Editor.SnapToGrid($MC._xmouse) / Gridsize;
			var y = Editor.SnapToGrid($MC._ymouse) / Gridsize;
						
			var p = new TVertex(0, 0, 0);
			p.ByIndex[$self.XYZ_arr[0]] = x;
			p.ByIndex[$self.XYZ_arr[1]] = y;
			p.FillItems();

			var p = $self.Editor.AddVertex(p.x, p.y, p.z);
			_root.status_txt.text = "Ready...";
			_root.Action = "";
			
			$self.Pnts_container["DragPoint" + p].onPress();	
		}
		Editor.Render();
	}
	
	public function AddPoint($id: Number): Void
	{
		Point = $id;
		
		var dp = Pnts_container.attachMovie("DragPoint", "DragPoint" + $id, Pnts_container.getNextHighestDepth());
		dp.Init(Editor, this, Point);
	}
	
	public function AddShape($id: Number): Void
	{
		var Shape = $id;
		var self = this;
		
		var s   = Shps_container.createEmptyMovieClip("Shape" + $id, Shps_container.getNextHighestDepth());
		s.Shape = Editor.Faces[Shape];	
		s.onEnterFrame = function()
		{			
			var Gridsize = self.Gridsize;
			var Style    = this.Shape.Style;
			var xp     = self.XYZ_arr[0];
			var yp     = self.XYZ_arr[1];
			
			var Points = self.Editor.Vertices;
			var Pts    = this.Shape.Vertices;
			var p1     = Pts[0], p2 = Pts[1], p3 = Pts[2], p4 = Pts[3];
			
			var x1 = Points[p1].ByIndex[xp] * Gridsize;
			var y1 = Points[p1].ByIndex[yp] * Gridsize;
			var x2 = Points[p2].ByIndex[xp] * Gridsize;
			var y2 = Points[p2].ByIndex[yp] * Gridsize;
			var x3 = Points[p3].ByIndex[xp] * Gridsize;
			var y3 = Points[p3].ByIndex[yp] * Gridsize;
			
			if (this.Shape.Type == 1)
			{
				var x4 = Points[p4].ByIndex[xp] * Gridsize;
				var y4 = Points[p4].ByIndex[yp] * Gridsize;
			}

			this.clear();
			
			if (Style.Line) this.lineStyle(Style.line_thick, Style.line_color, Style.line_alpha);
			if (Style.Fill) this.beginFill(Style.fill_color, Style.fill_alpha);
			
			this.moveTo(x1, y1);
			this.lineTo(x2, y2);
			this.lineTo(x3, y3);
			
			if (this.Shape.Type == 1) this.lineTo(x4, y4);
			
			this.lineTo(x1, y1);
			
			if (Style.Fill) this.endFill();
			
		}
		
		s.onPress = function()
		{
			//_root.selectedShape = this.Shape;
			if (Key.isDown(Key.SHIFT))
			{
				_root.SelectedShapes.push(this.Shape);
				return;
			} 
			else 
			{
				_root.SelectedShapes = new Array();
				_root.SelectedShapes.push(this.Shape);
			}
		}
		s.useHandCursor = false;
	}
	
	public function DrawGrid($MC: MovieClip, $w, $h): Void
	{
		var cols	= $w / Gridsize;
		var rows	= $h / Gridsize;
		var i;
		
		var cx 		= Math.ceil(cols / 2) * Gridsize;
		var cy		= Math.ceil(rows / 2) * Gridsize;
		
		$MC.beginFill(0xFFFFFF);
		$MC.moveTo(-$w / 2, -$h / 2);
		$MC.lineTo(-$w / 2, $h / 2);
		$MC.lineTo($w / 2, $h / 2);
		$MC.lineTo($w / 2, -$h / 2);
		$MC.lineTo(-$w / 2, -$h / 2);
		$MC.endFill();
		
		$MC.lineStyle(0, 0xDDDDDD, 100);
		
		for (i = 0; i <= cols; i++)
		{
			if (i == cx) continue;
				
			var p = i * Gridsize;
			$MC.moveTo(p - ($h / 2), -($h / 2));
			$MC.lineTo(p - ($h / 2), $h / 2);
		}
		
		for (i = 0; i <= rows; i++)
		{
			if (i == cy) continue;
			
			var p = i * Gridsize;
			$MC.moveTo(-($w / 2), p - ($w / 2));
			$MC.lineTo($w / 2, p - ($w / 2));
		}
		
		$MC.lineStyle(0, 0xFF0000, 100);
		$MC.moveTo(-($w / 2), 0);
		$MC.lineTo($w / 2, 0);
		$MC.moveTo(0, ($h / 2));
		$MC.lineTo(0, -($h / 2));
	}
}
		