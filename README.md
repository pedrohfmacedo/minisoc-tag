# MiniSoC Tag

## Project Overview

MiniSoC Tag contains the RTL and UVM verification environment for a small SoC. The RTL includes the top-level integration, AES, memory, SPI, and a mock PLL. Verification sources and project documentation are under `verif/`.

## Current Status

- A VCS/UVM 1.2 testbench is available with `top_tb` as its top module.
- The reset test is currently selected by default.
- The reset monitor publishes observed reset transitions to a functional coverage subscriber, which samples asserted and deasserted states.
- Verdi can open existing FSDB files through the testbench Makefile.

## Run Verification

Load the Synopsys environment, then run from the testbench directory:

```sh
cd verif/tb
make compile
make run UVM_TESTNAME=minisoc_reset_test UVM_SEED=1
```

Other useful targets are `make gui` and `make verdi_wf_easy FSDB_FILE=novas.fsdb`. The FSDB must exist before opening it. VCS and Verdi must be installed and available in the environment.

## Next Steps

- Generate and review functional coverage reports.
- Integrate and run the nominal, PLL, and multiclock tests.
- Expand DUT checks and assertions.
- Implement or remove the `verdi_wf` target currently mentioned by `make help`.

See [`verif/doc/README.md`](verif/doc/README.md) for the verification document index and documentation follow-ups.