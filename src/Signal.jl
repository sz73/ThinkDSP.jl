struct Signal

    freq::Union{Vector,Number}
    amp::Union{Vector,Number}
    func::Union{Vector,Function}
    offset::Union{Vector,Number}
    info::Dict

    function Signal(fr, a, f = sin, o=0, info = Dict(); name::String = "")

        if !isempty(name)
            info["name"] = name
        end

        new(fr, a, f, o, info)

    end

end


function Signal(;freq, amp, f = sin, offset=0, info = Dict(), name::String = "")

    if !isempty(name)
        info["name"] = name
    end

    Signal(freq, amp, f, offset, info)

end


function latexify(s::Signal)


    name = "signal"

    if haskey(s.info, "name")
        name = s.info["name"]
    end

    if s.func |> typeof <: Function
        s = L"%$(name)(t)=%$(s.func)(2π %$(s.freq) (t + %$(s.offset) s)) · %$(s.amp)"
    else

        s1 = L"%$(name)(t)="
        s2 = [
            L" %$(s.func[i])(2π %$(s.freq[i]) (t + %$(s.offset[i]) s)) · %$(s.amp[i]) +"
            for _ = 1:length(s.func)
        ]
        s3 = *(s2...)


        s = s1 * s3[1:end-2]

    end
    return s


end


function (s::Signal)(t)

    

    if typeof(s.func) <: Function
        
        d = s.func(s.freq * (t.+ s.offset) * 2 * pi ) * s.amp
    
    else
        @assert length(s.freq) == length(s.amp) == length(s.func) # check if e.g. same # functions and freqs are given

        d = sum(
            s.func[i](s.freq[i] * t * 2 * pi + s.offset[i]) * s.amp[i] for
            i = 1:length(s.func) )
    end

    return d

end

function +(s1::Signal, s2::Signal)

    frequencies = vcat([s1.freq, s2.freq]...)
    amps = vcat([s1.amp, s2.amp]...)
    offsets = vcat([s1.offset, s2.offset]...)
    functions = vcat([s1.func, s2.func]...)
    dicts = merge(s1.info,s2.info)
    return Signal(freq=frequencies, amp = amps, offset=offsets, f = functions, info=dicts)

end

function *(n::Number, s::Signal)

    amp = s.amp*n
    return Signal(s.freq,amp,s.func,s.offset,s.info)


end
