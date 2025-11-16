# Kivy iOS Wheel Action

A composite action for building Kivy iOS wheels for different architectures using cibuildwheel.

## Usage

### Basic Usage

To use this action in your workflow:

```yaml
name: Build iOS Wheels

on: [push, workflow_dispatch]

jobs:
  build_wheels:
    name: Build wheels on ${{ matrix.arch }}
    runs-on: macos-15
    strategy:
      matrix:
        arch: [arm64_iphoneos, arm64_iphonesimulator, x86_64_iphonesimulator]

    steps:
      - uses: actions/checkout@v5

      - name: Build iOS Wheel
        uses: kivy-school/actions/kivy-ios-wheel@main
        with:
          arch: ${{ matrix.arch }}
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `arch` | Target architecture (`arm64_iphoneos`, `arm64_iphonesimulator`, `x86_64_iphonesimulator`) | Yes | - |
| `repository` | Repository to clone | No | `kivy` |
| `owner` | Repository owner | No | `kivy-school` |
| `branch` | Branch to clone | No | `mobile_wheels` |
| `package-dir` | Package directory | No | `kivy` |
| `output-dir` | Output directory for wheels | No | `wheelhouse` |
| `kivy-split-examples` | Split Kivy examples | No | `1` |

## Example with Custom Inputs

```yaml
- name: Build iOS Wheel for arm64 iPhone
  uses: kivy-school/actions/kivy-ios-wheel@main
  with:
    arch: arm64_iphoneos
    repository: my-custom-package
    owner: my-org
    branch: main
    package-dir: src/package
    output-dir: dist
    kivy-split-examples: '0'
```

## Requirements

- Runs on macOS runners (tested on `macos-15`)
- Requires Xcode and iOS SDK to be available
- Uses `cibuildwheel` for building wheels

## Outputs

The action produces wheel files in the specified `output-dir` (default: `wheelhouse`).
