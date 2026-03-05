"""
Extends Unitful.jl to include Angle as an independent dimension in order to facilitate
[dispatching](https://docs.julialang.org/en/v1/manual/methods/#Methods).

See the [Documentation](https://cmichelenstrofer.github.io/DimensionfulAngles/) for more
information.

!!! note "Not SI"

    *Angle* is not an SI base dimension.

# Examples

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using DimensionfulAngles

julia> 1.0ua"turn"
1.0 τ

julia> 1.0ua"rad" - 1.0ua"°"
0.9825467074800567 rad

julia> cos(45ua"°")
0.7071067811865476
```
"""
module DimensionfulAngles

# using Base: Base  # extend: see `base.jl` for full list of functions extended
using Unitful: Unitful  # extend: has_unit_spacing, uconvert
using Unitful: cd as cdᵤ, Hz, lm, lx, m, minute, promotion, rad, rpm, rps, s, sr, 𝐉, 𝐋, 𝐓, °
using Unitful: ContextUnits, Dimension, Dimensions, DimensionlessQuantity, FixedUnits
using Unitful: FreeUnits, Frequency, FrequencyFreeUnits, Length, MixedUnits, NoDims
using Unitful: NoUnits, Number, Quantity, Time, Unitlike, Unit, Units, Wavenumber
using Unitful: @dimension, @refunit, @derived_dimension, @unit
using Unitful: dimension, register, uconvert, unit, ustrip
using UnitfulEquivalences: UnitfulEquivalences  # extend: edconvert
using UnitfulEquivalences: dimtype, edconvert, Equivalence, @eqrelation
using UnitfulAngles: turn, doubleTurn, halfTurn, quadrant, sextant, octant, clockPosition
using UnitfulAngles: hourAngle, compassPoint, hexacontade, brad, diameterPart, grad
using UnitfulAngles: arcminute, arcsecond
using UnitfulAngles: mas, μas, pas

export @ua_str
export θ₀
export Periodic, Dispersion
export sexagesimal, show_sexagesimal

# unexported:
#     (all angle and derived units, including prefixed units)
#     𝐀, Angle, AngleUnits, AngleFreeUnits
#     SolidAngle, SolidAngleUnits, SolidAngleFreeUnits
#     AngularVelocity, AngularVelocityUnits, AngularVelocityFreeUnits
#     AngularAcceleration, AngularAccelerationUnits, AngularAccelerationFreeUnits
#     AngularPeriod, AngularPeriodUnits, AngularPeriodFreeUnits
#     AngularWavenumber, AngularWavenumberUnits, AngularWavenumberFreeUnits
#     AngularWavelength, AngularWavelengthUnits, AngularWavelengthFreeUnits

# Dimension
"""
    𝐀

A dimension representing Angle.

!!! note "Not SI"

    *Angle* is not an SI base dimension.
"""
@dimension 𝐀 "𝐀" Angle true

# SI units
"""
    radᵃ

The radian, a unit of angle.

There are 2π rad in a circle.
The radian is the SI unit of angle.
Unlike `Unitful.rad`, which follows SI and is therefor dimensionless,
`radᵃ` has dimensions of Angle.
Accepts SI prefixes.

Dimension: [`DimensionfulAngles.𝐀`](@ref).

# Examples

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using DimensionfulAngles

julia> 1.0ua"rad" + 20.0ua"mrad"
1.02 rad
```
"""
@refunit radᵃ "rad" Radianᵃ 𝐀 true true

"""
    °ᵃ

The degree, a unit of angle.

There are 360° in a circle.
The degree is an SI-accepted unit of angle.
Unlike `Unitful.°`, which follows SI and is therefor dimensionless,
`°ᵃ` has dimensions of Angle.
Does not accepts SI prefixes.

Dimension: [`DimensionfulAngles.𝐀`](@ref).

# Examples

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using DimensionfulAngles

julia> 1ua"°"
1°
```
"""
@unit °ᵃ "°" Degreeᵃ (1radᵃ * π/180) false
Unitful.has_unit_spacing(u::Units{(Unit{:Degreeᵃ, 𝐀}(0, 1 // 1),), 𝐀}) = false

# Constant
"""
    θ₀

A quantity equal to the central angle of a plane circular sector whose arc length is
equal to that of its radius.
It has a value of exactly 1 rad or approximately 57.2958°.
Used as the defining constant of Angle dimension in several proposed SI extension systems.

Dimensions: 𝐀.

See also [`DimensionfulAngles.radᵃ`](@ref).

# Examples

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using DimensionfulAngles

julia> θ₀
1//1 rad

julia> θ₀ |> ua"°"
57.29577951308232°

julia> 2.1ua"rad" / θ₀
2.1
```
"""
const θ₀ = (1 // 1)radᵃ

# Other functionalities.
include("units.jl")  # Define other units of angle.
include("derived.jl")  # Define derived units and dimensions.
include("convert.jl") # Convert to/from `Unitful`
include("uamacro.jl")  # String macro for using dimensionful units.
include("base.jl")  # Extend Base functions to work with angular quantities.
include("defaults.jl")  # Submodule to flood workspace with unit types.
include("equivalences.jl")  # `UnitfulEquivalences` containing angular dimensions

# Register new units and dimensions with Unitful.jl.
const localpromotion = copy(promotion)
function __init__()
    register(DimensionfulAngles)
    merge!(promotion, localpromotion)
    return nothing
end

end
