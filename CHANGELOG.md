# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Extending the adopted spec, each change should have a link to its corresponding pull request appended.

## [3.1.0](https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v3.0.1...v3.1.0) (2022-09-19)


### Features

* expose cos_project variable ([#91](https://github.com/terraform-google-modules/terraform-google-container-vm/issues/91)) ([b32263d](https://github.com/terraform-google-modules/terraform-google-container-vm/commit/b32263d30cf2a61d20ddbca94733bf3abfb7a446))

## [3.0.1](https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v3.0.0...v3.0.1) (2022-07-20)


### Bug Fixes

* restart policy kills konlet-startup container fix for the value Never ([#87](https://github.com/terraform-google-modules/terraform-google-container-vm/issues/87)) ([fcbdafa](https://github.com/terraform-google-modules/terraform-google-container-vm/commit/fcbdafa2d5b00792c388dcda1e1715f5e2a615e6))

## [3.0.0](https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v2.0.0...v3.0.0) (2022-02-03)


### ⚠ BREAKING CHANGES

* add Terraform 0.13 constraint and module attribution (#70)

### Features

* Add container outputs ([#63](https://github.com/terraform-google-modules/terraform-google-container-vm/issues/63)) ([baa02ef](https://github.com/terraform-google-modules/terraform-google-container-vm/commit/baa02efede3eb42a6fa071761965d4885b9d64d8))
* add Terraform 0.13 constraint and module attribution ([#70](https://github.com/terraform-google-modules/terraform-google-container-vm/issues/70)) ([5e69eaf](https://github.com/terraform-google-modules/terraform-google-container-vm/commit/5e69eafaaaa8302c5732799e32d1da5c17b7b285))
* update TPG version constraints to allow 4.0 ([#78](https://github.com/terraform-google-modules/terraform-google-container-vm/issues/78)) ([4b769ec](https://github.com/terraform-google-modules/terraform-google-container-vm/commit/4b769ec7c46cd9b1d714c8782d6fa95fd9f1bc6f))
* Example for showing advanced container options [#55]

### Bug Fixes

* Coerce case for restart policy ([#77](https://github.com/terraform-google-modules/terraform-google-container-vm/issues/77)) ([5612b31](https://github.com/terraform-google-modules/terraform-google-container-vm/commit/5612b31592aade08544aa083658c331b5e06e712))

## [2.0.0] - 2019-12-13

### Added

- Support for named COS images and option to specify cos family. [#54]

### Changed

- **Breaking**: Removed dependency on ruby by using terraform's `yamlencode` instead. See the [upgrade guide](./docs/upgrading_to_v2.0.md) for details. [#57]

## [1.0.4] - 2019-10-16

### Fixed

- Fix default value of `kms_data` in `cos-mysql` submodule. [#48]

## [1.0.3] - 2019-10-12

### Fixed

- Fix regression in cos-mysql `kms_data` variable introduced in [#31]. [#46]

## [1.0.2] - 2019-10-11

### Fixed

- Migrated MIG example to TF 0.12 syntax and compatible modules. [#41]
- MySQL password file permissions and datadir mount. [#39]

## [1.0.1] - 2019-08-22

### Fixed

- Terraform 0.12 syntax in submodules. [#31]

## [1.0.0] - 2019-08-05

### Changed

- Supported version of Terraform is v0.12. [#27]

## [0.3.0] - 2019-05-15

### Added

- Initial import of the CFT Fabric COS modules. [#20]

### Fixed

- Fix script used for copyright boilerplate verification [#21]


## [0.2.0] - 2019-05-10

### Added

- added Docker environment variables section example. [#19]

## [0.1.1]

### Fixed

- `true` is properly rendered as a boolean in the
  `metadata_value` output. [#17]

## 0.1.0
### ADDED
- This is the initial release of the Container VM module.

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v1.0.4...v2.0.0
[1.0.4]: https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v0.3.0...v1.0.0
[0.3.0]: https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/terraform-google-modules/terraform-google-container-vm/compare/v0.1.0...v0.1.1

[#55]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/55
[#57]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/57
[#54]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/54
[#48]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/48
[#46]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/46
[#41]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/41
[#39]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/39
[#31]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/31
[#27]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/27
[#21]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/21
[#20]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/20
[#19]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/19
[#17]: https://github.com/terraform-google-modules/terraform-google-container-vm/pull/17
