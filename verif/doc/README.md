# Verification Documentation

## Current Contents

- `CI-Expert_Fase2_Verification_Plan_v0.0.1.pdf` - verification plan.
- `my_ditl_v0.0.1.pdf` - project reference document.
- `feat_future.txt` - future clock-agent feature suggestions, including duty cycle and jitter.
- `notes_vip.txt` - VIP notes.
- `organization_workspace.txt` - workspace organization notes.
- `uvm_structure_v0.0.2.png` and `uvm_structure_v0.0.3.png` - UVM structure diagrams.
- `rst_coverage_flow.txt` - reset monitor-to-coverage data flow.

## UVM Tests

Run a test after loading the Synopsys environment with `snps`:

```sh
make -C verif/tb all UVM_TESTNAME=minisoc_test_clk_2ghz
```

- `minisoc_test_clock` - nominal clock (500 ps then 1 ns), period limits (100 ps and 10 ns), and bounded-random clock (100 ps to 5 ns).
- `minisoc_test_reset` - asynchronous reset, synchronous reset on rising and falling clock edges, an asynchronous pulse train, and asynchronous assertion with synchronous deassertion.
- `minisoc_reset_test` - one reset with asynchronous assertion and synchronous deassertion.
- `minisoc_test_reset_clock` - runs the clock scenarios followed by the reset scenarios.
- `minisoc_test_random_constrained` - runs constrained-random clock and reset sequences in parallel.
- `minisoc_test_clk_2ghz` - runs a fixed 500 ps clock (2 GHz) with a constrained-random reset sequence in parallel.

## Next Steps

- Keep the verification plan aligned with tests that are integrated and passing.
- Document simulator setup, test execution, and coverage report commands.
- Update the UVM diagrams as agents, sequences, and checks are added.