# Artifact Appendix (Required for all badges)

Paper title: **Gryphes: Hybrid Proofs for Modular SNARKs with Applications to zkRollups**

Requested Badge(s):
  - [ ] **Available**
  - [ ] **Functional**
  - [x] **Reproduced**

Authors can provide this content _either_ as a separate file in their artifact
_or_ as part of their existing documentation (e.g., `README.md`). In the latter
case, you should have the same section titles as in this template.

This template includes several placeholders. When filling in this template for
their artifact, the authors should:

1. Remove this note.
2. Delete the sections that are _not_ required for the badge(s) they are
   applying for.
3. Omit suffixes of the form "(required/encouraged for badge ...)" from the
   section titles.
4. Authors should not leave the placeholder descriptions initially provided with
   this file into the submitted version with their artifact.

While this template is provided for artifact review, you should write your
instructions for someone trying to reuse your artifact in the future (i.e., not
an artifact reviewer).

## Description (Required for all badges)
Replace this with the following:

1. List the paper that the artifact relates to (i.e., paper title, authors,
   year, or even a BibTex cite).
2. A short description of your artifact and how it is relevant to your paper.

### Security/Privacy Issues and Ethical Concerns (Required for all badges)

We are not aware of any security or privacy risks when running our artifacts.
The artifact consists of cryptographic proof systems and SNARK implementations
that do not disable any security mechanisms, run vulnerable code, or access
sensitive data. The artifact does not involve user studies or collection of
personal data.

## Basic Requirements (Required for Functional and Reproduced badges)

For both sections below, if you are giving reviewers remote access to special
hardware (e.g., Intel SGX v2.0) or proprietary software (e.g., Matlab R2025a)
for the purpose of the artifact evaluation, do not provide these instructions
here but rather in the corresponding submission field on HotCRP.

### Hardware Requirements (Required for Functional and Reproduced badges)

1. **Minimal hardware requirements**: Can run on a laptop (No special
   hardware requirements).

2. **Hardware specifications for reproduced experiments**: All performance
   evaluations reported in the paper were conducted on a single workstation with
   the following specifications:
   - **Processor**: Intel Xeon E-2174G, featuring 4 physical cores and 8 logical
     threads enabled through Intel's Hyper-Threading technology, with a clock speed
     of 3.80 GHz
   - **Memory**: 128 GiB of DDR4 RAM operating at 2666 MHz
   - **Storage**: 1 TB NVMe SSD as primary storage


### Software Requirements (Required for Functional and Reproduced badges)

1. **Operating System**: Ubuntu 20.04.6 LTS with 64-bit Linux kernel
   (5.15.0-91-generic). The artifact should be compatible with other Linux
   distributions, but all experiments were conducted on Ubuntu 20.04.6 LTS.

2. **OS Packages**: The following system packages are required:
   - `build-essential` (for C/C++ compilation tools)
   - `curl` (for downloading dependencies)
   - `git` (for cloning repositories and managing submodules)
   - `pkg-config` (for library configuration)
   - `libssl-dev` (for SSL/TLS support)
   - `ca-certificates` (for SSL certificate verification)
   - `gnupg` (for package verification)
   - `lsb-release` (for system information)

