`ifndef UVM_MACROS_SVH
`define UVM_MACROS_SVH
`define UVM_NONE   0
`define UVM_LOW    1
`define UVM_MEDIUM 2
`define UVM_HIGH   3

`define uvm_info(ID, MSG, VB) \
  $display("[UVM_INFO @%0t][%s] %s", $time, ID, MSG);

`define uvm_error(ID, MSG) \
  $display("[UVM_ERROR @%0t][%s] %s", $time, ID, MSG);

`define uvm_fatal(ID, MSG) \
  begin \
    $display("[UVM_FATAL @%0t][%s] %s", $time, ID, MSG); \
    $finish; \
  end
`endif
