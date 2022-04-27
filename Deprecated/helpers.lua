local helpers={}

function helpers.min(val1,val2)
    return val1<val2 and val1 or val2
end

function helpers.max(val1,val2)
    return val1>val2 and val1 or val2
end

function helpers.clamp(val, min, max)
    return helpers.max(min, helpers.min(val, max))
end

return helpers