3. **Programming Languages and Compilers**:
   - **Rust**: Stable toolchain version 1.82.0 (or compatible version >= 1.82.0).
     The artifact uses Rust for most components, including the PlonK proving
     framework, matrix lookup arguments, and segment lookup implementations.
     Rust can be installed via `rustup` (https://rustup.rs/).
   - **Go (Golang)**: Version 1.19 or later. The artifact uses Go for the Shared
     Logic Components implemented in Groth16 using the gnark library. Go can be
     downloaded from https://go.dev/dl/.

4. **Rust Dependencies**: The artifact relies on the following Rust crates and
   libraries (versions are specified in the `Cargo.toml` files):
   - **arkworks libraries** (version 0.5.0): Used for finite field arithmetic,
     elliptic curve operations, polynomial arithmetic, and BN256 curve
     functionality. Key crates include:
     - `ark-ff` (finite field operations)
     - `ark-ec` (elliptic curve operations)
     - `ark-poly` (polynomial arithmetic)
     - `ark-std` (standard library traits)
     - `ark-serialize` (serialization)
     - `ark-bn254` (BN254 curve implementation)
   - **halo2 library** (version 0.3.0): The foundational PlonK proving framework
     from PSE (Privacy & Scaling Explorations). This library applies a KZG
     polynomial commitment scheme over the BN256 elliptic curve.
   - **halo2curves** (version 0.6.1): Provides BN256 curve functionality for halo2.
   - **Rayon** (version 1.10.0): Used for parallelism in Rust projects. The
     library automatically detects and utilizes all available logical cores on
     the workstation. All experiments are conducted with multiple cores in
     parallel unless otherwise noted.
   - **merlin** (version 3.0.0): Used for transcript generation in zero-knowledge
     proofs.
   - **blake2** (version 0.10.6): Cryptographic hash function implementation.

5. **Go Dependencies**: The artifact uses the following Go packages (versions
   are specified in the `go.mod` files):
   - **gnark** (version 0.7.0): Groth16 proving system implementation. The artifact
     uses a fork from `github.com/bnb-chain/gnark` (commit
     `0d81c67d080a`) as specified in the `replace` directives in `go.mod` files.
   - **gnark-crypto** (version 0.10.0): Cryptographic primitives for gnark. The
     artifact uses a fork from `github.com/bnb-chain/gnark-crypto` (commit
     `7c643ad11891`) as specified in the `replace` directives.
   - Additional dependencies are automatically resolved via `go mod download`.

6. **Artifact Packaging**: No container runtime or VM is required. The artifact
   can be run directly on a compatible Linux system after installing the
   dependencies listed above.

7. **Machine Learning Models**: Not applicable. This artifact does not use any
   machine learning models.

8. **Datasets**: Not applicable. This artifact does not require external
   datasets. All experiments use synthetic data generated during execution.

### Estimated Time and Storage Consumption (Required for Functional and Reproduced badges)

The following estimates are for running all experiments to reproduce the results
reported in the paper:

- **Overall time**: Approximately 2 hours.
- **Overall disk space**: Approximately 500 GB of disk space.

These estimates are conservative to ensure sufficient resources are available.
Actual consumption may vary depending on the specific experiments run and the
system configuration.

## Environment (Required for all badges)

In the following, describe how to access your artifact and all related and
necessary data and software components. Afterward, describe how to set up
everything and how to verify that everything is set up correctly.

### Accessibility (Required for all badges)

Access via GitHub link: [https://github.com/hkust-okx-zkdex-project/pets26-artifacts/tree/main](https://github.com/hkust-okx-zkdex-project/pets26-artifacts/tree/main)

### Set up the environment (Required for Functional and Reproduced badges)

The setup script (`setup.sh`) automates the installation of all required
dependencies. Run it from the repository root:

```bash
./setup.sh
```

The script performs the following operations:

1. **Installs system packages** (via `apt-get` on Ubuntu/Debian):
   - `build-essential` (C/C++ compilation tools)
   - `curl` (for downloading dependencies)
   - `git` (for repository management)
   - `pkg-config` (for library configuration)
   - `libssl-dev` (SSL/TLS development libraries)
   - `ca-certificates` (SSL certificate store)
   - `gnupg` (GNU Privacy Guard for package verification)
   - `lsb-release` (Linux Standard Base release information)

2. **Installs Rust toolchain** (version 1.82.0 or later):
   - Installs `rustup` if not present
   - Installs Rust 1.82.0 via rustup
   - Configures Rust/Cargo environment variables

3. **Installs Go** (version 1.19.13):
   - Downloads and installs Go 1.19.13 to `/usr/local/go`
   - Adds Go binary path to environment

4. **Initializes Git submodules**:
   - Syncs submodule URLs
   - Initializes and updates all submodules recursively

5. **Fetches Rust dependencies**:
   - Downloads dependencies for `ark-iesp`
   - Downloads dependencies for `halo2`
   - Downloads dependencies for `halo2-link-circuit`

6. **Downloads Go dependencies**:
   - Downloads Go modules for `rsa_accumulator`
   - Downloads Go modules for `benchmarkEdDSA`

After running the setup script, reload your shell environment to make Rust and Go
available in your current session. For **bash** users:

```bash
source ~/.bashrc
```

Alternatively, you can simply restart your terminal to load the updated
environment variables from your shell configuration file.·

### Testing the Environment (Required for Functional and Reproduced badges)

Replace the following by a description of the basic functionality tests to check
if the environment is set up correctly. These tests could be unit tests,
training an ML model on very low training data, etc. If these tests succeed, all
required software should be functioning correctly. Use code segments to simplify
the workflow, e.g.,

Launch the Docker container, attach the current working directory (i.e., run
from the root of the cloned git repository) as a volume, set the context to be
that volume, and provide an interactive bash terminal:

```bash
docker run --rm -it -v ${PWD}:/workspaces/example-docker-python-pip \
    -w /workspaces/example-docker-python-pip \
    --entrypoint bash example-docker-python-pip:main
```

Then within the Docker container, run:

```bash
./test.sh
```

Include the expected output.

## Artifact Evaluation (Required for Functional and Reproduced badges)

This section should include all the steps required to evaluate your artifact's
functionality and validate your paper's key results and claims. Therefore,
highlight your paper's main results and claims in the first subsection. And
describe the experiments that support your claims in the subsection after that.

### Main Results and Claims

List all your paper's results and claims that are supported by your submitted
artifacts.

#### Main Result 1: Name

Describe the results in 1 to 3 sentences. Mention what the independent and
dependent variables are; independent variables are the ones on the x-axes of
your figures, whereas the dependent ones are on the y-axes. By varying the
independent variable (e.g., file size) in a given manner (e.g., linearly), we
expect to see trends in the dependent variable (e.g., runtime, communication
overhead) vary in another manner (e.g., exponentially). Refer to the related
sections, figures, and/or tables in your paper and reference the experiments
that support this result/claim. See example below.

#### Main Result 2: Example Name

Our paper claims that when varying the file size linearly, the runtime also
increases linearly. This claim is reproducible by executing our
[Experiment 2](#experiment-2-example-name). In this experiment, we change the
file size linearly, from 2KB to 24KB, at intervals of 2KB each, and we show that
the runtime also increases linearly, reaching at most 1ms. We report these
results in "Figure 1a" and "Table 3" (Column 3 or Row 2) of our paper.

### Experiments
List each experiment to execute to reproduce your results. Describe:
 - How to execute it in detailed steps.
 - What the expected result is.
 - How long it takes to execute in human and compute times (approximately).
 - How much space it consumes on disk (approximately) (omit if <10GB).
 - Which claim and results does it support, and how.

#### Experiment 1: Name
- Time: replace with estimate in human-minutes/hours + compute-minutes/hours.
- Storage: replace with estimate for disk space used (omit if <10GB).

Provide a short explanation of the experiment and expected results. Describe
thoroughly the steps to perform the experiment and to collect and organize the
results as expected from your paper (see example below). Use code segments to
simplify the workflow, as follows.

```bash
python3 experiment_1.py
```

#### Experiment 2: Example Name

- Time: 10 human-minutes + 3 compute-hours
- Storage: 20GB

This example experiment reproduces
[Main Result 2: Example Name](#main-result-2-example-name), the following script
will run the simulation automatically with the different parameters specified in
the paper. (You may run the following command from the example Docker image.)

```bash
python3 main.py
```

Results from this example experiment will be aggregated over several iterations
by the script and output directly in raw format along with variances and
standard deviations in the `output-folder/` directory. You will also find there
the plots for "Figure 1a" in `.pdf` format and the table for "Table 3" in `.tex`
format. These can be directly compared to the results reported in the paper, and
should not quantitatively vary by more than 5% from expected results.


## Limitations (Required for Functional and Reproduced badges)

Describe which steps, experiments, results, graphs, tables, etc. are _not
reproducible_ with the provided artifact. Explain why this is not
included/possible and argue why the artifact should _still_ be evaluated for the
respective badges.

## Notes on Reusability (Encouraged for all badges)

First, this section might not apply to your artifacts. Describe how your
artifact can be used beyond your research paper, e.g., as a general framework.
The overall goal of artifact evaluation is not only to reproduce and verify your
research but also to help other researchers to re-use and extend your artifacts.
Discuss how your artifacts can be adapted to other settings, e.g., more input
dimensions, other datasets, and other behavior, through replacing individual
modules and functionality or running more iterations of a specific module.