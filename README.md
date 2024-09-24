# Conventional commit check

A pre-commit hook to check if the **first** commit complies with [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/)

To use, create a `.pre-commit-config.yaml` in your repo and add the following:
```
repos:
  - repo: https://github.com/BrightNight-Energy/conventional-commit-check
    rev: v1.0.0  # Use the latest tag or commit SHA
    hooks:
      - id: first-commit-check
```

To install, use:

```shell
pre-commit install --install-hooks
pre-commit install --hook-type commit-msg
```

✨ No configuration, zero-dependency ✨
