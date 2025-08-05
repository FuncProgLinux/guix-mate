# Frequently Asked Questions

> No one has asked anything before.

1. Why not follow the GNU Guix file names for the packages repository?

This project is limited at it's scope, the primary goal is to provide a nice
MATE Desktop experience to the Trisquel users migrating to Guix. Packages are
from MATE users for MATE users, if other users get benefit from this it's a
plus, but not a goal :)

2. A package broke! what should I do?

Please try rebuilding the package on your own checkout or clone the source file
to invoke `guix package -f <path_to_your_scm_file>` and open an issue with the
build logs in **THIS CHANNEL**. That way we can help you with debugging or
concluding if this is a bug of ours or an upstream bug.

3. Why are `mint-cursors` missing?

The `mint-cursor-themes` package was skipped because it contains the Bibata
cursor theme which is already present in GNU Guix. The other cursors don't
appear to be important whatsoever, so, that particular package was skipped.
