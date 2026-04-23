# Theory

The package treats angle as a computational base dimension. This is not a claim
that SI should add angle as an official base dimension; it is a practical modeling
choice for code where dispatch, conversion, and dimensional checking benefit from
distinguishing angles from pure scalars.

This distinction is useful in wave, rotor, and controls packages where radians,
degrees, angular rates, and phase angles interact with quantities that otherwise
share dimensionless representations. Making angle explicit catches unit mistakes
at package boundaries while still allowing deliberate conversions through
`Unitful` and `DimensionfulAngles` APIs.
