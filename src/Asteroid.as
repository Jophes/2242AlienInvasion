package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class Asteroid extends Sprite
	{
		// Collect the meteor images and embed them into private static constants
		[Embed(source = "../Assets/Meteors/meteorBrown_big1.png")] private static const asteroidBrownBig1Class:Class;
		[Embed(source = "../Assets/Meteors/meteorBrown_big2.png")] private static const asteroidBrownBig2Class:Class;
		[Embed(source = "../Assets/Meteors/meteorBrown_big3.png")] private static const asteroidBrownBig3Class:Class;
		[Embed(source = "../Assets/Meteors/meteorBrown_big4.png")] private static const asteroidBrownBig4Class:Class;
		
		[Embed(source = "../Assets/Meteors/meteorBrown_med1.png")] private static const asteroidBrownMed1Class:Class;
		[Embed(source = "../Assets/Meteors/meteorBrown_med2.png")] private static const asteroidBrownMed2Class:Class;
		
		[Embed(source = "../Assets/Meteors/meteorBrown_small1.png")] private static const asteroidBrownSmall1Class:Class;
		[Embed(source = "../Assets/Meteors/meteorBrown_small2.png")] private static const asteroidBrownSmall2Class:Class;
		
		[Embed(source = "../Assets/Meteors/meteorBrown_tiny1.png")] private static const asteroidBrownTiny1Class:Class;
		[Embed(source = "../Assets/Meteors/meteorBrown_tiny2.png")] private static const asteroidBrownTiny2Class:Class;
		
		[Embed(source = "../Assets/Meteors/meteorGrey_big1.png")] private static const asteroidGreyBig1Class:Class;
		[Embed(source = "../Assets/Meteors/meteorGrey_big2.png")] private static const asteroidGreyBig2Class:Class;
		[Embed(source = "../Assets/Meteors/meteorGrey_big3.png")] private static const asteroidGreyBig3Class:Class;
		[Embed(source = "../Assets/Meteors/meteorGrey_big4.png")] private static const asteroidGreyBig4Class:Class;
		
		[Embed(source = "../Assets/Meteors/meteorGrey_med1.png")] private static const asteroidGreyMed1Class:Class;
		[Embed(source = "../Assets/Meteors/meteorGrey_med2.png")] private static const asteroidGreyMed2Class:Class;
		
		[Embed(source = "../Assets/Meteors/meteorGrey_small1.png")] private static const asteroidGreySmall1Class:Class;
		[Embed(source = "../Assets/Meteors/meteorGrey_small2.png")] private static const asteroidGreySmall2Class:Class;
		
		[Embed(source = "../Assets/Meteors/meteorGrey_tiny1.png")] private static const asteroidGreyTiny1Class:Class;
		[Embed(source = "../Assets/Meteors/meteorGrey_tiny2.png")] private static const asteroidGreyTiny2Class:Class;
		
		// Place the classes into one array for ease of use
		private static const asteroidClasses:Array = new Array(
			new Array(
				new Array(asteroidBrownBig1Class, asteroidBrownBig2Class, asteroidBrownBig3Class, asteroidBrownBig4Class),
				new Array(asteroidBrownMed1Class, asteroidBrownMed2Class),
				new Array(asteroidBrownSmall1Class, asteroidBrownSmall2Class),
				new Array(asteroidBrownTiny1Class, asteroidBrownTiny2Class)
			),
			new Array(
				new Array(asteroidGreyBig1Class, asteroidGreyBig2Class, asteroidGreyBig3Class, asteroidGreyBig4Class),
				new Array(asteroidGreyMed1Class, asteroidGreyMed2Class),
				new Array(asteroidGreySmall1Class, asteroidGreySmall2Class),
				new Array(asteroidGreyTiny1Class, asteroidGreyTiny2Class)
			)
		);
		
		public var asteroidCol:uint;
		public var asteroidSize:uint;
		public var asteroidType:uint;
		
		private var asteroidBitmap:Bitmap;
		
		// Create the constructor for the asteroid class
		public function Asteroid(_col:uint, _size:uint, _type:uint) 
		{
			asteroidCol = _col;
			asteroidSize = _size;
			asteroidType = _type;
			asteroidBitmap = new asteroidClasses[asteroidCol][asteroidSize][asteroidType];
			addChild(asteroidBitmap);
		}
	}
}