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

function price_valid_until_eod(
        valuation_time::DateTime,
        price::PriceAtTime,
    )::Bool
    pt = price.time
    price_eod = DateTime(year(pt), month(pt), day(pt), 23, 59, 59, 999)
    price.time <= valuation_time && price_eod >= valuation_time
end

struct ExternallyPricedAsset <: AbstractAsset
    name::String
    prices::PricesSeries
end
Base.show(asset::ExternallyPricedAsset) = asset.name

function get_prices(
        asset::ExternallyPricedAsset,
        times::Vector{DateTime},
    )::PricesSeries
    filter(asset.prices) do pr
        any(times) do vt
            price_valid_until_eod(vt, pr)
        end
    end
end

