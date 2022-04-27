renderer = require"renderer"
helpers = require"helpers"

local drawRect, drawLine, clearScreen = drawRect, drawLine, clearScreen
local PIXEL_WIDTH, PIXEL_HEIGHT = PIXEL_WIDTH, PIXEL_HEIGHT

love.graphics.setDefaultFilter("nearest", "nearest")

FONT_KEY = " !\"#$%&'()*+,-./0123456789:;<=>?@abcdefghijklmnopqrstuvwxyz[\\]^_`ABCDEFGHIJKLMNOPQRSTUVWXYZ{|}~"
FONT = love.graphics.newImageFont('assets/font_mono.png', FONT_KEY)
love.graphics.setFont(FONT)

TEXT_EDITOR = 1
IMAGE_EDITOR = 2

function love.load()
    -- Key values
    key_timer = 0
    key_held_time = 0
    key_delay_default = 0.1
    key_delay = key_delay_default

    tframe = 0
    code_pos = 1
    code_offset = 0
end

function draw()
    clearScreen(1)
    draw_text_editor()
end

function update(dt)
    tframe = tframe+dt*55
    frame = tframe%30

    -- Updates
    update_text_editor()

    -- Keyboard stuff
    key_timer = key_timer+dt

    if key_last then
        if love.keyboard.isDown(key_last) then
            key_held_time = key_held_time+dt
        else
            key_held_time = 0
            key_last = nil
            key_timer = key_delay
        end
    end

    if key_held_time>2 then
        key_delay = key_delay_default/2
    else
        key_delay = key_delay_default
    end

end

-- [Text Editor]
local CODE_STRING = [[
--main

function _onready()
    gamestate = 0
    init_menu()
end

-- [helpers]

function lerp(val, to, by)
    return val<to and min(val+by, to) or val>to and max(val-by, to) or val
end
]]

local keywords = {
    "and", "break", "do", "else", 
    "elseif", "end", "false", "for", 
    "function", "if", "in", "local", 
    "nil", "not", "or", "repeat", 
    "return", "then", "true", "until", 
    "while", 
}

local separators = {
    " ", "\n", "\t", "\"", "\'", "+", "-", "/", "%", "^", "#", " = ", "~", "<", ">", 
    "(", ")", "{", "}", "[", "]", ";", ":", ", ", "."
}

local functions = {
    "drawRect", "drawLine", "clearScreen", 
    "min", "max", "clamp"
}


-- TEST STRING
-- 123456789AB

-- Update Text Editor
function update_text_editor()
    -- Move selection
    if key_held("right") then code_pos = code_pos+1 end
    if key_held("left") then code_pos = code_pos-1 end

    -- Editing Code
    if key_held("backspace") and code_pos>1 then 
        CODE_STRING = CODE_STRING:sub(0, code_pos-2)..CODE_STRING:sub(code_pos, #CODE_STRING)
        code_pos = code_pos-1 
    end

    if key_held("delete") and code_pos<#CODE_STRING then
        CODE_STRING = CODE_STRING:sub(0, code_pos-1)..CODE_STRING:sub(code_pos+1, #CODE_STRING)
    end

    for i = 1, #FONT_KEY do
        local key = string.sub(string.char(string.byte(FONT_KEY)), i, i+1)

        if key_held("a") then
            CODE_STRING=string.insert(CODE_STRING, "a", code_pos)
            code_pos = code_pos + 1
        end
    end

    code_pos = helpers.clamp(code_pos, 1, #CODE_STRING)
end

-- Draw Text Editor
function draw_text_editor()

    -- Code Editor
    local lines = split(string.upper(CODE_STRING), "\n")
    
    local length = #lines
    local code_l, code_t = 32, 13
    local debug_r = 27

    color(15)

    -- Draw line data
    for i = 0, length-1 do
        love.graphics.print(i, debug_r-(#tostring(i)*4), code_t+6*i)
    end

    -- Draw line
    local do_select, full_length = true, 0
    for i = 0, length-1 do

        -- Get values
        local line = lines[i+1]
        full_length = full_length+#line

        local line_t = code_t+i*6

        -- Draw selection
        if frame<15 and do_select and full_length >= code_pos then
            local l = code_l + (#line-1 + code_pos-full_length) * 4

            drawRect(l, line_t, l+4, line_t+6, 7)
            do_select = false
        end

        -- Print the code
        color(15)
        love.graphics.print(line, code_l, line_t)
    end
    
    -- Side Bars
    local side_col, bar_col = 14, 16
    drawLine(debug_r+2, 10, debug_r+2, 182, bar_col)
    drawRect(0, 0, PIXEL_WIDTH, 9, side_col)
    drawRect(0, PIXEL_HEIGHT-9, PIXEL_WIDTH, PIXEL_HEIGHT, side_col)

    color(16)
    love.graphics.print("Lines:"..#lines, 2, PIXEL_HEIGHT-7)
end

function split(str, sep)
    local temp = {}

    local i, j = 0, 1
    while true do
        i = string.find(str, sep, i+1)
        if i == nil then break end
        table.insert(temp, string.sub(str, j, i))
        j = i+1
    end

    return temp
end

function key_pressed(key)
    return love.keyboard.isDown(key)
end

function key_held(key)
    if not key then return false end

    if key_timer >= key_delay and love.keyboard.isDown(key) then
        key_timer = 0
        if key_last ~= key then
            key_last = key
            key_timer = -key_delay*2
        end
        return true
    end
end

function string.insert(str1, str2, pos)
    return str1:sub(1, pos-1)..str2..str1:sub(pos)
end