
local k = {}

function k.load()
    key_delay_default = 0.1
    key_delay = key_delay_default

    key_timer = key_delay

    key_held = 0
    key_last = nil
end

function k.update(dt)
    key_timer = key_timer+dt

    if key_last then
        if love.keyboard.isDown(key_last) then
            key_held = key_held+dt
        else
            k.load()
        end
    end

    key_delay = key_held>2 and key_delay_default/2 or key_delay_default
end

function k.check_key(key)
    if not love.keyboard.isDown(key) then return false end

    if key_timer >= key_delay then
        key_timer = 0
        if key_last ~= key then
            key_last = key
            key_timer = -key_delay*2
        end
        return true
    end
    return false
end

return k
