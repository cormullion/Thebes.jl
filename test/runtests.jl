using Thebes, Test

mktempdir() do tmpdir
    cd(tmpdir) do

        m = make(Cube)
        @test length(m.vertices) == 8

        m = make(Cube, "this is a cube")
        @test length(m.vertices) == 8

        @info "...testing 3D point arithmetic"
        include("point3d-arithmetic.jl")

        @info "... running test-1"
        include("test-1.jl")

        @info "... running test-2"
        include("test-2.jl")

        @info "... running test-3"
        include("test-3.jl")

        @info "... running test-4"
        include("test-4.jl")

        @info "... running test-5"
        include("test-5.jl")

        @info "... running test-6"
        include("test-6.jl")

        @info "... running test-7"
        include("test-7.jl")

        @info "... running latex text"
        include("latex-test.jl")

        @info "Write more tests...!"
    end
end
