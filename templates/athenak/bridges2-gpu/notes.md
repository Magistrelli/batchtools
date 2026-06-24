# Notes about compiling and running on PSC Bridges-2
1. Data transfers on the login node are throttled. Do not attempt to clone directly to
   your home directory on a login node. It is much easier to clone on an interactive node
   or use the data transfer node to copy the files from your local machine.
2. If CMake gives you error messages about git inside the Kokkos directory, delete
   `kokkos/.git`.
3. Compilation can be slow on the login nodes. Be patient or try on a compute node
   instead.
