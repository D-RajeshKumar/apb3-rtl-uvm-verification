class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)
  
  uvm_analysis_imp#(apb_txn,apb_scoreboard) sb_imp;
  int pass_cnt,fail_cnt,total;
  bit [31:0] mem_model [0:255];
  bit [31:0] rdata_exp;
   bit read_complete;
  
  function new(string name="apb_scoreboard",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_imp = new("sb_imp",this);
  endfunction
  
  function void write(apb_txn txn);

    bit [7:0] mem_addr;
    bit expected_error;
    bit txn_pass=1;
    
    mem_addr = txn.PADDR[7:0];
    
    expected_error = (txn.PADDR >= 256);
    
    //======= checking PSLVERR ===============
    if(txn.PSLVERR !== expected_error)begin
      fail_cnt++;
      `uvm_info(get_type_name(),"PSLVERR DOESNT MATCH",UVM_LOW)
    end
    else begin
      `uvm_info(get_type_name(),"PSLVERR MATCHED WITH EXPECTED ERROR",UVM_LOW)
    end
    
    //======= checking write ================
    if(txn.PWRITE)begin
      //write transaction
      if(expected_error)begin
        `uvm_info(get_type_name(),"INVALID WRITE",UVM_LOW)
      end
        else begin
      mem_model[mem_addr]=txn.PWDATA;
      `uvm_info(get_type_name(),$sformatf("[SB] WRITE addr=%0h data=%0h", mem_addr, txn.PWDATA),UVM_LOW)
    end
    end
    
    else begin
      total++;
      if(expected_error!== txn.PSLVERR)
        `uvm_info(get_type_name(),"INVALID READ",UVM_LOW)
        else begin
      if(mem_model[mem_addr] == txn.PRDATA) begin
        pass_cnt++;
        `uvm_info(get_type_name(),$sformatf("[SB] MATCH addr=%0h expected=%0h actual=%0h",mem_addr, mem_model[mem_addr],txn.PRDATA),UVM_LOW)
        read_complete=1;
        
      end
      else begin
        fail_cnt++;
        `uvm_info(get_type_name(),$sformatf("[SB] MISMATCH addr=%0h expected=%0h actual=%0h",mem_addr, mem_model[mem_addr], txn.PRDATA),UVM_LOW)
      end
        end
    end
    
    
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    
    `uvm_info(get_type_name(),$sformatf("TOTAL TEST CASES=%0d | PASS=%0d | FAIL=%0d",total,pass_cnt,fail_cnt),UVM_LOW)
    
  endfunction
  
endclass
