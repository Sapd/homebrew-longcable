cask "longcable" do
  version "0.4.1"
  sha256 "322ce1a372be747a804c22295a3387f92236b8e7511cd26de4278c5da289e937"

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
  # Runs as root before the app is moved to Applications. Longcable is not notarized:
  # like its curl installer, it clears the quarantine flag so Gatekeeper doesn't block
  # the app and the background service, then installs or updates the service (a
  # launchd daemon). The service keeps its settings across updates.
  installer script: {
    executable: "/bin/bash",
    args:       [
      "-c",
      'xattr -dr com.apple.quarantine "$1" && exec /bin/bash "$1/scripts/install-mac.sh"',
      "longcable-install",
      "#{staged_path}/longcable",
    ],
    sudo:       true,
  }

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
