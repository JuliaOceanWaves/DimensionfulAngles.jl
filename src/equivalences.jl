# equivalences containing angular dimensions

const _temporal_dims = [Time, Frequency, AngularPeriod, AngularVelocity]
const _spatial_dims = [Length, Wavenumber, AngularWavelength, AngularWavenumber]
const _temporal_units = Dict(
    Time => s, Frequency => Hz, AngularPeriod => s/radᵃ, AngularVelocity => radᵃ/s)
const _spatial_units = Dict(
    Length => m, Wavenumber => m^-1, AngularWavelength => m/radᵃ, AngularWavenumber => radᵃ/m
    )

# periodic equivalence for both temporal and spatial frequency
"""
    Periodic()

Equivalence to convert between temporal or spatial period, frequency,
[angular frequency](https://en.wikipedia.org/wiki/Angular_frequency), and angular period.

These quantities are related by ``f = ω/2π = 1/T = 1/(2πT̅)``, where

  - ``f`` is the (temporal) frequency,
  - ``ω`` is the (temporal) angular frequency,
  - ``T`` is the (temporal) period,
  - ``T̄`` is the (temporal) angular period,

and ``ν = k/2π = 1/λ = 1/(2πλ̄)``, where

- ``ν`` is the (spatial) frequency (linear wavenumber),
- ``k`` is the (spatial) angular frequency (angular wavenumber),
- ``λ`` is the (spatial) period (linear wavelength), and
- ``λ̄`` is the (spatial) angular period (angular wavelength).

See also [`DimensionfulAngles.Dispersion`](@ref)

# Example

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using Unitful

julia> using DimensionfulAngles

julia> uconvert(u"s", 10u"Hz", Periodic())
0.1 s

julia> uconvert(u"radᵃ/s", 1u"Hz", Periodic())
6.283185307179586 rad s⁻¹
```
"""
struct Periodic <: Equivalence end
# temporal
@eqrelation Periodic (AngularVelocity / Frequency = 2π * radᵃ)
@eqrelation Periodic (Frequency * Time = 1)
@eqrelation Periodic (AngularVelocity * Time = 2π * radᵃ)
@eqrelation Periodic (AngularVelocity * AngularPeriod = 1)
@eqrelation Periodic (Time / AngularPeriod = 2π * radᵃ)
@eqrelation Periodic (AngularPeriod * Frequency = 1/(2π * radᵃ))
# spatial
@eqrelation Periodic (AngularWavenumber / Wavenumber = 2π * radᵃ)
@eqrelation Periodic (Wavenumber * Length = 1)
@eqrelation Periodic (AngularWavenumber * Length = 2π * radᵃ)
@eqrelation Periodic (AngularWavenumber * AngularWavelength = 1)
@eqrelation Periodic (Length / AngularWavelength = 2π * radᵃ)
@eqrelation Periodic (AngularWavelength * Wavenumber = 1/(2π * radᵃ))
# default to `uconvert` behavior, temporal
for D ∈ _spatial_dims
    @eval begin
        function UnitfulEquivalences.edconvert(::dimtype($D), x::$D, equivalence::Periodic)
            u = _spatial_units[$D]
            return uconvert(u, x)
        end
    end
end
# default to `uconvert` behavior, spatial
for D ∈ _temporal_dims
    @eval begin
        function UnitfulEquivalences.edconvert(::dimtype($D), x::$D, equivalence::Periodic)
            u = _temporal_units[$D]
            return uconvert(u, x)
        end
    end
end

