package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class Projectile extends Sprite
	{
		// Embed laser bitmaps
		[Embed(source = "../Assets/Lasers/laserBlue01.png")] private static const laserBlue1:Class;
		[Embed(source = "../Assets/Lasers/laserGreen01.png")] private static const laserGreen1:Class;
		[Embed(source="../Assets/Lasers/laserRed01.png")] private static const laserRed1:Class;
		// Put all laser Classes into an array for ease of use
		private static const lasers:Array = new Array(laserBlue1, laserGreen1, laserRed1);
		
		private var laserBitmap:Bitmap;
		private var direction:Vec2;
		private var velocity:Number;
		private var distance:Number;
		private var maxDistance:Number;
		private var scaleMult:Number;
		public var plyProjectile:Boolean;
		public var projDamage:uint;
		public var laserCol:uint;
		
		public function Projectile(_projDmg:int = 1, _laserCol:uint = 0, _direction:Vec2 = null, _velocity:Number = 0, _maxDistance:Number = 0, _plyProj:Boolean = false) 
		{
			laserCol = _laserCol;
			projDamage = _projDmg;
			plyProjectile = _plyProj;
			
			laserBitmap = new lasers[_laserCol];
			laserBitmap.x = -4.5; laserBitmap.y = -3;
			addChild(laserBitmap);
			
			distance = 0;
			direction = _direction == null ? new Vec2() : _direction;
			velocity = _velocity;
			maxDistance = _maxDistance;
			scaleMult = maxDistance == 0 ? 0 : (1 / maxDistance);
			rotation = direction.toAngleDeg();
		}
		
		public function projectileTick():void
		{
			x += direction.x * velocity;
			y += direction.y * velocity;
			distance += direction.magnitude() * velocity;
			scaleX = 1 - distance * scaleMult;
			scaleY = scaleX;
		}
	}

}