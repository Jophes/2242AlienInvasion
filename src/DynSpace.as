package 
{
	import flash.utils.*;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class DynSpace extends Sprite
	{
		[Embed(source = "../Assets/Effects/star1.png")]
		public static const star1:Class;
		[Embed(source = "../Assets/Effects/star2.png")]
		public static const star2:Class;
		[Embed(source = "../Assets/Effects/star3.png")]
		public static const star3:Class;
		public static var starObjs:Array = new Array(star1, star2, star3);
		
		private var stars:Array;
		private var starTickIntervalId:uint;
		private var worldScrollIntervalId:uint;
		private var scrollVarIntervalId:uint;
		private const worldScrollMaxIncrement:Number = 3;
		private var worldScrollIncrement:Number = 0;
		private var starsPerUnit:Number = 0.1;
		private var worldHeight:Number = Main.dimensions.y;
		private var starTimerIncrement:Number = Math.PI * 0.01 * 1/*2x mult for half interval speed*/;
		
		public function DynSpace() 
		{
			// Create the background with a preset colour and populate it with random stars
			graphics.beginFill(0x0F0F1F, 1);
			graphics.drawRect(0, 0, Main.dimensions.x, Main.dimensions.y);
			graphics.endFill();
			stars = new Array();
			for (var i:int = 0; i < starsPerUnit*worldHeight; i++) 
			{
				var starInSpace:Star = new Star((uint)(Math.random() * starObjs.length), 12.5 + Math.random() * (Main.dimensions.x - 25), Main.dimensions.y - 12 - Math.random() * (worldHeight-24));
				addChild(starInSpace);
				stars.push(starInSpace);
			}
			//starTickIntervalId = setInterval(starTick, 20);
			worldScrollIncrement = worldScrollMaxIncrement;
		}
		
		/*public function startWorldScroll():void
		{
			worldScrollIntervalId = setInterval(worldAutoScroll, 20);
		}
		
		public function stopWorldScroll():void
		{
			clearInterval(worldScrollIntervalId);
		}*/
		
		// Change the system to support input from the level selector for the drag and drop functionality 
		public function setupForLevelSelector(_worldHeight:Number):void
		{
			var additionalHeight:uint = _worldHeight - worldHeight;
			for (var i:int = 0; i < starsPerUnit*additionalHeight; i++) 
			{
				var starInSpace:Star = new Star((uint)(Math.random() * starObjs.length), 12.5 + Math.random() * (Main.dimensions.x - 25), -12 -Math.random() * additionalHeight);
				addChild(starInSpace);
				stars.push(starInSpace);
			}
			worldHeight = _worldHeight;
		}
		
		// Remove all the screens that are currently off the screen
		public function purgeOffScreenStars():void
		{
			var starsToBeRemoved:Array = new Array;
			for each (var star:Star in stars) 
				if (star.y > (Main.dimensions.y - 12) || star.y < 12)
				{
					starsToBeRemoved.push(star);
					removeChild(star);
				}
			stars = removeItemsFromArray(stars, starsToBeRemoved);
			worldHeight = Main.dimensions.y;
			if (stars.length < starsPerUnit * worldHeight)
			{
				var starsMissing:int = starsPerUnit * worldHeight - stars.length;
				var yRangeAboveTop:Number = (Main.dimensions.y / (Main.dimensions.y * starsPerUnit)) * starsMissing;
				for (var i:int = 0; i < starsMissing; i++) 
				{
					var starInSpace:Star = new Star((uint)(Math.random() * starObjs.length), 12.5 + Math.random() * (Main.dimensions.x - 25), -12 - Math.random() * yRangeAboveTop);
					addChild(starInSpace);
					stars.push(starInSpace);
					starInSpace.generateValues();
				}
			}
		}
		
		public function removeItemsFromArray(arrayOfItems:Array, itemsToBeRemoved:Array):Array
		{
			var tmpArrayOfItems:Array = new Array();
			for each (var itemInArray:Object in arrayOfItems) 
			{
				var isItemInRemovedArray:Boolean = false;
				for each (var itemToBeRemoved:Object in itemsToBeRemoved) 
					if (itemInArray == itemToBeRemoved)
					{
						isItemInRemovedArray = true;
						break;
					}
				if (isItemInRemovedArray == false)
					tmpArrayOfItems.push(itemInArray);
			}
			return tmpArrayOfItems;
		}
		
		public function starTick():void
		{
			for each (var starInSpace:Star in stars) 
			{
				starInSpace.timer += (starInSpace.timer < Main.PI2) ? starTimerIncrement : -starInSpace.timer;
				starInSpace.updateStar();
			}
		}
		
		public function worldScrollIn(_incrementValue:Number):void
		{
			for each (var starInSpace:Star in stars) 
			{
				starInSpace.y += _incrementValue;
			}
		}
		
		public function worldAutoScroll():void
		{
			var tooManyStars:Boolean = starsPerUnit * worldHeight < stars.length;
			var starsToBeRemoved:Array = new Array();
			for each (var starInSpace:Star in stars) 
			{
				starInSpace.y += worldScrollIncrement * starInSpace.incrementMult * 2/*2x mult for half interval speed*/;
				if (starInSpace.y > (Main.dimensions.y + 12))
					if (tooManyStars)
						starsToBeRemoved.push(starInSpace);
					else
					{
						starInSpace.x = 12.5 + Math.random() * (Main.dimensions.x - 25);
						starInSpace.y = -12 - Math.random() * worldScrollIncrement;
						starInSpace.generateValues();
					}
			}
			if (tooManyStars)
				stars = removeItemsFromArray(stars, starsToBeRemoved);
			
			if (worldScrollIncrement < worldScrollMaxIncrement * 0.98)
				worldScrollIncrement = Main.lerp(worldScrollIncrement, worldScrollMaxIncrement, 0.01);
		}
	}
}