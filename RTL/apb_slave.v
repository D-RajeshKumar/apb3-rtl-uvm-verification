module APB_SLAVE#(parameter DATA_WIDTH=32,
                 parameter ADDR_WIDTH=32,
                 parameter MEM_DEPTH=256)
  (
    input PCLK,
    input PRSTN,
    
    input PWRITE,
    input [ADDR_WIDTH-1:0] PADDR,
    input [DATA_WIDTH-1:0] PWDATA,
    input PSELX,
    input PENABLE,
    
    output wire PREADY,
    output wire [DATA_WIDTH-1:0] PRDATA,
    output wire PSLVERR
  );
  
  reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
  localparam MEM_ADDR_WIDTH=$clog2(MEM_DEPTH);
  integer i;
  reg [MEM_ADDR_WIDTH-1:0] mem_addr;
  reg [1:0] wait_cnt;
  
  wire addr_valid;
  reg addr_err;
  
  assign addr_valid=(PADDR < MEM_DEPTH);
  
  assign PRDATA = (PSELX && PENABLE && !PWRITE && !addr_err)?mem[mem_addr]:'0;
  
  assign PREADY = (PSELX && PENABLE && wait_cnt==0);
  
  assign PSLVERR = (PREADY && addr_err);
  
  always@(posedge PCLK or negedge PRSTN)begin
    if(!PRSTN)begin
	  addr_err<=0;	
      wait_cnt<=0;
      for (i = 0; i < MEM_DEPTH; i = i + 1) begin
      mem[i] <= 32'b0;
    end
    end
    else begin
      
      if(PSELX && !PENABLE)begin
        addr_err<= !addr_valid;
        
        mem_addr<=PADDR[MEM_ADDR_WIDTH-1:0];
        if(!addr_valid)
          wait_cnt<='0;
        else if(PADDR[3:0] == 4'h0)
          wait_cnt <=2'd2;
        else
          wait_cnt<='0;

      end
      else if(PSELX && PENABLE)begin
        if(wait_cnt != 0)begin
          wait_cnt<= wait_cnt-1;
        end
        else if(PWRITE && !addr_err)
          mem[mem_addr]<=PWDATA;
      end
    end
  end
endmodule
