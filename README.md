# Oolong

[![CI](https://github.com/EdHone/oolong/workflows/pull-request/badge.svg)](https://github.com/EdHone/oolong/actions)

## Getting started
Oolong is an object oriented logging system for modern Fortran. The aim of this project is to provide a simple, flexible logging interface that will enable a wide range of logging functionality for a wide range of model paradigms.

The project uses the [Fortran package manager (FPM)](https://github.com/fortran-lang/fpm) as a build system. Simply install FPM and use ```fpm build``` to build the oolong library. An example of the functionality of offer can be run with ```fpm run --example``` and the test suite can be run with ```fpm test```.

### Installation
To install Oolong as a static library, run
```
fpm install --prefix .
```
Additionally, installation can be achieved with Spack for users that want to bypass FPM as an immediate dependency. This can be achieved by running:
```shell
spack repo add .spack
spack install oolong
```

## Usage
The Oolong logging system can be used from within a Fortran application. The minimum amount of code needed to get started is shown below:
```fortran
use oolong, only: logger_type, LEVEL_INFO
...
type(logger_type) :: log
log = logger_type(LEVEL_INFO)
call log%event("Hello world!", LEVEL_INFO)
```
which produces the following output:
```
[2024-03-05 14:14:09.573] INFO: Hello world!
```

More advanced usage can be seen in the ```examples/demo.f90``` file.
