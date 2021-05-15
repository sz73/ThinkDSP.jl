module ThinkDSP


using FFTW
using LaTeXStrings
using LinearAlgebra
using Statistics
using RecipesBase

import Base: +, filter, *
import Latexify: latexify
import WAV: wavplay


include("Signal.jl")
include("Spectrum.jl")
include("Wave.jl")
include("Noise.jl")

include("struct_functions.jl")
include("signal_functions.jl")



export Signal, Wave, Spectrum, Integrated_Spectrum
export BrownianNoise, PinkNoise, GaussianNoise, WhiteNoise
export slope, latexify, triangle, squarewave



end
