class apb_txn extends uvm_sequence_item;
  `uvm_object_utils(apb_txn)
  
  function new(string name="apb_txn");
    super.new(name);
  endfunction
  
   bit transfer;
  rand bit write_in;
  rand bit [31:0]wdata_in;
  rand bit [31:0]addr_in;
  
    bit PWRITE;
  bit [31:0] PADDR;
  bit [31:0] PWDATA;
    bit PSELX;
    
    bit PENABLE;
  bit [31:0] prdata_out;
  bit pslverr_out;
    bit PREADY;
    
    bit PSLVERR;
  bit [31:0] PRDATA;
  
  constraint cons1 {
    addr_in inside {[32'h0000_0000:32'h0000_00FF]};}
  
  constraint c_wait_bias {
    addr_in[3:0] dist {
      		4'h0 :=3,
      [4'h1:4'hF] :/13
    };
  }
  
  //string function
    virtual function string convert2string();
      return $sformatf("TRANSFER=%0b|PADDR=%0h|WDATA=%0h|PRDATA=%0h|prdata_out=%0h|PSLVERR_out=%0b|READY=%0b",transfer,PADDR,PWDATA,PRDATA,prdata_out,pslverr_out,PREADY);
  endfunction
  
endclass

