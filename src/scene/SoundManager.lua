local SoundManager = {}

-- Sound effect storage
SoundManager.sounds = {
    collision = audio.loadSound("data/8bitCrash.mp3"),
 }

-- Function to play collision sound
function SoundManager:playCollisionSound()
    if self.sounds.collision then
        audio.play(self.sounds.collision)
    end
end

-- Function to play a generic sound (if you want more flexibility)
function SoundManager:playSound(soundName)
    local sound = self.sounds[soundName]
    if sound then
        audio.play(sound)
    end
end

-- Add more functions here for different sound effects, e.g., background music, victory sound, etc.

return SoundManager
