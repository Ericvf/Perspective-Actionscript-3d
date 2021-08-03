class TASC_reader
{
	private var XML_object: XML;
	private var Engine: TEngine3D;
	
	public var OnFinish: Function;
	public var Vertices: Array;
	public var Faces: Array;
	
	public var XML_content: String;
	var rIndex, oIndex: Number;
	
	public function TASC_reader($t: String)
	{
        XML_object = new XML();
		Vertices   = new Array();
		Faces	   = new Array();
		
		if ($t != undefined) load($t);
	}
	
	private function load($t: String, $c: TEngine3D)
	{
		trace("loading XML file");
		XML_object.onLoad = loadXML;
        XML_object.load($t);
		
		Engine = $c;
	}
	
	function loadXML($succ)
	{
        if (!$succ) return;
		_root.ASC_reader.resetXML();
	}
	
	function resetXML()
	{
		trace("resetXML socket");
		XML_content = XML_object.firstChild.nodeValue;
		
		Vertices   = new Array();
		Faces	   = new Array();
		rIndex = 0;
		oIndex = 0;
		
		readXML();
	}
	
	function readXML()
	{
		trace("readingXML");
		
		var Lines = XML_content.split("\n");
		
		for (var i in Lines)
		{
			var Line = Lines[i];
			if (Line.length > 30)
			{
				var t = Line.substring(0, 4);
				switch (t)
				{
					case "Vert": Vertices.push(Line); break;
					case "Face": Faces.push(Line); break;
				}
			}
		}
		
		processData();
	}
	
	function processData()
	{
		trace("processing data");
		
		for (var i in Vertices)
		{
			var Line = Vertices[i];
			var Word = Line.split(":");
			var X, Y, Z;
			if (Word[0].substring(0, 6) == "Vertex")
			{
				X = Word[2].split(" ");
				Y = Word[3].split(" ");
				Z = Word[4].split("\r");
				
				if (X[0] == "") X.shift();
				if (Y[0] == "") Y.shift();
				if (Z[0] == "") Z.shift();

				Vertices[i] = {x: X[0], y: Y[0], z: Z[0]};
			}
		}
		
		for (var i in Faces)
		{
			var Line = Faces[i];
			var Word = Line.split(":");
			var A, B, C, D, E;
			
			if (Word[0].substring(0, 4) == "Face")
			{
				A = Word[2].split(" ");
				B = Word[3].split(" ");
				C = Word[4].split(" ")
				D = Word[5].split(" ");
				E = Word[6].split(" ");
				
				if (A[0] == "") A.shift();
				if (B[0] == "") B.shift();
				if (C[0] == "") C.shift();
				if (D[0] == "") D.shift()
				if (E[0] == "") E.shift();
				
				var d = -1;
				var e = 0;
				
				if (C[1] == "D") d = D[0];
				if (D[1] == "E") e = E[0];
				
				Faces[i] = {a: A[0], b: B[0], c: C[0], d: d, e: e};
			}
		}
		
		finish();
	}
	
	function finish()
	{
		trace("finished");
		OnFinish(Engine);
	}
}