-- Requirements 
local audio = require("audio")

local SoundManager = {}

-- Sound effect storage
SoundManager.sounds = {
    playerDamage = audio.loadSound("data/sound/sfx/PlayerDamage.mp3"),
    mainMenuOST = audio.loadSound("data/sound/music/MainMenuMusic.wav"),
    ingameOST = audio.loadSound("data/sound/music/InGameMusic.wav"),
    playerShoot = audio.loadSound("data/sound/sfx/PlayerShoot.wav"),
    gameStart = audio.loadSound("data/sound/music/GameStart.wav"),
    bayonetShoot = audio.loadSound("data/sound/sfx/BayonetShoot.wav"),
    bayonetDamage = audio.loadSound("data/sound/sfx/BayonetDamage.wav"),
    bayonetOST = audio.loadSound("data/sound/music/BayonetMusic.wav"),
    enemyDamage = audio.loadSound("data/sound/sfx/EnemyDamage.wav"),
 }

-- Function to play collision sound
function SoundManager:playCollisionSound()
    if self.sounds.collision then
        audio.play(self.sounds.playerDamage)
    end
end

-- Function to play a generic sound (if you want more flexibility)
--
-- @channel (int):  1 = user interface, 2 = sound effects player, 3 = background music scene 1,
--                  4 = sound effect enemy,  10 = background music, 11 = Boss Music
--
-- @soundVolume (float): 0.0 to 1.0
--
-- @loop (int): -1 = loop forever, 0 = play once, 1 = play twice, etc.
-- 
-- @fadeTime (int): time in milliseconds to fade in 
--
function SoundManager:playSound(soundName, channel, soundVolume, loop, fadeTime)
    local sound = SoundManager.sounds[soundName]
    if sound then
        if channel == 2 or channel == 4 then
            audio.stop({channel = channel})
        end

        audio.setVolume(soundVolume, {channel = channel})
        audio.play(sound, {channel = channel, loops = loop, fadein = fadeTime})
    end
end

-- Function to stop a specific audio channel
--
-- @channel: 1 = user interface, 2 = sound effects, 3 = background music
--
-- @fade (boolean): true = fade out, false = stop immediately
--
-- @fadeTime (int): time in milliseconds to fade out
--
function SoundManager:stopAudioChannel(channel, fade, fadeTime)
    if fade then
        if fade then
            audio.fadeOut({channel = channel, time = fadeTime})
        else
            audio.stop({channel = channel})
        end
    end
end

-- Add more functions here for different sound effects, e.g., background music, victory sound, etc.

return SoundManager