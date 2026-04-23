# Quick Start

`DimensionfulAngles` extends `Unitful` so plane and phase angles carry an angle
dimension instead of behaving as plain dimensionless numbers.

```julia
using DimensionfulAngles
using Unitful

heading = pi / 6 * ua"rad"
turn_rate = 2pi * ua"rad" / u"s"
next_heading = heading + turn_rate * 0.5u"s"
```

Use `DimensionfulAngles.DefaultSymbols` when you want convenient symbols in an
interactive session. Package code can also import explicit units or use the
`@ua_str` string macro described in the package guide.
