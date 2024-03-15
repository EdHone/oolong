# Copyright 2013-2024 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

import subprocess
from pathlib import Path

from spack.package import *


class Oolong(Package):
    """A lightweight, object-oriented logging system for modern Fortran applications."""

    homepage = "https://github.com/EdHone/oolong"
    url = "https://github.com/EdHone/oolong/archive/refs/tags/v0.1.0.tar.gz"
    git = "https://github.com/EdHone/oolong.git"

    maintainers("EdHone")

    license("BSD-3-Clause")

    version("head", branch="main")
    version("0.1.0", sha256="278e5fed51c4bb64454b623f1c53b209b1a772eb6ad1172e18a4b60e59d606a7")

    variant("mpi", default=False, description="Enable parallel logging")

    depends_on("fpm@0.8:", type="build")
    depends_on("mpi", when="+mpi")

    def setup_build_environment(self, env):
        if self.spec.satisfies("+mpi"):
            env.set("FPM_FC", self.spec["mpi"].mpifc)
            env.set("FPM_FFLAGS", f"-DMPI")
        elif Path(self.compiler.fc).parts[-1] == "ftn" and self.spec.satisfies("%gcc"):
            # For some Cray machines all compilers are wrapped in 'ftn' - look for
            # gcc in spec instead to get flags right
            env.set("FPM_FC", "gfortran")
        else:
            env.set("FPM_FC", self.compiler.fc)

    def install(self, spec, prefix):
        subprocess.run(["fpm", "install", "--prefix", "."])
        install_tree("lib", prefix.lib)
        install_tree("include", prefix.include)
