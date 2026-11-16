cask "longcable" do
  version "0.4.0"
  sha256 "23866c312cf49e5bde4f8c4517f9bc711b9bf9ffd43811658929fe3927e92bea"

  url "https://github.com/Sapd/longcable/releases/download/v#{version}/longcable-macos.tar.gz"
  name "Longcable"
  desc "USB/IP server for using USB devices and the microphone on another computer"
  homepage "https://github.com/Sapd/longcable"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "longcable/Longcable.app"

  # Structured postflight_steps can't run a command with sudo; third-party taps may
  # still use a postflight block.
  postflight do
    # Longcable is not notarized. Like its curl installer, drop the quarantine flag so
    # Gatekeeper doesn't block the app and the background service.
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Longcable.app", "#{staged_path}/longcable"]
    # Installs or updates the background service (a launchd daemon). Keeps its settings.
    system_command "/bin/bash",
                   args: ["#{staged_path}/longcable/scripts/install-mac.sh"],
                   sudo: true
  end

  uninstall launchctl: "org.sapd.longcable",
            quit:      "org.sapd.longcable.app",
            delete:    [
              "/Library/Application Support/Longcable/longcable-server",
              "/Library/LaunchDaemons/org.sapd.longcable.plist",
            ]

  zap delete: [
        "/Library/Application Support/Longcable",
        "/Library/Logs/Longcable",
      ],
      trash:  "~/Library/Preferences/org.sapd.longcable.app.plist"

  caveats <<~EOS
    Longcable runs a background service that shares the USB devices you choose.
    Open Longcable from Applications to choose them and to set up your PC.
  EOS
end
