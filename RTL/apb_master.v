module APB_MASTER #(parameter DATA_WIDTH=32,
                    parameter ADDR_WIDTH=32
                   )(
  input wire PCLK,
  input wire PRSTN,
  
  input wire transfer,
  input wire write_in,
  input wire [DATA_WIDTH-1:0] wdata_in,
  input wire [ADDR_WIDTH-1:0] addr_in,
  
  //from peripheral to the APB master inputs
  input wire PREADY,
  
  input wire [DATA_WIDTH-1:0] PRDATA,
  input wire PSLVERR,
  
  //to the APB slave
  output wire PWRITE,
  output wire [ADDR_WIDTH-1:0] PADDR,
  output wire [DATA_WIDTH-1:0] PWDATA,
  output wire PSELX,
  output wire PENABLE,
  
    output reg  [DATA_WIDTH-1:0]   prdata_out,  // Captures read data
    output reg                     pslverr_out  // Captures error status
);
  
  
//   typedef enum [1:0] 
  parameter IDLE=2'b00,SETUP=2'b01,ACCESS=2'b10;
  reg [1:0] state,nextstate;
  reg [ADDR_WIDTH-1:0] addr_reg;
  reg [DATA_WIDTH-1:0] data_reg;
  reg write_reg;
  
  
  
  //nextstate logic
  always@(posedge PCLK or negedge PRSTN)begin
    if(!PRSTN)
      state<=IDLE;
    else 
      state<=nextstate;
  end
  
  //FSM logic for APB
  
  always@(*)begin
    case(state)
      IDLE: nextstate=(transfer)?SETUP:IDLE;
      SETUP:
        nextstate=ACCESS;
      ACCESS:
        nextstate = (PREADY)?IDLE:ACCESS;
      default: nextstate=IDLE;
    endcase
  end
  
  
  //comb so no 1 cycle lag (for better verif env)
  assign PSELX = (state!=IDLE);
  assign PENABLE = (state==ACCESS);
  assign PADDR = addr_reg;
  assign PWRITE = write_reg;
  assign PWDATA = data_reg;
  
  //output logic
  
  always@(posedge PCLK or negedge PRSTN)begin
    if(!PRSTN)begin
      addr_reg<=0;
      write_reg<=0;	
      data_reg<=0;
    end
    else if(state==IDLE && transfer)begin
      addr_reg<=addr_in;
      data_reg<=wdata_in;
      write_reg<=write_in;
      
    end
  end
  
  always@(posedge PCLK or negedge PRSTN)begin
    if(!PRSTN)begin
      prdata_out<=0;
      pslverr_out<=0;
    end
    else if(state==ACCESS && PREADY)begin
      pslverr_out<=PSLVERR;
      if(!write_reg)
              prdata_out<=PRDATA;
    end
  end
endmodule
