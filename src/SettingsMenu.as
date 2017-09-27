package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author ...
	 */
	public class SettingsMenu extends Sprite
	{
		[Embed(source = "../Assets/UI/Custom Assets/SettingsMenu/settingsMenu.png")] private static const settingsMenuClass:Class;
		[Embed(source = "../Assets/UI/Custom Assets/SettingsMenu/settingsSlider.png")] private static const settingsMenuSliderClass:Class;
		
		private var settingsMenuBck:Bitmap;
		private var settingsTextFormat:TextFormat;
		private var settingsSFXText:TextField;
		private var settingsMusicText:TextField;
		public var settingsSFXSlider:Bitmap;
		public var settingsMusicSlider:Bitmap;
		
		public function SettingsMenu() 
		{
			settingsMenuBck = new settingsMenuClass();
			settingsMenuBck.x = 640-260; settingsMenuBck.y = 360-180;
			addChild(settingsMenuBck);
			settingsTextFormat = new TextFormat();
			settingsTextFormat.size = 24;
			settingsTextFormat.color = new ColorTransform(0.1, 0.1, 0.1);
			settingsTextFormat.font = "prototype";
			settingsTextFormat.align = TextFormatAlign.CENTER;
			settingsSFXSlider = new settingsMenuSliderClass(); addChild(settingsSFXSlider);
			settingsSFXSlider.x = settingsMenuBck.x + 167 - 14+244; settingsSFXSlider.y = settingsMenuBck.y + 158 - 19;
			settingsMusicSlider = new settingsMenuSliderClass(); addChild(settingsMusicSlider);
			settingsMusicSlider.x = settingsMenuBck.x + 167 - 14+244; settingsMusicSlider.y = settingsMenuBck.y + 222 - 19;
			updateSFXSlider(100);
			updateMusicSlider(100);
		}
		
		public function updateSFXSlider(percentage:Number):void
		{
			Main.sfxSndTrns.volume = (percentage / 100);
			if (settingsSFXText != null)
				removeChild(settingsSFXText)
			settingsSFXText = new TextField();
			settingsSFXText.text = percentage + "%";
			settingsSFXText.setTextFormat(settingsTextFormat);
			settingsSFXText.selectable = false;
			settingsSFXText.x = 640-260+438-25; settingsSFXText.y = 360-180+142;
			addChild(settingsSFXText);
		}
		
		public function updateMusicSlider(percentage:Number):void
		{
			Main.musicSndTrns.volume = (percentage / 100);
			if (settingsMusicText != null)
				removeChild(settingsMusicText)
			settingsMusicText = new TextField();
			settingsMusicText.text = percentage + "%";
			settingsMusicText.setTextFormat(settingsTextFormat);
			settingsMusicText.selectable = false;
			settingsMusicText.x = 640-260+438-25; settingsMusicText.y = 360-180+208;
			addChild(settingsMusicText);
		}
	}

}