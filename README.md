# Mechanising Complexity Theory: The Cook-Levin Theorem in Coq
Lennard Gäher <gaeher@mpi-sws.org>, Fabian Kunze <fabian.kunze@cs.uni-saarland.de>

This repository contains the Coq formalisation of the paper "Mechanising Complexity Theory: The Cook-Levin Theorem in Coq".

## How to compile the code
Assuming coq 8.12.1 and `opam` is installed, you can build the necessary dependencies and the code itself as follows:
First, create a fresh opam switch and add the Coq repo:
````
opam switch create cook-levin 4.07.1+flambda
eval $(opam env)
opam repo add coq-released https://coq.inria.fr/opam/released
````

Clone the repository, checkout the submodule containing the copy of the [Coq Library of Undecidability Proofs](https://github.com/uds-psl/coq-library-undecidability), use `opam` to install all dependencies in the current switch, and then build using `make`:

````
git clone https://github.com/uds-psl/cook-levin.git
cd cook-levin
make deps
make all
````

The compiled documentation can be entered [here](https://uds-psl.github.io/cook-levin/website/Complexity.NP.SAT.CookLevin.html#CookLevin) or in the `./website/Complexity.NP.SAT.CookLevin.html` file of this repository.


# The Coq Library of Complexity Theory
This repo is a snapshot of our [Coq Library of Complexity Theory](https://github.com/uds-psl/coq-library-complexity), together with the coqdoc documentation of this library and the [Coq Library of Undecidability Proofs](https://github.com/uds-psl/coq-library-undecidability). It contains other, unrelated parts of that library, whose authors are credited in the respective libraries README file.
