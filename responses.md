# Responses to Artifact Reviews

We sincerely thank all reviewers for their thorough evaluation of our artifact and their constructive feedback. We are pleased that all reviewers found the artifact available and well-documented. Below, we address the specific concerns raised by the reviewers, organized by problem area.

---

## Integer Overflow in Experiment 4 (Circuit Rows)

**Mentioned in:** Review #3A2d

An Int32 overflow issue was identified when logging circuit rows for large transaction types (N ≥ 2^15). This is indeed a display bug in the logging code, not in the actual circuit implementation. The circuit logic itself uses proper 64-bit integers; only the log output formatting uses Int32.

**Action taken:** We have fixed the overflow bug in the code.

---

## Cargo Warnings in Experiments 2 and 5

**Mentioned in:** Review #3B2d

Warnings were noted in experiments 2 and 5 regarding unexpected `cfg` condition values (e.g., `floor-planner-v1-legacy-pdqsort` and `circuit-params`). These warnings are **expected and benign** - they are caused by conditional compilation features defined in our fork of halo2 that Cargo's linting doesn't recognize. Note that halo2 is a common Plonk proving framework that is widely discussed and used in academia and industry.

These warnings do not affect:
- Compilation success
- Runtime behavior
- Benchmark correctness

---

## Mapping Experiment Results to Paper Terminology

**Mentioned in:** Review #3B2d, Review #3C2d

Several reviewers raised concerns about the difficulty in connecting experiment outputs to paper figures/tables. We provide the following clarifications:

### Experiment 1: Link Protocol (Table 1)

**Questions raised:**
- How does "Log Shared" map to polynomial degree in Table 1? (Review #3B2d, Review #3C2d)
- Does experiment 1 produce 15 results while Table 1 shows 10? (Review #3B2d)
- What does "Log Seg" represent? (Review #3C2d)

**Clarifications:**
- **"Log Shared":** Corresponds to log₂(number of rows of the shared part per tx). With 1024 number of transactions, the polynomial degree is 2^(10+log shared) - 1
- **"Log Seg":** Is log₂(number of rows of the segment part per tx). With 1024 number of transactions, the polynomial degree is 2^16 - 1
- **Number of results:** The first 11 results map to the results in Table 1. Table 1 reports the average prove time of 5 executions for 10 of these parameters

**Action taken:** We have added polynomial degrees in the printed log.

### Experiment 2: Plonk + Matrix Lookup

**Question raised:**
- Does "NUM TABLE CIRCUITS" refer to the number of transaction types? (Review #3C2d)

**Answer:** Yes. NUM TABLE CIRCUITS is the number of segment circuits in the lookup table.

**Action taken:** We have enhanced logging variable names in Experiment 2.

