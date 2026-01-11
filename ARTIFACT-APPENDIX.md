# Artifact Appendix (Required for all badges)

Paper title: **Gryphes: Hybrid Proofs for Modular SNARKs with Applications to zkRollups**

Requested Badge(s):
  - [x] **Available**
  - [x] **Functional**
  - [x] **Reproduced**


## Description

1. **Paper**: Gryphes: Hybrid Proofs for Modular SNARKs with Applications to zkRollups

   **Authors**:
   - Jiajun Xin (jxin@cse.ust.hk), The Hong Kong University of Science and Technology
   - Samuel Cheung On Tin (xtianae@cse.ust.hk), The Hong Kong University of Science and Technology
   - Christodoulos Pappas (cpappas@connect.ust.hk), The Hong Kong University of Science and Technology
   - Yongjin Huang (jason.huang@okg.com), OKG
   - Dimitrios Papadopoulos (dipapado@cse.ust.hk), The Hong Kong University of Science and Technology

   **Year**: 2026

2. This artifact provides the code, scripts, and instructions to reproduce all experimental results reported in Section 6 of the paper.

### Security/Privacy Issues and Ethical Concerns

We are not aware of any security or privacy risks when running our artifacts.
The artifact consists of cryptographic proof systems and SNARK implementations
that do not disable any security mechanisms, run vulnerable code, or access
sensitive data. The artifact does not involve user studies or collection of
personal data.

## Basic Requirements

### Hardware Requirements

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


### Software Requirements

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

### Estimated Time and Storage Consumption

The following estimates are for running all experiments to reproduce the results
reported in the paper:

- **Overall time**: Approximately 2-3 hours.
- **Overall disk space**: Approximately 100 GB of disk space.

These estimates are conservative to ensure sufficient resources are available.
Actual consumption may vary depending on the specific experiments run and the
system configuration.

## Environment

### Accessibility

