<!-- Itsnexn was here \[._.]/ -->

# Itsnexn's Dotfiles!

### TABLE OF CONTENT

- [INFORMATION](information)
- [INSTALLATION](installation)
- [RULES](rules)
- [SUPPORT MY WORK](support-my-work)
- [LICENSE](license)

### INFORMATION

This is my personal dotfiles repository, Thanks for dropping by!

Dotfiles are the customization files that are used to personalize your
GNU/Linux or other Unix-Like system. This repository contains my personal
dotfiles. They are stored here for convenience so that I may quickly access
them on new machines or new installs. also, others may find some of my
configurations helpful in customizing their own dotfiles.

Configurations in this repo:
- Text editor:              [vim](https://vim.org)
- mpd client/Music Player:  [ncmpcpp](https://github.com/ncmpcpp/ncmpcpp)
- X11 Compositor:           [picom](https://github.com/yshui/picom)
- RSS Reader:               [newsboat](https://newsboat.org/)
- Shell:                    [bash](https://www.gnu.org/software/bash/) FTW!
- Terminal multiplexer:     [tmux](https://github.com/tmux/tmux)
- Document Reader:          [zathura](https://pwmt.org/projects/zathura/)
- Notification deamon:      [wired-notify](https://github.com/Toqozz/wired-notify)

My Other Configurations:
- Terminal emulator: _personal fork of [st](https://github.com/itsnexn/st)_
- Window manager:    _personal fork of [dwm](https://github.com/itsnexn/dwm)_
- Application menu:  _personal fork of [dmenu](https://github.com/itsnexn/dmenu)_

Colors are based on [gruvbox](https://github.com/morhetz/gruvbox)

Fonts:
[jet brains mono](https://github.com/JetBrains/JetBrainsMono),
[iosevka](https://github.com/be5invis/Iosevka),
[nerd fonts](https://github.com/ryanoasis/nerd-fonts)

### INSTALLATION

I use GNU [`stow`](https://www.gnu.org/software/stow/) to manage my dotfiles.
GNU stow lets you symlink a project’s files to an arbitrary folder.

```bash
git clone https://github.com/itsnexn/dotfiles
cd /path/to/repo

# GNU stow creates symlink in [-t]arget directory which in this case is users home directory
stow -t ~ .
```

If you received a _WARNING_, it is most likely because you already have files
that contradict with the installation process.

Here's an awesome blog post about using GNU stow to manage your dotfiles.
- [Using GNU Stow to manage your dotfiles](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)

### RULES

• **XDG BASE DIRECTORY**:

We want to make our home directory as clean as possible. the XBDS was created
on 2003 to address the narrow needs of the X Desktop Group
(now https://www.freedesktop.org) and their related per-user configuration and
data files. Since then many<sup>[1]</sup> projects have adopted the
specification as a solution to the uncontrolled<sup>[2]</sup> dotfile situation
users have grown to dislike.<sup>[3]</sup>

• **KISS PRINCIPLE**:

We don't want to include every single line of the sample configuration file.
thats just stupid. your feature self can just [R.T.F.M](https://en.wikipedia.org/wiki/RTFM)
and add/update what he needs. write something that sucks less; stop including
keybindings/features that you're not even gonna use once.

### SUPPORT MY WORK

I enjoy customizing stuff and sharing my configurations with others. If you
liked something I built, please consider giving me a **star** or making a
[donation](https://itsnexn.xyz/donation).

### [LICENSE](/LICENSE)

The files and scripts in this repository are licensed under the MIT License,
which allows you to use, modify, copy, distribute, sell, give away, etc. the
software. In other words, do what you want with it. The only requirement with
the MIT License is that the license and copyright notice must be provided with
the software.

[1]: https://wiki.archlinux.org/index.php/XDG_Base_Directory
[2]: http://pub.gajendra.net/2012/09/dotfiles
[3]: https://www.reddit.com/r/linux/comments/971m0z/im_tired_of_folders_littering_my_home_directory/
