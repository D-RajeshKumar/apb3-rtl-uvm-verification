class apb_cov_collector extends uvm_subscriber#(apb_txn);
  `uvm_component_utils(apb_cov_collector)
  
  apb_txn txn;
  
  covergroup cg_apb;
    option.per_instance=1;
    
    cw: coverpoint txn.PWRITE;

    
    cwd: coverpoint txn.PWDATA {
      bins all_zeroes = {32'h0000_0000};
      bins all_ones = {32'hFFFF_FFFF};
      bins middle = {[32'h0000_0001:32'hFFFF_FFFE]};
    }
    
    
    cerr: coverpoint (txn.PADDR>=256){
      bins error = {1};
      bins valid = {0};
    }
    
   cwait: coverpoint (txn.PADDR[3:0] == 4'h0) {
  	bins wait_state    = {1};
  	bins no_wait_state = {0};
	}
    
    cww: cross cwait,cw;
    cew: cross cerr,cw;
    
  endgroup
  
  function new(string name="apb_cov_collector",uvm_component parent);
    super.new(name,parent);
    cg_apb=new();
  endfunction
  
  function void write(apb_txn t);
    this.txn = t;
    cg_apb.sample();
  endfunction
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    
    `uvm_info(get_type_name(),$sformatf("total coverage %0.2f%%",cg_apb.get_coverage()),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("PWRITE coverage %0.2f%%",cg_apb.cw.get_coverage()),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("PWDATA coverage %0.2f%%",cg_apb.cwd.get_coverage()),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("PADDR coverage %0.2f%%",cg_apb.cwait.get_coverage()),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("CROSS WAIT coverage %0.2f%%",cg_apb.cww.get_coverage()),UVM_LOW)
    `uvm_info(get_type_name(),$sformatf("CROSS ERROR coverage %0.2f%%",cg_apb.cew.get_coverage()),UVM_LOW)
    
    
  endfunction
endclass
