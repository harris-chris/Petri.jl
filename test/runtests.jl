using DataFrames
using Dates
using Pkg
using Test

const petri_path = abspath(dirname(Base.source_path()), "..")
println("Testing Petri at path $petri_path")
Pkg.develop(PackageSpec(path=petri_path))

using Petri

test_files = [
    "Asset.jl",
    "Strategy.jl"
]

println("Running tests:")

for test_file in test_files
    include(test_file)
end
