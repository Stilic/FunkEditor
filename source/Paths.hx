package;

import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets;
import openfl.media.Sound;
import flixel.graphics.FlxGraphic;

using StringTools;

enum FileType
{
	TEXT;
	XML;
	JSON;
	IMAGE;
	SOUND;
	MUSIC;
	FONT(type:FontType);
}

enum FontType
{
	TTF;
	OTF;
}

class Paths
{
	static var imagesLoaded:Map<String, FlxGraphic> = [];
	static var soundsLoaded:Map<String, Sound> = [];

	public static function getPath(key:String, type:FileType, ?customDirectory:String)
	{
		var path:String = 'assets/';
		if (customDirectory != null)
			path += customDirectory;

		switch (type)
		{
			case TEXT:
				if (customDirectory == null)
					path += 'data';
				path += '/$key.txt';
			case XML:
				if (customDirectory == null)
					path += 'data';
				path += '/$key.xml';
			case JSON:
				if (customDirectory == null)
					path += 'data';
				path += '/$key.json';
			case IMAGE:
				if (customDirectory == null)
					path += 'images';
				path += '/$key.png';
			case SOUND | MUSIC:
				if (customDirectory == null)
				{
					if (type == MUSIC)
						path += 'music';
					else
						path += 'sounds';
				}
				path += '/$key.ogg';
			case FONT(type):
				if (customDirectory == null)
					path += 'fonts';
				path += '/$key';
				if (type == OTF)
					path += '.otf';
				else
					path += '.ttf';
		}

		return path;
	}

	inline public static function formatToSongPath(path:String)
	{
		return path.toLowerCase().replace('-', ' ');
	}

	public static function image(key:String, ?customDirectory:String)
	{
		var path:String = getPath(key, IMAGE, customDirectory);
		if (imagesLoaded.exists(path))
			return imagesLoaded.get(path);

		var graphic:FlxGraphic = FlxGraphic.fromAssetKey(path, false, null, false);
		graphic.persist = false;
		graphic.destroyOnNoUse = false;
		imagesLoaded.set(path, graphic);

		return graphic;
	}

	inline public static function getSparrowAtlas(key:String, ?customDirectory:String = 'images')
	{
		return FlxAtlasFrames.fromSparrow(image(key, customDirectory), Assets.getText(getPath(key, XML, customDirectory)));
	}

	public static function sound(key:String, isMusic:Bool = false, ?customDirectory:String)
	{
		var path:String = getPath(key, isMusic ? MUSIC : SOUND, customDirectory);
		if (soundsLoaded.exists(path))
			return soundsLoaded.get(path);

		var sound:Sound = Assets.getSound(path, false);
		soundsLoaded.set(path, sound);

		return sound;
	}

	public static function clearCache()
	{
		for (key => graphic in imagesLoaded)
		{
			imagesLoaded.remove(key);
			graphic.destroy();
		}
		soundsLoaded.clear();
	}
}
