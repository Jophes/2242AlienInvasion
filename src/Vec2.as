package 
{
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class Vec2 
	{
		public var x:Number;
		public var y:Number;
		public function Vec2(_x:Number = 0 , _y:Number = 0) 
		{
			x = _x; y = _y;
		}
		
		public function magnitude(_origin:Vec2 = null):Number
		{
			if (!_origin) { _origin = new Vec2(); };
			return Math.sqrt(Math.pow((x - _origin.x),2) + Math.pow((y - _origin.y),2));
		}
		
		public function normalise(_origin:Vec2 = null):Vec2
		{
			if (!_origin) { _origin = new Vec2(); };
			var mag:Number = magnitude(_origin);
			if (mag != 0)
				return new Vec2((x - _origin.x) / mag, (y - _origin.y) / mag);
			else
				return new Vec2();
		}
		
		public function toAngle(_origin:Vec2 = null):Number
		{
			if (!_origin) { _origin = new Vec2(); };
			var angle:Number = Math.atan2(x - _origin.x, _origin.y - y);
			if (angle < 0){angle += Math.PI*2;}
			return angle;
		}
		
		public function toAngleDeg(_origin:Vec2 = null):Number
		{
			if (!_origin) { _origin = new Vec2(); };
			var angle:Number = (Math.atan2(x - _origin.x, _origin.y - y) / Math.PI) * 180;
			if (angle < 0){angle += 360;}
			return angle;
		}
		
		public function normal():Vec2
		{
			return new Vec2(y, x);
		}
		
		public function lerpVec(targetValue:Vec2, fraction:Number):Vec2
		{
			return new Vec2(Main.lerp(x, targetValue.x, fraction), Main.lerp(y, targetValue.y, fraction));
		}
	}
}