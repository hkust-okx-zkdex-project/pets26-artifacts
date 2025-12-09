# PETS26 Artifacts - Gryphes: Hybrid Proofs for Modular SNARKs

This repository contains the artifacts for reproducing the experimental results presented in the paper **"Gryphes: Hybrid Proofs for Modular SNARKs with Applications to zkRollups"**. The experiments demonstrate the performance characteristics of our hybrid proof system that combines PlonK and Groth16 to achieve efficient zero-knowledge proofs for modular blockchain applications.

## Overview

This artifact package enables reviewers to reproduce the key performance results from Section 6 of the paper. The repository includes:

- **Link protocol implementation** (for Table 1 results)
- **PlonK with matrix lookup benchmarks** (for Figure 4a, 4b, 4c, and partial 4d)
- **Pure PlonK monolithic circuit** (for partial Figure 4d)
- **Link circuit combining PlonK with Groth16** (for link circuit performance evaluation)
- **Basic cost including EdDSA signatures and RSA memberships with Groth16** (for link circuit performance evaluation)

The experiments are organized into automated scripts that compile the necessary components, run the benchmarks, and save results to timestamped output files for analysis.

## Repository Structure

```
.
├── ark-iesp/                    # Link protocol implementation (Experiment 1)
├── ark-segmentlookup/           # Matrix lookup by distinct segments (Experiment 3)
├── halo2/                       # PlonK implementation with matrix lookup (Experiments 2, 4)
├── halo2-link-circuit/          # Link circuit implementation (Experiment 5)
├── bencheddsa/                  # EdDSA benchmarks (Experiment 6)
├── rsa_accumulator/             # RSA Accumulator (Experiment 7)
├── results/                     # Output directory for experiment results
├── setup.sh                     # Environment setup script
└── run_experiment_*.sh          # Individual experiment execution scripts
```

## Setup Instructions

### Prerequisites

The setup script will automatically install the following if not present:
- **Rust 1.82.0** (or compatible newer version)
- **Go 1.19** (or compatible newer version)
- Basic build tools (gcc, make, etc.)

The setup script is designed for **Ubuntu/Debian** systems but may work on other Linux distributions with minor modifications.

