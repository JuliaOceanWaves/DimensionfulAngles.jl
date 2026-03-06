# Basic usage

This package extends [Unitful.jl](https://juliaphysics.github.io/Unitful.jl/stable/) and the new dimension of angle inherits a lot of default behavior from *Unitful.jl*.
You should read the *Unitful.jl* documentation first.

At its core, [`DimensionfulAngles`](@ref) defines:

  - the angle dimension [`DimensionfulAngles.𝐀`](@ref)
  - the reference unit radian [`DimensionfulAngles.radᵃ`](@ref) (SI unit of angle)
  - the degree [`DimensionfulAngles.°ᵃ`](@ref) (SI-accepted unit of angle)
  - the *"defining constant"* [`θ₀`](@ref) equal to one radian.
  - the [`@ua_str`](@ref) macro for easily recalling units in the package
  - extensions to `uconvert` to convert between `Unitful` and `DimensionfulAngles` quantities.

The unit `radᵃ` is prefixable, and therefore defines many other units, which are documented in [Prefixed units](@ref intro_prefixed).

The units in this package are appended the superscript `ᵃ` to differentiate them from the units in [Unitful.jl](https://juliaphysics.github.io/Unitful.jl/stable/) and [UnitfulAngles.jl](https://github.com/yakir12/UnitfulAngles.jl), which have the same name but are non-dimensional.
The [`@ua_str`](@ref) provides an easier way to access these units without having to type the superscript `ᵃ`.
For example, both of these are equivalent:

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using Unitful

julia> using DimensionfulAngles

julia> 1.3u"radᵃ"
1.3 rad

julia> 1.3ua"rad"
1.3 rad
```

The default `u` string can still be more convenient when defining quantities with mixed units, such as

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using Unitful

julia> using DimensionfulAngles

julia> 2.1u"radᵃ/s"
2.1 rad s⁻¹
```

Alternatively it might be convenient to import the units you are using directly, renaming units from *DimensionfulAngles* to remove the superscript `ᵃ`.
For example:

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using Unitful

julia> using Unitful: m, s, kg

julia> using DimensionfulAngles: radᵃ as rad, °ᵃ as °

julia> 2.1rad / s
2.1 rad s⁻¹
```

Yet another way to import units is to import the *default* set of units, which includes
all the
[default units from `Unitful.jl`](https://juliaphysics.github.io/Unitful.jl/stable/#Important-note-on-namespaces)
but with angle units from `DimensionfulAngles.jl`.
The units from `DimensionfulAngles.jl` are imported without the superscript `ᵃ` in their
names.
This is done as:

```julia-repl
julia> using DimensionfulAngles.DefaultSymbols
```

One of the main advantage of defining an angle dimension is to be able to dispatch on angles.
This behavior and useful aliases are completely inherited from *Unitful.jl*.
The most basic usage uses the automatically defined alias [`DimensionfulAngles.Angle`](@ref):

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using Unitful

julia> using DimensionfulAngles

julia> what_am_i(::Unitful.Length) = "I am a length."
what_am_i (generic function with 1 method)

julia> what_am_i(::DimensionfulAngles.Angle) = "I am an angle."
what_am_i (generic function with 2 methods)

julia> my_height = 6u"ft" + 1.0u"inch"
1.8542 m

julia> angle = 1.2ua"rad"
1.2 rad

julia> what_am_i(my_height)
"I am a length."

julia> what_am_i(angle)
"I am an angle."
```

Finally, we can convert quantities to or from `Unitful` (including `UnitfulAngles`) using an
extension of `uconvert` with first argument `:Unitful` or `:DimensionfulAngles`.

```@docs
Unitful.uconvert(::Symbol, ::Quantity)
```

Note that astronomical units in `DimensionfulAngles` and `UnitfulAngles` are not equivalent
and quantities containing these units are converted to compatible, non-astronomical, units
first.
Specifically, the `UnitfulAngles` units [`mas`, `μas`, `pas`] are converted to `arcsecond`,
the `DimensionfulAngles` unit `asᵃ` and all its prefixed versions are converted to
`arcsecondᵃ`, and the `DimensionfulAngles` units [`ʰᵃ`, `ᵐᵃ`, `ˢᵃ`] are converted to
`hourAngleᵃ`.
For example:

```jldoctest; setup = :(using DimensionfulAngles, Unitful)
julia> θ = 1u"μas"
1 μas

julia> θ̄ = uconvert(:DimensionfulAngles, θ)
1//1000000″

julia> uconvert(:Unitful, 1u"ᵐᵃ")
1//60 hourAngle
```

## [Syntax](@id intro_syntax)

Contents:

  - [Syntax](@ref intro_syntax)

      + [Syntax provided by *Unitful.jl*](@ref intro_unitful)
      + [Prefixed Units](@ref derived_prefixed)

```@docs
DimensionfulAngles
DimensionfulAngles.𝐀
DimensionfulAngles.radᵃ
DimensionfulAngles.°ᵃ
DimensionfulAngles.θ₀
@ua_str
DimensionfulAngles.DefaultSymbols
```

### [Syntax provided by *Unitful.jl*](@id intro_unitful)

```@docs
DimensionfulAngles.Angle
DimensionfulAngles.AngleUnits
DimensionfulAngles.AngleFreeUnits
```

### [Prefixed units](@id intro_prefixed)

```@autodocs
Modules = [DimensionfulAngles]
Filter = x->_filter_prefixed("rad", x; exceptions=["grad", "brad"])
```
