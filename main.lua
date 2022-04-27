
editor_pal = {
    0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
}

mem_map = {

}

function love.load()
    love.graphics.setDefaultFilter("nearest")

    -- Keys
    keyboard = require"keyboard"
    keyboard.load()

    -- Window and default sprites
    screen = {
        x = 0,
        y = 0,
        scale = 1,
    }

    require"utils"
    require"graphics"
    love.window.setMode(window.w, window.h, {resizable=true})
    love.resize(window.w, window.h)

    love.mouse.setVisible(false)
    cursors = love.image.newImageData("assets/cursors.png")

    love.window.setIcon(love.image.newImageData("assets/terminal_icon.png"))
    love.window.setTitle("Terminal-16")

    font = love.image.newImageData("assets/font.png")

    -- Requirements
    codestate = require"editor_code"
    drawstate = require"editor_draw"

    current_scene = codestate
end

fps_cap = 61
window = {
    w = 640,
    h = 480,
}

console = {
    w = 256,
    h = 192,
}

mouse = {
    x = 0,
    y = 0,
    spr = 0,
    col = {
        {16,1,15},
        {16,1,15},
        {16,1,15},
        {16,1,15},
        {16,3,7},
        {16,15,15},
        {16,14,15},
        {16,15,15},
    },
    onscreen = false,
}

screen_pixels={}
for i=1,console.w*console.h do table.insert(screen_pixels,0) end

code = {}

local code_temp=([[
-- main
 
function _onready()
    gamestate = 0
    init_menu()
end
 
-- [helpers]
 
function lerp(val, to, by)
    return val<to and min(val+by, to) or val>to and max(val-by, to) or val
end
 
]]):upper()

code_temp:gsub("[^\n]+",function(v)
    table.insert(code,v)
end)

function love.resize(w,h)
    screen.scale = math.floor(math.min(w,h) / console.w + 0.5)
    screen.x = w/2 - (screen.scale*console.w)/2
    screen.y = h/2 - (screen.scale*console.h)/2
end

time = 0
function love.update(dt)
    time = time+dt

    -- Mouse
    local mx,my = love.mouse.getPosition()
    mx = math.floor((mx-screen.x)/screen.scale)
    my = math.floor((my-screen.y)/screen.scale)

    mouse.lb = love.mouse.isDown(1)
    mouse.rb = love.mouse.isDown(2)
    mouse.mb = love.mouse.isDown(3)
    mouse.any_butt = mouse.lb or mouse.rb or mouse.mb

    mouse.onscreen = mx==bound_x(mx) and my==bound_y(my)
    mouse.x,mouse.y = mx,my
    
    mouse.spr = 0

    -- Keys
    keyboard.update(dt)

    -- Update
    if current_scene.update then current_scene.update(dt) end
    if current_scene.keypressed then current_scene.keypressed() end
    if current_scene.textinput then current_scene.textinput() end

    -- Mouse
    if mouse.spr == 1 or mouse.spr == 2 then
        if mouse.any_butt then mouse.spr = 3 end
    end

    -- Draw
    if current_scene.draw then current_scene.draw(time) end
    
end

function love.draw()
    for i=1,256*192 do
        local x,y = screen.x+(i%console.w)*screen.scale, screen.y+(i/console.w)*screen.scale
        color(screen_pixels[i])
        love.graphics.rectangle("fill",x,y,screen.scale,screen.scale)
    end
end

function love.draw()
    love.graphics.clear()

    for x=1,console.w-1 do for y=0,console.h do
        local pixel = screen_pixels[x+y*console.w]
        local dx,dy = screen.x+(x*screen.scale), screen.y+(y*screen.scale)

        color(pixel)
        love.graphics.rectangle("fill", dx, dy, screen.scale,screen.scale)
    end end
end

local keys_font=" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
key_states={}
for i=1,#keys_font do
    key_states[keys_font:sub(i,i)]=false
end

-- function love.keypressed(key)
--     if key_timer >= key_delay then
--         key_timer = 0
--         if key_last ~= key then
--             key_last = key
--             key_timer = -key_delay*2
--         end
--         if current_scene.keypressed then current_scene.keypressed(key) end
--     end
-- end

-- function love.textinput(key)
--     if key_timer >= key_delay then
--         key_timer = 0
--         if key_last ~= key then
--             key_last = key
--             key_timer = -key_delay*2
--         end
--         if current_scene.textinput then current_scene.textinput(key) end
--     end
-- end

function love.wheelmoved(x,y)
    if current_scene.wheelmoved then current_scene.wheelmoved(x,y) end
end