### Environment Setup

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd pets26-artifacts
   ```

2. **Run the setup script:**
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

   The setup script will:
   - Update system packages
   - Install Rust 1.82.0 via rustup (if needed)
   - Install Go 1.19 (if needed)
   - Initialize and update all git submodules
   - Download and cache Rust/Go dependencies for all projects

3. **Reload your shell environment:**
   
   After the setup script completes, reload your shell environment to make Rust and Go available:
   ```bash
   source ~/.bashrc
   ```
   
   Alternatively, you can restart your terminal session.

4. **Verify installation:**
   
   After setup completes, verify the installations:
   ```bash
   rustc --version   # Should show 1.82.0 or higher
   cargo --version   # Should show corresponding cargo version
   go version        # Should show 1.19 or higher
   ```

   If the commands are still not found after running `source ~/.bashrc`, you may need to manually source the environment:
   ```bash
   source ~/.cargo/env  # For Rust
   export PATH=$PATH:/usr/local/go/bin  # For Go
   ```

## Running Experiments

All experiment scripts are located in the repository root and follow the naming convention `run_experiment_<number>_<name>.sh`. Each script:
- Automatically navigates to the appropriate directory
- Compiles the code in release mode for optimal performance
- Runs the benchmark with appropriate parameters
- Captures output to a timestamped file in the `results/` directory

Before running experiments, ensure all scripts are executable:
```bash
chmod +x run_experiment_*.sh
```

### Experiment 1: Link Protocol (Table 1)

This experiment benchmarks the Link protocol implementation.

```bash
./run_experiment_1_link_protocol.sh
```

**Output:** `results/experiment_1_link_protocol_<timestamp>.txt`

**Corresponds to:** Table 1 in the paper

### Experiment 2: PlonK + Matrix Lookup by Transaction Types (Figure 4a, 4c, partial 4d)

This experiment benchmarks PlonK with matrix lookup according to total transaction types in the lookup table (2 fan-in gates, powered by matrix lookup).

```bash
./run_experiment_2_plonk_matrix_lookup.sh
```

**Output:** `results/experiment_2_plonk_matrix_lookup_<timestamp>.txt`

**Corresponds to:** Figure 4(a), Figure 4(c), and partial Figure 4(d) in the paper

**Implementation:** Located in `halo2/sublonk` submodule, runs `cargo run --release --bin sublonk`

### Experiment 3: Matrix Lookup by Distinct Segments (Figure 4b)

This experiment benchmarks matrix lookup according to the number of distinct segments selected.

```bash
./run_experiment_3_plonk_segments.sh
```

**Output:** `results/experiment_3_plonk_segments_<timestamp>.txt`

**Corresponds to:** Figure 4(b) in the paper

**Implementation:** Located in `ark-segmentlookup/bench/end_to_end` submodule, runs `cargo run --release`

### Experiment 4: Pure PlonK Monolithic Circuit (partial Figure 4d)

This experiment benchmarks the pure PlonK implementation without matrix lookup for comparison.

```bash
./run_experiment_4_pure_plonk.sh
```

**Output:** `results/experiment_4_pure_plonk_<timestamp>.txt`

**Corresponds to:** Partial Figure 4(d) in the paper (comparison baseline)

### Experiment 5: Link Circuit (PlonK + Groth16)

This experiment benchmarks the link circuit that combines PlonK with Groth16 across multiple parameter combinations.

```bash
./run_experiment_5_link_circuit.sh
```

**Output:** 
- Main results: `results/experiment_5_link_circuit_<timestamp>.txt`
- Individual parameter logs: `results/experiment_5_link_circuit_<timestamp>_k<N>_deg<M>.log`

This experiment tests 5 different parameter combinations (k=11 to k=15) with 5 iterations each for statistical reliability.

**Corresponds to:** Link circuit performance evaluation

### Experiment 6: EdDSA signatures (gnark)

This experiment benchmarks the EdDSA signature verifications from the official benchmarks in gnark.

```bash
./run_experiment_6_eddsa.sh
```

**Output:** 
- Main results: `results/experiment_6_eddsa_<timestamp>.txt`

**Corresponds to:** EdDSA signatures

### Experiment 7: RSA Accumulator benchmarks (gnark)

This experiment benchmarks the RSA accumulators and MultiSwap in golang, the MultiSwap is implemented with gnark.
Note that this experiment requires a large memory for generating precomputation table for RSA accumualtor. 

```bash
./run_experiment_7_rsa.sh
```

**Output:** 
- Main results: `results/experiment_7_rsa_<timestamp>.txt`

**Corresponds to:** RSA accumulators and MultiSwap

## Understanding Results

After running an experiment, the results are saved in the `results/` directory with timestamps for easy identification. Each result file contains:
- Experiment metadata (timestamp, command executed, parameters)
- Complete benchmark output including timing measurements
- Any warnings or errors encountered during execution

Some results require mathematical inference to match the exact figures in the paper. Detailed mapping of raw results to paper figures will be provided in subsequent documentation updates.

## Tips for Reviewers

- **Running Time:** Some experiments (especially Experiment 5) can take considerable time to complete. Plan accordingly.
- **System Resources:** These cryptographic benchmarks are computationally intensive. Ensure your system has adequate CPU and memory resources.
- **Result Files:** All results are timestamped, so you can run experiments multiple times without overwriting previous results.
- **Incremental Testing:** You can run experiments individually in any order based on which paper results you want to verify.

## Project Components

### ark-iesp
Implementation of the Link protocol used in Experiment 1. Built in Rust using arkworks libraries.

### halo2
Modified version of the halo2 proving system with matrix lookup support. Used in Experiments 2 and 4.

### ark-segmentlookup
Implementation of matrix lookup according to the number of distinct segments selected. Used in Experiment 3.

### halo2-link-circuit
Implementation of the link circuit that combines PlonK and Groth16 proofs. Used in Experiment 5.

### benchmarkEdDSA
Benchmarks for EdDSA signatures with gnark

### rsa_accumulator
Benchmarks for RSA accumulator and MultiSwap

## Troubleshooting

**Issue:** "Cargo is not installed" error
- **Solution:** Run `./setup.sh` again or manually install Rust via `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`

**Issue:** "Go is not installed" error  
- **Solution:** Run `./setup.sh` again or manually install Go from https://go.dev/dl/

**Issue:** Compilation errors during experiment runs
- **Solution:** Ensure all submodules are properly initialized: `git submodule update --init --recursive`

**Issue:** Permission denied when running scripts
- **Solution:** Make scripts executable: `chmod +x run_experiment_*.sh`

## Support

For questions or issues related to artifact evaluation, please refer to the paper or contact the authors through the appropriate channels.
