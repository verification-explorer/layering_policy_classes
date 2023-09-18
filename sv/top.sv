package pkg_lib;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "types.sv"
  `include "rand_policy_base.sv"
  `include "pwr_mng_port.sv"
  `include "pwr_mng_chip.sv"
  `include "policies.sv"
  `include "sys_test.sv"
endpackage

module top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import pkg_lib::*;
  initial run_test("sys_test");
endmodule
