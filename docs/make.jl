using Documenter, Thebes, Luxor, Rotations

makedocs(
    modules  = [Thebes],
    sitename = "Thebes",
    warnonly = true,
    format   = Documenter.HTML(
        size_threshold = nothing,
        prettyurls = get(ENV, "CI", nothing) == "true",
        assets = ["assets/thebes-docs.css"],
        collapselevel = 1,
    ),
    pages    = Any[
        "Introduction to Thebes"  => "index.md",
        "The basics"              => "basics.md",
        "Views"                   => "views.md",
        "Polygons and planes"     => "polys.md",
        "Objects"                 => "objects.md",
        "Text"                    => "text.md",
        "Tools"                   => "tools.md",
        "Index"                   => "functionindex.md"
        ]
    )

deploydocs(
    repo = "github.com/cormullion/Thebes.jl.git",
    target="build",
    push_preview=true,
    forcepush=true,
)
