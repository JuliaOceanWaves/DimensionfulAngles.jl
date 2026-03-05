using Test, DimensionfulAngles, Unitful

units = (:°ᵃ => 360, :arcminuteᵃ => 360 * 60, :arcsecondᵃ => 360 * 3600,
    :diameterPartᵃ => 2π * 60, :doubleTurnᵃ => 0.5, :turnᵃ => 1, :halfTurnᵃ => 2,
    :quadrantᵃ => 4, :sextantᵃ => 6, :octantᵃ => 8, :clockPositionᵃ => 12,
    :hourAngleᵃ => 24, :compassPointᵃ => 32, :hexacontadeᵃ => 60, :bradᵃ => 256,
    :gradᵃ => 400, :ʰᵃ => 24, :ᵐᵃ => 24 * 60, :ˢᵃ => 24 * 3600)
powers = map(x -> x[1], sort(collect(Unitful.prefixdict)))
prefixes = map(x -> x[2], sort(collect(Unitful.prefixdict)))

for (unit, full_turn) in (:radᵃ => 2π, :asᵃ => 360 * 3600)
    prefix_units = Symbol.(prefixes .* "$unit")
    values = full_turn ./ (10.0 .^ powers)
    global units = units ∪ (prefix_units .=> values)
end

function test_functions(functions)
    function_objects = map(f -> getfield(Base, f), functions)
    for f in function_objects
        reference = f(π / 4)
        for (unit, full_turn) in units
            @test f((full_turn / 8) * getproperty(DimensionfulAngles, unit)) ≈ reference
        end
    end
    return nothing
end

@testset "Trigonometric" begin
    test_functions((:sin, :cos, :tan, :cot, :sec, :csc, :cis))
    for (unit, full_turn) in units
        @test @eval all(sincos(($full_turn / 8) * DimensionfulAngles.$unit) .≈
                        sincos(π / 4))
    end

    for f in (:sinpi, :cospi, :cispi, :sincospi), (unit, full_turn) in units
        if unit == :halfTurnᵃ && f == :sincospi
            @test @eval all($f(($full_turn / 8) * DimensionfulAngles.$unit) .≈ $f(1 / 4))
        elseif unit == :halfTurnᵃ
            @test @eval $f(($full_turn / 8) * DimensionfulAngles.$unit) ≈ $f(1 / 4)
        else
            @test_throws ArgumentError @eval $f(($full_turn / 8) * DimensionfulAngles.$unit)
        end
    end

    functions_d_version = (:sind, :cosd, :tand, :cotd, :secd, :cscd, :sincosd)
    for f in functions_d_version, (unit, full_turn) in units
        if unit == :°ᵃ && f == :sincosd
            @test @eval all($f(($full_turn / 8) * DimensionfulAngles.$unit) .≈ $f(45))
        elseif unit == :°ᵃ
            @test @eval $f(($full_turn / 8) * DimensionfulAngles.$unit) ≈ $f(45)
        else
            @test_throws ArgumentError @eval $f(($full_turn / 8) * DimensionfulAngles.$unit)
        end
    end

    for f in (:asin, :acos, :atan, :acot, :asec, :acsc), (unit, _) in units
        unit = Meta.parse("DimensionfulAngles.$unit")
        if f == :asec || f == :acsc
            @test @eval $f($unit, 1.7) ≈ ($f(1.7) * ua"rad" |> $unit)
        else
            @test @eval $f($unit, 0.7) ≈ ($f(0.7) * ua"rad" |> $unit)
        end
    end

    for (unit, _) in units
        unit = @eval DimensionfulAngles.$unit
        @test atan(unit, 2, 1) == (atan(2, 1) * ua"rad" |> unit)
    end
end

@testset "Hyperbolic" begin
    test_functions((:sinh, :cosh, :tanh, :coth, :sech, :csch))

    for f in (:asinh, :acosh, :atanh, :acoth, :asech, :acsch), (unit, _) in units
        unit = Meta.parse("DimensionfulAngles.$unit")
        if f == :asech || f == :atanh
            @test @eval $f($unit, 0.7) == ($f(0.7) * ua"rad" |> $unit)
        else
            @test @eval $f($unit, 1.7) == ($f(1.7) * ua"rad" |> $unit)
        end
    end
end

@testset "Sinc" begin
    test_functions((:sinc, :cosc))
end

@testset "Exponential" begin
    for f in (:exp, :expm1), (unit, full_turn) in units
        @test @eval $f(1im * ($full_turn / 8) * DimensionfulAngles.$unit) ≈ $f(1im * π / 4)
        @test_throws DomainError @eval $f((1 + 1im) * ($full_turn / 8) *
                                          DimensionfulAngles.$unit)
        @test_throws ArgumentError @eval $f(($full_turn / 8) * DimensionfulAngles.$unit)
    end

    for f in (:log, :log1p), (unit, _) in units
        unit = Meta.parse("DimensionfulAngles.$unit")
        @test @eval $f($unit, π / 4) ≈ ($f(π / 4) * ua"rad" |> $unit)
    end
end

@testset "Other Functions" begin
    for (unit, full_turn) in units
        unit = @eval DimensionfulAngles.$unit
        @test angle(unit, 1.2 * exp(1im * 0.5)) ≈ (0.5ua"rad" |> unit)
        @test mod2pi(2.5 * full_turn * unit) ≈ 0.5ua"turn" |> unit
        @test rem2pi(2.5 * full_turn * unit, RoundDown) ≈ 0.5ua"turn" |> unit
        if unit == ua"°"
            @test deg2rad((full_turn / 8) * unit) ≈ (π / 4)ua"rad"
        else
            @test_throws ArgumentError deg2rad((full_turn / 8) * unit)
        end
        if unit == ua"rad"
            @test rad2deg((full_turn / 8) * unit) ≈ 45ua"°"
        else
            @test_throws ArgumentError rad2deg((full_turn / 8) * unit)
        end
    end
end

# TODO: test matrix inputs
# TODO: use random numbers on some meaningful domain for each function
# TODO: get rid of global constants
