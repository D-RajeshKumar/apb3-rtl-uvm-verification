interface apb_if#(  parameter DATA_WIDTH=32,
                    parameter ADDR_WIDTH=32
                   ) (input PCLK);
  
  //--------------- INPUTS -------------------
  logic PRSTN;
  logic transfer;
  logic write_in;
  logic [DATA_WIDTH-1:0] wdata_in;
  logic [ADDR_WIDTH-1:0] addr_in;
  
  logic PSLVERR;
  logic [DATA_WIDTH-1:0] PRDATA;
  logic PREADY;

  //--------------- OUTPUTS -------------------
  logic PWRITE;
  logic [ADDR_WIDTH-1:0] PADDR;
  logic [DATA_WIDTH-1:0] PWDATA;
  logic PSELX;
  logic PENABLE;
  logic [DATA_WIDTH-1:0] prdata_out;
  logic pslverr_out;
  
  
  //====== DRV CLOCKING BLOCK =======
  
  clocking drv_cb @(posedge PCLK);
    
    default input #1 output #1;
    output transfer;
    output write_in;
    output wdata_in;
    output addr_in;
    
    input PREADY;
    
  endclocking
    
  //======= MON CLOCKING BLOCK =======
  
  clocking mon_cb @(posedge PCLK);
    
    default input #1 output #1;
    input transfer;
    input write_in;
    input wdata_in;
    input addr_in;
    
    input PWRITE;
    input PADDR;
    input PWDATA;
    input PSELX;
    
    input PENABLE;
    input prdata_out;
    input pslverr_out;
    input PREADY;
    
    input PSLVERR;
    input PRDATA;
    
  endclocking
endinterface
