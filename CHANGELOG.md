# Changelog

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
