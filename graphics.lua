-- temp graphics file (add mem support)

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

color_replace = {
    {0, 1, 0},
    {0x00, 0x00, 0x00},
    {0x7f, 0x7f, 0x7f},
    {0xff, 0xff, 0xff},
}

function getRGB(ind)
    local col=colors[ind]
    return {col[1]/255,col[2]/255,col[3]/255}
end

function color(c)
    c=c or 1
    local rgb=getRGB(c)
    love.graphics.setColor(rgb[1],rgb[2],rgb[3]) 
end

function draw_pixel(x,y,c)
    c=c or 1
    screen_pixels[bound_x(x)+bound_y(y)*console.w]=c
end

function draw_linev(y1,y2,x,c)
    c=c or 1
    for y=y1,y2 do
        draw_pixel(x,y,c)
    end
end

function draw_lineh(x1,x2,y,c)
    c=c or 1
    for x=x1,x2 do
        draw_pixel(x,y,c)
    end
end

function draw_rectangle(x1,y1,x2,y2,c)
    c=c or 1
    for y=y1,y2 do
        draw_lineh(x1,x2,y,c)
    end
end

function clear_screen(c)
    c=c or 1
    for i=1,console.w*console.h do screen_pixels[i]=c end
end

function draw_text(str,x,y,c)
    c=c or 1
    
    line_x=x or 1
    x,y,c=math.floor(x),math.floor(y),math.floor(c)

    str=tostring(str or "")
    for i=1,#str do
        local char=str:sub(i,i)
        local charcode=string.byte(char)

        for xx=0,3 do for yy=0,5 do
            local r=font:getPixel(charcode%16*4+xx, math.floor(charcode/16)*6+yy)
            if r>0 then draw_pixel(x+xx, y+yy, c) end
        end end

        x = x+4
        if char=="\n" then
            x = line_x
            y = y+6
        end
    end
end

function plot_imgdata_part(img,x,y,l,t,w,h,pal)
    for xx=0,w do for yy=0,h do
        local r,g,b,a=img:getPixel(l+xx,t+yy)

        if a>0 then
            draw_pixel(x+xx, y+yy, pal[math.floor(r + g + 1)])
        end
    end end 
end
