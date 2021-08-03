class TColor
{
	public var R, G, B: Number;
	
	public function TColor($c: Number)
	{
		if ($c != undefined) setHex($c);
	}
	
	public function setHex($hex: Number): Void
	{
		R = $hex >> 16;
		G = $hex >> 8 ^ R << 8;
		B = $hex ^ (R << 16 | G << 8);
	}
	
	public function getHex(): Number
	{
		return R << 16 | G << 8 | B;
	}
	
	public function Truncate(): Void
	{
		R = Math.min(R, 255);
		G = Math.min(G, 255);
		B = Math.min(B, 255);
	}
	
	public function addValue($v: Number)
	{
		R += $v;
		G += $v;
		B += $v;
		
		Truncate();
	}
	
	public function mulValue($v: Number)
	{
		R = R * $v;
		G = G * $v;
		B = B * $v;
		
		Truncate();
	}
}