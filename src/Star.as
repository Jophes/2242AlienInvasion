package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class Star extends Sprite
	{
		public var starType:uint;
		public var starBitmap:Bitmap;
		public var upper:Number;
		public var difference:Number;
		public var lower:Number;
		public var timer:Number;
		public var incrementMult:Number;
		public var distanceFromOriginal:Number;
		
		public function Star(_starType:uint,_posX:Number = 0,_posY:Number = 0) 
		{
			starType = _starType;
			starBitmap = new DynSpace.starObjs[_starType];
			starBitmap.x = -12.5; starBitmap.y = -12;
			addChild(starBitmap);
			
			generateValues();
			
			x = _posX;
			y = _posY;
		}
		
		public function generateValues():void
		{
			incrementMult = 0.6 + Math.random() * 0.6;
			lower = 30 + Math.random() * 20;
			upper = 100 - Math.random() * 20;
			difference = upper - lower;
			timer = Math.random() * Main.PI2;
			updateStar();
		}
		
		public function updateStar():void
		{
			//var tmpTimer:Number = (lower + difference * 0.01 * ((timer <= 100) ? timer : (200 - timer))) * 0.01;
			var tmpTimer:Number = (lower + difference * 0.01 * (1 + Math.cos(timer)) * 50) * 0.01;
			scaleX = 0.5 * tmpTimer + Main.starTypeOffsets[starType];
			scaleY = scaleX;
			starBitmap.transform.colorTransform = new ColorTransform(1, 1, 1, tmpTimer);
		}
	}
}