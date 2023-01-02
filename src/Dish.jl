using Dates

include("Asset.jl")
include("Strategy.jl")

struct Dish <: AbstractAsset
    strategy::AbstractStrategy
end
