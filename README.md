<img src=".repo-assets/logo.png" height="150" width="150"  />

# GUIX MATE 🧉

This channel tries to improve your MATE Desktop experience in GNU GUIX systems.

- Tired of your favorite GTK applications looking like `libadwaita`? We've got
  cross-platform xapps from Linux Mint adapted to GUIX.
- Jealous of that Ubuntu audio indicator with music player controls?
- Running away from rust? MATE is almost pure C.

Return to the comfy _traditional_ desktop everyone loved in the 2000's.

## Goals

- Rival Ubuntu MATE on software available for the MATE desktop.
- Patch upstream sources to remove `apt/dpkg` specific behavior
- Updates at least once per week/month, there's much room for improvement
- Rebrand if possible to improve user experience and integration with GUIX
- Upstream packages to GNU Guix to benefit trisquel users migrating

## Usage (Remote)

To install this channel you must paste the following on your `channels.scm`
file:

```scheme
(channel
    (name 'guix-mate)
    (branch "main")
    (url "https://codeberg.org/guix-mate/guix-mate")
    (introduction
            (make-channel-introduction
                    "70e843bef537d74d43744d4abc94691adc4e4197"
                    (openpgp-fingerprint
                    "DF6F 2589 1002 1FB5 29DB DBF1 E495 97E6 5890 833D"))))
```

## Contributing

Please see the [CONTRIBUTING](CONTRIBUTING.md) file for more details.

## FAQ

Please read [FAQ.md](FAQ.md)

## Available software

Consult the [package matrix document](PACKAGE_MATRIX.md) for more information
about available software in this repository.

## Credits

This channel takes bits & pieces from other libre software projects:

- Futurile's Guix packaging series:
  - [build systems & phases](https://www.futurile.net/2024/07/23/guix-package-structure-build-system-phases/)
  - [modify packages using inheritance](https://www.futurile.net/2024/01/12/modifying-guix-packages-using-inheritance/)
