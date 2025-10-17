# Homebrew Taps

Official Homebrew tap for [euforicio](https://github.com/euforicio)'s tools.

## Installation

```bash
brew tap euforicio/taps
```

## Available Formulas

### wikimd

Local-first Markdown wiki with live file watching and elegant UI.

```bash
brew install wikimd
```

**Repository:** [euforicio/wikimd](https://github.com/euforicio/wikimd)

**Usage:**
```bash
# Start wiki server
wikimd --root ~/my-wiki
```

For enhanced search functionality, install ripgrep:
```bash
brew install ripgrep
```

---

## Adding More Tools

This tap can contain multiple formulas. To add a new tool:

1. Create a new formula file in `Formula/<tool-name>.rb`
2. Follow the [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
3. Test locally: `brew install --build-from-source Formula/<tool-name>.rb`
4. Audit: `brew audit --strict --online Formula/<tool-name>.rb`
5. Commit and push

## Maintainers

Maintained by [euforicio](https://github.com/euforicio).

## License

Individual formulas may have different licenses. See each tool's repository for details.
