using DataFrames
using Dates

export AbstractStrategy, DefinedPositionsStrategy
export Positions, PositionsDelta, PositionsTable
export get_rebalance

"""
    Petri.AbstractStrategy
An interface type defined as

Interface definition:
| Required Methods                                                                               | Default Definition         | Brief Description                                                                                                                                            |
|-------------------------------------------------------------------------------|----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Petri.get_holdings(strategy::Petri.AbstractStrategy)::Dict{DateTime, Petri.AbstractHoldings}` | get_holdings(strategy)     | Used to obtain the holdings of a dish. Does not need to provide a `Holding` for every possible date.
"""

PositionsTable = DataFrame

abstract type AbstractStrategy end

# used to describe rebalances
struct Positions
    time::DateTime
    positions::Dict{AbstractAsset, Number}
end

struct PositionsDelta
    time::DateTime
    deltas::Dict{AbstractAsset, Number}
end

Rebalance = Union{Positions, PositionsDelta}

struct DefinedPositionsStrategy <: AbstractStrategy
    positions::Vector{Positions}
end

function get_rebalance(
        strategy::DefinedPositionsStrategy,
        positions_table::Union{Nothing, PositionsTable},
        rebalance_after::DateTime,
    )::Union{Nothing, Rebalance}
    valid_holdings = filter(strategy.positions) do pos
        pos.time > rebalance_after
    end
    sorted_holdings = sort(valid_holdings; by= (x -> x.time))
    first(sorted_holdings)
end

