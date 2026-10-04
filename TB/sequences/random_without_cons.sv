class random_without_cons extends apb_base_sequence;
  `uvm_object_utils(random_without_cons)
  
  function new(string name="random_without_cons");
    super.new(name);
  endfunction
  
  task body();
    repeat(30)begin
      txn = apb_txn::type_id::create("txn");
    start_item(txn);
    txn.transfer=1;
    txn.cons1.constraint_mode(0);
      txn.c_wait_bias.constraint_mode(0);
    assert(txn.randomize());
    finish_item(txn);
  end
  endtask
  
endclass
