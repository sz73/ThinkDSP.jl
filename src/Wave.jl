struct Wave

    amps::Vector 
    time
    framerate::Number

    signal::Signal
    #isnoise::Bool

end


function Wave(s::Signal; t = 0, framerate = 44_100)

    if t == 0
        freq = s.freq
        if !(s.freq |> typeof <: Number)
            freq = minimum(s.freq)
        end

        t = inv(freq) * 5

    end

    dt = inv(framerate)

    r = range(0, t, step = dt)   

    amps = s.(r) # evaluating the signal

    if haskey(s.info, "WhiteNoise")
        amps = amps + WhiteNoise(s.info["WhiteNoise"])
    end

    if haskey(s.info, "GaussianNoise")
        amps = amps + GaussianNoise(s.info["GaussianNoise"])
    end

    if haskey(s.info, "BrownianNoise")
        amps = amps + BrownianNoise(s.info["BrownianNoise"])
    end

    if haskey(s.info, "PinkNoise")
        amps = amps + PinkNoise(s.info["PinkNoise"]...)
    end

    Wave(amps, r, framerate, s)

end


function wavplay(w::Wave)

    wavplay(w.amps, w.framerate)

end

@recipe function plot(w::Wave)

    if haskey(w.signal.info, "name")
        label --> (w.signal.info["name"] * " framerate $(w.framerate)")
    else
        label --> "Framerate $(w.framerate)"
    end
    yguide --> "Amplitude"
    xguide --> "Time in s"
    
    w.time, w.amps

end


function filter(w::Wave, type::Symbol, args...)

    amps = deepcopy(spec.amps)
    
    if type == :band
        @assert length(args) == 2
        @assert args[1] < args[2]
        amps[spec.fs .< args[1] ] .= 0 
        amps[spec.fs .> args[2] ] .= 0 
    end

    if type == :low
        @assert length(args) == 1
        amps[spec.fs .> args[1] ] .= 0 
    end

    if type == :high
        @assert length(args) == 1
        amps[spec.fs .< args[1] ] .= 0 
    end

    return Spectrum(amps, spec.fs, abs2.(amps), spec.signal, spec.framerate, spec.d)

end



