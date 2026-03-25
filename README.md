# BlackParrot ALU UVM Proof of Concept

A Verilator-compatible UVM testbench for the BlackParrot RISC-V processor ALU.
Built as part of GSoC 2026 preparation.

## Environment
- OS: Ubuntu 22.04
- Verilator: 5.030
- UVM: Verilator-compatible stub

## Project Structure
```
bp_uvm_poc/
├── alu_if.sv          # ALU SystemVerilog interface
├── bp_be_alu_stub.sv  # BlackParrot ALU model
├── tb_top.sv          # UVM testbench top
├── uvm_stub/src/      # Verilator-compatible UVM
│   ├── uvm_pkg.sv
│   └── uvm_macros.svh
└── README.md
```

## How to Run
```bash
# Build
verilator --binary --timing \
  +incdir+./uvm_stub/src \
  ./uvm_stub/src/uvm_pkg.sv \
  ./alu_if.sv \
  ./bp_be_alu_stub.sv \
  ./tb_top.sv \
  --top-module tb_top \
  -o sim_alu \
  -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-UNOPTFLAT

# Run
./obj_dir/sim_alu
```

## Expected Output
```
[UVM_INFO @0][TB_TOP] Starting BlackParrot ALU UVM Testbench
[UVM_INFO @10][TB_TOP] ADD: 10+5=15 (exp 15)
[UVM_INFO @20][TB_TOP] SUB: 10-5=5  (exp 5)
[UVM_INFO @30][TB_TOP] AND: 10&5=0  (exp 0)
[UVM_INFO @40][TB_TOP] OR:  10|5=15 (exp 15)
[UVM_INFO @50][TB_TOP] XOR: 10^5=15 (exp 15)
[UVM_INFO @50][TB_TOP] ALU UVM POC COMPLETE - [BSG-PASS]
```

## ALU Operations Tested
| Opcode | Operation | Status |
|--------|-----------|--------|
| 4'h0   | ADD       | ✅ |
| 4'h1   | SUB       | ✅ |
| 4'h2   | AND       | ✅ |
| 4'h3   | OR        | ✅ |
| 4'h4   | XOR       | ✅ |
| 4'h5   | SLL       | ✅ |
| 4'h6   | SRL       | ✅ |
| 4'h7   | SRA       | ✅ |
