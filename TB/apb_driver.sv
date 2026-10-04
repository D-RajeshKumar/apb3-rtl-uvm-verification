class apb_driver extends uvm_driver#(apb_txn);
  `uvm_component_utils(apb_driver)
  
  virtual apb_if vif;
  
  function new(string name="apb_driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))begin
      `uvm_fatal(get_type_name(),"DIDNT GET INTERFACE FROM DATABASE")
    end
    
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_txn txn;
    forever begin
    seq_item_port.get_next_item(txn);
      drive(txn);
      seq_item_port.item_done();
    end
  endtask
  
  task drive(apb_txn txn);
    vif.drv_cb.transfer<=txn.transfer;
    vif.drv_cb.write_in<=txn.write_in;
    vif.drv_cb.wdata_in<=txn.wdata_in;
    vif.drv_cb.addr_in<=txn.addr_in;
    
      @(vif.drv_cb);
    if(txn.transfer)begin
    while(vif.drv_cb.PREADY !== 1'b1)
      @(vif.drv_cb);
      
       vif.drv_cb.transfer <= 1'b0;
    
    end
  endtask
  
endclass
