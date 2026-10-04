class apb_base_sequence extends uvm_sequence#(apb_txn);
  `uvm_object_utils(apb_base_sequence)
  
  apb_txn txn;
  
  function new(string name="apb_sequence");
    super.new(name);
  endfunction
  
  task body();
    
    txn = apb_txn::type_id::create("txn");
    
    start_item(txn);
    txn.transfer=1;
    txn.write_in=1;
    txn.wdata_in=32'h1234_5678;
    txn.addr_in=32'h0000_0002;
    finish_item(txn);
    
    
    txn = apb_txn::type_id::create("txn");

    start_item(txn);
    txn.transfer=1;
    txn.write_in=0;
    txn.addr_in=32'h0000_0002;
    finish_item(txn);
    
  endtask
endclass
