using Test, SafeTestsets, Documenter

@time @testset verbose=true "DimensionfulAngles.jl" begin
    @time @safetestset "Test Core Package" begin
        include("test_core_package.jl")
    end
    @time @safetestset "Test Base Functions" begin
        include("test_base_functions.jl")
    end
    @time @safetestset "Doc Tests" begin
        include("test_doctest.jl")
    end
end
