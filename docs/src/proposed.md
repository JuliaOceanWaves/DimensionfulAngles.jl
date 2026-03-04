# Relation to proposed SI extensions

The concept of dimensions has some limitations (see [SI-Brochure_2019](@cite), [Nature_2017](@cite), and [Bramwell_2017](@cite)), which have led to many proposed extensions to the SI system, including many proposals to include angles as a dimension.
Several such proposals include [Eder_1982](@cite), [Quincey_2021](@cite), [Leonard_2021](@cite), and references therein.

## Summary of proposals

The exact form of the proposals and their effects on the equations of physics are all
different, but most (i) include angle as a base dimension, (ii) use a "fundamental"
constant, typically equal to one radian, to modify the equations of physics, and (iii)
define solid angle as a derived dimension equal to angle squared.
The different proposals, however, take different approaches to which equations or
quantity units to modify.
One exception not considered here is a class of proposals that define a new dimension for *radius length* rather than for *angle*.

Some examples of how common equations would be modified in such systems, using ``θ₀=1rad``:

  - Trigonometric & exponential functions:

      + ``cos(θ) → cos(θ/θ₀)``
      + ``cos(ωt+φ) → cos([ωt+φ]/θ₀)``
      + ``Aℯⁱᶿ → Aℯ^{iθ/θ₀}``

  - Angular frequency and angular wave number:

      + ``ω=2πf → ω=2πfθ₀``
      + ``k=2π/λ → k=2πθ₀/λ``

  - Arc length and sector area:

      + ``s=rθ → s=rθ/θ₀``
      + ``A=½r²θ → A=½r²θ/θ₀``

  - Solid angles
      + ``Ω=A/r² → Ω=Aθ₀²/r²``

  - kinematic equations:

      + ``v=rω → v=rω/θ₀``
      + ``a=rω² → a=rω²/θ₀²``

  - For dynamic equations, there's more variability between the different proposals.
    As an example, [Quincey_2021](@cite) would modify the units of torque and moment of inertia while leaving the units of work and energy intact.

      + ``T=(𝐫×𝐅) → T=(𝐫×𝐅)/θ₀`` (torque, new units: ``J/rad``)
      + ``I=Σ(mᵢ⋅rᵢ²)/θ₀²`` (moment of inertia, new units: ``kg⋅m²/rad²``)
      + ``L=Iω=(𝐫×𝐩)/θ₀`` (angular momentum, new units: ``J/(rad/s)``)
      + ``W=Tθ`` (work)
      + ``E=½Iω²`` (kinetic energy)

## *DimensionfulAngles.jl*'s relation to these proposals

*DimensionfulAngles.jl* extends the number of base dimensions solely for convenience when working with unitful quantities on a computer.
It does not propose or promote any *official* extension of the SI system such as those summarized above.
However, there's a few ideas we borrow from these proposals, namely:

**1. Defining constant**

The constant `θ₀=1rad` is provided as a hypothetical "defining unit" or "fundamental constant", mostly for analogy/consistency with the other base dimensions in the SI and *Unitful.jl*.

**2. Solid angles**

Solid angles are considered a derived dimension equal to angle squared (𝐀²).
This is in agreement with the proposals discussed above.

## Normalizing with `θ₀`
In contrast to these proposals, one of the goals of this package is to **not** require the use of the constant `θ₀` for normalizing inputs to common functions.
To this end, the extensions to functions in `Base` ensure that function calls like

```jldoctest; setup = :(using DimensionfulAngles), filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> cos(45ua"°")
0.7071067811865476
```

work without having to use the constant `θ₀` to normalize the argument.
Please report any function in `Base` or in the *standard library* that should handle arguments of a dimension that includes angles but is not currently covered by this package.
A goal of this package is to cover all such functions as well as those whose output should be of dimensions that includes angles.

While we try to cover most sensical functions, you will most likely have to manually remove angle units (e.g. normalizing with `θ₀` as above) when dealing with dynamic equations (e.g. the torque relationship above).
To this end it might be beneficial to be consistent and follow a specific system/proposal.

Functions in other packages for which it would make sense to provide arguments with dimensions including angles will not immediately work.
You will likely need to convert to radians and then strip the units before providing the quantity as an argument to that function.
This can be done in several ways, including through the use of the constant `θ₀` for normalization.
Alternatively, you can expand those functions to accept dimensionful angles by defining new methods.
If you believe such expansion should be included in *DimensionfulAngles.jl* (e.g. to cover a very popular package) please create an [issue](https://github.com/cmichelenstrofer/DimensionfulAngles.jl/issues) in the GitHub repository.

## References

```@bibliography
```
