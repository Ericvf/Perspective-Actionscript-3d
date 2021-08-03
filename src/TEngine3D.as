class TEngine3D
{
	// Includes
	#include "color.as"
	
	public var Instance, FacesClip, ShadowClip: MovieClip;
	public var Vertices: Array;
	public var Lights: Array;
	public var Faces: Array;

	// Privates
	private var RAD: Number = 0.0174;  // PI / 180
	private var PI: Number = 3.141593; // PI
	private var Camera: TCamera;
	
	// Publics
	public var DrawFaces: Boolean = true;
	public var RemoveLines: Boolean = false;
	public var Wireframe: Boolean = false;
	public var SpecularLights: Boolean = false;
	public var Shading: Boolean = false;
	public var Culling: Boolean = false;
	public var DepthCulling: Boolean = true;
	public var Shadow: Boolean = false;
	public var Scale: Number = 100;
	public var OverrideAlpha: Number = 0;
	
	public var FocalLength: Number = 200;
	public var height: Number;
	public var width: Number;

	// Constructor
	function TEngine3D($instance: MovieClip)
	{	
		// Init some stuff
		_root.ASC_reader = new TASC_reader();
		_root.ASC_reader.OnFinish = ASC_finish;
		
		Camera = new TCamera(0, 0, 1);
		
		Vertices = new Array();
		Lights = new Array();
		Faces = new Array();
		
		// Create the Containerclip
		if (!$instance)
		{
			Instance = _root.createEmptyMovieClip("OBJ_container", 1);
			width  	 = Stage.width;
			height 	 = Stage.height;
			
			Instance._x = this.width / 2;
			Instance._y = this.height / 2;
		}
		else {
			Instance = $instance;
			width	 = Instance._width;
			height	 = Instance._height;
		}
		
		ShadowClip = Instance.createEmptyMovieClip("Shadow", 1);
		FacesClip = Instance.createEmptyMovieClip("Faces", 2);
	}
	
	public function ASC_finish($e: TEngine3D): Void
	{
		var ASC = _root.ASC_reader;
		
		for (var v in ASC.Vertices)
			$e.AddVertex(ASC.Vertices[v].x, ASC.Vertices[v].y, ASC.Vertices[v].z);

		for (var f in Faces)
		{
			var F = Faces[f];
			
			var D;
			var E;
			if (F.d != undefined) D = F.d; else D = -1;
			if (F.e) E = parseInt(F.e); else E = 0xFF0000;
			
			$e.AddFace(new TFace(E, 100, 0), F.a, F.b, F.c, D, true);
		}
	}

	// Function that loops through all the Points of a given shape and rotates them
	public function RotateWorld($xa: Number, $ya: Number, $za: Number, $a: Boolean): Void
	{
		// Alpha
		var cosX = Math.cos($xa * RAD);
		var sinX = Math.sin($xa * RAD);
		
		// Beta
		var cosY = Math.cos($ya * RAD);
		var sinY = Math.sin($ya * RAD);
		
		// Gamma
		var cosZ = Math.cos($za * RAD);
		var sinZ = Math.sin($za * RAD);

		// Loop through all the Vertices
		var i = Vertices.length;
		while(i--)
		{
			// Store data locally
			var Vertex = Vertices[i];
			var x = Vertex.x, y = Vertex.y, z = Vertex.z;
			
			// Rotate around X-axis
			var xy = cosX * y - sinX * z;
			var xz = sinX * y + cosX * z;
			
			// Rotate around Y-axis
			var yz = cosY * xz - sinY * x;
			var yx = sinY * xz + cosY * x;
			
			// Rotate around Z-axis
			var zx = cosZ * yx - sinZ * xy;
			var zy = sinZ * yx + cosZ * xy;

			// Scale distances
			Vertex.rx = (zx / 100) * Scale;
			Vertex.ry = (zy / 100) * Scale;
			Vertex.rz = (yz / 100) * Scale;
			
			// Check for appending rotation to object or only displaying it
			if ($a)
			{
				Vertex.x = zx;
				Vertex.y = zy;
				Vertex.z = yz;
			}
			
			Vertex.to2D(FocalLength);
		}
	}
				
	// Function that renders the entire 3D object
	public function Render(): Void
	{
		// Loop past faces
		var c    = Faces.length;
		if (Shadow) ShadowClip.clear();
		
		while (c--)
		{
			if (DrawFaces)
			{
			// Save Vertices
			var p0 = Vertices[Faces[c].Vertices[0]];
			var p1 = Vertices[Faces[c].Vertices[1]];
			var p2 = Vertices[Faces[c].Vertices[2]];
			var p3 = Vertices[Faces[c].Vertices[3]];
			
			// Save depth
			var Z  = (p0.rz + p1.rz + p2.rz);

			// Copy style (since we are going to mutate it)
			var Style   = Faces[c].Style.Copy();
			var Verts 	= Faces[c].Vertices;
			var Face  	= Faces[c];
			
			// Booleans
			var FacingCam = false;
			var Draw   	  = true;
			
			// Check if this Face if facing the camera
			FacingCam = Face.FaceCulling();
			
			// Remove the linestyle if we aren't suppose to draw lines
			if (RemoveLines) Style.Line = false;
			
			// Reset Style for Wireframe mode
			if (Wireframe) Style = new TStyle(true, 0, 0, 100, false);
			
			// Check if we should draw if we are not facing the camera
			if (Culling and !Wireframe) Draw = FacingCam;	
			
			// Add lightning
			if (Draw and Style.Fill and !Wireframe) 
			{
				// Save current RGB colorvalue
				var RGB = HexToRGB(Style.fill_color);
				var Diffuse = 0;
				var Reflect = 0;

				if (Shading or SpecularLights)
				{
					if (Lights.length > 0)
					{
						for (var L in Lights)
						{
							var Light = Lights[L].Copy();
							var FaceNormal = Face.FindNormal();
							var LightAngle  = Light.DotProduct(FaceNormal) / 100;
							Light.Normalize();
							
							if (Shading)
							{
								var B = Light.Offset + Light.Brightness * Math.max(-LightAngle, 0);
								if (B > 0) Diffuse += B;
							}
					
							if (SpecularLights)
							{
								var Direction  = Light.UnitVector();
								var Reflection = Light.New_SubtractVector(FaceNormal.New_Multiply(LightAngle * 2));
								Reflection.Normalize();
								
								var Specular = Reflection.DotProduct(Direction) * (Light.Specular / 10);
								Reflect = Math.pow(Specular, 2);
							}
						}
						
						if (Shading)
						{
							RGB.r = Math.min(RGB.r * Diffuse, 255);
							RGB.g = Math.min(RGB.g * Diffuse, 255);
							RGB.b = Math.min(RGB.b * Diffuse, 255);
						}
						
						if (SpecularLights)
						{
							RGB.r = Math.min(RGB.r + Reflect, 255);
							RGB.g = Math.min(RGB.g + Reflect, 255);
							RGB.b = Math.min(RGB.b + Reflect, 255);							
						}
					} else
					{
						Diffuse = 1 - CalculateShading(Face);
						
						RGB.r = Math.min(RGB.r * Diffuse, 255);
						RGB.g = Math.min(RGB.g * Diffuse, 255);
						RGB.b = Math.min(RGB.b * Diffuse, 255);
					}
				}
												
				// Save the value in our Style
                Style.fill_color = RGBToHex(RGB);
			}
			
			// If we are drawing shadows
			if (Shadow)
			{
				DrawShadow(Face);
			}
			
			// If we are still drawing
			if (Draw) 
			{
				// Draw the shape in it's clip
				DrawShape(Face.Clip, Style, Face);
				
				// Depth to swap
				var nz = 100000000 - (Z*10) + c;
				
				// if we are DepthCulling make backfaces lower then the rest
				if (!FacingCam and DepthCulling) nz -= 10000;
				
				// Swap the depths of our face
				Face.Clip.swapDepths(nz);
			}
			else Face.Clip.clear();
		}
		updateAfterEvent();
		}
	}
	
	// Function the calculates flat shading
	private function CalculateShading($face: TFace): Number
	{
		// Calculate the normal of our face
		var FaceNormal = $face.FindNormal();
		
		// Calculate the length of our normal
		var NormalLen  = FaceNormal.CalculateNormal();

		// Return the angle (decimal) of our normal
		var F = Math.acos(-FaceNormal.z / NormalLen) / PI;
		return F;
	}
	
	// Function that calculates darkness from lightsources
	private function CalculateSpecLights($face: TFace): Number
	{
		// Find our normal
		var FaceNormal = $face.FindNormal();
		var F = 1 / 5;

		// Loop through all dynamic lights
		for (var l in Lights)
		{
			// Substract the lightvector from the normalvector
			var d1 = FaceNormal.New_SubtractVector(Lights[l]); d1.Normalize();
			
			// 3D distance between facenormal and light
			var r  = FaceNormal.DotProduct(d1);
		
			// if distance greater than 0 add the brightness
			if (r > 0) F += (r / 120) * Lights[l].Brightness;
		}
		
		// return the value
		return F;
	}
					
	// Function that draws a face
	public function DrawShape($MC, $Style, $Shape): Void
	{
		// Clear the content of the clip
		$MC.clear();

		// If we override the alpha value
		if (OverrideAlpha) $Style.fill_alpha = OverrideAlpha;
		
		// If we should draw a line, set the linestyle of the clip
		if ($Style.Line) $MC.lineStyle($Style.line_thick, $Style.line_color, $Style.line_alpha);
		
		// If we should draw a fill, set the fillstyle of the clip
		if ($Style.Fill) $MC.beginFill($Style.fill_color, $Style.fill_alpha);
	
		// Locally store the 4 vertices in 2d space
		var p0 = Vertices[$Shape.Vertices[0]], p0x = p0.sx, p0y = p0.sy;
		var p1 = Vertices[$Shape.Vertices[1]], p1x = p1.sx, p1y = p1.sy;
		var p2 = Vertices[$Shape.Vertices[2]], p2x = p2.sx, p2y = p2.sy;
		var p3 = Vertices[$Shape.Vertices[3]], p3x = p3.sx, p3y = p3.sy;
	
		// Move to the first vertex, and draw the next vertices
		$MC.moveTo(p0x, p0y);
		$MC.lineTo(p1x, p1y);
		$MC.lineTo(p2x, p2y);
		
		// Only draw to the fourth vertex if our Type defines a quad
		if ($Shape.Type) $MC.lineTo(p3x, p3y);
		
		// Draw back to the first vertex
		$MC.lineTo(p0x, p0y);

		// End fillstyle
		if ($Style.Fill) $MC.endFill();
	}
	
	// Function that draws a shadow
	public function DrawShadow($face): Void
	{
		
			var p0 = Vertices[$face.Vertices[0]];
			var p1 = Vertices[$face.Vertices[1]];
			var p2 = Vertices[$face.Vertices[2]];
			var p3 = Vertices[$face.Vertices[3]];
		
			ShadowClip.beginFill(0xAAAAAA, 50);
			
			var k1 = 200 / (200 + p0.rz);
			var k2 = 200 / (200 + p1.rz);
			var k3 = 200 / (200 + p2.rz);
			var k4 = 200 / (200 + p3.rz);
			ShadowClip.moveTo(p0.rx * k1, 120 * k1);
			ShadowClip.lineTo(p1.rx * k2, 120 * k2);
			ShadowClip.lineTo(p2.rx * k3, 120 * k3);
			if ($face.Type) ShadowClip.lineTo(p3.rx * k4, 120 * k4);
			ShadowClip.lineTo(p0.rx * k1, 120 * k1);
	}

	// Function that adds a vertex to our engine
	public function AddVertex($x, $y, $z: Number): Number
	{
		// Push the coordinates into the Vertices array
		var ID = Vertices.push(new TVertex($x, $y, $z));
		
		// Return the index that the vertex has been given
		return ID - 1;
	}
	
	// Function that adds a face to our engine
	public function AddFace($face: TFace, $p1, $p2, $p3, $p4: Number, $rev: Boolean)
	{		
		// Copy the facestyle
		$face = $face.Copy();
		
		// Push the face into the Faces array
		var ID = Faces.push($face) - 1;

		// Create a new clip to draw in
		$face.Clip = FacesClip.createEmptyMovieClip("face" + ID, ID);
		
		// Save the vertices inside the face
		$face.Vertices = [$p1, $p2, $p3, $p4];
		
		// Define the engine
		$face.Engine = this;
		
		// if we specified a fourth vertex, we are a quad
		if ($p4 != undefined and $p4 >= 0) $face.Type = 1;
		
		// if we specified reversing the face, do so
		if ($rev) $face.Reverse();

		// Return the face index
		return ID;
	}
	
	public function LoadFile($t: String): Void
	{
		_root.ASC_reader.load($t, this);
	}
	
	// Function that adds a light to our engine
	public function AddLight($light: TLightSource): Void
	{
		// Push light into the Light array
		Lights.push($light);
	}
	
	// Function clear all data
	public function clear(): Void
	{
		// Empty the arrays
		removeMovieClip(FacesClip);
		FacesClip = Instance.createEmptyMovieClip("Faces", 2);
		Vertices = new Array();
		Faces = new Array();
	}
}