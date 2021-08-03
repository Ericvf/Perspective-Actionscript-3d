class TLightSource extends TVector
{
	public var Brightness: Number;
	public var Specular: Number;
	public var Offset: Number;
	
	
	function TLightSource($x: Number, $y: Number, $z: Number, $brightness: Number, $offset: Number, $specular: Number)
	{
		super($x, $y, $z);
		
		Brightness = $brightness - $offset;
		Specular = $specular;
		Offset = $offset;
	}
	
	function Copy(): TLightSource
	{
		return new TLightSource(x, y, z, Brightness + Offset, Offset, Specular);
	}
}