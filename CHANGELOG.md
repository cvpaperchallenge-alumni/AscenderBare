# Changelog

All notable changes to this project will be documented in this file.

This project follows a date-based versioning scheme (`vYYYY.MM.DD`) and the
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) convention.

## [Unreleased]

### Added

- (placeholder)

### Changed

- (placeholder)

### Fixed

- (placeholder)

______________________________________________________________________

## [v2025.09.19] - 2025-09-19

### Added

- Added **ABCI job template** (`scripts/abci/job_template.sh`).
- Added **mise / uv setup for ABCI job scripts**.
- Introduced **direnv support**, enhancing handling of environment variables such as `MISE_DATA_DIR`.
- Improved developer experience: added `poethepoet` as a development dependency.

### Changed

- Reorganized **job template placement** (moved to a dedicated directory).
- Updated **Dockerfile** (build adjustments and maintenance).
- Updated **uv settings** and **container naming**.

### Fixed

- Fixed **CI jobs** and performed general maintenance.
- Fixed `.venv` path specification and environment variable names originating from **mise**.
- Added **direnv enablement instructions** and resolved shim conflicts.

### Documentation

- Added and updated **README/ABCI documentation** (usage instructions on ABCI, caveats, and pointers to templates).
- Cleaned up **warning messages** and made minor textual adjustments.

______________________________________________________________________

## [v2025.09.01] - 2025-09-01

### Added

- Initial setup adjustments.
