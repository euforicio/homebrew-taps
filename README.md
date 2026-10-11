# Homebrew Taps

Official Homebrew tap for [euforicio](https://github.com/euforicio)'s tools.

## Installation

```bash
brew tap euforicio/taps
```

## Available Formulas

### dotlocal

Local HTTPS routing for any server runtime on macOS and Linux (ARM64 and x86_64).

```sh
brew install euforicio/taps/dotlocal
# Explicit macOS privileged listeners and certificate trust:
dotlocal init
```

Starting with dotlocal 0.1.2, the CLI and daemon retain signed automatic updates.
Brew owns the launcher
and bundled binary; signed CLI updates replace `~/.dotlocal/bin/dotlocal`.
A newer Brew bundle advances that runtime unless a version is pinned or the nightly channel is selected. An older
bundle cannot downgrade a newer runtime. `brew info dotlocal` shows the package
version; `dotlocal version` shows the running version.

The hourly Actions workflow authenticates dotlocal's stable channel with its
pinned Ed25519 public key, checks all four release archive hashes, and tests real
Brew installation, upgrade, signed rollback/update and strict HTTPS/HTTP2 on
macOS/Linux ARM64/x86_64 before committing a formula change. Nightlies never
update the formula. Unchanged channels produce no commit. The workflow uses the
tap's own Actions token and needs no cross-repository credential.

`brew uninstall dotlocal` removes the launcher and bundle. User state and an
explicitly installed macOS daemon remain. Remove that service first with
`sudo dotlocal uninstall` if desired; formula operations never install a root service.

**Repository:** [euforicio/dotlocal](https://github.com/euforicio/dotlocal)

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

## Available Casks

### scratchpad

Simple, native macOS scratchpad and clipboard manager.

```bash
brew install --cask scratchpad
```

This is available via this tap:

```bash
brew tap euforicio/taps
brew install --cask euforicio/taps/scratchpad
```

**Repository:** [euforicio/scratchpad](https://github.com/euforicio/scratchpad)

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
