struct Spectrum

    amps
    fs
    power
    signal::Signal

    framerate::Number
    #start # start time of the signal
    d # length of the converted wave
end


struct Integrated_Spectrum

    cumulated
    fs

end

function Integrated_Spectrum(spec::Spectrum)

    cs = cumsum(spec.power)

    cs /= cs[end] #normalizing, so total power = 1

    return Integrated_Spectrum(cs, spec.fs)
end


function filter(spec::Spectrum, type::Symbol, args...)

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



@recipe function plot(spec::Spectrum;noise=false)


    #=
    if haskey(w.signal.info, "name")
        label --> (w.signal.info["name"]*" framerate $(w.framerate)")
    else
        label --> "Framerate $(w.framerate)"
    end
    =#
    xguide --> "Frequeny in Hz"
    legend --> :none
    if noise
        xscale --> :log10
        yscale --> :log10
        xlims --> [0.01,spec.fs[end]*10]
        ylims --> [(spec.power |> median) * 1e-5, (spec.power |> maximum) * 10 ]
        yguide --> "Power"
        spec.fs, abs.(spec.amps).^2
    else
        yguide --> "Amplitude"
        spec.fs, abs.(spec.amps)
    end

end


@recipe function plot(ispec::Integrated_Spectrum)


    #=
    if haskey(w.signal.info, "name")
        label --> (w.signal.info["name"]*" framerate $(w.framerate)")
    else
        label --> "Framerate $(w.framerate)"
    end
    =#
    grid --> true
    linewidth --> 3
    label --> :none
    yguide --> "Cumulative Fraction of Power"
    xguide --> "Frequeny in Hz"
    ispec.fs, ispec.cumulated

end
