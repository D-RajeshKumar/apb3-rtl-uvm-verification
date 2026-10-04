class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  
  function new(string name="apb_agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  apb_sequencer sqrh;
  apb_driver drvh;
  apb_monitor monh;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    sqrh = apb_sequencer::type_id::create("sqrh",this);
    drvh = apb_driver::type_id::create("drvh",this);
    monh = apb_monitor::type_id::create("monh",this);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    drvh.seq_item_port.connect(sqrh.seq_item_export);
    
  endfunction
  
endclass
