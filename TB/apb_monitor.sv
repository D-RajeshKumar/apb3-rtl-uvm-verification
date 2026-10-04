class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)
  
  virtual apb_if vif;
  uvm_analysis_port #(apb_txn) mon_ap;
  bit captured_this_txn;
  
  function new(string name="apb_monitor",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap=new("mon_ap",this);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))begin
      `uvm_fatal(get_type_name(),"DIDNT GET INTERFACE FROM DATABASE")
    end
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_txn txn;
	bit captured;
    
    forever begin
      @(vif.mon_cb);
      txn = apb_txn::type_id::create("txn");
      
      if (vif.mon_cb.PSELX && !vif.mon_cb.PENABLE)
        captured = 1'b0;
      
      if(vif.mon_cb.PSELX && vif.mon_cb.PENABLE && vif.mon_cb.PREADY && !captured)begin
        
        
      txn.PWRITE=vif.mon_cb.PWRITE;
      txn.PADDR=vif.mon_cb.PADDR;
      txn.PWDATA=vif.mon_cb.PWDATA;
      txn.transfer=vif.mon_cb.transfer;
      
        
      txn.PSELX=vif.mon_cb.PSELX;
      txn.PENABLE=vif.mon_cb.PENABLE;
      txn.prdata_out=vif.mon_cb.prdata_out;
      txn.pslverr_out=vif.mon_cb.pslverr_out;
      txn.PSLVERR=vif.mon_cb.PSLVERR;
      txn.PRDATA=vif.mon_cb.PRDATA;
      txn.PREADY=vif.mon_cb.PREADY;
        
      `uvm_info(get_type_name(),txn.convert2string(),UVM_LOW);
      mon_ap.write(txn);

		captured=1'b1;
        
      end
    end
    
  endtask
  
endclass
