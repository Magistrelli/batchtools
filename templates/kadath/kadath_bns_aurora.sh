#!/bin/bash
#
# Build script for AthenaK with kadath_bns problem on Aurora (ALCF)
# MPI + Intel GPU (SYCL) build
# Kokkos version: 4.7.04
#
# Usage:
#   bash kadath_bns_aurora.sh          # configure + build
#   bash kadath_bns_aurora.sh clean    # wipe build directory, then configure + build
#

set -e

# ---------------------------------------------------------------------------
# Load modules
# ---------------------------------------------------------------------------
echo "Loading modules..."
module load boost/1.88.0
module load fftw/3.3.10
module load cmake

echo "Currently loaded modules:"
module list

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
ATHENAK_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${ATHENAK_HOME}/build_kadath_test2"

# GSL installed locally (no cluster module on Aurora; see install_aurora.sh)
export GSL_HOME="${HOME}/local"

# FFTW root (set by fftw module; fallback to known spack path)
export FFTW_ROOT="${FFTW_ROOT:-/opt/aurora/26.26.0/spack/unified/1.1.1/install/linux-x86_64/fftw-3.3.10-6vaqs46}"

# MKL root (set by oneapi module; fallback to known path)
export MKLROOT="${MKLROOT:-/opt/aurora/26.26.0/oneapi/mkl/latest}"

# Help cmake find FFTW3 via pkg-config and GSL via prefix path
export PKG_CONFIG_PATH="${FFTW_ROOT}/lib/pkgconfig:${PKG_CONFIG_PATH}"

echo ""
echo "=== Aurora environment ==="
echo "  ATHENAK_HOME : ${ATHENAK_HOME}"
echo "  BUILD_DIR    : ${BUILD_DIR}"
echo "  GSL_HOME     : ${GSL_HOME}"
echo "  FFTW_ROOT    : ${FFTW_ROOT}"
echo "  MKLROOT      : ${MKLROOT}"
echo ""

# ---------------------------------------------------------------------------
# Configure
# ---------------------------------------------------------------------------
echo "Setting up build directory: ${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

if [ "${1}" = "clean" ]; then
    echo "=== Wiping build directory ${BUILD_DIR} (required when switching Kokkos versions) ==="
    rm -rf "${BUILD_DIR}"
    mkdir -p "${BUILD_DIR}"
fi

echo "Configuring with CMake..."
cmake \
  -DAthena_ENABLE_MPI=ON \
  -DCMAKE_CXX_COMPILER=icpx \
  -DCMAKE_BUILD_TYPE=Release \
  -DPROBLEM=kadath_bns \
  -DGSL_ROOT_DIR="${GSL_HOME}" \
  -DKokkos_ENABLE_SERIAL=ON \
  -DKokkos_ENABLE_SYCL=ON \
  -DKokkos_ENABLE_SYCL_RELOCATABLE_DEVICE_CODE=ON \
  -DKokkos_ARCH_INTEL_PVC=ON \
  "${ATHENAK_HOME}"

#-DKokkos_ENABLE_DEPRECATED_CODE_4=ON \
#-DBLA_VENDOR=Intel10_64lp \
# ---------------------------------------------------------------------------
# Build
# ---------------------------------------------------------------------------
echo "Building with make..."
make -j16

# ---------------------------------------------------------------------------
# Verify
# ---------------------------------------------------------------------------
if [ -f "${BUILD_DIR}/src/athena" ]; then
    echo ""
    echo "=========================================="
    echo "Build successful!"
    echo "Executable: ${BUILD_DIR}/src/athena"
    ls -lh "${BUILD_DIR}/src/athena"
    echo "=========================================="
else
    echo "Error: Executable not found!"
    exit 1
fi
