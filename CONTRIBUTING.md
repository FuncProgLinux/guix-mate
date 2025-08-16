# CONTRIBUTING

Thank you for being interested in contributing to yet another Guix channel. This
small document should guide you through our goals on this project.

## Makefile based workflow

Use the provided `Makefile` to aid you with package addition or IDE setup. The
`build-system` directory contains separated files for a specific purpose. By
default you can call this build system by just running `make`:

```
=== [GUIX MATE GNU MAKEFILE + PERL  BUILD SYSTEM v1.0.0] ===

Usage:
  make [target] [variables]

Target(s):
  dev                           Starts a development guix shell for this channel
  fmt                           Format the Guile Scheme source code of this repostory
  nrepl                         Starts nrepl-server for Emacs Arei

Variable(s):
  MAKE_DIR                      The directory where the build system Makefiles are stored (default: build-system)

Example(s):
  make dev
  make fmt
```

## Software flow

Contributing to the existing Guix distribution is our primary goal. However, you
may use this channel in case you want to test the packages before we present
them to the Guix developers. If any of our packages doesn't get into the main
Guix branch, we will still provide support for it from here:

Here's the mermaid diagram of the current workflow:

```mermaid
---
title: GUIX MATE Development Cycle
displayMode: compact
config:
  theme: dark
flowchart:
    useWidth: 400
    compact: true
---
graph TD
    subgraph Guix MATE
        A[[Package Development]] --> B{Initial Testing};
        B -- Passes --> C[[Usable Package]];
        B -- Fails --> A;
        F --> A;
    end

    C --> D{Attempt Upstream Contribution};
    D -- Upstream Accepts --> E[[Accepted in Official Guix Upstream]];
    D -- Upstream Rejects (for any reason) --> F[[Rejected by Upstream & Maintained in Guix MATE]];
```

## Contributing environment

If you wish to replicate the development environment:

1. Clone the repository, best if done in `~/src/guix-mate`
2. Enter a shell using `make dev` this shell is preconfigured with tools to
   develop this Guix channel.
3. Extend your scheme editing experience by running
   `./pre-inst-env -- guix repl --listen=tcp:37146` on a separate terminal to
   enhance emacs with `geiser-connect`
4. Test builds with `./pre-inst-env guix build <package>`
5. Test installation with `./pre-inst-env guix install <package>`
6. Style using `make-fmt`.
7. Hackers, you'll be free.
8. Replicate on a new branch to send patches :)

## Channel scope

This channel doesn't add non-related software like other tools or binaries aside
of the popular MATE Desktop implementations. We will maintain the upstreamed
packages on GNU Guix and the extra sources here.
