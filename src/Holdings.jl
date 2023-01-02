include("Asset.jl")

abstract type AbstractHoldings end

struct Holdings <: AbstractHoldings
    holdings::Dict{AbstractAsset, Number}
end

struct HoldingsDelta <: AbstractHoldings
    deltas::Dict{AbstractAsset, Number}
end

# Expected to have infrequent or possibly one or zero dates
HoldingsSeries = Dict{DateTime, AbstractHoldings}

# Expected to have more-or-less contiguous dates
HoldingsTable = DataFrame

