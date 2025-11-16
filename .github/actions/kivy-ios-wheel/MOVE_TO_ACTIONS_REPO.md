# Moving to kivy-school/actions Repository

This action should be moved to the `kivy-school/actions` repository.

## Structure in actions repo

```
kivy-school/actions/
├── kivy-ios-wheel/
│   ├── action.yml
│   └── README.md
```

## Files to move

1. Copy `action.yml` from this directory to `kivy-school/actions/kivy-ios-wheel/action.yml`
2. Copy `README.md` from this directory to `kivy-school/actions/kivy-ios-wheel/README.md`

## Update README.md

After moving, update the usage examples in README.md to use:

```yaml
uses: kivy-school/actions/kivy-ios-wheel@main
```

instead of:

```yaml
uses: kivy-school/kivy-mobile-builder/.github/actions/kivy-ios-wheel@main
```

## Update workflows

Update any workflows in this repository that use the action to reference the new location:

```yaml
- name: Build iOS Wheel
  uses: kivy-school/actions/kivy-ios-wheel@main
  with:
    arch: ${{ matrix.arch }}
```
