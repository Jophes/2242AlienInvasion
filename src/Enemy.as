package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Enemy extends Sprite
	{
		[Embed(source = "../Assets/Enemies/enemyBlack1.png")] private static const enemyBlack1Class:Class;
		[Embed(source = "../Assets/Enemies/enemyBlack2.png")] private static const enemyBlack2Class:Class;
		[Embed(source = "../Assets/Enemies/enemyBlack3.png")] private static const enemyBlack3Class:Class;
		[Embed(source = "../Assets/Enemies/enemyBlack4.png")] private static const enemyBlack4Class:Class;
		[Embed(source = "../Assets/Enemies/enemyBlack5.png")] private static const enemyBlack5Class:Class;
		
		[Embed(source = "../Assets/Enemies/enemyBlue1.png")] private static const enemyBlue1Class:Class;
		[Embed(source = "../Assets/Enemies/enemyBlue2.png")] private static const enemyBlue2Class:Class;
		[Embed(source = "../Assets/Enemies/enemyBlue3.png")] private static const enemyBlue3Class:Class;
		[Embed(source = "../Assets/Enemies/enemyBlue4.png")] private static const enemyBlue4Class:Class;
		[Embed(source = "../Assets/Enemies/enemyBlue5.png")] private static const enemyBlue5Class:Class;
		
		[Embed(source = "../Assets/Enemies/enemyGreen1.png")] private static const enemyGreen1Class:Class;
		[Embed(source = "../Assets/Enemies/enemyGreen2.png")] private static const enemyGreen2Class:Class;
		[Embed(source = "../Assets/Enemies/enemyGreen3.png")] private static const enemyGreen3Class:Class;
		[Embed(source = "../Assets/Enemies/enemyGreen4.png")] private static const enemyGreen4Class:Class;
		[Embed(source = "../Assets/Enemies/enemyGreen5.png")] private static const enemyGreen5Class:Class;
		
		[Embed(source = "../Assets/Enemies/enemyRed1.png")] private static const enemyRed1Class:Class;
		[Embed(source = "../Assets/Enemies/enemyRed2.png")] private static const enemyRed2Class:Class;
		[Embed(source = "../Assets/Enemies/enemyRed3.png")] private static const enemyRed3Class:Class;
		[Embed(source = "../Assets/Enemies/enemyRed4.png")] private static const enemyRed4Class:Class;
		[Embed(source = "../Assets/Enemies/enemyRed5.png")] private static const enemyRed5Class:Class;
		
		[Embed(source = "../Assets/Enemies/boss1.png")] private static const enemyBoss1Class:Class;
		[Embed(source = "../Assets/Enemies/boss2.png")] private static const enemyBoss2Class:Class;
		[Embed(source = "../Assets/Enemies/boss3.png")] private static const enemyBoss3Class:Class;
		[Embed(source = "../Assets/Enemies/boss4.png")] private static const enemyBoss4Class:Class;
		
		private static const enemyClasses:Array = new Array ( new Array ( enemyBlack1Class, enemyBlack2Class, enemyBlack3Class, enemyBlack4Class, enemyBlack5Class ),
															new Array ( enemyBlue1Class, enemyBlue2Class, enemyBlue3Class, enemyBlue4Class, enemyBlue5Class),
															new Array ( enemyGreen1Class, enemyGreen2Class, enemyGreen3Class, enemyGreen4Class, enemyGreen5Class),
															new Array ( enemyRed1Class, enemyRed2Class, enemyRed3Class, enemyRed4Class, enemyRed5Class));
		private static const enemySizes:Array = new Array ( 46.5, 52, 51.5, 41, 46.5, 253.5, 236, 249, 260);
		private static const enemyTimes:Array = new Array ( 270, 385, 450, 990, 220, -1, -1, -1, -1 );
		private static const enemyFireDelay:Array = new Array ( 10, 12, 10, 30, 15, 12, 15, 12.5, 10 );
		private static const enemyFireSpeed:Array = new Array ( 15, 12.5, 20, 15, 13, 15, 10, 12.5, 15 );
		private static const enemyFireCol:Array = new Array( 1, 2, 2, 2, 1, 2, 2, 1, 1 );
		private static const enemyFireDamage:Array = new Array( 2, 5, 1, 15, 10, 10, 15, 15, 25 );
		public static var scoreReturns:Array = new Array(100, 150, 125, 175, 250, 2000, 5000, 13000, 100000);
		private static var enemyHealthStat:Array = new Array( 20, 35, 15, 40, 10, 750, 1500, 3000, 6000 );
		private static var enemyMovementFuncs:Array = new Array( 
			function (_movementTimer:Number):Vec2
			{
				var tmpPos:Vec2; var tmpTimer:Number;
				if (_movementTimer < 90)
				{
					tmpTimer = Math.PI * (_movementTimer / 180);
					tmpPos = new Vec2(-52 - Math.cos(Math.PI*0.5+tmpTimer) * 820, 720 - 360 + Math.sin(Math.PI*0.5+tmpTimer) * 256);
				}
				else if (_movementTimer >= 90 && _movementTimer < 180)
				{
					tmpTimer = Math.PI * ((_movementTimer - 90) / 90);
					tmpPos = new Vec2(384 + 256 + Math.cos(tmpTimer) * 128, 720 - 360 - Math.sin(tmpTimer) * 128);
				}
				else if (_movementTimer >= 180)
				{
					tmpTimer = Math.PI * ((_movementTimer - 180) / 180);
					tmpPos = new Vec2(1332 - Math.cos(tmpTimer) * 820, 720 - 360 + Math.sin(tmpTimer) * 256);
				}
				return tmpPos;
			},
			function (_movementTimer:Number):Vec2
			{
				var tmpPos:Vec2 = new Vec2(0,0); var tmpTimer:Number;
				if (_movementTimer < 32)
				{
					tmpPos = new Vec2(128, _movementTimer*8);
				}
				else if (_movementTimer >= 32 && _movementTimer < 144.5)
				{
					tmpTimer = Math.PI * ((_movementTimer - 54.5) / 45);
					tmpPos = new Vec2(256 + Math.sin(tmpTimer) * 128, 256 + Math.cos(tmpTimer) * 128);
				}
				else if (_movementTimer >= 144.5 && _movementTimer < 240.5)
				{
					tmpTimer = (_movementTimer - 144.5);
					tmpPos = new Vec2(256 + tmpTimer * 8, 384);
				}
				else if (_movementTimer >= 240.5 && _movementTimer < 353)
				{
					tmpTimer = Math.PI * ((_movementTimer - 240.5) / 45);
					tmpPos = new Vec2(1024 + Math.sin(tmpTimer) * 128, 256 + Math.cos(tmpTimer) * 128);
				}
				else if (_movementTimer >= 353)
				{
					tmpTimer = (_movementTimer - 353);
					tmpPos = new Vec2(1152, 256-tmpTimer*8);
				}
				return tmpPos;
			},
			function (_movementTimer:Number):Vec2
			{
				var tmpTimer:Number = Math.PI * (_movementTimer / 90); var tmpPos:Vec2 = new Vec2();
				for (var i:int = 1; i < 7; i++)
					if (tmpTimer >= Math.PI*(i-1) && tmpTimer < Math.PI * i)
						tmpPos = new Vec2(256 + Math.sin(tmpTimer) * 128, 128 * (i-1) - Math.cos(tmpTimer) * 128 * (i%2 + 1));
				return tmpPos;
			},
			function (_movementTimer:Number):Vec2
			{
				var tmpTimer:Number = Math.PI * (_movementTimer / 90); var tmpPos:Vec2 = new Vec2();
				for (var i:int = 1; i < 20; i++)
					if (tmpTimer >= Math.PI*(i-1) && tmpTimer < Math.PI * i)
						tmpPos = new Vec2(128 * (i-1) - Math.cos(tmpTimer) * 128 * (i%2 + 1), 360 + Math.sin(tmpTimer) * 128);
				return tmpPos;
			},
			function (_movementTimer:Number):Vec2
			{
				
				var angleToPlayerFromCentre:Number = (new Vec2(Player.plyObj.x, Player.plyObj.y)).toAngle(new Vec2(640 , 360));
				var tmpPos:Vec2 = new Vec2(640 + Math.sin(angleToPlayerFromCentre) * 700, 360 - Math.cos(angleToPlayerFromCentre) * 700);
				return tmpPos;
			},
			function (_movementTimer:Number):Vec2
			{
				return new Vec2(640 + Math.sin((_movementTimer / 180)*Math.PI)*256, -50);
			},
			function (_movementTimer:Number):Vec2
			{
				return new Vec2(640, -50);
			},
			function (_movementTimer:Number):Vec2
			{
				return new Vec2(640 + Math.sin((_movementTimer / 180)*Math.PI)*256, -50);
			},
			function (_movementTimer:Number):Vec2
			{
				return new Vec2(640, -200);
			}
			);
		
		private var enemyBitmap:Bitmap;
		public var enemyType:uint;
		private var movementSpeed:Number = 5;
		private var curFireInterval:Number = 0;
		private var movementTimer:Number = 0;
		private var maxMoveTimer:uint = 0;
		private var movementFunction:Function;
		private var fireLeftSide:Boolean = false;
		private var fireOffset:Vec2 = new Vec2(12, -12);
		private var fireDirection:Vec2 = new Vec2(0, 1);
		public var powerUpDropId:int;
		private var reverse:Boolean = false;
		public var enemyHealth:int;
		public var active:Boolean = false;
		public var healthBar:HealthBar;
		
		public function Enemy(_enemyColour:uint = 0, _enemyType:uint = 0, _reverse:Boolean = false, _powerUpDropId:int = -1) 
		{
			reverse = _reverse;
			enemyHealth = enemyHealthStat[_enemyType];
			enemyType = _enemyType;
			powerUpDropId = _powerUpDropId;
			if (enemyType <= 4)
			{
				enemyBitmap = new enemyClasses[_enemyColour][_enemyType];
				enemyBitmap.y = -42;
			}
			switch (enemyType) 
			{
				case 5:
					enemyBitmap = new enemyBoss1Class();
					break;
				case 6:
					enemyBitmap = new enemyBoss2Class();
					break;
				case 7:
					enemyBitmap = new enemyBoss3Class();
					break;
				case 8:
					enemyBitmap = new enemyBoss4Class();
					break;
			}
			enemyBitmap.x = -enemySizes[_enemyType];
			if (!reverse)
				maxMoveTimer = enemyTimes[_enemyType];
			else
			{
				movementTimer = enemyTimes[_enemyType];
				maxMoveTimer = 0;
			}
			movementFunction = enemyMovementFuncs[_enemyType];
			var tmpPos:Vec2 = movementFunction(_enemyType);
			x = tmpPos.x; y = tmpPos.y;
			if (enemyType == 4)
				rotation = (new Vec2(x, y)).toAngleDeg(new Vec2(Player.plyObj.x, Player.plyObj.y));
			if (!reverse && movementTimer <= maxMoveTimer) { active = true; }
			else if (reverse && movementTimer >= maxMoveTimer) { active = true; }
			addChild(enemyBitmap);
			
			healthBar = new HealthBar(enemyHealth);
			healthBar.y = -45;
			addChild(healthBar);
		}
		
		public function enemyTick():void
		{
			if ((!reverse && movementTimer <= maxMoveTimer) || (reverse && movementTimer >= maxMoveTimer))
			{
				if (enemyType < 4)
				{
					var newPos:Vec2 = movementFunction(movementTimer);
					var angleToNewPos:Number = (new Vec2(x, y)).toAngleDeg(newPos);
					fireDirection = newPos.normalise(new Vec2(x, y));
					rotation = angleToNewPos;
					x = newPos.x;
					y = newPos.y;
				}
				else if (enemyType == 4)
				{
					var rotationInRads:Number = (rotation / 180) * Math.PI;
					var directionVec:Vec2 = new Vec2( -Math.sin(rotationInRads), Math.cos(rotationInRads));
					fireDirection = directionVec.normalise();
					x += directionVec.x*8; y += directionVec.y*8;
				}
				else
				{
					var newPos2:Vec2 = movementFunction(movementTimer);
					x = newPos2.x;
					y = newPos2.y;
				}
			}
			else if (((!reverse && movementTimer >= maxMoveTimer) || (reverse && movementTimer <= maxMoveTimer)) && maxMoveTimer != -1)
			{
				active = false;
			}
			movementTimer += 0.5 * (reverse ? -1 : 1);
			
			if (curFireInterval < enemyFireDelay[enemyType])
				curFireInterval += 1;
			else if (curFireInterval >= enemyFireDelay[enemyType])
			{
				if (enemyType <= 4)
				{
					var angleToPly:Number = -(new Vec2(Player.plyObj.x - x, y - Player.plyObj.y)).toAngleDeg();
					angleToPly = angleToPly < -180 ? angleToPly + 360 : angleToPly;
					var upperRot:Number = rotation + 25; var lowerRot:Number = rotation - 25;
					if ((lowerRot < -180 && upperRot <= 180 && (angleToPly > lowerRot + 360 || angleToPly < upperRot)) || (lowerRot >= -180 && upperRot > 180 && (angleToPly > lowerRot || angleToPly < upperRot - 360)) || (lowerRot >= -180 && upperRot <= 180 && angleToPly > lowerRot && angleToPly < upperRot))
					{
						curFireInterval = 0 ;
						Game.GameObj.fireProjectile(this, fireOffset, fireDirection, enemyFireDamage[enemyType], fireLeftSide, false, enemyFireSpeed[enemyType], enemyFireCol[enemyType]);
						fireLeftSide = !fireLeftSide;
					}
				}
				else if (enemyType == 5)
				{
					curFireInterval = 0;
					Game.GameObj.fireProjectile(this, new Vec2(175, 200), new Vec2(0,1), enemyFireDamage[enemyType], fireLeftSide, false, enemyFireSpeed[enemyType], enemyFireCol[enemyType]);
					fireLeftSide = !fireLeftSide;
				}
				else if (enemyType == 6 || enemyType == 7)
				{
					curFireInterval = 0;
					Game.GameObj.fireProjectile(this, new Vec2(225, 250), new Vec2(Math.sin((movementTimer/180)*Math.PI),1), enemyFireDamage[enemyType], fireLeftSide, false, enemyFireSpeed[enemyType], enemyFireCol[enemyType]);
					fireLeftSide = !fireLeftSide;
				}
				else if (enemyType == 8)
				{
					curFireInterval = 0;
					var firePosition:Vec2 = new Vec2(x + 125 * (fireLeftSide ? -1 : 1), y + 425);
					Game.GameObj.fireProjectile(this, new Vec2(125, 425), (new Vec2(Player.plyObj.x - firePosition.x, Player.plyObj.y - firePosition.y)).normalise(), enemyFireDamage[enemyType], fireLeftSide, false, enemyFireSpeed[enemyType], enemyFireCol[enemyType]);
					fireLeftSide = !fireLeftSide;
				}
			}
			// boss 1 - move side to side constant shooting
			// boss 2 - stay stil and shoot side to side
			// boss 3 - move side to side and shoot side to side
			// boss 4 - constantly aim for player and move around
		}		
	}

}