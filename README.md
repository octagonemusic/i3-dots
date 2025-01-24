# i3-dots Configuration

This repository contains a set of dotfiles for my personal Arch Linux setup, including configurations for `i3`, `polybar`, `rofi`, `alacritty`, and other applications. The configuration is managed using `stow` to handle symlinks for a clean and modular setup.

## Prerequisites

Before you begin, make sure you have the following installed:

- `git`
- `stow`
- A Linux environment (Arch Linux preferred)

## Installation

### 1. Clone the Repository
Clone this repository to your desired location. For example:

```bash
git clone https://github.com/yourusername/i3-dots.git
```

### 2. Navigate to the i3-dots Folder
Move to the `i3-dots` folder you just cloned:

```bash
cd i3-dots
```

### 3. Stow the Configurations
Use `stow` to create symlinks for the desired configurations. For example, to stow `polybar` and `rofi` configurations:

```bash
stow -t ~ polybar rofi
```

This will create symlinks in your home directory (`~`) that point to the appropriate configuration files within the `i3-dots` folder.

### 4. Additional Configuration
For other configurations, repeat the stow process:

```bash
stow -t ~ alacritty
stow -t ~ i3
# and so on for other apps...
```

You can check the specific configuration folders within the `i3-dots` repository to see which applications have configuration files that can be stowed.

## Customization

You can modify the configuration files directly in the repository (e.g., changing colors in `polybar`, keybindings in `i3`, etc.). Once you make changes, just run `stow` again to ensure your home directory remains in sync with the repository.

## Unstowing Configurations

To remove a configuration and its symlinks from your home directory, use the `-D` flag:

```bash
stow -D -t ~ polybar
```

This will remove the symlinks but leave the original files in the repository intact.

## Troubleshooting

- **Missing dependencies**: Make sure all the required dependencies for each application (like `polybar`, `rofi`, etc.) are installed.
- **Symlink issues**: If `stow` creates symlinks in the wrong location, make sure you're running the `stow` command from within the `i3-dots` directory and using `-t ~` to specify the target directory.
  
