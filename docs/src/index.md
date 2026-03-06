# DimensionfulAngles.jl

*An extension of [Unitful.jl](https://juliaphysics.github.io/Unitful.jl/stable/) to include angle as a dimension.*

While angle is not an SI base dimension, it can be extremely useful to consider it as one in computer units systems.
This allows, among other things, [dispatching](https://docs.julialang.org/en/v1/manual/methods/) on angles.
This package creates a single additional dimension *angle* which is assigned to both plane and phase angles.

!!! note

    Please read through the [Unitful.jl documentation](https://juliaphysics.github.io/Unitful.jl/stable/) first. This package extends *Unitful.jl* and documentation for the main usage and features of *Unitful.jl* are not duplicated here.

**Angle as a dimension?**

For motivating examples on why this is useful, see [Angle as a dimension?](@ref).
The main takeaway is that

> *While the choice to use the SI dimensions in Unitful is the right one, for use cases that deal extensively with a dimensionless quantity, it can be extremely useful to extend the base dimensions to include that quantity.*
> *This package extends it to use angles as a dimension.*

**Package Guide**

The [Package Guide](https://JuliaOceanWaves.github.io/DimensionfulAngles.jl/stable/guide/intro/) is the main documentation for the package and includes usage details and examples of all of *DimensionfulAngles.jl*'s capabilities.
These include

  - Angle as a base dimension.
  - A comprehensive list of angular units.
  - The `@ua_str` macro for easily accessing these units.
  - Derived dimensions and their units, including: solid angles, angular velocity/frequency, angular acceleration, luminous flux, illuminance, etc.
  - Conversion between `Unitful` and `DimensionfulAngles` quantities.
  - A [UnitfulEquivalences.jl](https://sostock.github.io/UnitfulEquivalences.jl/stable/) `Equivalence` to convert between period, frequency, and angular frequency of a periodic response.
  - A comprehensive extension of functions in `Base` that take angular quantities as inputs, or output angular quantities.

**Relationship to proposed SI extensions**

This package extends the number of base dimensions solely for convenience when working with unitful quantities on a computer.
This package does not propose or promote any *official* extension of the SI system.
Such proposals do exist, and for completeness these are discussed in [Relation to proposed SI extensions](@ref).

**Definitions**

These definitions are based on the [SI Brochure](https://www.bipm.org/en/publications/si-brochure).
In particular note the distinction between a quantity (which has a value and a unit), its unit, and its dimension.
Any physical quantity has a unique standard (coherent) SI unit and dimension, but the converse is not true.
E.g. both torque and energy, two distinct quantities, have the same dimension and units.
Also note the distinction between plane and phase angles as distinct quantities, and angular velocity and angular frequency as distinct quantities.

  - **Angle**: Either a plane or phase angle.
  - **Plane Angle**: The angle between two lines originating from a common point.
  - **Phase Angle** or **Phase**: The argument of a complex number, i.e. the angle between the real axis and the radius of the polar representation of the complex number in the complex plane.
  - **Unit**: A particular example of the quantity concerned which is used as a reference. For a particular quantity, different units may be used.
  - **Dimension**: A conventional system for organizing physical quantities. In the SI the seven base quantities are each assigned one dimension. The dimensions of all other (derived) quantities are written as a product of powers of the base dimensions according to the equations of physics that relate these quantities.
