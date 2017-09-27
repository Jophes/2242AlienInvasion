package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.*
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	//import mx.core.BitmapAsset;
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class LevelSelector extends Sprite
	{
		[Embed(source = "../Assets/UI/Custom Assets/levelSelectorBtn.png")] public static const levelSelectBtnClass:Class;
		[Embed(source = "../Assets/UI/Custom Assets/levelSelectorConnectorStart.png")] public static const levelSelectBtnStartClass:Class;
		[Embed(source = "../Assets/UI/Custom Assets/levelSelectorConnectorMid.png")] public static const levelSelectBtnMidClass:Class;
		[Embed(source = "../Assets/UI/Custom Assets/optionsIcon.png")] public static const optionsIconClass:Class;
		[Embed(source = "../Assets/UI/Custom Assets/levelSelectMenu.png")] public static const levelSelectMenu:Class;
		[Embed(source = "../Assets/UI/Custom Assets/return.png")] public static const returnClass:Class;
		
		[Embed(source = "../Assets/UI/Custom Assets/Ship Menu/playerUnderlay1.png")] private const plyUnderlay1Class:Class;
		[Embed(source = "../Assets/UI/Custom Assets/Ship Menu/playerUnderlay2.png")] private const plyUnderlay2Class:Class;
		[Embed(source = "../Assets/UI/Custom Assets/Ship Menu/playerUnderlay3.png")] private const plyUnderlay3Class:Class;
		[Embed(source = "../Assets/UI/Custom Assets/Ship Menu/shipSelection.png")] private const shipSelectionClass:Class;
		[Embed(source = "../Assets/UI/Custom Assets/Ship Menu/playerSelectBtn.png")] private const shipSelectionBtnClass:Class;
		private const plyUnderlaysClasses:Array = new Array(plyUnderlay1Class, plyUnderlay2Class, plyUnderlay3Class);
		private const plyUnderlaysSizes:Array = new Array(new Vec2(105, 81), new Vec2(118, 81), new Vec2(103, 81));
		private var plySelectionBtn:Sprite;
		private var plySelectionMenu:Sprite;
		private var plySelectionBtnIndicators:Array;
		private var plySelectionBtns:Array;
		private var plySelected:Vec2 = Main.selectedShip;
		private var plyHoverSelection:Vec2;
		
		private var worldScrolled:Number = 0;
		private var maxWorldScroll:Number = 720;
		
		private var mouseDown:Boolean = false;
		private var prevMouseYPos:Number;
		
		private var levelBtns:Array;
		private var optionsSprite:Sprite;
		private var returnSprite:Sprite;
		private var lvlMenuBtns:Array;
		private var btnHover:Array;
		
		private var levelSelectMenu:Bitmap;
		private var levelSelectTitleText:TextField;
		public static var levelSelectTextFormat:TextFormat;
		public static var healthBarFormat:TextFormat;
		private var levelSelectMenuOpen:Boolean = false;
		private var selectedLevelId:uint;
		
		private var settingsMenu:SettingsMenu;
		private var settingsBtns:Array;
		private var settingBtnHover:Boolean = false;
		
		public function LevelSelector() 
		{
			Main.dynBckGrnd.setupForLevelSelector(maxWorldScroll+Main.dimensions.y-16);
			Main.stg.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			Main.stg.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			Main.stg.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			Main.stg.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			Main.stg.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			Main.stg.addEventListener(MouseEvent.CLICK, handleStageClick);
			addEventListener(MouseEvent.CLICK, handleClick);
			
			addEventListener(Event.ENTER_FRAME, levelSelectTick);
			
			levelSelectTextFormat = new TextFormat();
			levelSelectTextFormat.size = 64;
			levelSelectTextFormat.font = "prototype";
			levelSelectTextFormat.align = TextFormatAlign.CENTER;
			
			healthBarFormat = new TextFormat();
			healthBarFormat.size = 9;
			healthBarFormat.font = "prototype";
			healthBarFormat.align = TextFormatAlign.CENTER;
			
			btnHover = new Array(false, false);
			lvlMenuBtns = new Array(new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn());
			lvlMenuBtns[0].x = 466 + 64; lvlMenuBtns[0].y = 239 + 128;
			lvlMenuBtns[1].x = 466 + 224; lvlMenuBtns[1].y = 239 + 128;
			lvlMenuBtns[2].x = 466 + 64; lvlMenuBtns[2].y = 239 + 185;
			lvlMenuBtns[3].x = 486 + 224; lvlMenuBtns[3].y = 239 + 185;
			
			// Add elements to level selector
			levelBtns = new Array();
			levelBtns.push(createLevelBtn(new Vec2(420, 420),"" + (levelBtns.length + 1)));
			levelBtns.push(createLevelBtn(new Vec2(720, 60),"" + (levelBtns.length + 1)));
			levelBtns.push(createLevelBtn(new Vec2(280, -350),"" + (levelBtns.length + 1)));
			levelBtns.push(createLevelBtn(new Vec2(820, -620),"" + (levelBtns.length + 1)));
			levelBtns.push(createLevelBtn(new Vec2(1025, 520),"R"));
			
			connectBtns(new Vec2(420, 420), new Vec2(720, 60));
			connectBtns(new Vec2(720, 60), new Vec2(280, -350));
			connectBtns(new Vec2(280, -350), new Vec2(820, -620));
			
			var tmpBitmap:Bitmap = new LevelSelector.optionsIconClass();
			optionsSprite = new Sprite();
			optionsSprite.addChild(tmpBitmap);
			optionsSprite.x = 16; optionsSprite.y = 720 - 64 - 16;
			Main.layerObjs[1].addChild(optionsSprite);
			
			tmpBitmap = new shipSelectionBtnClass();
			tmpBitmap.scaleX = 0.5; tmpBitmap.scaleY = 0.5;
			plySelectionBtn = new Sprite();
			plySelectionBtn.addChild(tmpBitmap);
			plySelectionBtn.x = 16+74; plySelectionBtn.y = 720 - 64 - 16-6;
			Main.layerObjs[1].addChild(plySelectionBtn);
			
			tmpBitmap = new LevelSelector.returnClass();
			returnSprite = new Sprite();
			returnSprite.addChild(tmpBitmap);
			returnSprite.x = 16; returnSprite.y = 16;
			Main.layerObjs[1].addChild(returnSprite);
		}
		
		public function handleClick(e:MouseEvent):void
		{
			if (settingsMenu == null && plySelectionMenu == null)
				for (var i:int = 0; i < levelBtns.length; i++) 
				{
					if ((levelBtns[i] == e.target || levelBtns[i] == (DisplayObject)(e.target).parent) && !levelSelectMenuOpen)
					{
						openLevelSelectMenu(i);
						break;
					}
				}
		}
		
		private function openLevelSelectMenu(levelId:Number):void
		{
			levelSelectMenu = new LevelSelector.levelSelectMenu();
			Main.layerObjs[1].addChild(levelSelectMenu);
			levelSelectMenu.x = 466; levelSelectMenu.y = 239;
			levelSelectMenuOpen = true;
			levelSelectTitleText = new TextField();
			levelSelectTitleText.textColor = 0x202020;
			levelSelectTitleText.selectable = false;
			if (levelId == 4)
				levelSelectTitleText.text = "Level R";
			else
				levelSelectTitleText.text = "Level " + (levelId + 1);
			selectedLevelId = levelId;
			levelSelectTitleText.autoSize = TextFieldAutoSize.CENTER;
			levelSelectTitleText.x = 624-20; levelSelectTitleText.y = 271;
			levelSelectTitleText.setTextFormat(levelSelectTextFormat);
			Main.layerObjs[1].addChild(levelSelectTitleText);
			for each (var btn:Bitmap in lvlMenuBtns)
			{
				Main.layerObjs[1].addChild(btn);
				btn.visible = false;
			}
			Main.stg.addEventListener(MouseEvent.MOUSE_MOVE, handleLevelSelectMenuHover);
			Main.stg.addEventListener(MouseEvent.MOUSE_DOWN, handleLevelSelectMenuDown);
		}
		
		public function handleLevelSelectMenuDown(e:MouseEvent):void
		{
			if (settingsMenu == null && plySelectionMenu == null)
			{
				if (btnHover[0])
				{
					closeLevelSelectMenu();
					Main.layerObjs[1].removeChild(optionsSprite);
					Main.layerObjs[1].removeChild(returnSprite);
					Main.layerObjs[1].removeChild(plySelectionBtn);
					purgeEventListeners();
					Main.mainObj.loadGame(selectedLevelId);
				}
				else if (btnHover[1])
				{
					closeLevelSelectMenu();
				}
			}
			else if (settingsMenu != null)
			{
				
				if (settingBtnHover)
				{
					Main.layerObjs[1].removeChild(settingsMenu);
					settingsMenu = null;
					settingsBtns = null;
					settingBtnHover = false;
					Main.stg.removeEventListener(MouseEvent.MOUSE_MOVE, handleLevelSelectMenuHover);
					Main.stg.removeEventListener(MouseEvent.MOUSE_DOWN, handleLevelSelectMenuDown);
				}
			}
			else if (plySelectionMenu != null)
			{
				if (plySelectionBtnIndicators[0].visible)
				{
					Main.layerObjs[1].removeChild(plySelectionMenu);
					plySelectionMenu = null;
					Main.stg.removeEventListener(MouseEvent.MOUSE_MOVE, handleLevelSelectMenuHover);
					Main.stg.removeEventListener(MouseEvent.MOUSE_DOWN, handleLevelSelectMenuDown);
				}
				if (plyHoverSelection != null)
				{
					plySelectionBtns[plySelected.x][plySelected.y].transform.colorTransform = new ColorTransform(0.1, 0.1, 0.1);
					plySelected = plyHoverSelection;
					Main.selectedShip = plySelected;
					plySelectionBtns[plySelected.x][plySelected.y].transform.colorTransform = new ColorTransform(0.9, 0.9, 0.9);
				}
			}
		}
		
		public function handleLevelSelectMenuHover(e:MouseEvent):void
		{
			if (settingsMenu == null && plySelectionMenu == null)
				if (e.localX >= 486 + 64 && e.localY >= 239 + 115 && e.localX <= 486 + 245 && e.localY <= 239 + 161)
				{
					for (var i:int = 0; i < 2; i++) 
					{
						lvlMenuBtns[i].visible = true;
						lvlMenuBtns[i + 2].visible = false;
					}
					btnHover[0] = true;
				}
				else if (e.localX >= 486 + 62 && e.localY >= 239 + 169 && e.localX <= 486 + 245 && e.localY <= 239 + 215)
				{
					for (var j:int = 0; j < 2; j++) 
					{
						lvlMenuBtns[j].visible = false;
						lvlMenuBtns[j + 2].visible = true;
					}
					btnHover[1] = true;
				}
				else
				{
					for (var k:int = 0; k < 4; k++) 
					{
						lvlMenuBtns[k].visible = false;
					}
					btnHover[0] = false; btnHover[1] = false;
				}
			else if (settingsMenu != null)
			{
				var xPos:Number = e.localX < 547 ? 547 : (e.localX > 792 ? 792 : e.localX);
				if (e.localX >= 380 + 183 && e.localY >= 180 + 272 && e.localX <= 380 + 336 && e.localY <= 180 + 319)
				{
					for (var l:int = 0; l < 2; l++) 
						settingsBtns[l].visible = true;
					settingBtnHover = true;
				}
				else if (e.localX >= 547-8 && e.localX <= 792+8 && e.localY >= 319 && e.localY <= 358 && mouseDown)
				{
					settingsMenu.updateSFXSlider((int)(((xPos - 547) / 244) * 100));
					settingsMenu.settingsSFXSlider.x = e.localX-14;
				}
				else if (e.localX >= 547-8 && e.localX <= 792+8 && e.localY >= 383 && e.localY <= 422 && mouseDown)
				{
					settingsMenu.updateMusicSlider((int)(((xPos - 547) / 244) * 100));
					settingsMenu.settingsMusicSlider.x = e.localX-14;
				}
				else
				{
					for (var m:int = 0; m < 2; m++) 
						settingsBtns[m].visible = false;
					settingBtnHover = false;
				}
			}
			else if (plySelectionMenu != null)
			{
				var globalPos:Point = e.target.localToGlobal(new Point(e.localX, e.localY));
				if (globalPos.x >= 185 + plySelectionMenu.x && globalPos.x <= 335 + plySelectionMenu.x && globalPos.y >= 399 + plySelectionMenu.y && globalPos.y <= 442 + plySelectionMenu.y)
				{
					plySelectionBtnIndicators[0].visible = true;
					plySelectionBtnIndicators[1].visible = true;
				}
				else
				{
					plySelectionBtnIndicators[0].visible = false;
					plySelectionBtnIndicators[1].visible = false;
				}
				
				plyHoverSelection = null;
				for (var g:int = 0; g < 3; g++) 
				{
					for (var h:int = 0; h < 4; h++) 
					{
						if (!(plySelected.x == g && plySelected.y == h))
						{
							var tmpBitmap:Bitmap = plySelectionBtns[g][h];
							if (globalPos.x >= plySelectionMenu.x + tmpBitmap.x && globalPos.y >= plySelectionMenu.y + tmpBitmap.y && globalPos.x <= plySelectionMenu.x + tmpBitmap.x + (Player.shipXOffset[g] * 2 + 6) && globalPos.y <= plySelectionMenu.y + tmpBitmap.y + 96)
							{
								tmpBitmap.transform.colorTransform = new ColorTransform(0.35, 0.35, 0.35);
								plyHoverSelection = new Vec2(g, h);
							}
							else
							{
								tmpBitmap.transform.colorTransform = new ColorTransform(0.1, 0.1, 0.1);
							}
						}
					}
				}
			}
		}
		
		private function closeLevelSelectMenu():void
		{
			for each (var btn:Bitmap in lvlMenuBtns)
			{
				Main.layerObjs[1].removeChild(btn);
			}
			levelSelectMenuOpen = false;
			Main.layerObjs[1].removeChild(levelSelectTitleText);
			Main.layerObjs[1].removeChild(levelSelectMenu);
			Main.stg.removeEventListener(MouseEvent.MOUSE_OVER, handleLevelSelectMenuHover);
			Main.stg.removeEventListener(MouseEvent.MOUSE_DOWN, handleLevelSelectMenuDown);
		}
		
		public function handleStageClick(e:MouseEvent):void
		{
			if (e.target == optionsSprite && settingsMenu == null && plySelectionMenu == null)
			{
				settingsMenu = new SettingsMenu();
				settingsMenu.x = 0; settingsMenu.y = 0;
				Main.layerObjs[1].addChild(settingsMenu);
				settingsBtns = new Array(new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn());
				settingsBtns[0].x = 640 + 0 + 185 - 260; settingsBtns[0].y = 360 + 0+ 287 - 180;
				settingsBtns[1].x = 640 + 0 + 315 - 260; settingsBtns[1].y = 360 + 0 + 287 - 180;
				for each (var settingBtn:DisplayObject in settingsBtns) 
				{
					settingsMenu.addChild(settingBtn);
					settingBtn.visible = false;
				}
				Main.stg.addEventListener(MouseEvent.MOUSE_MOVE, handleLevelSelectMenuHover);
				Main.stg.addEventListener(MouseEvent.MOUSE_DOWN, handleLevelSelectMenuDown);
			}
			else if (e.target == returnSprite)
			{
				purgeEventListeners();
				Main.layerObjs[1].removeChild(optionsSprite);
				Main.layerObjs[1].removeChild(returnSprite);
				Main.layerObjs[1].removeChild(plySelectionBtn);
				if (settingsMenu != null)
					Main.layerObjs[1].removeChild(settingsMenu)
				if (plySelectionMenu != null)
					Main.layerObjs[1].removeChild(plySelectionMenu);
				Main.mainObj.loadMainMenu();
			}
			else if (e.target == plySelectionBtn && plySelectionMenu == null && settingsMenu == null )
			{
				plySelectionMenu = new Sprite()
				plySelectionMenu.addChild(new shipSelectionClass());
				plySelectionMenu.x = 620 - 260; plySelectionMenu.y = 360 - 241;
				Main.layerObjs[1].addChild(plySelectionMenu)
				plySelectionBtnIndicators = new Array(new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn());
				plySelectionBtnIndicators[0].visible = false; plySelectionBtnIndicators[1].visible = false;
				plySelectionMenu.addChild(plySelectionBtnIndicators[0]); plySelectionMenu.addChild(plySelectionBtnIndicators[1]); 
				plySelectionBtnIndicators[0].x = 185; plySelectionBtnIndicators[0].y = 412;
				plySelectionBtnIndicators[1].x = 315; plySelectionBtnIndicators[1].y = 412;
				
				plySelectionBtns = new Array();
				for (var i:int = 0; i < 3; i++) 
				{
					plySelectionBtns[i] = new Array();
					for (var j:int = 0; j < 4; j++) 
					{
						var tmpBitmap:Bitmap = new Player.plyShips[i][j];
						var underlayBitmap:Bitmap;
						switch(i)
						{
							case 0: 
								tmpBitmap.x = 93; 
								underlayBitmap = new plyUnderlay1Class();
								underlayBitmap.x = 90;
								break;
							case 1: 
								tmpBitmap.x = 208; 
								underlayBitmap = new plyUnderlay2Class();
								underlayBitmap.x = 205;
								break;
							case 2: 
								tmpBitmap.x = 335; 
								underlayBitmap = new plyUnderlay3Class();
								underlayBitmap.x = 332;
								break;
						}
						tmpBitmap.y = 34 + 90 * j;
						underlayBitmap.y = tmpBitmap.y - 3;
						plySelectionMenu.addChild(underlayBitmap);
						if (plySelected.x == i && plySelected.y == j)
							underlayBitmap.transform.colorTransform = new ColorTransform(0.9, 0.9, 0.9);
						else
							underlayBitmap.transform.colorTransform = new ColorTransform(0.1, 0.1, 0.1);
						plySelectionBtns[i][j] = underlayBitmap;
						plySelectionMenu.addChild(tmpBitmap);
					}
				}
				
				Main.stg.addEventListener(MouseEvent.MOUSE_MOVE, handleLevelSelectMenuHover);
				Main.stg.addEventListener(MouseEvent.MOUSE_DOWN, handleLevelSelectMenuDown);
			}
		}
		
		private function createLevelBtn(pos:Vec2, _text:String):Sprite
		{
			var tmp:Bitmap = new LevelSelector.levelSelectBtnClass();
			var tmpSpr:Sprite = new Sprite();
			tmpSpr.addChild(tmp);
			var tmpTxtField:TextField;
			tmpTxtField = new TextField();
			tmpTxtField.textColor = 0x202020;
			tmpTxtField.selectable = false;
			tmpTxtField.text = _text;
			tmpTxtField.autoSize = TextFieldAutoSize.CENTER;
			tmpTxtField.x = 58; tmpTxtField.y = 24;
			tmpTxtField.setTextFormat(levelSelectTextFormat);
			tmpSpr.addChild(tmpTxtField);
			tmpSpr.x = pos.x; tmpSpr.y = pos.y;
			addChild(tmpSpr);
			return tmpSpr;
		}
		
		private function connectBtns(pos1:Vec2, pos2:Vec2):void
		{
			createConnectorPort(pos1, pos2);
			createConnectorPort(pos2, pos1);
			
			var midPoint:Vec2 = new Vec2((pos1.x + pos2.x + 128) * 0.5, (pos1.y + pos2.y + 128) * 0.5);
			var midConnectorHolder:Sprite = new Sprite();
			var midConnector:Bitmap = new LevelSelector.levelSelectBtnMidClass();
			midConnector.y = -16; midConnector.scaleX = pos2.magnitude(pos1) - 108; midConnector.x = -midConnector.scaleX * 0.5;
			midConnectorHolder.addChild(midConnector);
			midConnectorHolder.x = midPoint.x; midConnectorHolder.y = midPoint.y;
			midConnectorHolder.rotation = pos1.toAngleDeg(pos2)+90;
			addChild(midConnectorHolder);
		}
		
		private function createConnectorPort(pos1:Vec2, pos2:Vec2):void
		{
			var ang1to2:Number = pos2.toAngle(pos1);
			var startconnectorHolder:Sprite = new Sprite();
			var startConnector:Bitmap = new LevelSelector.levelSelectBtnStartClass();
			startConnector.x = -8; startConnector.y = -16;
			startconnectorHolder.addChild(startConnector);
			startconnectorHolder.x = pos1.x + 64 + Math.sin(ang1to2) * 54;
			startconnectorHolder.y = pos1.y + 64 - Math.cos(ang1to2) * 54;
			startconnectorHolder.rotation = (ang1to2 / Math.PI) * 180 - 90;
			addChild(startconnectorHolder);
		}
		
		public function levelSelectTick(e:Event):void
		{
			Main.dynBckGrnd.starTick();
		}
		
		public function handleMouseWheel(e:MouseEvent):void
		{
			if (!mouseDown && !levelSelectMenuOpen && settingsMenu == null && plySelectionMenu == null)
			{
				var prevWorldScroll:Number = worldScrolled;
				worldScrolled += e.delta * 20;
				worldScrolled = worldScrolled < 0 ? 0 : (worldScrolled > maxWorldScroll ? maxWorldScroll : worldScrolled);
				y = worldScrolled;
				Main.dynBckGrnd.worldScrollIn(worldScrolled - prevWorldScroll);
			}
		}
		
		private function purgeEventListeners():void
		{
			Main.stg.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			Main.stg.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			Main.stg.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			Main.stg.removeEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			Main.stg.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			Main.stg.removeEventListener(MouseEvent.CLICK, handleStageClick);
			removeEventListener(MouseEvent.CLICK, handleClick);
			removeEventListener(Event.ENTER_FRAME, levelSelectTick);
			removeEventListener(Event.ENTER_FRAME, levelSelectTick);
			Main.dynBckGrnd.purgeOffScreenStars();
		}
		
		public function handleKeyDown(e:KeyboardEvent):void
		{
			/*if (e.keyCode == 27)
			{
				Main.mainObj.loadGame(selectedLevelId);
			}*/
		}
		
		public function handleMouseDown(e:MouseEvent):void
		{
			mouseDown = true;
		}
		
		public function handleMouseUp(e:MouseEvent):void
		{
			mouseDown = false;
		}
		
		public function handleMouseMove(e:MouseEvent):void
		{
			//trace("target:" + e.target + " yPos:" + e.localY + " globalYPos:" + e.target.localToGlobal(new Point(e.localX, e.localY)).y + " targetMouseY:" + e.target.mouseY);
			var globalYPos:Number = e.target.localToGlobal(new Point(e.localX, e.localY)).y;
			if (mouseDown && !isNaN(prevMouseYPos) && !levelSelectMenuOpen && settingsMenu == null && plySelectionMenu == null)
			{
				var prevWorldScroll:Number = worldScrolled;
				worldScrolled += (globalYPos - prevMouseYPos);
				worldScrolled = worldScrolled < 0 ? 0 : (worldScrolled > maxWorldScroll ? maxWorldScroll : worldScrolled);
				y = worldScrolled;
				Main.dynBckGrnd.worldScrollIn(worldScrolled - prevWorldScroll);
				//trace("target:"+e.target+" down:" + mouseDown + " previous:" + prevMouseYPos + " now:" + e.localY + " prevworldscroll:" + prevWorldScroll + " worldscrollnow:" + worldScrolled);
			}
			prevMouseYPos = globalYPos;
		}
	}

}