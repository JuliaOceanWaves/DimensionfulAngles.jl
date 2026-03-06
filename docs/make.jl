using Documenter
using DocumenterCitations
using DimensionfulAngles
using Unitful
using UnitfulAngles

ENV["UNITFUL_FANCY_EXPONENTS"] = true

bib = CitationBibliography(joinpath(@__DIR__, "references.bib"))

function _filter_prefixed(base, x; exceptions = [nothing])
    n = length(base)
    if (typeof(x) <: Unitful.Unitlike &&
        length("$x") > n &&
        "$x"[(end - n + 1):end] == base &&
        "$x" ∉ exceptions)
        return true
    end
    return false
end

makedocs(;
    sitename = "DimensionfulAngles",
    format = Documenter.HTML(
        assets = String["assets/citations.css",],
    ),
    modules = [DimensionfulAngles],
    pages = [
        "Home" => "index.md",
        "Angle as a dimension?" => "motivation.md",
        "Package Guide" => ["guide/intro.md",
            "guide/units.md",
            "guide/derived.md",
            "guide/base.md"],
        "Relationship to proposed SI extensions." => "proposed.md",
        "Index" => "syntax.md"
    ],
    plugins = [bib]
)

deploydocs(; repo = "github.com/JuliaOceanWaves/DimensionfulAngles.jl.git",)
