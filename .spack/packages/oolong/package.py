# Copyright 2013-2024 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

from spack.package import *
import subprocess
from pathlib import Path


class Oolong(Package):
    """An object oriented logging system for modern Fortran applications."""

    homepage = "https://github.com/EdHone/oolong"
    url = "https://github.com/EdHone/oolong/archive/refs/tags/v0.1.0.tar.gz"
    git = "https://github.com/EdHone/oolong.git"

    maintainers("EdHone")

    license("BSD-3-Clause", checked_by="EdHone")

    version("head", branch="main")
    version("0.1.0", sha256="278e5fed51c4bb64454b623f1c53b209b1a772eb6ad1172e18a4b60e59d606a7")

    variant("mpi", default=False, description="Enable parallel logging")

    depends_on("fpm")
    depends_on("mpi", when="+mpi")


    def setup_build_environment(self, env):
        # For some Cray machines all compilers are wrapped in 'ftn' - look for
        # gcc in spec instead
        if Path(self.compiler.fc).parts[-1] == "ftn":
            if self.spec.satisfies("%gcc"):
                env.set("FPM_FC", "gfortran")
            else:
                env.set("FPM_FC", self.compiler.fc)
        else:
            env.set("FPM_FC", self.compiler.fc)

        if self.spec.satisfies("+mpi"):
            env.set("FPM_FFLAGS", f"-DMPI -L{self.spec['mpi'].prefix}/lib")
            env.set("FPM_LDFLAGS", f"-L{self.spec['mpi'].prefix}/lib")

    def install(self, spec, prefix):
        subprocess.run(["fpm", "install", "--prefix", "."])
        install_tree("lib", prefix.lib)
        install_tree("include", prefix.include)

