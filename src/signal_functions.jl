function triangle(t, a = 1)
    abs(2 * a - 2 * mod(abs(2 * t/(2*pi)), 2)) - a
end


function squarewave(t, a = 1)
    t = 2*t
    mt = mod(t/(2*pi),2)

    if 0 <= mt <= 1
        return -a
    elseif 1 < mt <= 2
        return a
    end

end
