function HexToRGB($hex: Number): Object
{
	var RGB: Object;
	var R: Number;
	var G: Number;
	var B: Number;
	
	R = $hex >> 16;
	G = $hex >> 8 ^ R << 8;
	B = $hex ^ (R << 16 | G << 8);
	
	RGB = 
	{
		r: R, 
		g: G, 
		b: B
	};
	
	return RGB;
}


function RGBToHex($RGB: Object): Number
{
	return $RGB.r << 16 | $RGB.g << 8 | $RGB.b;
}

function HexAddBrightness($color: Number, $brightness: Number): Number
{
	var RGB: Object;
	var alpha: Number;
	
	if ($brightness > 255) $brightness = 255;
	
	RGB   	= HexToRGB($color);
	alpha 	= $brightness / 100;
	
	if ($brightness > 0)  
	{
		RGB.r += Math.floor((255 - RGB.r) * alpha);
		RGB.g += Math.floor((255 - RGB.g) * alpha);
		RGB.b += Math.floor((255 - RGB.b) * alpha);
	}
	else if ($brightness < 0) 
	{
		RGB.r -= Math.floor(-RGB.r * alpha);
		RGB.g -= Math.floor(-RGB.g * alpha);
		RGB.b -= Math.floor(-RGB.b * alpha);
	}

	return RGBToHex(RGB);
};