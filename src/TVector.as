class TVector
{
	public var x, y, z: Number;
	
	function TVector($x: Number, $y: Number, $z: Number)
	{
		// Handle parameters
		x = $x;
		y = $y;
		z = $z;
	}

	function Copy(): TVector
	{
		return new TVector(x, y, z);
	}
	
	function toString(): String
	{
		return "{x: "+x+",y: "+y+",z: "+z+"}";
	}

	function CalculateNormal(): Number
	{
		var m = Math.sqrt(x * x + y * y + z * z);
		return m;
	}
	
	function DotProduct($v: TVector): Number
	{
		var d = x * $v.x + y * $v.y + z * $v.z;
		return d;
    }
	
	function CrossProduct($v: TVector): Number
    {
		var v = new TVector(0,0,0);
		v.x = y * $v.z - z * $v.y;
		v.y = z * $v.x - x * $v.z;
		v.z = x * $v.y - y * $v.x;
		return(v);
	}
	
	function UnitVector(): TVector
	{
		var unit = new TVector(x, y, z);
		var norm = CalculateNormal();
		unit.x = unit.x / norm;
		unit.y = unit.y / norm;
		unit.z = unit.z / norm;
		return(unit);
	}
    
	function Normalize(): Void
	{
		var norm = CalculateNormal();
		x = x / norm;
		y = y / norm;
		z = z / norm;
	}
	
	function AddVector($v: TVector): Void
	{
		x += $v.x;
		y += $v.y;
		z += $v.z;
	}
	
	function New_AddVector($v: TVector): TVector
	{
		var v = new TVector(0,0,0);
		v.x = x + $v.x;
		v.y = y + $v.y;
		v.z = z + $v.z;
		
		return v;
	}
	
	function SubtractVector($v: TVector): Void
	{
		x -= $v.x;
		y -= $v.y;
		z -= $v.z;
	}

	function New_SubtractVector($v: TVector): TVector
	{
		var v = new TVector(0,0,0);
		v.x = x - $v.x;
		v.y = y - $v.y;
		v.z = z - $v.z;
		
		return v;
	}
	
	function Multiply($v: Number): Void
	{
		x *= $v;
		y *= $v;
		z *= $v;
	}
	
	function New_Multiply($v: Number): TVector
	{
		var v = new TVector(0,0,0);
		v.x = x * $v;
		v.y = y * $v;
		v.z = z * $v;
		
		return v;
	}
	
}