function math.clamp(val,min,max)
    return math.min(max, math.max(val, min))
end

function bound_x(x)
    return math.clamp(x, 0, console.w)
end

function bound_y(y)
    return math.clamp(y, -1, console.h+1)
end

function string.insert(str1,str2,pos)
    return str1:sub(1, pos)..str2..str1:sub(pos+1)
end

function string.delete(str,pos)
    return str:sub(1, pos-1)..str:sub(pos+1,#str)
end

function table.pos(table,val)
    for i,t in ipairs(table) do
        if t==val then return i end
    end
    return -1
end

function string.pad(str,len,filler)
    for i=#str,len do
        str = filler..str
    end
    return str
end
