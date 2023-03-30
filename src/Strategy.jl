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

function get_position_names(positions::Positions)::Vector{String}
    map(x -> x.name, keys(positions) |> collect)
end

function get_position_names(positions_delta::PositionsDelta)::Vector{String}
    map(x -> x.name, keys(deltas) |> collect)
end

"""
    struct DefinedPositionsStrategy
        positions::Vector{Positions}
    end

A very simple strategy type, effectively just a table of known positions for the
dish. This is the obvious strategy type to use if (say) you have a simple table
of historical holdings.
"""

struct DefinedPositionsStrategy <: AbstractStrategy
    positions::Vector{Positions}
end

"""
    get_rebalance(
        strategy::DefinedPositionsStrategy,
        positions_table::Union{Nothing, PositionsTable},
        rebalance_after::DateTime,
      )::Union{Nothing, Rebalance}

Returns the first valid rebalance, if any, for a given DefinedPositionsStrategy and
PositionsTable.
"""

function get_rebalance(
        strategy::DefinedPositionsStrategy,
        positions_table::Union{Nothing, PositionsTable},
        rebalance_after::DateTime,
    )::Union{Nothing, Rebalance}
    valid_holdings = filter(strategy.positions) do pos
        pos.time >= rebalance_after
    end
    sorted_holdings = sort(valid_holdings; by= (x -> x.time))
    first(sorted_holdings)
end

