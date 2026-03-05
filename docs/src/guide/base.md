# Extension of `Base` functions

One of the goals of this project is to extend all functions in Julia `Base` and the
*standard library* that make sense to use quantities with dimensionful angles.
Please let us know of any function we missed through a GitHub
[issue](https://github.com/JuliaOceanWaves/DimensionfulAngles.jl/issues).

The functions in `Base` currently extended to accept dimensionful angle arguments are:

  - trigonometric functions: `sin`, `cos`, `tan`, `cot`, `sec`, `csc`, `sincos`, `sinpi`,
    `cospi`, `sincospi`, `sind`, `cosd`, `tand`, `cotd`, `secd`, `cscd`, `sincosd`
  - hyperbolic functions: `sinh`, `cosh`, `tanh`, `coth`, `sech`, `csch`
  - exponential functions: `exp`, `expm1`, `cis`, `cispi`
  - Sinc functions: `sinc`, `cosc`
  - conversions: `deg2rad`, `rad2deg`
  - divisions: `mod2pi`, `rem2pi`

For example

```jldoctest
julia> using DimensionfulAngles

julia> angle = 10.52ua"°"
10.52°

julia> cos(angle)
0.9831912354632536

julia> rem2pi(angle, RoundNearest)
10.52°

julia> rem2pi(angle + 360ua"°", RoundNearest)
10.519999999999992°
```

The functions with a `*d` version and `deg2rad` only accept angles in degrees and functions with a `*pi` version only accept angles in half turns.
Similarly, `rad2deg` only accepts angles in radians.
The functions `exp` and `expm1` only accept imaginary angles, that is `1im*θ` for some angle `θ`.

Additionally, several inverse functions in base are extended to return quantities with
dimensionful angles when requested.
This is requested by providing a unit as the first argument.
For instance

```jldocs
julia> using DimensionfulAngles

julia> acos(ua"°", 0.9831912354632536)
10.52000000000001°
```

The functions in `Base` that are currently extended to accept units as their first argument
and return values with those units are:

  - inverse trigonometric functions: `asin`, `acos`, `atan`, `acot`, `asec`, `acsc`, `asind`, `acosd`, `acotd`, `asecd`, `acscd`, `atan(x, y)`
  - inverse hyperbolic functions: `asinh`, `acosh`, `atanh`, `acoth`, `asech`, `acsch`
  - logarithmic functions: `log`, `log1p`
  - phase angle of a complex number: `angle`
