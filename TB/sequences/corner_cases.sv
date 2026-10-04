class corner_cases extends apb_base_sequence;
  `uvm_object_utils(corner_cases)
  
  function new(string name="corner_cases");
    super.new(name);
  endfunction
  
  task body();
  
    txn = apb_txn::type_id::create("txn");
    
    start_item(txn);
    txn.transfer=1;
    txn.write_in=1;
    txn.wdata_in=32'hFFFF_FFFF;
    txn.addr_in=32'h0000_0000;
    finish_item(txn);
    
    
    txn = apb_txn::type_id::create("txn");

    start_item(txn);
    txn.transfer=1;
    txn.write_in=0;
    txn.addr_in=32'h0000_0000;
    finish_item(txn);
    
            txn = apb_txn::type_id::create("txn");
    
    start_item(txn);
    txn.transfer=1;
    txn.write_in=1;
    txn.wdata_in=32'h0000_0000;
    txn.addr_in=32'h0000_00FF;
    finish_item(txn);
    
    
    txn = apb_txn::type_id::create("txn");

    start_item(txn);
    txn.transfer=1;
    txn.write_in=0;
    txn.addr_in=32'h0000_00FF;
    finish_item(txn);
  endtask
endclass
