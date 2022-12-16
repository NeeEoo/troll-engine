package;

import FreeplayState;
import sowy.*;
import flixel.system.FlxSound;

class JukeboxState extends MusicBeatState
{
    var options:Array<SowyTextButton> = [];
	public var voices = new FlxSound();
	static public var instance:JukeboxState; 
    var curSelected:Int = 0;

    override function create(){
		instance = this;

		//// Load the songs!!!

		for (i in CoolUtil.coolTextFile(Paths.txt('freeplaySonglist')))
		{
			if (i != null && i.length > 0){
				var song:Array<String> = i.split(":");
				/*
					var isLocked = false;
					if (isLocked)
						return;
				*/
				addSong(song[0], null);
					
			}
		}

		#if MODS_ALLOWED
		for (mod in Paths.getModDirectories())
		{
			Paths.currentModDirectory = mod;

			for (i in CoolUtil.coolTextFile(Paths.modsTxt('freeplaySonglist')))
			{
				if (i != null && i.length > 0){
					var song:Array<String> = i.split(":");
					/*
                        var isLocked = false;
                        if (isLocked)
                            return;
                    */
					addSong(song[0], null);
				}
			}
		}
		Paths.currentModDirectory = '';
		#end

        super.create();

		FlxG.autoPause = false;

		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
    }

    override function update(e){
        if (controls.BACK)
            MusicBeatState.switchState(new GalleryMenuState());
        super.update(e);
    }

	public function addSong(songName:String, ?folder:String):SowyTextButton
	{
		var folder = folder != null ? folder : Paths.currentModDirectory;

		var button = new SowyTextButton(0, 0, 0, songName, 24, function(){
			playSong(songName, folder);
        });
		button.y = 32 * options.push(button);
		add(button);

		////

		return button;
	}

    /////
    //var curSong;

    public static function playSong(songName:String, ?folder = "")
    {
		var prevPath = Paths.currentModDirectory;
		Paths.currentModDirectory = folder;

		FlxG.sound.playMusic(Paths.inst(songName), 1, true);
		/*
		if (instance != null)
			instance.voices.loadEmbedded(Paths.voices(songName), true, false);
		*/

		Paths.currentModDirectory = prevPath;
    }

    /* useless!!!!
    public static function stopSong()
    {

    }
    */
}

class JukeboxSongData{
    public var name:String;
	public var dir:String;
	public var icon:String;
}