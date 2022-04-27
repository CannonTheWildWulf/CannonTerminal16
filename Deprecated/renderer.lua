helpers=require"helpers"

colors = {
    {0x00, 0x00, 0x00},
    {0x5d, 0x25, 0x40},
    {0xef, 0x36, 0x4b},
    {0x67, 0x2c, 0x26},
    {0xff, 0x75, 0x2a},
    {0x6f, 0x5a, 0x1d},
    {0xff, 0xf3, 0x41},
    {0x21, 0x5a, 0x39},
    {0x49, 0xdc, 0x41},
    {0x2e, 0x60, 0x8e},
    {0x3b, 0xcc, 0xf8},
    {0x2b, 0x2b, 0x63},
    {0xa1, 0x4f, 0xf1},
    {0x71, 0x71, 0x71},
    {0xff, 0xff, 0xff},
    {0x29, 0x29, 0x29},
}

TILE_WIDTH = 32
TILE_HEIGHT = 24
TILE_SIZE = 8

PIXEL_WIDTH = TILE_WIDTH*TILE_SIZE
PIXEL_HEIGHT = TILE_HEIGHT*TILE_SIZE

SCREEN_SCALE = 3

SCREEN_WIDTH = PIXEL_WIDTH * SCREEN_SCALE
SCREEN_HEIGHT = PIXEL_HEIGHT * SCREEN_SCALE

function getRGB(ind)
    local col=colors[ind]
    return {col[1]/255,col[2]/255,col[3]/255}
end
function color(ind)
    local rgb=getRGB(ind)
    love.graphics.setColor(rgb[1],rgb[2],rgb[3]) 
end
function clearScreen(ind)
    local rgb=getRGB(ind)
    love.graphics.clear({rgb[1],rgb[2],rgb[3]}) 
end

function drawPixel(x, y, c) 
    color(c)
    love.graphics.rectangle("fill", x, y, 1, 1)
end
function drawRect(x1, y1, x2, y2, c)
    color(c)
    love.graphics.rectangle("fill", x1, y1, x2-x1, y2-y1)
end
function drawLine(x1,y1,x2,y2,c)
    color(c)
    love.graphics.line(x1,y1,x2,y2)
end

local tile = {
    0x00,0x11,0x22,0x33,
    0x00,0x11,0x22,0x33,
    0x44,0x55,0x66,0x77,
    0x44,0x55,0x66,0x77,
    0x88,0x99,0xaa,0xbb,
    0x88,0x99,0xaa,0xbb,
    0xcc,0xdd,0xee,0xff,
    0xcc,0xdd,0xee,0xff,
}

function drawTile(x, y, tileData)
    for yy=0,TILE_SIZE do 
        for xx=0,TILE_SIZE do
            local index = (yy * TILE_SIZE + xx)/2
            local byte = tileData[index]

            local c1 = 4
            local c2 = 3

            drawPixel(x+xx, y+yy, c1)
            drawPixel(x+xx+1, y+yy, c2)
        end
    end
end

function draw()
    -- for y=0,TILE_HEIGHT*TILE_SIZE do for x=0,TILE_WIDTH*TILE_SIZE do
    --     local col = 0x06
    --     drawPixel(x,y,colors[col])
    -- end end
    drawTile(0,0,tile)
end
