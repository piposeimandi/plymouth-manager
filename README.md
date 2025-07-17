# Plymouth Manager

Theme manager for Plymouth bootsplash, now compatible with Linux Mint 22 and derivatives.

## Features

- List and interactively select Plymouth themes.
- Install and activate new themes.
- Preview the bootsplash for a customizable amount of time.
- Enhanced security, robustness, and usability.

## Requirements

- bash
- sudo
- plymouth
- update-alternatives
- update-initramfs

Make sure these commands are installed on your system before using Plymouth Manager.

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/x1unix/plymouth-manager/master/install.sh | bash
```
Or download the script manually and make it executable:

```bash
wget https://raw.githubusercontent.com/piposeimandi/plymouth-manager/main/plym.sh
chmod +x plym.sh
sudo mv plym.sh /usr/local/bin/plym
```

## Usage

```
plym [command] [arguments...]
```

### Available commands

- `list`  
  List installed Plymouth themes, indicating the current one.

- `install <theme>`  
  Install and register the specified theme (the folder must be in `/usr/share/plymouth/themes`).

- `select`  
  Interactively select the Plymouth theme and update initramfs.

- `preview [seconds]`  
  Show a preview of the bootsplash for the specified number of seconds (default: 5).  
  **Requires root privileges**.

- `help`, `--help`, `-h`  
  Show help.

### Examples

```bash
sudo plym install mytheme
sudo plym select
sudo plym preview 8
plym list
```

## Recent Improvements

- Protected variables and safe path handling.
- Automatic dependency checking.
- Improved error handling and informative messages.
- Preview option with customizable duration.
- Refactored code and documented functions.
- Tested and compatible with Linux Mint 22.

---

Found a bug or have suggestions? Open an issue!
