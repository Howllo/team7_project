local Background = {}

function Background.new()
    local group = display.newGroup()

    -- Get the actual size of the screen
    local screenWidth = display.actualContentWidth
    local screenHeight = display.actualContentHeight
    
    -- Image dimensions
    local imageWidth = 1782
    local imageHeight = 675

    -- Far background (static)
    local farback1 = display.newImageRect(group, "data/farback.png", imageWidth, imageHeight)
    farback1.x = screenWidth * 0.5
    farback1.y = screenHeight * 0.5

    local farback2 = display.newImageRect(group, "data/farback.png", imageWidth, imageHeight)
    farback2.x = farback1.x + imageWidth
    farback2.y = screenHeight * 0.5

    -- Starfield (moving and looping)
    local starfield1 = display.newImageRect(group, "data/starfield.png", imageWidth, imageHeight)
    starfield1.x = screenWidth * 0.5
    starfield1.y = screenHeight * 0.5

    local starfield2 = display.newImageRect(group, "data/starfield.png", imageWidth, imageHeight)
    starfield2.x = starfield1.x + imageWidth
    starfield2.y = screenHeight * 0.5

    local starfield3 = display.newImageRect(group, "data/starfield.png", imageWidth, imageHeight)
    starfield3.x = starfield2.x + imageWidth
    starfield3.y = screenHeight * 0.5

    -- Function to update the background
    function group:move(speed, backgroundSpeed)
        -- Move all starfield images
        starfield1.x = starfield1.x - speed
        starfield2.x = starfield2.x - speed
        starfield3.x = starfield3.x - speed

        -- Move far background images at a slower speed
        farback1.x = farback1.x - backgroundSpeed
        farback2.x = farback2.x - backgroundSpeed

        -- Loop the starfield images
        local starfieldResetPosition = screenWidth + (imageWidth - screenWidth) * 0.5
        if starfield1.x <= -imageWidth * 0.5 then
            starfield1.x = starfield3.x + imageWidth - 1
        end
        if starfield2.x <= -imageWidth * 0.5 then
            starfield2.x = starfield1.x + imageWidth - 1
        end
        if starfield3.x <= -imageWidth * 0.5 then
            starfield3.x = starfield2.x + imageWidth - 1
        end

        -- Loop the far background images
        if farback1.x <= -imageWidth * 0.5 then
            farback1.x = farback2.x + imageWidth - 1
        end
        if farback2.x <= -imageWidth * 0.5 then
            farback2.x = farback1.x + imageWidth - 1
        end
    end

    return group
end

return Background
