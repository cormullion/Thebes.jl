![thebes](docs/src/assets/figures/repository-open-graph-template.png)

| **Documentation**                       | **Build Status**                          | **Code Coverage**               |
|:---------------------------------------:|:-----------------------------------------:|:-------------------------------:|
| [![][docs-stable-img]][docs-stable-url] | [![Build Status][travis-img]][travis-url] | [![][codecov-img]][codecov-url] |
| [![][docs-development-img]][docs-development-url] | [![Build Status][appvey-img]][appvey-url] |                                 |

# Thebes

Thebes.jl is a little extension package for vector-graphics package [Luxor.jl](https://github.com/JuliaGraphics/Luxor.jl) that provides some rudimentary 3D (2.5D?) wireframe functionality.

![mobius](docs/src/assets/figures/mobiusmovie.gif)

#### ‘Thebes’?

Luxor.jl is built on [Cairo.jl](https://github.com/JuliaGraphics/Cairo.jl), and Thebes.jl provides a 3D context for Luxor.jl. Luxor, the modern city about 675km south of Cairo, is built on the site of Thebes, the ancient capital city of Egypt, which flourished 5000 years ago.

# Acknowledgements

Many thanks to Chris @c42f who help me implement the rotations.

[docs-development-img]: https://img.shields.io/badge/docs-development-blue.svg
[docs-development-url]: http://cormullion.github.io/Thebes.jl/dev/

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: http://cormullion.github.io/Thebes.jl/dev/

[travis-img]: https://travis-ci.com/cormullion/Thebes.jl.svg?branch=master
[travis-url]: https://travis-ci.com/cormullion/Thebes.jl

[appvey-img]: https://ci.appveyor.com/api/projects/status/yhslnuoo8803e2pe?svg=true
[appvey-url]: https://ci.appveyor.com/project/cormullion/thebes-jl/branch/master

[codecov-img]: https://codecov.io/gh/cormullion/Thebes.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/cormullion/Thebes.jl
