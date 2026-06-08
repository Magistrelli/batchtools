cmake   -DAthena_ENABLE_MPI=ON \
	-DAthena_ENABLE_OPENMP=ON \
	-DCMAKE_CXX_COMPILER=icpx \
	-DGSL_ROOT_DIR=`gsl-config --prefix` \
	-DKokkos_ENABLE_SERIAL=ON \
	$@ ../
