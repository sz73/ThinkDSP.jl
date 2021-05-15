function Spectrum(w::Wave)

    amps = rfft(w.amps)
    fs = rfftfreq(length(w.amps), w.framerate)
    power = abs2.(amps)
    d = length(w.amps)
    
    return Spectrum(amps, fs, power,w.signal, w.framerate, d)

end

function Wave(spec::Spectrum)

    amps = irfft(spec.amps, spec.d)
    dt = inv(spec.framerate)
    t = range(0,step=dt,length = length(amps))
    #t = 0:dt:spec.d*dt
    return Wave(amps, t, spec.framerate, spec.signal)

end


# check type interference!
function +(w::Wave, wn::WhiteNoise)

    r = zeros(size(w.amps)) + wn

    return Wave(w.amps + r, w.time, w.framerate, w.signal)

end

function +(w::Wave, pn::PinkNoise)

    r = zeros(size(w.amps)) + pn

    return Wave(w.amps + r, w.time, w.framerate, w.signal)

end

function +(w::Wave, bn::BrownianNoise)

    r = zeros(size(w.amps)) + bn

    return Wave(w.amps + r, w.time, w.framerate, w.signal)

end


function +(w::Wave, gn::GaussianNoise)

    r = zeros(size(w.amps)) + gn

    return Wave(w.amps + r, w.time, w.framerate, w.signal)

end

function slope(spec::Spectrum)

    x = spec.fs[2:end] .|> log10
    y = spec.power[2:end] .|> log10
    X = [ones(length(x)) x]
    return X\y

end


Wave(wn::WhiteNoise;t=0.1,framerate=10_000) = wn(t,framerate)

Wave(gn::GaussianNoise;t=0.1,framerate=10_000) = gn(t,framerate)

Wave(bn::BrownianNoise;t=0.1,framerate=10_000) = bn(t,framerate)

Wave(pn::PinkNoise;t=0.1,framerate=10_000) = pn(t,framerate)






