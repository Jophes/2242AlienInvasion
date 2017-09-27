package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Joseph Higgins
	 */
	public class HealthBar extends Sprite
	{
		[Embed(source = "../Assets/UI/Custom Assets/healthbarinner.png")] public static const healthInnerClass:Class;
		[Embed(source = "../Assets/UI/Custom Assets/healthbarouter.png")] public static const healthOuterClass:Class;
		
		public var healthInnerBitmap:Bitmap;
		public var healthOuterBitmap:Bitmap;
		public var healthText:TextField;
		
		private var maxHealth:int;
		
		public function HealthBar(health:int) 
		{
			maxHealth = health;
			healthOuterBitmap = new healthOuterClass();
			healthOuterBitmap.x = -45; healthOuterBitmap.y = -7;
			addChild(healthOuterBitmap);
			healthInnerBitmap = new healthInnerClass();
			healthInnerBitmap.x = -44; healthInnerBitmap.y = -6;
			healthInnerBitmap.scaleX = 88;
			addChild(healthInnerBitmap);
			/*healthText = new TextField();
			healthText.text = health + "/" + maxHealth;
			healthText.defaultTextFormat = LevelSelector.healthBarFormat;
			healthText.autoSize = TextFieldAutoSize.CENTER;
			healthText.y = -9; healthText.x = -20;
			addChild(healthText);*/
		}
		
		public function setHealth(health:uint):void
		{
			healthInnerBitmap.scaleX = (health / maxHealth) * 88;
			if (health <= 0 || health > maxHealth)
				healthInnerBitmap.visible = false;
			/*removeChild(healthText);
			healthText = new TextField();
			healthText.text = health + "/" + maxHealth;
			healthText.defaultTextFormat = LevelSelector.healthBarFormat;
			healthText.autoSize = TextFieldAutoSize.CENTER;
			healthText.y = -9; healthText.x = -20;
			addChild(healthText);*/
		}
		
	}

}