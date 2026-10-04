class random_test extends apb_base_sequence;
  `uvm_object_utils(random_test)
  
  function new(string name="random_test");
    super.new(name);
  endfunction
  
  task body();
    
    repeat(30)begin
      txn = apb_txn::type_id::create("txn");
    start_item(txn);
    txn.transfer=1;
      assert(txn.randomize() with {write_in==1;} );
    finish_item(txn);
  end
  endtask
endclass
