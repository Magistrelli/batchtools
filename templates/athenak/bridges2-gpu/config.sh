#!/usr/bin/env bash

cmake -D Athena_ENABLE_MPI=ON \
      -D Kokkos_ENABLE_CUDA=ON \
      -D Kokkos_ENABLE_CUDA_LAMBDA=ON \
      -D Kokkos_ARCH_VOLTA70=ON \
      -D Kokkos_ENABLE_IMPL_CUDA_MALLOC_AYSNC=OFF \
      -D NVHPC_CUDA_HOME=../kokkos/bin/nvcc_wrapper \
      $@ ../
