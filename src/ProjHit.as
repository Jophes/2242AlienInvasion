package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class ProjHit extends Sprite
	{
		[Embed(source = "../Assets/Lasers/laserBlue08.png")] private static const laserBlue1:Class;
		[Embed(source = "../Assets/Lasers/laserBlue09.png")] private static const laserBlue2:Class;
		[Embed(source = "../Assets/Lasers/laserBlue10.png")] private static const laserBlue3:Class;
		[Embed(source = "../Assets/Lasers/laserBlue11.png")] private static const laserBlue4:Class;
		
		[Embed(source = "../Assets/Lasers/laserGreen08.png")] private static const laserGreen1:Class;
		[Embed(source = "../Assets/Lasers/laserGreen09.png")] private static const laserGreen2:Class;
		[Embed(source = "../Assets/Lasers/laserGreen10.png")] private static const laserGreen3:Class;
		[Embed(source = "../Assets/Lasers/laserGreen11.png")] private static const laserGreen4:Class;
		
		[Embed(source = "../Assets/Lasers/laserRed08.png")] private static const laserRed1:Class;
		[Embed(source = "../Assets/Lasers/laserRed09.png")] private static const laserRed2:Class;
		[Embed(source = "../Assets/Lasers/laserRed10.png")] private static const laserRed3:Class;
		[Embed(source = "../Assets/Lasers/laserRed11.png")] private static const laserRed4:Class;
		
		public static const laserClasses:Array = new Array( new Array(laserBlue1, laserBlue2, laserBlue3, laserBlue4), new Array(laserGreen1, laserGreen2, laserGreen3, laserGreen4), new Array(laserRed1, laserRed2, laserRed3, laserRed4));
		
		public var laserCol:uint;
		public var laserType:uint;
		public var active:Boolean = true;
		
		private var timer:uint;
		private var maxTimer:uint;
		private var projHit:Bitmap;
		
		public function ProjHit(_laserCol:uint, _laserType:uint, _maxtimer:uint) 
		{ // 1&2 48x46  3&4 38*38
			laserCol = _laserCol;
			laserType = _laserType;
			timer = 0;
			maxTimer = _maxtimer;
			
			projHit = new ProjHit.laserClasses[laserCol][laserType];
			addChild(projHit);
			var offset:Vec2 = new Vec2();
			if (laserType <= 1)
				offset = new Vec2( -24, 23);
			else if (laserType <= 3)
				offset = new Vec2( -19, -19);
			projHit.x = offset.x; projHit.y = offset.y;
			projTick();
		}
		
		public function projTick():void
		{
			if (active)
			{
				timer += 1;
				scaleX = 1.25 - timer * 0.1;
				scaleY = scaleX;
				projHit.transform.colorTransform = new ColorTransform(1, 1, 1, 1 - timer * 0.1);
				if (timer >= maxTimer)
					active = false;
			}
		}
	}

}