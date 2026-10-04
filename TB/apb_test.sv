class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)
  
  apb_env envh;
  apb_base_sequence sqh;
  corner_cases cch;
  random_test rth;
  random_without_cons rwch;
  random_reads rrh;
  
  function new(string name="apb_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    envh = apb_env::type_id::create("envh",this);
    sqh  = apb_base_sequence::type_id::create("sqh");
    cch = corner_cases::type_id::create("cch");
    rth = random_test::type_id::create("rth");
    rwch = random_without_cons::type_id::create("rwch");
    rrh = random_reads::type_id::create("rrh");
    
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    phase.raise_objection(this);
    
    sqh.start(envh.agh.sqrh);
    
    cch.start(envh.agh.sqrh);
    
    rth.start(envh.agh.sqrh);
    
    rwch.start(envh.agh.sqrh);
    
    rrh.start(envh.agh.sqrh);
    
    phase.drop_objection(this);
    
  endtask
  
endclass
