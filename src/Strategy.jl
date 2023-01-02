using DataFrames
using Dates

include("Holdings.jl")

"""
    Petri.AbstractStrategy
An interface type defined as

Interface definition:
| Required Methods                                                                               | Default Definition         | Brief Description                                                                                                                                            |
|-------------------------------------------------------------------------------|----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `Petri.get_holdings(strategy::Petri.AbstractStrategy)::Dict{DateTime, Petri.AbstractHoldings}` | get_holdings(strategy)     | Used to obtain the holdings of a dish. Does not need to provide a `Holding` for every possible date.
"""
abstract type AbstractStrategy end

struct DefinedHoldingsStrategy
    holdings::Dict{DateTime, Holdings}
end

# function from_table(
#         assets::Table,
#         table::Table,
#     )::DefinedHoldingsStrategy

# end

function get_rebalances(
        strategy::DefinedHoldingsStrategy,
        holdings_table::HoldingsTable
    )::HoldingsSeries
    strategy.holdings
end