Access via GitHub link: [https://github.com/hkust-okx-zkdex-project/pets26-artifacts/tree/main](https://github.com/hkust-okx-zkdex-project/pets26-artifacts/tree/main)

### Set up the environment

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
environment variables from your shell configuration file.

### Testing the Environment

Run the following quick checks after `./setup.sh`:

1. Verify toolchains are available (expect Rust 1.82+ and Go 1.19+):
   ```bash
   rustc --version
   cargo --version
   go version
   ```

2. Ensure experiment scripts are executable:
   ```bash
   chmod +x run_experiment_*.sh
   ```

3. Smoke test the toolchain by running the shortest experiment script (records output to `results/`):
   ```bash
   ./run_experiment_1_link_protocol.sh
   ```
   Expected: a timestamped log file `results/experiment_1_link_protocol_<timestamp>.txt` is created without errors.

### Expected Compilation Warnings

When running experiments, you may observe compilation warnings (e.g., unexpected `cfg` condition values like `floor-planner-v1-legacy-pdqsort` and `circuit-params`, Cargo profile warnings, or unused code warnings). These warnings are expected and benign. All experiments will compile and run successfully despite these warnings, and they can be safely ignored during artifact evaluation.

## Artifact Evaluation

This section should include all the steps required to evaluate your artifact's
functionality and validate your paper's key results and claims. Therefore,
highlight your paper's main results and claims in the first subsection. And
describe the experiments that support your claims in the subsection after that.

### Main Results and Claims

List all your paper's results and claims that are supported by your submitted
artifacts.

#### Main Result 1: Link Protocol Performance

The Link protocol exhibits quasi-linear growth in proving time ($O(\log n + k \log k)$) as the degree of the linked polynomials increases. We benchmark the protocol with one polynomial of fixed degree $2^{16}$ and another varying from $2^{10}$ to $2^{20}$. The proving time increases from 1.1s to 24.1s as shown in **Table 1** of the paper. This result is reproduced by [Experiment 1](#experiment-1-link-protocol).

#### Main Result 2: Matrix Lookup vs. Monolithic Plonk Efficiency

Matrix lookup dominates the prover overhead (approx. 95% of computation) compared to Plonk operations (5%) as shown in **Figure 4(a)**. Despite this overhead, the system scales sub-linearly with the number of supported transaction types (**Figure 4(c)**). Compared to monolithic Plonk (**Figure 4(d)**), our approach is more efficient when the number of transaction types exceeds 32–64, as monolithic circuits grow linearly while our approach grows sub-linearly. These results are reproduced by [Experiment 2](#experiment-2-plonk--matrix-lookup) and [Experiment 4](#experiment-4-monolithic-plonk).

#### Main Result 3: Impact of Transaction Diversity

Prover time grows quasi-linearly with the number of *distinct* transaction types selected within a batch, as shown in **Figure 4(b)**. When selecting 1 transaction type versus 1024 distinct types in a batch of size 1024, the proving time increases, demonstrating that restricting transaction variety improves efficiency. This result is reproduced by [Experiment 3](#experiment-3-matrix-lookup-with-distinct-segments).

#### Main Result 4: Link Circuit Efficiency

For a realistic zkRollup scenario (1024 transactions), the Link circuit achieves a proving time of approximately 1167.8 ms and verification time of 3.2 ms. This demonstrates the practical efficiency of the composition between heterogeneous proof systems. This result is reproduced by [Experiment 5](#experiment-5-link-circuit).

#### Main Result 5: Cryptographic Primitive Performance

The system efficiently handles cryptographic operations: EdDSA signature verification and RSA accumulator updates. The RSA accumulator proving time scales linearly with the number of users ($2^{14}$ to $2^{18}$), as shown in **Table 2**. This is reproduced by [Experiment 6](#experiment-6-eddsa-benchmark) and [Experiment 7](#experiment-7-rsa-accumulator).

### Experiments

List each experiment to execute to reproduce your results.

#### Experiment 1: Link Protocol

- **Time**: ~10 minutes
- **Storage**: 10 GB

This experiment reproduces **Main Result 1** (Table 1). It benchmarks the Link protocol between two polynomials of varying degrees.

```bash
./run_experiment_1_link_protocol.sh
```

#### Experiment 2: Plonk + Matrix Lookup

- **Time**: ~30 minutes
- **Storage**: 10 GB

This experiment reproduces **Main Result 2** (Figure 4(a), 4(c), and partial 4(d)). It runs the `sublonk` benchmark which evaluates the performance of the Plonk + matrix lookup system with varying lookup table sizes (total transaction types).

```bash
./run_experiment_2_plonk_matrix_lookup.sh
```

#### Experiment 3: Matrix Lookup with Distinct Segments

- **Time**: ~15 minutes
- **Storage**: 10 GB

This experiment reproduces **Main Result 3** (Figure 4(b)). It benchmarks the impact of the number of *distinct* transaction types selected in a batch on the prover time.

```bash
./run_experiment_3_plonk_segments.sh
```

#### Experiment 4: Monolithic Plonk

- **Time**: ~30 minutes
- **Storage**: 10 GB

This experiment reproduces the monolithic Plonk baseline for **Main Result 2** (Figure 4(d)). It runs a pure Plonk universal circuit to compare against the matrix lookup approach.

```bash
./run_experiment_4_pure_plonk.sh
```

#### Experiment 5: Link Circuit

- **Time**: ~10 minutes
- **Storage**: 10 GB

This experiment reproduces **Main Result 4**. It runs the end-to-end benchmark for the Link circuit with multiple parameter combinations to verify the efficiency of linking heterogeneous proofs.

```bash
./run_experiment_5_link_circuit.sh
```

#### Experiment 6: EdDSA Benchmark

- **Time**: ~30 minutes
- **Storage**: 10 GB

This experiment reproduces part of **Main Result 5**. It benchmarks the EdDSA signature verification component.

```bash
./run_experiment_6_eddsa.sh
```

#### Experiment 7: RSA Accumulator

- **Time**: ~30 minutes
- **Storage**: 10 GB

This experiment reproduces **Main Result 5** (Table 2). It benchmarks the RSA accumulator proving time for different numbers of users.

```bash
./run_experiment_7_rsa.sh
```


## Limitations

We cannot produce the artifacts of an end-to-end zkRollup performance as shown in the paper due to hardware constraints. The full end-to-end system requires significant computational resources and memory that exceed standard workstation capabilities (specifically for the combined proving of all components at full scale). As a result, the numbers for the complete end-to-end system performance reported in the paper are obtained by mathematical inferences based on the performance of individual components (Link protocol, Plonk + matrix lookup, EdDSA, RSA Accumulator) which are benchmarked individually in this artifact. All individual component benchmarks are fully reproducible.

## Notes on Reusability

The components of the Gryphes framework are designed to be modular and can be used as individual components in other projects:

- **Matrix Lookup**: The matrix lookup implementation (in `sublonk` and `ark-segmentlookup`) can be used to efficiently handle diverse application logic in other SNARK-based systems, enabling sub-linear scaling with the number of supported circuit types.
- **Link Protocol**: The Link protocol (in `halo2-link-circuit` and `ark-iesp`) provides a generic mechanism for composing heterogeneous SNARKs (e.g., combining Plonk with Groth16) and can be reused to link proofs from different proving systems.
