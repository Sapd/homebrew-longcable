# Homebrew tap for Longcable

[Longcable](https://github.com/Sapd/longcable) is a free, open-source USB/IP server for
macOS: use your Mac's USB devices and microphone on a Windows or Linux PC over the network.

```bash
brew install --cask sapd/longcable/longcable
```

This installs the app and its background service (it asks for your password once).
Then open Longcable from Applications. Update with `brew upgrade`, remove with
`brew uninstall longcable` (add `--zap` to also delete its settings and logs).

Longcable is not notarized, so the cask clears macOS's quarantine flag after
installing, as Longcable's own installer does. The cask follows new releases
automatically.
