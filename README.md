# GoXLR Power

Automatically turns off your GoXLR lights when your PC shuts down.

## The Problem

When you shut down your PC, the GoXLR stays powered via USB and its lights remain on. This can be annoying, especially at night or if you want a clean shutdown experience.

## The Solution

GoXLR Power is a lightweight background service that:
- Detects when Windows is shutting down
- Automatically turns off all GoXLR lights before shutdown completes
- GoXLR Utility handles turning lights back on at startup (no action needed)

## Requirements

- Windows 10 or Windows 11
- [GoXLR Utility](https://github.com/GoXLR-on-Linux/goxlr-utility) installed in `C:\Program Files\GoXLR Utility`
- GoXLR or GoXLR Mini

## Installation

1. Download this repository
2. Right-click on `install.bat`
3. Select **"Run as administrator"**
4. Done!

The service will start immediately and will automatically start on every login.

## Uninstallation

1. Right-click on `uninstall.bat`
2. Select **"Run as administrator"**

This completely removes GoXLR Power from your system.

## How It Works

GoXLR Power uses a simple approach:

1. **At login**: A hidden PowerShell script starts in the background
2. **Running**: The script listens for Windows `SessionEnding` events (shutdown/restart/logoff)
3. **At shutdown**: When detected, it sends a command to GoXLR Utility to turn off all lights (`lighting global 000000`)
4. **At next startup**: GoXLR Utility automatically loads your profile and restores your lighting

### Files Installed

All files are installed in `C:\ProgramData\GoXLR-Power\`:

| File | Purpose |
|------|---------|
| `goxlr-power.ps1` | PowerShell script that listens for shutdown events |
| `goxlr-power.vbs` | VBScript launcher to run PowerShell without a visible window |

A scheduled task named "GoXLR-Power" is created to start the service at login.

## Troubleshooting

### Lights don't turn off at shutdown

1. Make sure GoXLR Utility is running
2. Check if the scheduled task exists: Open Task Scheduler and look for "GoXLR-Power"
3. Try running `uninstall.bat` then `install.bat` again (both as administrator)

### GoXLR Utility is installed in a different location

Edit the `install.bat` file and change the `GOXLR_CLIENT` path to match your installation.

### I see a PowerShell window at startup

This shouldn't happen with the current version. If it does:
1. Run `uninstall.bat` as administrator
2. Run `install.bat` as administrator

## Notes

- The GoXLR cannot truly "power off" via software as it's powered by USB. This tool only turns off the lights.
- To completely cut power to your GoXLR when shutting down, enable **"ErP Ready"** or **"Deep Sleep"** in your BIOS settings.

## Disclaimer

**This software is provided "as is", without warranty of any kind, express or implied.**

- This is a community project and is **not affiliated** with TC-Helicon or the GoXLR Utility team
- Use at your own risk
- The author(s) are not responsible for any damage, data loss, or issues that may arise from using this software
- This software creates scheduled tasks and runs scripts at startup - review the source code if you have concerns
- Always download from the official repository to avoid tampered versions

## License

MIT License - Feel free to use, modify, and distribute.

## Contributing

Found a bug? Have an improvement? Feel free to:
- Open an issue
- Submit a pull request
- Share with the GoXLR community

## Credits

Made for the GoXLR community.

Uses [GoXLR Utility](https://github.com/GoXLR-on-Linux/goxlr-utility) for device communication.