# periodic equivalence with a specific dispersion relation relating temporal and spatial
# frequencies
"""
    Dispersion(; dispersion=nothing, dispersion_inverse=nothing)

Equivalence to convert between temporal and spatial frequencies using a specific
[dispersion relation](https://en.wikipedia.org/wiki/Dispersion_relation).

This extends the Periodic() equivalence to convert between spatial and temporal quantities
based on the provided dispersion relation.

See also [`DimensionfulAngles.Periodic`](@ref).

# Example

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using DimensionfulAngles, Unitful

julia> g = Unitful.gn  # gravitational acceleration
9.80665 m s⁻²

julia> deepwater = Dispersion(
        dispersion = (k -> √(g*k*θ₀)), dispersion_inverse = (ω -> ω^2/(g*θ₀))
       );

julia> uconvert(u"radᵃ/mm", 1.0u"Hz", deepwater)
0.004025678249387654 rad mm⁻¹
```

Some dispersion relations do not have an expressible inverse.
In such cases using `Roots.jl` might be beneficial.
For example, here is how we could use the
linear [water wave dispersion](https://en.wikipedia.org/wiki/Dispersion_(water_waves))
without deep water approximation:

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using DimensionfulAngles, Unitful, Roots

julia> g = Unitful.gn  # gravitational acceleration
9.80665 m s⁻²

julia> h = 0.5u"m"  # water depth
0.5 m

julia> waterwaves = Dispersion(
        dispersion = (k -> √(k*θ₀*g*tanh(k*h/θ₀))),
        dispersion_inverse = (ω -> solve(ZeroProblem(k -> k - ω^2/(g*tanh(k*h/θ₀))/θ₀, (0u"radᵃ/m", (Inf)u"radᵃ/m"))))
       );

julia> uconvert(u"Hz", 0.004025678249387654u"radᵃ/mm", waterwaves)
0.9823052153509486 Hz

julia> h = (Inf)u"m"  # water depth
Inf m

julia> waterwaves = Dispersion(
        dispersion = ( k -> √(k*θ₀*g*tanh(k*h/θ₀)) ),
        dispersion_inverse = (ω -> solve(ZeroProblem(k -> k - ω^2/(g*tanh(k*h/θ₀))/θ₀, k0)))
       );

julia> uconvert(u"Hz", 0.004025678249387654u"radᵃ/mm", waterwaves) ≈ 1u"Hz"
true
```
"""
struct Dispersion <: Equivalence
    dispersion::Union{Function, Nothing}
    dispersion_inverse::Union{Function, Nothing}

    function Dispersion(;
            dispersion::Union{Function, Nothing}=nothing,
            dispersion_inverse::Union{Function, Nothing}=nothing
        )
        return new(dispersion, dispersion_inverse)
    end
end

# use all the equivalences in Periodic
for T1 ∈ _temporal_dims, T2 ∈ _temporal_dims
    @eval begin
        function UnitfulEquivalences.edconvert(d::dimtype($T1), x::$T2, ::Dispersion)
            return edconvert(d, x, Periodic())
        end
    end
end

for T1 ∈ _spatial_dims, T2 ∈ _spatial_dims
    @eval begin
        function UnitfulEquivalences.edconvert(d::dimtype($T1), x::$T2, ::Dispersion)
            return edconvert(d, x, Periodic())
        end
    end
end

# add new equivalences between temporal <-> spatial frequencies
for D_in ∈ _spatial_dims, D_out ∈ _temporal_dims
    @eval begin
        function UnitfulEquivalences.edconvert(
                ::dimtype($D_out), x::$D_in, equivalence::Dispersion
            )
            isnothing(equivalence.dispersion) && throw(ArgumentError(
                "`dispersion` function not defined"))
            k = uconvert(radᵃ/m, x, Periodic())
            ω = equivalence.dispersion(k)
            u = _temporal_units[$D_out]
            return uconvert(u, ω, Periodic())
        end
    end
end

for D_in ∈ _temporal_dims, D_out ∈ _spatial_dims
    @eval begin
        function UnitfulEquivalences.edconvert(
                ::dimtype($D_out), x::$D_in, equivalence::Dispersion
            )
            isnothing(equivalence.dispersion_inverse) && throw(ArgumentError(
                "`dispersion_inverse` function not defined"))
            ω = uconvert(radᵃ/s, x, Periodic())
            k = equivalence.dispersion_inverse(ω)
            u = _spatial_units[$D_out]
            return uconvert(u, k, Periodic())
        end
    end
end
