package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.ShaderParameter;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.*
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class Game extends Sprite
	{
		[Embed(source = "../Assets/UI/Custom Assets/pauseMenu.png")] private static const pauseMenuClass:Class;
		[Embed(source = "../Assets/UI/Custom Assets/gameOver.png")] private static const gameOverClass:Class;
		[Embed(source = "../Assets/Music/level3.mp3")] private var bossmusicClass:Class;
		private var music:Sound;
		[Embed(source = "../Assets/Sounds/sfx_laser1.mp3")] private var shootSound1Class:Class;
		[Embed(source = "../Assets/Sounds/sfx_laser2.mp3")] private var shootSound2Class:Class;
		private var shootSound1:Sound; 
		private var shootSound2:Sound;
		
		[Embed(source = "../Assets/Sounds/sfx_hit1.mp3")] private var hitSound1Class:Class;
		[Embed(source = "../Assets/Sounds/sfx_hit2.mp3")] private var hitSound2Class:Class;
		[Embed(source = "../Assets/Sounds/sfx_hit3.mp3")] private var hitSound3Class:Class;
		[Embed(source = "../Assets/Sounds/sfx_hit4.mp3")] private var hitSound4Class:Class;
		private var hitSounds:Array;
		
		public static var GameObj:Game;
		
		private var ply:Player;
		public static var projectileLayer:Sprite;
		private var projectiles:Array;
		private var projHits:Array;
		public static var enemyLayer:Sprite;
		private var enemies:Array;
		private var asteroids:Array;
		private var powerUps:Array;
	
		private var spawnEnemy:uint;
		private var spawnEnemyAt:uint;
		private var scoreCounter:uint;
		private var scoreCounterTextField:TextField;
		private var projMax:Vec2 = new Vec2(Main.dimensions.x + 54, Main.dimensions.y + 54);
		
		private var levelId:uint;
		private var levelCounter:uint = 0;
		private var levelCounterMax:Array = new Array(2000,1500,2000,2000);
		private var levelEnemySpawns:Dictionary = new Dictionary();
		private var levelEnemyReversed:Dictionary = new Dictionary();
		private var levelEnemyDrop:Dictionary = new Dictionary();
		private var levelAsteroidSpawns:Dictionary = new Dictionary();
		private var endLevelReached:Boolean = false;
		private var pause:Boolean = false;
		private var pauseMenu:Sprite;
		private var pauseMenuBtns:Array;
		private var pauseMenuBtnsHover:Array;
		private var gameOverMenu:Sprite;
		private var gameOverBtns:Array;
		private var gameOverBtnsHover:Array;
		private var godMode:Boolean = false;
		private var musicSoundChannel:SoundChannel;
		private var superTimer:int = -1;
		private var gameOverHeaderFormat:TextFormat;
		private var gameOverScoreFormat:TextFormat;
		
		public function Game(_levelId:uint) 
		{
			music = new bossmusicClass();
			musicSoundChannel = music.play(0,0,Main.musicSndTrns);
			
			Main.cursor.visible = false;
			
			levelId = _levelId;
			// Assign values in relevant positions telling algorithms when to spawn what enemies
			// Level 1
			if (levelId == 0)
			{
				levelEnemySpawns[50] = 0; levelEnemyDrop[50] = 0;
				levelEnemySpawns[200] = 4;
				levelEnemySpawns[350] = 3; levelEnemyReversed[350] = true; levelEnemyDrop[350] = 2;
				levelEnemySpawns[450] = 2;
				levelAsteroidSpawns[500] = new Array(0, 0, 2, 768);
				levelEnemySpawns[600] = 1;
				levelEnemySpawns[800] = 4; 
				levelEnemySpawns[1000] = 2; levelEnemyReversed[1000] = true;
				levelEnemySpawns[1050] = 2;
				levelAsteroidSpawns[1075] = new Array(1, 1, 0, 256);
				levelEnemySpawns[1100] = 2;
				levelEnemySpawns[1150] = 2; levelEnemyReversed[1150] = true;
				levelEnemySpawns[1450] = 3;
				levelEnemySpawns[1800] = 3; levelEnemyReversed[1800] = true; levelEnemyDrop[1800] = 1;
				levelAsteroidSpawns[1850] = new Array(0, 0, 1, 956);
				levelEnemySpawns[1900] = 0; levelEnemyReversed[1900] = true;
				levelEnemySpawns[2000] = 5;
				// @ 2000 spawn boss
			}
			else if (levelId == 1)
			{
				levelEnemySpawns[50] = 4;
				levelEnemySpawns[200] = 2;
				levelEnemySpawns[325] = 3; levelEnemyDrop[325] = 0;
				levelEnemySpawns[475] = 0; levelEnemyReversed[475] = true;
				levelEnemySpawns[575] = 1; levelEnemyReversed[575] = true;
				levelEnemySpawns[700] = 0;
				levelEnemySpawns[800] = 0; levelEnemyDrop[800] = 2;
				levelEnemySpawns[925] = 0; levelEnemyReversed[[925]] = true;
				levelEnemySpawns[1050] = 0; levelEnemyReversed[1050] = true;
				levelEnemySpawns[1250] = 3; 
				levelEnemySpawns[1350] = 2;
				levelEnemySpawns[1450] = 1; levelEnemyReversed[1450] = true;
				levelEnemySpawns[1500] = 6;
			}
			else if (levelId == 2)
			{
				levelEnemySpawns[50] = 0;
				levelEnemySpawns[150] = 3; levelEnemyReversed[150] = true;
				levelAsteroidSpawns[300] = new Array(0, 0, 0, 768);
				levelAsteroidSpawns[325] = new Array(0, 1, 0, 702);
				levelAsteroidSpawns[310] = new Array(0, 1, 1, 794);
				levelEnemySpawns[425] = 4;
				levelEnemySpawns[450] = 2; levelEnemyReversed[450] = true;
				levelEnemySpawns[475] = 4;
				levelEnemySpawns[800] = 3; levelEnemyReversed[800] = true;
				levelEnemySpawns[975] = 0; levelEnemyReversed[975] = true;
				levelEnemySpawns[1050] = 0;
				levelAsteroidSpawns[1075] = new Array(1, 0, 1, 512);
				levelEnemySpawns[1300] = 1; levelEnemyDrop[1300] = 1;
				levelEnemySpawns[1350] = 3;
				levelEnemySpawns[1400] = 4;
				levelEnemySpawns[1550] = 2; levelEnemyDrop[1550] = 0;
				levelEnemySpawns[1800] = 0; levelEnemyReversed[1800] = true;
				levelAsteroidSpawns[1850] = new Array(1, 2, 0, 956);
				levelEnemySpawns[1900] = 2; levelEnemyReversed[1900] = true;
				levelEnemySpawns[2000] = 7;
			}
			else if (levelId == 3)
			{
				levelEnemySpawns[50] = 1;
				levelEnemySpawns[325] = 3; levelEnemyReversed[325] = true;
				levelEnemySpawns[350] = 4;
				levelEnemySpawns[375] = 2;
				levelEnemySpawns[575] = 1; levelEnemyReversed[575] = true;
				levelEnemySpawns[800] = 1; levelEnemyReversed[800] = true;
				levelEnemySpawns[875] = 2;
				levelAsteroidSpawns[890] = new Array(1, 0, 3, 325);
				levelAsteroidSpawns[895] = new Array(0, 3, 1, 850);
				levelAsteroidSpawns[925] = new Array(0, 1, 0, 1100);
				levelAsteroidSpawns[935] = new Array(1, 0, 1, 620);
				levelEnemySpawns[975] = 4;
				levelEnemySpawns[1100] = 3;
				levelEnemySpawns[1375] = 0; levelEnemyReversed[1375] = true;
				levelEnemySpawns[1450] = 1; levelEnemyReversed[1450] = true;
				levelEnemySpawns[1650] = 0; levelEnemyDrop[1650] = 1;
				levelEnemySpawns[1750] = 3; levelEnemyDrop[1750] = 0;
				levelEnemySpawns[1850] = 4; levelEnemyDrop[1850] = 2;
				levelAsteroidSpawns[1875] = new Array(0, 0, 2, 768);
				levelEnemySpawns[1900] = 3; levelEnemyReversed[1900] = true;
				levelEnemySpawns[2000] = 8;
			}
			
			shootSound1 = new shootSound1Class();
			shootSound2 = new shootSound2Class();
			pauseMenuBtnsHover = new Array(false, false, false);
			gameOverBtnsHover = new Array(false, false);
			hitSounds = new Array(new hitSound1Class(), new hitSound2Class(), new hitSound3Class(), new hitSound4Class());
			
			scoreCounter = 0;
			//setScoreText();
			
			GameObj = this;
			
			projectiles = new Array();
			projHits = new Array();
			projectileLayer = new Sprite();
			addChild(projectileLayer);
			
			gameOverHeaderFormat = new TextFormat("prototype");
			gameOverHeaderFormat.size = 64;
			
			gameOverScoreFormat = new TextFormat("prototype");
			gameOverScoreFormat.size = 40;
				
			enemies = new Array();
			asteroids = new Array();
			powerUps = new Array();
			enemyLayer = new Sprite();
			addChild(enemyLayer);
			
			ply = new Player(Main.selectedShip.x, Main.selectedShip.y);
			ply.x = Main.dimensions.x * 0.5; ply.y = Main.dimensions.y * 0.8;
			addChild(ply);
			
			spawnEnemy = 0;
			spawnEnemyAt = Math.floor(Math.random() * 8);
			
			Main.stg.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			Main.stg.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			Main.stg.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			addEventListener(Event.ENTER_FRAME, gameTick);
		}
		
		private function purgeEventListeners():void
		{
			Main.stg.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			Main.stg.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			Main.stg.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			removeEventListener(Event.ENTER_FRAME, gameTick);
			musicSoundChannel.stop();
		}
		
		private function handleMouseDown(event:MouseEvent):void
		{
			if (gameOverBtnsHover[0])
			{
				Main.cursor.visible = false;
				Main.layerObjs[1].removeChild(gameOverMenu);
				gameOverMenu = null;
				gameOverBtnsHover = new Array(false, false);
				purgeEventListeners();
				Main.mainObj.loadGame(levelId);
			}
			else if (gameOverBtnsHover[1])
			{
				Main.layerObjs[1].removeChild(gameOverMenu);
				purgeEventListeners();
				Main.mainObj.loadLevelSelector();
				gameOverBtnsHover = new Array(false, false);
			}
			else if (pauseMenuBtnsHover[0])
			{
				Main.cursor.visible = false;
				Main.layerObjs[1].removeChild(pauseMenu);
				pauseMenu = null;
				pause = false;
				pauseMenuBtnsHover = new Array(false, false, false);
			}
			else if (pauseMenuBtnsHover[1])
			{
				Main.layerObjs[1].removeChild(pauseMenu);
				purgeEventListeners();
				Main.mainObj.loadGame(levelId);
				pauseMenuBtnsHover = new Array(false, false, false);
			}
			else if (pauseMenuBtnsHover[2])
			{
				Main.layerObjs[1].removeChild(pauseMenu);
				purgeEventListeners();
				Main.mainObj.loadLevelSelector();
				pauseMenuBtnsHover = new Array(false, false, false);
			}
		}
		
		private function handleMouseMove(event:MouseEvent):void
		{
			var mPos:Point = event.target.localToGlobal(new Point(event.localX, event.localY));
			if (pause)
			{
				var btnHover:int = -1;
				var localPos:Vec2 = new Vec2(mPos.x - pauseMenu.x, mPos.y - pauseMenu.y);
				if (localPos.x >= 23 && localPos.x <= 286 && localPos.y >= 49 && localPos.y <= 91)
					btnHover = 0;
				else if (localPos.x >= 34 && localPos.x <= 275 && localPos.y >= 111 && localPos.y <= 153)
					btnHover = 1;
				else if (localPos.x >= 78 && localPos.x <= 227 && localPos.y >= 173 && localPos.y <= 215)
					btnHover = 2;
				for (var i:int = 0; i < 3; i++) 
				{
					pauseMenuBtnsHover[i] = (i == btnHover);
					pauseMenuBtns[i * 2].visible = pauseMenuBtnsHover[i];
					pauseMenuBtns[i * 2 + 1].visible = pauseMenuBtnsHover[i];
				}
			}
			else if (gameOverMenu != null)
			{
				var btnHover2:int = -1;
				var localGOPos:Vec2 = new Vec2(mPos.x - gameOverMenu.x, mPos.y - gameOverMenu.y);
				if (localGOPos.x >= 138 && localGOPos.x <= 379 && localGOPos.y >= 209 && localGOPos.y <= 253)
					btnHover2 = 0;
				else if (localGOPos.x >= 185 && localGOPos.x <= 334 && localGOPos.y >= 274 && localGOPos.y <= 317)
					btnHover2 = 1;
				for (var j:int = 0; j < 2; j++) 
				{
					gameOverBtnsHover[j] = (j == btnHover2);
					gameOverBtns[j * 2].visible = gameOverBtnsHover[j];
					gameOverBtns[j * 2 + 1].visible = gameOverBtnsHover[j];
				}
			}
		}
		
		private function setScoreText():void
		{
			if (scoreCounterTextField != null)
				Main.layerObjs[1].removeChild(scoreCounterTextField);
			scoreCounterTextField = new TextField();
			scoreCounterTextField.textColor = 0xECF2FA;
			scoreCounterTextField.selectable = false;
			scoreCounterTextField.text = "Score: " + scoreCounter;
			scoreCounterTextField.autoSize = TextFieldAutoSize.CENTER;
			scoreCounterTextField.x = 624; scoreCounterTextField.y = 16;
			scoreCounterTextField.setTextFormat(LevelSelector.levelSelectTextFormat);
			Main.layerObjs[1].addChild(scoreCounterTextField);
		}
		
		private function spawnRandomEnemy():void
		{
			var tmpEnemy:Enemy = new Enemy(Math.floor(Math.random() * 4), Math.floor(Math.random() * 5));
			enemyLayer.addChild(tmpEnemy);
			enemies.push(tmpEnemy);
		}
		
		private function spawnSelectEnemy(_enemyType:uint, _reverse:Boolean, _powerUpId:int):void
		{
			var tmpEnemy:Enemy = new Enemy(Math.floor(Math.random() * 4), _enemyType, _reverse, _powerUpId);
			enemyLayer.addChild(tmpEnemy);
			enemies.push(tmpEnemy);
		}
		
		private function spawnSelectAsteroid(_asteroidCol:uint, _asteroidSize:uint, _asteroidType:uint, _asteroidX:uint):void
		{
			var tmpAsteroid:Asteroid = new Asteroid(_asteroidCol, _asteroidSize, _asteroidType);
			tmpAsteroid.x = _asteroidX;
			enemyLayer.addChild(tmpAsteroid);
			asteroids.push(tmpAsteroid);
		}
		
		public function handleKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == 27 && ply.plyAlive)
			{
				/*Main.stg.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				ply.purgeEventListeners();
				removeEventListener(Event.ENTER_FRAME, gameTick);
				removeChild(ply);
				Main.mainObj.loadMainMenu();*/
				/*Main.stg.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				ply.purgeEventListeners();
				removeEventListener(Event.ENTER_FRAME, gameTick);
				removeChild(ply);
				Main.layerObjs[1].removeChild(scoreCounterTextField);
				Main.mainObj.loadGame(levelId);*/
				if (pause)
				{
					Main.cursor.visible = false;
					Main.layerObjs[1].removeChild(pauseMenu);
				}
				else
				{
					Main.cursor.visible = true;
					pauseMenu = new Sprite();
					Main.layerObjs[1].addChild(pauseMenu);
					pauseMenu.x = 466; pauseMenu.y = 239;
					pauseMenu.addChild(new pauseMenuClass());
					pauseMenuBtns = new Array(new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn());
					pauseMenuBtns[0].x = 23; pauseMenuBtns[0].y = 62;
					pauseMenuBtns[1].x = 265; pauseMenuBtns[1].y = 62;
					pauseMenuBtns[2].x = 34; pauseMenuBtns[2].y = 122;
					pauseMenuBtns[3].x = 256; pauseMenuBtns[3].y = 122;
					pauseMenuBtns[4].x = 78; pauseMenuBtns[4].y = 185;
					pauseMenuBtns[5].x = 208; pauseMenuBtns[5].y = 185;
					for each (var pmbtns:Bitmap in pauseMenuBtns) 
					{
						pmbtns.visible = false;
						pauseMenu.addChild(pmbtns);
					}
				}
				pause = !pause;
			}
			else if (e.keyCode == 71)
			{
				godMode = true;
			}
		}
		
		public function gameTick(e:Event):void
		{
			if (!pause && gameOverMenu == null)
			{
				for each (var projHit:ProjHit in projHits) 
				{
					if (projHit.active)
					{
						projHit.projTick();
					}
					else
					{
						removeChild(projHit);
						projHits.removeAt(projHits.indexOf(projHit));
					}
				}
				if (ply.plyAlive)
					for each (var proj:Projectile in projectiles) 
						if (!proj.plyProjectile && ply.hitTestObject(proj) && !godMode)
						{
							if (ply.shieldStrength == 0)
							{
								//ply.health -= proj.projDamage;
								ply.updateHealth(ply.health - proj.projDamage);
								ply.health = (ply.health < 0 ? 0 : ply.health);
								ply.plyHealthBar.setHealth(ply.health);
								if (ply.health <= 0)
								{
									ply.plyAlive = false;
									break;
								}
							}
							else
								ply.updateShieldStrength(ply.shieldStrength - 1);
							hitSounds[(int)(Math.random() * 4)].play(0,0,Main.sfxSndTrns);
							var tmpProjHit:ProjHit = new ProjHit(proj.laserCol, (int)(Math.random() * 4), 10);
							addChild(tmpProjHit);
							tmpProjHit.x = proj.x; tmpProjHit.y = proj.y;
							projHits.push(tmpProjHit);
							projectileLayer.removeChild(proj);
							projectiles.removeAt(projectiles.indexOf(proj));
						}
				if (ply.plyAlive)
				{
					ply.plyTick();
					Main.dynBckGrnd.starTick();
					if (!endLevelReached)
						Main.dynBckGrnd.worldAutoScroll();
					
					for each (var enemy:Enemy in enemies)
					{
						enemy.enemyTick();
						if (enemy.active)
							for each (var proj2:Projectile in projectiles) 
								if (proj2.plyProjectile && enemy.hitTestObject(proj2))
								{
									enemy.enemyHealth -= proj2.projDamage;
									enemy.healthBar.setHealth(enemy.enemyHealth);
									hitSounds[(int)(Math.random() * 4)].play(0,0,Main.sfxSndTrns);
									var tmpProjHit2:ProjHit = new ProjHit(proj2.laserCol, (int)(Math.random() * 4), 10);
									addChild(tmpProjHit2);
									tmpProjHit2.x = proj2.x; tmpProjHit2.y = proj2.y;
									projHits.push(tmpProjHit2);
									projectileLayer.removeChild(proj2);
									projectiles.removeAt(projectiles.indexOf(proj2));
									if (enemy.enemyHealth <= 0)
									{
										enemy.active = false;
										scoreCounter += Enemy.scoreReturns[enemy.enemyType];
										//setScoreText();
										break;
									}
								}
						
						if (!enemy.active)
						{
							enemyLayer.removeChild(enemy);
							if (enemy.powerUpDropId != -1)
							{
								var newPowerUp:PowerUp = new PowerUp(enemy.powerUpDropId);
								newPowerUp.x = enemy.x; newPowerUp.y = enemy.y;
								enemyLayer.addChild(newPowerUp);
								powerUps.push(newPowerUp);
							}
							enemies.removeAt(enemies.indexOf(enemy));
						}
					}
					
					for each (var asteroid:Asteroid in asteroids) 
					{
						asteroid.y += 2;
						/*for each (var enemy2:Enemy in enemies) 
						{
							if (enemy2.hitTestObject(asteroid))
							{
								enemy2.active = false;
							}
						}*/
						for each (var projInGame:Projectile in projectiles) 
						{
							if (asteroid.hitTestObject(projInGame))
							{
								hitSounds[(int)(Math.random() * 4)].play(Main.sfxSndTrns);
								var tmpProjHit3:ProjHit = new ProjHit(projInGame.laserCol, (int)(Math.random() * 4), 10);
								addChild(tmpProjHit3);
								tmpProjHit3.x = projInGame.x; tmpProjHit3.y = projInGame.y;
								projHits.push(tmpProjHit3);
								projectileLayer.removeChild(projInGame);
								projectiles.removeAt(projectiles.indexOf(projInGame));
							}
						}
						/*if (asteroid.hitTestObject(ply))
						{
							ply.updateHealth(0);
							ply.plyHealthBar.setHealth(ply.health);
							ply.plyAlive = false;
						}*/
						if (asteroid.y > 720)
						{
							enemyLayer.removeChild(asteroid);
							asteroids.removeAt(asteroids.indexOf(asteroid));
						}
					}
					
					for each (var droppedPowerUp:PowerUp in powerUps) 
					{
						if (ply.hitTestObject(droppedPowerUp))
						{
							switch (droppedPowerUp.powerUpId) 
							{
								case 0:
									ply.updateShieldStrength(3);
									break;
								
								case 1:
									ply.updateHealth(Player.plyShipAttributes[Player.plyObj.shipType][0]);
									ply.plyHealthBar.setHealth(ply.health);
									break;
								
								case 2:
									// up speed
									// up wep power
									ply.moveModifer = 2.5;
									ply.weaponWaitModifier = 2.5;
									superTimer = 1000;
									break;
							}
							enemyLayer.removeChild(droppedPowerUp);
							powerUps.removeAt(powerUps.indexOf(droppedPowerUp));
						}
					}
					
					if (superTimer > 0)
					{
						superTimer -= 1;
					}
					else if (superTimer == 0)
					{
						ply.moveModifer = 2.5;
						ply.weaponWaitModifier = 2.5;
						superTimer = -1;
					}
					
					if (levelId <= 3 && !endLevelReached)
					{
						levelCounter += 1;
						//setScoreText();
						if (levelEnemySpawns[levelCounter] != null)
						{
							spawnSelectEnemy(levelEnemySpawns[levelCounter], (levelEnemyReversed[levelCounter] != null ? true : false), (levelEnemyDrop[levelCounter] == null ? -1 : levelEnemyDrop[levelCounter])); 
						}
						if (levelAsteroidSpawns[levelCounter] != null)
						{
							spawnSelectAsteroid(levelAsteroidSpawns[levelCounter][0], levelAsteroidSpawns[levelCounter][1], levelAsteroidSpawns[levelCounter][2], levelAsteroidSpawns[levelCounter][3]);
						}
						if (levelCounter > levelCounterMax[levelId])
						{
							endLevelReached = true;
						}
					}
					else if (!endLevelReached)
					{
						// Random mode
						spawnEnemy += 1;
						levelCounter += 1;
						if (spawnEnemy > spawnEnemyAt)
						{
							spawnEnemy = 0;
							spawnEnemyAt = 100/(1 + levelCounter/1000) + Math.floor(Math.random() * 100/(1 + levelCounter/1000));
							spawnRandomEnemy();
						}
					}
					
					for each (var projectileInGame:Projectile in projectiles) 
					{
						projectileInGame.projectileTick();
						if (projectileInGame.x < -54 || projectileInGame.x > projMax.x || projectileInGame.y < -54 || projectileInGame.y > projMax.y/* || projectileInGame.scaleX <= 0*/)
						{
							projectileLayer.removeChild(projectileInGame);
							projectiles.removeAt(projectiles.indexOf(projectileInGame));
						}
					}
				}
				if (enemies.length == 0 && endLevelReached)
				{
					createGameOverScreen(true);
				}
			}
			if (!ply.plyAlive && gameOverMenu == null)
			{
				createGameOverScreen(false);
			}
		}
		
		
		private function createGameOverScreen(_win:Boolean):void
		{
			Main.cursor.visible = true;
			gameOverMenu = new Sprite();
			Main.layerObjs[1].addChild(gameOverMenu);
			gameOverMenu.x = 360; gameOverMenu.y = 180;
			gameOverMenu.addChild(new gameOverClass());
			var gameOverHeader:TextField = new TextField();
			gameOverHeader.text = (_win ? "You Won!" : "Game Over");
			gameOverHeader.selectable = false;
			gameOverHeader.autoSize = TextFieldAutoSize.CENTER;
			gameOverHeader.setTextFormat(gameOverHeaderFormat);
			gameOverHeader.x = (_win ? 120 : 100); gameOverHeader.y = 40;
			gameOverMenu.addChild(gameOverHeader);
			var gameOverScore:TextField = new TextField();
			gameOverScore.text = "Score: " + scoreCounter;
			gameOverScore.selectable = false;
			gameOverScore.autoSize = TextFieldAutoSize.CENTER;
			gameOverScore.x = 225; gameOverScore.y = 135;
			gameOverScore.setTextFormat(gameOverScoreFormat);
			gameOverMenu.addChild(gameOverScore);
			gameOverBtns = new Array(new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn());
			gameOverBtns[0].x = 138; gameOverBtns[0].y = 224;
			gameOverBtns[1].x = 360; gameOverBtns[1].y = 224;
			gameOverBtns[2].x = 185; gameOverBtns[2].y = 288;
			gameOverBtns[3].x = 315; gameOverBtns[3].y = 288;
			for each (var gameBtn:Bitmap in gameOverBtns)
			{
				gameBtn.visible = false;
				gameOverMenu.addChild(gameBtn);
			}
		}
		
		public function fireProjectile(_callingObject:DisplayObject, _offset:Vec2, _direction:Vec2, _projDmg:uint, _leftSide:Boolean = false,  _plyProj:Boolean = false, _fireVel:Number = 20, _fireCol:uint = 0):void
		{
			var proj:Projectile = new Projectile(_projDmg, _fireCol, _direction, _fireVel, 0, _plyProj);
			var globalPoint:Point = _callingObject.localToGlobal(new Point(_offset.x * (_leftSide ? -1 : 1), _offset.y));
			proj.x = globalPoint.x; proj.y = globalPoint.y;
			projectileLayer.addChild(proj);
			projectiles.push(proj);
			if (_leftSide)
				shootSound1.play(0,0,Main.sfxSndTrns);
			else 
				shootSound2.play(0,0,Main.sfxSndTrns);
		}
	}
}