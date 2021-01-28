using Documenter, Thebes, Luxor, Rotations

makedocs(
    modules = [Thebes],
    sitename = "Thebes",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true", sidebar_sitename=true),
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
    target = "build"
)
