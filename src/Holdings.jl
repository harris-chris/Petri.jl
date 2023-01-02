include("Asset.jl")

abstract type AbstractHoldings end

struct Holdings <: AbstractHoldings
    holdings::Dict{AbstractAsset, Number}
end

struct HoldingsDelta <: AbstractHoldings
    deltas::Dict{AbstractAsset, Number}
end

