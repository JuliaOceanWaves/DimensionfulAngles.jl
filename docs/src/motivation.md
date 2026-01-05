# Angle as a dimension?

While *angle* is not an SI base dimension, it can be convenient to treat it as dimension in computer systems.
A few points about base dimensions:

 1. The choice of base dimensions is largely a matter of convention.
 2. Dimensionless quantities cannot be used in dimensional analysis, such as checking the dimensional consistency of equations.

Point 1 above means it is not "wrong" to use a system with 8 base dimensions with angle as one of them.
For instance, the [SI Brochure](https://www.bipm.org/en/publications/si-brochure) states:

> Physical  quantities  can  be  organized in  a  system  of  dimensions,  where  the  system  used  is   decided  by  convention.

and

> For  historical  reasons the radian and steradian are treated as derived units

Note that by including *angle* as a dimension we are dropping its definition as a ratio of
lengths.
This is what makes the SI angle dimensionless and would make this 8-dimension system
incoherent (dimensions would not be linearly independent).

Point 2 means that we cannot (easily) differentiate between different dimensionless quantities.
In practice this means we have to be very careful when dealing with dimensionless quantities.
Here are some motivating examples using [Unitful.jl](https://painterqubits.github.io/Unitful.jl/).

## Example- Dimensional Consistency

Trying to add *quantities* with different dimensions results in an error.

```jldoctest
julia> using Unitful

julia> number_of_cats = 5
5

julia> length = 2u"m"
2 m

julia> length + number_of_cats
ERROR: DimensionError: 2 m and 5 are not dimensionally compatible.
[...]
```

However this does not work with dimensionless quantities such as angles.

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using Unitful

julia> angle = 10u"°"
10°

julia> number_of_cats = 5
5

julia> angle + number_of_cats
5.174532925199433
```

What happened here?
First it was recognized that both quantities have the same dimensions (no dimensions in this case) and therefore can be added.
Since the units are different (degrees and no units) they both need to be converted to the base unit (`1`), which in the case of the angle means converting it to radians.
Finally they can be added.

Since angle is not a dimension we cannot differentiate between units of angle and other dimensionless units, which also leads to problems like this:

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using Unitful

julia> 1u"°" + 1u"rad"
1.0174532925199433
```

where the results has no units (converted to units of `1`).

## Example - Angular Frequency

[Angular frequency](https://en.wikipedia.org/wiki/Angular_frequency) is a common way to describe the frequency of a periodic response.
It is a measure of rotational rate (i.e. of the phase angle of the periodic waveform) and has units of (phase) angle over units of time (e.g. $rad/s = 1/s$).
The frequency on the other hand is defined as one over the period and has units of 1 over time (e.g. $Hz = 1/s$).
These are essentially the same units for two physically different quantities.
And although they are physically different quantities they are used in practice to describe the same thing: how fast is the response repeating (which is also commonly described with yet a third physically distinct quantity: the period in units of time).
The fact that frequency and angular frequency have the same units and are used to describe the same thing is often the source of many embarrassing mistakes.

The [SI Brochure](https://www.bipm.org/en/publications/si-brochure) states:

> The  SI  unit  of  frequency  is  hertz,  the  SI  unit  of  angular  velocity  and  angular  frequency  is  radian  per  second,   and  the  SI  unit  of  activity  is  becquerel,  implying  counts  per  second.   Although it is formally correct to write all three of these units as the reciprocal second, the  use of the different names emphasizes the different nature of the quantities concerned.

We might naively try to convert between these as though it were merely a unit-conversion:

```jldoctest
julia> using Unitful

julia> uconvert(u"rad/s", 1u"Hz")
1 rad s⁻¹
```

which results in the wrong answer (the equivalent angular frequency is $2π~rad/s$) and no error message.

## Example - Multiple Dispatch

One of the main features of Julia is multiple dispatch.
*Unitful.jl* allows you to dispatch on dimensions, defining functions that can take quantities with any units of the dispatched dimension.
This ability can **not** be used for angular dimensions, and we have to either (1) dispatch on *no dimension* or (2) dispatch on an union of all angle units.
The former would work for all dimensionless quantities not just angles, and the latter can become cumbersome with a large number of units when considering prefixes and additional units in [UnitfulAngles.jl](https://github.com/yakir12/UnitfulAngles.jl).

```jldoctest; filter = r"(\\d*).(\\d{1,10})\\d+" => s"\\1.\\2"
julia> using Unitful

julia> what_am_i(::Unitful.Length) = "I am a length."
what_am_i (generic function with 1 method)

julia> what_am_i(::Unitful.Time) = "I am a time."
what_am_i (generic function with 2 methods)

julia> what_am_i(::DimensionlessQuantity) = "I am an angle?"
what_am_i (generic function with 3 methods)

julia> my_height = 6u"ft" + 1.0u"inch"
1.8542 m

julia> angle = 1.2u"rad"
1.2 rad

julia> percent = 12u"percent"
12 %

julia> what_am_i(my_height)
"I am a length."

julia> what_am_i(angle)
"I am an angle?"

julia> what_am_i(percent)
"I am an angle?"
```

## Takeaways

The main takeaway is that

> While the choice to use the SI dimensions in Unitful is the right one, for use cases that deal extensively with a dimensionless quantity, it can be extremely useful to extend the base dimensions to include that quantity.
> This package extends it to use *angles* as a dimension.

There will always be quantities which are dimensionless and have units of `1` as well as distinct quantities with the same dimensions.
There is no "complete" system and this package is simply an extension to facilitate working with angles specifically.
And while this resolves some confusion between, for example frequency and angular frequency (which have the same dimension in SI), there are still different quantities with the same dimension of angle, namely plane angles and phase angles.
