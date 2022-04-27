local s = {}
s.code = code or {}

function cursor_pos(line,row)
    return {code_l + row*4, code_t + line*6}
end

s.edit_line = 1
s.edit_row = 0

s.scroll = {
    x = 0,
    y = 0,
}

function s.update()
    -- Update edit pos

end

function s.draw()
    local line_offset = s.scroll.y*4
    clear_screen(1)

    local code_l = 32
    local code_t = 7

    -- Draw edit rect
    if time%0.5 < 0.25 then
        local edit_l,edit_t = code_l+s.edit_row*4,code_t+s.edit_line*6
        draw_rectangle(edit_l, edit_t, edit_l+3, edit_t+5, 7)
    end
    
    -- Draws the code
    for i,line in ipairs(s.code) do
        local drawline = line
        local index = string.pad(tostring(i-1),3," ")

        -- Draw line number
        draw_text(index, 12, code_t+i*6, 15)

        -- Draw line
        draw_text(drawline, code_l, code_t+i*6, 15)
    end

    draw_linev(11,181,29,16)
    draw_rectangle(0,0,console.w,9,14)
    draw_rectangle(0,console.h-9,console.w,console.h,14)

    plot_imgdata_part(cursors,mouse.x,mouse.y,mouse.spr%4*10,math.floor(mouse.spr/4)*10,9,9,mouse.col[mouse.spr+1])
end

function s.keypressed(key)
    local key_right,key_left = keyboard.check_key("right"), keyboard.check_key("left")
    local key_down,key_up = keyboard.check_key("down"), keyboard.check_key("up")

    if keyboard.check_key("backspace") then
        if s.edit_row > 0 then
            s.code[s.edit_line] = string.delete(s.code[s.edit_line],s.edit_row)
            s.edit_row = s.edit_row-1
        elseif s.edit_line > 1 then
            s.edit_line = s.edit_line-1
            s.edit_row = #s.code[s.edit_line]

            local str=s.code[s.edit_line]
            s.code[s.edit_line]=string.insert(s.code[s.edit_line],s.code[s.edit_line+1],#s.code[s.edit_line])
            table.remove(s.code,s.edit_line+1)

        end
    end

    if keyboard.check_key("delete") then
        if s.edit_row <= #s.code[s.edit_line] then
            s.code[s.edit_line] = string.delete(s.code[s.edit_line],s.edit_row+1)
        elseif s.edit_line < #s.code then

        end
    end

    if key_down then 
        -- Move down one line
        if s.edit_line == #s.code then s.edit_row = #s.code[s.edit_line] 
        else s.edit_line = s.edit_line + 1 end
    elseif key_up then 
        -- Move up one line
        if s.edit_line == 1 then s.edit_row = 0 
        else s.edit_line = s.edit_line - 1 end

    -- Move left and right
    elseif key_right or key_left then 
        s.edit_row = s.edit_row + (key_right and 1 or -1)

        -- Change line
        if s.edit_row < 0 then 
            s.edit_line = s.edit_line - 1
            if s.code[s.edit_line] then s.edit_row = #s.code[s.edit_line] end
        elseif s.edit_row > #s.code[s.edit_line] then
            s.edit_line = s.edit_line + 1
            if s.code[s.edit_line] then s.edit_row = 0 end
        end
    end

    s.edit_line = math.clamp(s.edit_line, 1, #s.code)
    s.edit_row = math.clamp(s.edit_row, 0, #s.code[s.edit_line])

end

return s