# Conventional commit check

A pre-commit hook to check if a the **first** commit complies with [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/)

To use, create a `.pre-commit-config.yaml` in your repo and add the following:
```
repos:
  - repo: https://github.com/YOUR-USERNAME/conventional-commit-check
    rev: v1.0.0  # Use the latest tag or commit SHA
    hooks:
      - id: first-commit-check
```

✨ No configuration, zero-dependency ✨
