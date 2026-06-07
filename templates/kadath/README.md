# AthenaK + Kadath/FUKA on Aurora (ALCF)

This directory contains build scripts for compiling Kadath/FUKA and AthenaK
with the `kadath_bns` problem generator on the Aurora cluster.

| Script | Purpose |
|--------|---------|
| `install_aurora.sh` | Build the Kadath/FUKA library (`libkadath.a`) |
| `kadath_bns_aurora.sh` | Configure and build AthenaK with `-DPROBLEM=kadath_bns` |

For full setup instructions — including patching Kadath, linking it into the
AthenaK source tree, input file configuration, and running the simulation —
see the tutorial:

**https://github.com/alanlam1002/athenak-tutorial-kadath**
