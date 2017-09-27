package 
{
	import flash.media.Sound;
	import flash.utils.*;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class Player extends Sprite
	{
		// Embed all player ships
		// Type 1 Ships
		[Embed(source = "../Assets/PlayerShips/playerShip1_blue.png")] private static const ply1ShipBlue:Class;
		[Embed(source = "../Assets/PlayerShips/playerShip1_green.png")] private static const ply1ShipGreen:Class;
		[Embed(source = "../Assets/PlayerShips/playerShip1_orange.png")] private static const ply1ShipOrange:Class;
		[Embed(source = "../Assets/PlayerShips/playerShip1_red.png")] private static const ply1ShipRed:Class;
		// Type 2 Ships           
		[Embed(source = "../Assets/PlayerShips/playerShip2_blue.png")] private static const ply2ShipBlue:Class;
		[Embed(source = "../Assets/PlayerShips/playerShip2_green.png")] private static const ply2ShipGreen:Class;
		[Embed(source = "../Assets/PlayerShips/playerShip2_orange.png")] private static const ply2ShipOrange:Class;
		[Embed(source = "../Assets/PlayerShips/playerShip2_red.png")] private static const ply2ShipRed:Class;
		// Type 3 Ships           
		[Embed(source = "../Assets/PlayerShips/playerShip3_blue.png")] private static const ply3ShipBlue:Class;
		[Embed(source = "../Assets/PlayerShips/playerShip3_green.png")] private static const ply3ShipGreen:Class;
		[Embed(source = "../Assets/PlayerShips/playerShip3_orange.png")] private static const ply3ShipOrange:Class;
		[Embed(source = "../Assets/PlayerShips/playerShip3_red.png")] private static const ply3ShipRed:Class;
		// Put all ship Classes into an array for ease of use
		public static const plyShips:Array = new Array(new Array(ply1ShipBlue, ply1ShipGreen, ply1ShipOrange, ply1ShipRed),
														new Array(ply2ShipBlue, ply2ShipGreen, ply2ShipOrange, ply2ShipRed),
														new Array(ply3ShipBlue, ply3ShipGreen, ply3ShipOrange, ply3ShipRed));
		// Embed damage models for each type of ship
		// Type 1 Ships
		[Embed(source = "../Assets/Damage/playerShip1_damage1.png")] private static const ply1ShipDmg1:Class;
		[Embed(source = "../Assets/Damage/playerShip1_damage2.png")] private static const ply1ShipDmg2:Class;
		[Embed(source = "../Assets/Damage/playerShip1_damage3.png")] private static const ply1ShipDmg3:Class;
		// Type 2 Ships                               
		[Embed(source = "../Assets/Damage/playerShip2_damage1.png")] private static const ply2ShipDmg1:Class;
		[Embed(source = "../Assets/Damage/playerShip2_damage2.png")] private static const ply2ShipDmg2:Class;
		[Embed(source = "../Assets/Damage/playerShip2_damage3.png")] private static const ply2ShipDmg3:Class;
		// Type 3 Ships                               
		[Embed(source = "../Assets/Damage/playerShip3_damage1.png")] private static const ply3ShipDmg1:Class;
		[Embed(source = "../Assets/Damage/playerShip3_damage2.png")] private static const ply3ShipDmg2:Class;
		[Embed(source = "../Assets/Damage/playerShip3_damage3.png")] private static const ply3ShipDmg3:Class;
		// Put all ship Classes into an array for ease of use
		private static const plyShipDmg:Array = new Array(new Array(ply1ShipDmg1, ply1ShipDmg2, ply1ShipDmg3),
														new Array(ply2ShipDmg1, ply2ShipDmg2, ply2ShipDmg3),
														new Array(ply3ShipDmg1, ply3ShipDmg2, ply3ShipDmg3));
		
																	//    plyHealth, moveSpeed, wepWaitMaxtime, wepDamage
		public static const plyShipAttributes:Array = new Array(new Array(85, 8.5, 8, 18),
																 new Array(100, 7.5, 10, 22), 
																 new Array(125, 4, 6, 35))
		
		public var shipType:uint;
		private var shipCol:uint;
		private var shipBitmap:Bitmap;
		public static const shipXOffset:Array = new Array(49.5, 56, 49);
		private var plyTickIntervalId:uint;
		
		public var plyAlive:Boolean = true;
		public var health:int = 100;
		
		private const keysAccepted:Array = new Array(37, 38, 39, 40, 65, 87, 68, 83, 82, 32);
		private var keysDown:Dictionary = new Dictionary();
		private var weaponWaitTime:Number = 0;
		private var weaponWaitTimeMax:Number = 10;
		public var weaponWaitModifier:Number = 0;
		
		public var moveModifer:Number = 0;
		private var moveSpeed:Number = 7.5 * 1;
		private var moveDirection:Vec2 = new Vec2();
		private var moveVel:Vec2 = new Vec2();
		
		private var fireOffset:Vec2 = new Vec2(12, -20);
		private var fireDirection:Vec2 = new Vec2(0, -1);
		
		private var fireLeftState:Boolean = false;
		public var plyHealthBar:HealthBar;
		public static var plyObj:Player;
		
		[Embed(source = "../Assets/Effects/shield1.png")] private static const shield1Class:Class;
		[Embed(source = "../Assets/Effects/shield2.png")] private static const shield2Class:Class;
		[Embed(source = "../Assets/Effects/shield3.png")] private static const shield3Class:Class;
		private var shields:Array;
		public var shieldStrength:uint = 0;
		
		public function Player(_shipType:uint = 0, _shipCol:uint = 0) 
		{
			health = plyShipAttributes[_shipType][0];
			moveSpeed = plyShipAttributes[_shipType][1];
			weaponWaitTimeMax = plyShipAttributes[_shipType][2];
			
			shipType = _shipType;
			shipCol = _shipCol;
			
			plyObj = this; 
			
			shipBitmap = new plyShips[shipType][shipCol];
			shipBitmap.x = -shipXOffset[shipType]; shipBitmap.y = -37.5;
			addChild(shipBitmap);
			
			for each (var acceptedKey:int in keysAccepted)
				keysDown[acceptedKey] = 0;
			
			Main.stg.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			Main.stg.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			
			plyHealthBar = new HealthBar(health);
			plyHealthBar.y = 50;
			addChild(plyHealthBar);
			
			shields = new Array(new shield1Class(), new shield2Class(), new shield3Class());
			shields[0].x = -66.5; shields[0].y = -54;
			shields[1].x = -71.5; shields[1].y = -59.5;
			shields[2].x = -72; shields[2].y = -68.5;
			for each (var shield:Bitmap in shields)
			{
				addChild(shield);
				shield.visible = false;
			}
			
			//plyTickIntervalId = setInterval(plyTick, 10);
		}
		
		public function updateShieldStrength(_shieldStrength:uint):void
		{
			shieldStrength = _shieldStrength;
			for (var i:int = 0; i < shields.length; i++) 
				shields[i].visible = (i + 1 == shieldStrength);
		}
		
		public function handleKeyDown(e:KeyboardEvent):void
		{
			updateKeys(e.keyCode);
		}
		
		public function handleKeyUp(e:KeyboardEvent):void
		{
			updateKeys(e.keyCode, false);
		}
		
		public function plyTick():void
		{
			x += moveDirection.x * (moveSpeed+moveModifer);
			y += moveDirection.y * (moveSpeed+moveModifer);
			x = x < shipXOffset[shipType] ? shipXOffset[shipType] : (x > (Main.dimensions.x - shipXOffset[shipType]) ? (Main.dimensions.x - shipXOffset[shipType]) : x);
			y = y < 37.5 ? 37.5 : (y > (Main.dimensions.y - 37.5) ? (Main.dimensions.y - 37.5) : y);
			if (weaponWaitTime < (weaponWaitTimeMax - weaponWaitModifier))
				weaponWaitTime += 1;
			else 
			{
				if (keysDown[32])
				{
					Game.GameObj.fireProjectile(this, fireOffset, fireDirection, plyShipAttributes[shipType][3], fireLeftState, true);
					fireLeftState = !fireLeftState;
					weaponWaitTime = 0;
				}
			}
		}
		
		private function updateKeys(keyCode:uint, down:Boolean = true):void
		{
			if (keysDown[keyCode] != null) 
			{
				keysDown[keyCode] = down;
				moveDirection.x = ((keysDown[39] || keysDown[68]) ? 1 : 0) - ((keysDown[37] || keysDown[65]) ? 1 : 0);
				moveDirection.y = ((keysDown[40] || keysDown[83]) ? 1 : 0) - ((keysDown[38] || keysDown[87]) ? 1 : 0);
				moveDirection = moveDirection.normalise();
				/*if (keysDown[82])
				{
					shipType = (int)(Math.random() * 3);
					shipCol = (int)(Math.random() * 4);
					
					removeChild(shipBitmap);
					shipBitmap = new plyShips[shipType][shipCol];
					shipBitmap.x = -shipXOffset[shipType]; shipBitmap.y = -37.5;
					ddChild(shipBitmap);
				}*/
			}
		}
		
		public function purgeEventListeners():void
		{
			Main.stg.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			Main.stg.removeEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
		}
		
		private var damageOverlay:Bitmap;
		public function updateHealth(_health:Number):void
		{
			health = _health;
			if (damageOverlay != null)
			{
				removeChild(damageOverlay);
				damageOverlay = null;
			}
			if (health < 25)
				damageOverlay = new plyShipDmg[shipType][2];
			else if (health < 50)
				damageOverlay = new plyShipDmg[shipType][1];
			else if (health < 75)
				damageOverlay = new plyShipDmg[shipType][0];
			if (damageOverlay != null)
			{
				addChild(damageOverlay);
				damageOverlay.x = shipBitmap.x; damageOverlay.y = shipBitmap.y;
			}
		}
	}
}