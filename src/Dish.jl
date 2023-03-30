using DataFrames
using Dates

include("Asset.jl")
include("Strategy.jl")

export Dish
export get_positions_table

struct Dish <: AbstractAsset
    strategy::AbstractStrategy
end

PricesTable = DataFrame

function get_positions_table(
        dish::Dish,
        times::Vector{DateTime},
    )::PositionsTable
    positions_table = nothing
    rebalance_floor = first(times)
    rebalance = get_rebalance(dish.strategy, positions_table, rebalance_floor)
    while !isnothing(rebalance)
        positions_table = update_with_rebalance(positions_table, rebalance, times)
        rebalance_floor = rebalance.time
        rebalance = get_rebalance(dish.strategy, positions_table, rebalance_floor)
    end
    positions_table
end

function update_with_rebalance(
        holdings_table::Nothing,
        rebalance::Positions,
        times::Vector{DateTime},
    )::Union{Nothing, PositionsTable}
    asset_to_holdings = map(collect(rebalance.positions)) do (asset, pos)
        prices_series = get_prices(asset, times)
        map(x -> x.val * pos, prices_series)
    end
    DataFrame(asset_to_holdings, get_position_names(rebalance))
end

function update_with_rebalance(
        holdings_table::Nothing,
        rebalance::PositionsDelta,
    )::Union{Nothing, PositionsTable}
    nothing
end

function update_with_rebalance(
        holdings_table::PositionsTable,
        rebalance::Positions,
    )::Union{Nothing, PositionsTable}
    error("Not implemented")
end

function update_with_rebalance(
        holdings_table::PositionsTable,
        rebalance::PositionsDelta,
    )::Union{Nothing, PositionsTable}
    error("Not implemented")
end

# function get_prices_table(
#         dish::Dish,
#         times::Vector{DateTime},
#     )::PricesTable
# end
