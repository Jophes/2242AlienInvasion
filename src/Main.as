package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class Main extends Sprite 
	{
		// Static vars to be used from other classes
		public static const starTypeOffsets:Array = new Array(0.25, 0.1, 0.05);
		public static var dimensions:Vec2;
		public static var PI2:Number = Math.PI * 2;
		public static var stg:Object;
		public static var mainObj:Main;
		public static var musicSndTrns:SoundTransform;
		public static var sfxSndTrns:SoundTransform;
		public static var selectedShip:Vec2 = new Vec2(0, 0);
		
		public static var dynBckGrnd:DynSpace;
		
		public static var layerObjs:Array;
		
		private var pageLoaded:DisplayObject;
		
		[Embed(source = "../Assets/UI/Parts/cursor_pointer3D.png")] private const cursorClass:Class;
		public static var cursor:Bitmap;
		
		[Embed(source = "../Assets/Fonts/Prototype.ttf", fontName="prototype")] public static const prototypeFont:Class;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Mouse.hide();
			musicSndTrns = new SoundTransform(1, 0);
			sfxSndTrns = new SoundTransform(1, 0);
			
			layerObjs = new Array();
			// Main Layer
			layerObjs.push(new Sprite());
			addChild(layerObjs[0]);
			// UI Layer
			layerObjs.push(new Sprite());
			addChild(layerObjs[1]);
			// Mouse Layer
			layerObjs.push(new Sprite());
			addChild(layerObjs[2]);
			
			mainObj = this;
			stg = stage;
			
			dimensions = new Vec2(stage.stageWidth, stage.stageHeight);
			
			dynBckGrnd = new DynSpace();
			layerObjs[0].addChild(dynBckGrnd);
			
			cursor = new cursorClass();
			layerObjs[2].addChild(cursor);
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			loadMainMenu();
			//loadLevelSelector();
		}
		
		public function handleMouseMove(e:MouseEvent):void
		{
			var globalPoint:Point = e.target.localToGlobal(new Point(e.localX, e.localY));
			cursor.x = globalPoint.x;
			cursor.y = globalPoint.y;
		}
		
		public function loadMainMenu():void
		{
			if (pageLoaded != null)
				layerObjs[0].removeChild(pageLoaded);
			pageLoaded = new MainMenu();
			layerObjs[0].addChild(pageLoaded);
		}
		
		public function loadLevelSelector():void
		{
			if (pageLoaded != null)
				layerObjs[0].removeChild(pageLoaded);
			pageLoaded = new LevelSelector();
			layerObjs[0].addChild(pageLoaded);
		}
		
		public function loadGame(_levelId:uint):void
		{
			if (pageLoaded != null)
				layerObjs[0].removeChild(pageLoaded);
			pageLoaded = new Game(_levelId);
			layerObjs[0].addChild(pageLoaded);
		}
		
		// Useful static math functions
		public static function lerp(value:Number, targetValue:Number, fraction:Number):Number
		{ return value + (targetValue - value) * fraction; }
		
	}
	
}