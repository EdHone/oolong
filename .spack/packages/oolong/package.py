# Copyright 2013-2024 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

# ----------------------------------------------------------------------------
# If you submit this package back to Spack as a pull request,
# please first remove this boilerplate and all FIXME comments.
#
# This is a template package file for Spack.  We've put "FIXME"
# next to all the things you'll want to change. Once you've handled
# them, you can save this file and test your package like this:
#
#     spack install oolong
#
# You can edit this file again by typing:
#
#     spack edit oolong
#
# See the Spack documentation for more information on packaging.
# ----------------------------------------------------------------------------

from spack.package import *
import subprocess


class Oolong(Package):
    """An object oriented logging system for modern Fortran applications."""

    homepage = "https://github.com/EdHone/oolong.git"
    url = "https://github.com/EdHone/oolong.git"

    maintainers("EdHone")

    # FIXME: Add the SPDX identifier of the project's license below.
    # See https://spdx.org/licenses/ for a list. Upon manually verifying
    # the license, set checked_by to your Github username.
    license("BSD-3-Clause", checked_by="EdHone")

    version("0.1.0")

    depends_on("fpm")

    def setup_build_environment(self, env):
        env.set("FPM_FC", self.compiler.fc)

    def install(self, spec, prefix):
        # FIXME: Unknown build system
        subprocess.run(["pwd"])
