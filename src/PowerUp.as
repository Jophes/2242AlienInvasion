package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class PowerUp extends Sprite	
	{
		[Embed(source = "../Assets/Power-ups/shield_gold.png")] private static const shieldClass:Class; // shield
		[Embed(source = "../Assets/Power-ups/pill_red.png")] private static const redPillClass:Class; // hp up
		[Embed(source = "../Assets/Power-ups/bolt_gold.png")] private static const superClass:Class; // super speed + weps
		private static const powerUpClasses:Array = new Array(shieldClass, redPillClass, superClass);
		private static const powerUpOffsets:Array = new Array(new Vec2( -15, -15), new Vec2( -11, -10.5), new Vec2( -9.5, -15));
		
		public var powerUpId:uint;
		private var powerUpBitmap:Bitmap;
		
		public function PowerUp(_powerUpId:uint) 
		{
			if (_powerUpId >= powerUpClasses.length)
				trace("Power up id is invalid");
			powerUpId = _powerUpId;
			powerUpBitmap = new powerUpClasses[powerUpId];
			powerUpBitmap.x = powerUpOffsets[powerUpId].x; 
			powerUpBitmap.y = powerUpOffsets[powerUpId].y;
			addChild(powerUpBitmap);
		}
		
	}

}