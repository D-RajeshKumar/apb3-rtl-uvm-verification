class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  apb_agent agh;
  apb_scoreboard sbh;
  apb_cov_collector acc;
  
  function new(string name="apb_env",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agh = apb_agent::type_id::create("agh",this);
    sbh = apb_scoreboard::type_id::create("sbh",this);
    acc = apb_cov_collector::type_id::create("acc",this);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    agh.monh.mon_ap.connect(sbh.sb_imp);
    agh.monh.mon_ap.connect(acc.analysis_export);
    
  endfunction
  
endclass
