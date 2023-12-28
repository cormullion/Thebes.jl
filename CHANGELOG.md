# Changelog

## [v1.0.0] - 2023-12-????

### Added

### Changed

- Package extensions added kind of
- min Julia 1.9

### Removed

### Deprecated

──────────────────────────────────────────

## [v0.9.0] - 2023-01-24

### Added

- `scaleby!(o, d)`
- `import_off_file(fname)`

### Changed

- Package extensions sort of added

### Removed

### Deprecated

──────────────────────────────────────────

## [v0.8.0] - 2022-05-20 11:01:59

### Added

- 3D LaTex text
- draw Luxor paths

### Changed

- Project.toml
- some point3d comparisons
- fixed wrong spherical/cartesian conversions
- eachindex()

### Removed

### Deprecated

──────────────────────────────────────────

## [v0.7.0] - 2022-01-21

### Added

### Changed

- Project.toml

- midpoint() was wrong, fixed

### Removed

### Deprecated

──────────────────────────────────────────

## [v0.6.0] - 2021-03-11

### Added

### Changed

- cartesiantospherical() returns points in correct "math" order `(ρ, θ, ϕ)`
rather than scrambled "physics"-style :)
- pin(object) changed to accept a simpler rendering function

### Removed

### Deprecated

──────────────────────────────────────────

## [v0.5.0] - 2020-01-31

### Added

- dependency on Rotations.jl added

### Changed

- Point3Ds are now FieldVectors from StaticArrays.jl
- rotations now calculated by Rotations.jl
- all `rotateby` functions modified

### Removed

### Deprecated

──────────────────────────────────────────
