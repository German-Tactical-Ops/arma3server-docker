# Git Submodules Commands

```Bash
    git clone --recurse-submodules
    git submodule init
    git submodule update
    
    git submodule update --init
    git submodule update --init --recursive
```

## Development: New Submodules changes
```Bash
    git submodule update --remote
```

## Server: Pull changes from submodules remote
```Bash
    git pull --recurse-submodules
```
## Best Practices
- Always use `--recurse-submodules` when cloning to ensure all submodules are initialized and updated.
- Use `--remote` with `update` to fetch latest changes from remote repositories.
- Regularly run `git pull --recurse-submodules` to keep your project up-to-date with all submodule changes.