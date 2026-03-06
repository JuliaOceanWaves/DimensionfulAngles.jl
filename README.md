[![CI](https://github.com/JuliaOceanWaves/DimensionfulAngles.jl/actions/workflows/Test.yml/badge.svg)](https://github.com/JuliaOceanWaves/DimensionfulAngles.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/JuliaOceanWaves/DimensionfulAngles.jl/branch/main/graph/badge.svg?token=QI8L8PQ71T)](https://codecov.io/gh/JuliaOceanWaves/DimensionfulAngles.jl)
[![deps](https://juliahub.com/docs/General/DimensionfulAngles/stable/deps.svg)](https://juliahub.com/ui/Packages/General/DimensionfulAngles?t=2)

# DimensionfulAngles.jl
Extends [Unitful.jl](https://github.com/JuliaPhysics/Unitful.jl) to include *angle* as a dimension and allow [dispatching](https://docs.julialang.org/en/v1/manual/methods/) on *angles*.

The full documentation can be found at [https://JuliaOceanWaves.github.io/DimensionfulAngles.jl](https://JuliaOceanWaves.github.io/DimensionfulAngles.jl).

## Basic Usage

Use *DimensionfulAngles.jl* for units containing angles and *Unitful.jl* for all other units.
The units in *DimensionfulAngles.jl* are differentiated from their dimensionless counterparts with a superscript `ᵃ`.
Simply add this superscript to any angle units to make it dimensionful.
In Julia environments this can be typed as `\^a<tab>`.

```julia
julia> using Unitful

julia> using DimensionfulAngles

julia> dimensionless_angle = 1u"rad"

1 rad

julia> dimensionful_angle = 1u"radᵃ"
1 rad

julia> typeof(dimensionless_angle)
Quantity{Int64, NoDims, Unitful.FreeUnits{(rad,), NoDims, nothing}}

julia> typeof(dimensionful_angle)
Quantity{Int64, 𝐀, Unitful.FreeUnits{(rad,), 𝐀, nothing}}
```

When defining quantities with units from *DimensionfulAngles.jl* you can use the `ua` string instead and omit the superscript `ᵃ`.
But when defining quantities with units from both it is more convenient to use the `u` string.

```julia
julia> dimensionful_angle = 1ua"rad"
1 rad

julia> typeof(dimensionful_angle)
Quantity{Int64, 𝐀, Unitful.FreeUnits{(rad,), 𝐀, nothing}}

julia> angular_velocity = 1.2u"radᵃ/s"
1.2 rad s⁻¹

julia> typeof(angular_velocity)
Quantity{Float64, 𝐀 𝐓⁻¹, Unitful.FreeUnits{(rad, s⁻¹), 𝐀 𝐓⁻¹, nothing}}
```

A third alternative is to directly import only the units you will be using and renaming those from *DimensionfulAngles.jl* to remove the superscript `ᵃ`.

```julia
julia> using Unitful

julia> using Unitful: m, s, kg

julia> using DimensionfulAngles: radᵃ as rad, °ᵃ as °

julia> angular_velocity = 1.2rad / s
1.2 rad s⁻¹
```

### Default Symbols
Another way of doing this is to  import all default units, which includes SI base and derived units from `Unitful.jl` with angle units from `DimensionfulAngles.jl`.
This is done as

```julia
julia> using DimensionfulAngles.DefaultSymbols

julia> angular_velocity = 1.2rad / s
```

### Converting to/from `Unitful.jl`
To convert a quantity to or from `Unitful.jl` use the `uconvert` function with first
argument either `:Unitful` or `:DimensionfulAngles`.
For example:

```julia
julia> using Unitful, DimensionfulAngles

julia> ω = 3.2u"radᵃ/s"
3.2 rad s⁻¹

julia> ω̄ = uconvert(:Unitful, ω)
3.2 rad s⁻¹

julia> dimension(ω)
𝐀 𝐓⁻¹

julia> dimension(ω̄)
𝐓⁻¹
```


## Contributing

Contributions are welcome! 🎊 Please see the [contribution guidelines](https://github.com/JuliaOceanWaves/.github/blob/main/CONTRIBUTING.md) for ways to contribute to the project.

## Acknowledgments

Some portions of this software are adapted from:

  - [UnitfulAngles.jl](https://github.com/yakir12/UnitfulAngles.jl/blob/master/LICENSE.md): Copyright (c) 2017: Yakir Luc Gagnon.
  - [UnitfulUS.jl](https://github.com/PainterQubits/UnitfulUS.jl/blob/master/LICENSE.md): Copyright (c) 2017, California Institute of Technology. All rights reserved.
