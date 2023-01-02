using DataFrames
using Dates

export AbstractAsset, DefinedPriceAsset
export get_prices

"""
    Petri.AbstractAsset
An interface type defined as

Interface definition:
| Required Methods                                                                   | Default Definition         | Brief Description                                                                                                                                            |
|------------------------------------------------------------------------------------|----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Petri.get_prices(asset::Petri.AbstractAsset, times::Vector{DateTime})::DataFrame` | get_prices(asset)          | Used to obtain prices for an Asset. The returned DataFrame should have an index that contains all times specified in `times`, and values of type `Union{Missing, Float64}`
"""
abstract type AbstractAsset end

struct DefinedPriceAsset <: AbstractAsset
    name::String
    prices::Vector{Tuple{DateTime, Float64}}
end
Base.show(asset::DefinedPriceAsset) = asset.name

function get_prices(
        asset::DefinedPriceAsset,
        times::Vector{DateTime},
    )::DataFrame
    complete = DataFrame(
        Time=map(first, asset.prices),
        Price=map(last, asset.prices),
    )
    @info complete
    filter(r -> r.Time in times, complete)
end

