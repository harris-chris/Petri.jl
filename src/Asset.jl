using StructArrays
using Dates

export AbstractAsset, ExternallyPricedAsset
export PricesAtTime, PricesSeries
export ValueAtTime, ValuesSeries
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

struct PriceAtTime
    time::DateTime
    val::Float64
end

struct ValueAtTime
    time::DateTime
    val::Float64
end

PricesSeries = StructArray{PriceAtTime}
ValuesSeries = StructArray{ValueAtTime}

struct ExternallyPricedAsset <: AbstractAsset
    name::String
    prices::PricesSeries
    # price_stale_if::Function
end
Base.show(asset::ExternallyPricedAsset) = asset.name

function get_prices(
        asset::ExternallyPricedAsset,
        times::Vector{DateTime},
    )::PricesSeries
    # complete = DataFrame(
    #     Time=map(first, asset.prices),
    #     Price=map(last, asset.prices),
    # )
    filter(r -> r.time in times, asset.prices)
end

