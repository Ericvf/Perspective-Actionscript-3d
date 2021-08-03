class TEditor extends TEngine3D
{
	public var VerticesClip, Backgrnd: MovieClip;
	private var Viewports: Array;
	private var RenderCount: Number;
	private var FPS_count: Number;
	
	public var Gridsize: Number;
	public var Snap: Boolean;
	public var DispVertices: Boolean;
	
	public var ShowVertex: Boolean;
	public var ShowFaces: Boolean;
	public var ShowFPS: Boolean;

	function TEditor($instance: MovieClip, $gridsize: Number)
	{
		super($instance);
		
		Gridsize = $gridsize;
		RenderCount = 0;
		FPS_count = 0;

		Viewports = new Array();
		Vertices  = new Array();
		Lights	  = new Array();
		Faces     = new Array();
		Shading   = true;
		
		var h = Instance._height;
		var w = Instance._width;

		Instance.createTextField("Vertices_txt", 2, -(w/2) + 4, -(h/2) + 35, w - 5, 20);
		Instance.createTextField("Faces_txt", 3, -(w/2) + 4, -(h/2) + 50, w - 5, 20);
		Instance.createTextField("FPS_txt", 4, -(w/2) + 4, -(h/2) + 65, w - 5,20);
		Backgrnd 	   = Instance.createEmptyMovieClip("background", 5);
		VerticesClip   = Instance.createEmptyMovieClip("Vertices", 7);
		FacesClip  	   = Instance.createEmptyMovieClip("Faces", 6);
		
		var w = Instance._width / 2;
		var h = Instance._height/ 2;
		var self = this;
		
		Backgrnd.beginFill(0xFFFFFF, 0);
		Backgrnd.moveTo(-w, -h);
		Backgrnd.lineTo( w, -h);
		Backgrnd.lineTo( w, h)
		Backgrnd.lineTo( -w, h);
		Backgrnd.lineTo( -w, -h);

		DispVertices = false;
		ShowVertex = true; 
		ShowFaces  = true; 
		ShowFPS    = true; 
		Snap       = true;
		
		setInterval(this, "FPS_counter", 1000);
	}

	public function Render()
	{		
		super.Render();	
		RenderCount++;
		
		var Format  = new TextFormat();
		Format.color= 0xCCCCCC;
		Format.font = "Verdana"
		Format.bold = true;

		if (ShowVertex) Instance.Vertices_txt.text = "Vertices: " + Vertices.length;
		if (ShowFaces) Instance.Faces_txt.text = "Faces: " + Faces.length;
		if (ShowFPS) Instance.FPS_txt.text = "FPS: " + FPS_count;
		
		Instance.Vertices_txt.setTextFormat(Format);
		Instance.Faces_txt.setTextFormat(Format);
		Instance.FPS_txt.setTextFormat(Format);

		if (DispVertices or _root.Action == "addshape")
		{
			VerticesClip._visible = true;
			
			var len = Vertices.length;
			while(len--)
			{
				var MC = VerticesClip["DragPoint" + len];
				MC._x = Vertices[len].sx;
				MC._y = Vertices[len].sy;
				MC._xscale = MC._yscale = 100 - Vertices[len].rz;
				MC._visible = true;
			}
		}
		else VerticesClip._visible = false;
		

	}

	private function FPS_counter()
	{
		FPS_count   = RenderCount;
		RenderCount = 0;
	}
	
	public function SnapToGrid($pos)
	{
		if (Key.isDown(Key.SHIFT)) return $pos;
		
		if (Snap) $pos = Math.round($pos / Gridsize) * Gridsize;
		return $pos;
	}

	public function AddViewport($vp: TViewport): Number
	{
		var l = Viewports.push($vp);
		return l;
	}
	
	public function AddVertex($x, $y, $z: Number): Number
	{
		var ID = super.AddVertex($x, $y, $z);
		
		for (var v in Viewports)
		{
			var vp = Viewports[v];
			vp.AddPoint(ID);
		}
		
		var V = VerticesClip.attachMovie("DragPoint", "DragPoint" + ID, VerticesClip.getNextHighestDepth());
		V.Init(this, 0, ID);
		
		return ID;
	}
	
	public function AddFace($face: TFace, $p1, $p2, $p3, $p4: Number, $rev: Boolean)
	{
		var ID = super.AddFace($face, $p1, $p2, $p3, $p4, $rev); 

		for (var v in Viewports)
		{
			var vp = Viewports[v];
			vp.AddShape(ID);
		}
		
		_root.SelectedShapes = new Array();
		_root.SelectedShapes.push($face);
		
		return ID;
	}
	
	public function DrawShape($MC, $Style, $Shape): Void
	{
		if (_root.SelectedShapes != undefined)
		{
			for (var S in _root.SelectedShapes)
			{
				var SShape = _root.SelectedShapes[S];
				if (SShape == $Shape)
				{
					$Style.fill_color = 0xFF0000;
					$Style.fill_alpha = 100;
					
					$Style.line_color = 0xFFFF00;
					$Style.Line = true;
					break;
				}
			}
		}
			
		super.DrawShape($MC, $Style, $Shape);
	}
	//*/
}
		