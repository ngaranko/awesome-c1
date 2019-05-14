local shape = {}

function shape.full_round_rect(cr,width,height,dir,radius)
    -- fully rounds off rectangles in one direction.
    -- produces something like a rounded trapezoid
    -- dir: 'top' rounds top 2 corners, 'left' rounds left 2, etc
    -- valid values: 'top', 'left', 'bottom', 'right'
    -- radius: optional, allows you to not fully round the corners
    local rad
    if dir == 'top' or dir == 'bottom' then
        rad = radius or height
        if rad > height then
           rad = height
        end
        -- account for thin rectange
        if rad > width/2 then
           rad = width/2
        end

    elseif dir == 'left' or dir == 'right' then
        rad = radius or width
        -- account for short rectange
        if rad > height/2 then
           rad = height/2
        end
        if rad > width then
           rad = width
        end    
    end

    -- Top left
    if dir == 'left' or dir == 'top' then
        cr:arc( rad, rad, rad, math.pi, 3*(math.pi/2))
    else
        cr:move_to(0,0)
    end

    -- Top right
    if dir == 'right' or dir == 'top' then
        cr:arc( width-rad, rad, rad, 3*(math.pi/2), math.pi*2)
    else
        cr:line_to(width, 0)
    end

    -- Bottom right
    if dir == 'right' or dir == 'bottom' then
        cr:arc( width-rad, height-rad, rad, math.pi*2 , math.pi/2)
    else
        cr:line_to(width, height)
    end

    -- Bottom left
    if dir == 'left' or dir == 'bottom' then
        cr:arc( rad, height-rad, rad, math.pi/2, math.pi)
    else
        cr:line_to(0, height)
    end

    cr:close_path()
end

return shape
