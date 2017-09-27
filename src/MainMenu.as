package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.*
	import flash.system.fscommand;
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class MainMenu extends Sprite
	{
		[Embed(source = "../Assets/UI/Custom Assets/main_menu.png")] private static const mainMenuClass:Class;
		[Embed(source = "../Assets/UI/Custom Assets/main_menu_button.png")] public static const mainMenuBtn:Class;
		
		private var mainMenuBitmap:Bitmap;
		private var mainMenuBtns:Array;
		private var btnHover:Array;
		private var mainMenuTickIntervalId:uint;
		
		public function MainMenu() 
		{
			mainMenuBitmap = new MainMenu.mainMenuClass();
			mainMenuBitmap.x = 380; mainMenuBitmap.y = 180;
			addChild(mainMenuBitmap);
			
			btnHover = new Array(false, false);
			mainMenuBtns = new Array(new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn(), new MainMenu.mainMenuBtn());
			mainMenuBtns[0].x = 380 + 170; mainMenuBtns[0].y = 180 + 222;
			mainMenuBtns[1].x = 380 + 330; mainMenuBtns[1].y = 180 + 222;
			mainMenuBtns[2].x = 380 + 185; mainMenuBtns[2].y = 180 + 287;
			mainMenuBtns[3].x = 380 + 315; mainMenuBtns[3].y = 180 + 287;
			for each (var btn:Bitmap in mainMenuBtns)
			{
				addChild(btn);
				btn.visible = false;
			}
			
			Main.stg.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseOver);
			addEventListener(MouseEvent.CLICK, handleMouseDown);
			mainMenuTickIntervalId = setInterval(mainMenuTick, 20);
		}
		
		private function purgeEventListeners():void
		{
			Main.stg.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseOver);
			removeEventListener(MouseEvent.CLICK, handleMouseDown);
		}
		
		public function handleMouseDown(e:MouseEvent):void
		{
			if (btnHover[0])
			{
				purgeEventListeners();
				Main.mainObj.loadLevelSelector();
			}
			else if (btnHover[1])
			{
				fscommand("quit");
			}
		}
		
		public function handleMouseOver(e:MouseEvent):void
		{
			if (e.localX >= 380 + 168 && e.localY >= 180 + 207 && e.localX <= 380 + 351 && e.localY <= 180 + 254)
			{
				for (var i:int = 0; i < 2; i++) 
				{
					mainMenuBtns[i].visible = true;
					mainMenuBtns[i + 2].visible = false;
				}
				btnHover[0] = true;
			}
			else if (e.localX >= 380 + 183 && e.localY >= 180 + 272 && e.localX <= 380 + 336 && e.localY <= 180 + 319)
			{
				for (var j:int = 0; j < 2; j++) 
				{
					mainMenuBtns[j].visible = false;
					mainMenuBtns[j + 2].visible = true;
				}
				btnHover[1] = true;
			}
			else
			{
				for (var k:int = 0; k < 4; k++) 
				{
					mainMenuBtns[k].visible = false;
				}
				btnHover[0] = false; btnHover[1] = false;
			}
		}
		
		public function handleKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == 27)
			{
				Main.stg.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				clearInterval(mainMenuTickIntervalId);
				Main.mainObj.loadLevelSelector();
			}
		}
		
		public function mainMenuTick():void
		{
			Main.dynBckGrnd.starTick();
		}
		
	}

}