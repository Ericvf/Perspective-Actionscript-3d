class TStyle
{
	public var fill_color: Number = 0x000000;
	public var fill_alpha: Number = 100;
	public var line_thick: Number = 1;
	public var line_color: Number = 0x000000;
	public var line_alpha: Number = 100;
	public var Line: Boolean;
	public var Fill: Boolean;
	
	function TStyle($dl, $lt, $lc, $la, $df, $fc, $fa: Number)
	{
		// Line
		if ($dl)
		{
			if ($lt != undefined) line_thick = $lt;
			if ($lc != undefined) line_color = $lc;
			if ($la != undefined) line_alpha = $la;
			Line = true;
		}
		
		// Fill
		if ($df)
		{
			if ($fc != undefined) fill_color = $fc;
			if ($fa != undefined) fill_alpha = $fa;
			Fill = true;
		}
	}
	
	public function Copy(): TStyle
	{
		return new TStyle(Line, line_thick, line_color, line_alpha, Fill, fill_color, fill_alpha);
	}
}