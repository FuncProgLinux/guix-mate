# GUIX MATE 🦬🧉

This channel tries to improve your MATE Desktop experience in GNU GUIX systems.

- Tired of your favorite GTK applications looking like `libadwaita`? We've got cross-platform xapps from Linux Mint adapted to GUIX. 
- Jealous of that Ubuntu audio indicator with music player controls?
- Running away from rust? MATE is almost pure C.

Return to the comfy *traditional* desktop everyone loved in the 2000's 

_This channel is still experimental. You can see package progress [here](https://codeberg.org/guix-mate/-/projects/13979)_

## Usage

This channel is not ready to be used. Grab an issue if you wish to help.

## Goals

- Rival Ubuntu MATE on software available for the MATE desktop.
- Patch upstream sources to remove `apt/dpkg` specific behavior
- Updates at least once per week/month, there's much room for improvement
- Rebrand if possible to improve user experience and integration with GUIX

## Available software

The following list shows the available packages you can install + the packages we wish to maintain in this repository:

### Mint
- [ ] `mintdesktop` (The original mate-tweak)
- [ ] `mintMenu` (The original `advanced-mate-menu`)
- [x] `python3-xapp` (Python bindings for libxapp)
- [ ] `xed` (Pluma fork, more complete than pluma, cross platform between XFCE/MATE/Cinnamon)
- [ ] [`xdg-desktop-portal-xapp`](https://github.com/linuxmint/xdg-desktop-portal-xapp) Make Cinnamon, MATE & XFCE compatible with desktop portals.
- [ ] [`xviewer`](https://github.com/linuxmint/xviewer) (xapp image viewer, looks the same on XFCE/MATE/Cinnamon)
- [ ] [`sticky`](https://github.com/linuxmint/sticky) (Note taking application.)
- [ ] [`xapp-thumbnailers`](https://github.com/linuxmint/xapp-thumbnailers) (Thumbnail generators)
- [ ] [`webapp-manager`](https://github.com/linuxmint/webapp-manager/tree/master)
- [ ] [`warpinator`](https://github.com/linuxmint/warpinator)
- [ ] [`xreader`](https://github.com/linuxmint/xreader) 
- [ ] [`timeshift`](https://github.com/linuxmint/timeshift)
- [ ] [`pix`](https://github.com/linuxmint/pix)

### Ubuntu MATE
- [ ] Yaru MATE themes by default
- [ ] `mate-hud` with `rofi`
- [ ] `mate-dock-applet`
- [ ] `indicator-emojitwo`
- [ ] Ayatana indicators
- [ ] `brisk-menu` (It has a memory leak and hasn't been updated in 4 years (nor is it stable). Seems to work fine on latest ubuntu mate)
- [ ] `ubuntu-mate-artwork` (Wallpapers, icons and themes)
- [ ] [`mate-window-applets`](https://github.com/ubuntu-mate/mate-window-applets)
- [ ] Plank

### Trisquel
- [ ] Trisquel Themes (greybird?)
- [ ] Trisquel Icons (subsitute trisquel logo for GUIX logo by luis felipe)
- [ ] Package abrowser (most of it's installation is rebranding only in the Debian package. Some way to avoid using a proprietary channel is greatly appreciated)

## Excluded software

### Ubuntu MATE
- [`mate-optimus`](https://github.com/ubuntu-mate/mate-optimus) only useful for proprietary drivers.