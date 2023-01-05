using DataFrames

include("Asset.jl")

export Holdings, HoldingsTable

# Expected to have more-or-less contiguous dates
HoldingsTable = DataFrame

