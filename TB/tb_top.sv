module top;
  
  logic clk;
  
  initial clk=0;
  always #5 clk=~clk;
  
  apb_if intf(clk);
  
  APB_MASTER DUT1(.PCLK(intf.PCLK),
    			  .PRSTN(intf.PRSTN),
                  .transfer(intf.transfer),
                  .write_in(intf.write_in),
                  .wdata_in(intf.wdata_in),
                  .addr_in(intf.addr_in),
                  .PREADY(intf.PREADY),
                  .PWRITE(intf.PWRITE),
                  .PADDR(intf.PADDR),
                  .PWDATA(intf.PWDATA),
                  .PSELX(intf.PSELX),
                  .PENABLE(intf.PENABLE),
                  .PRDATA(intf.PRDATA),
                  .PSLVERR(intf.PSLVERR),
                  .prdata_out(intf.prdata_out),
                  .pslverr_out(intf.pslverr_out)
                ); 

  APB_SLAVE DUT2(.PCLK(intf.PCLK),
                 .PRSTN(intf.PRSTN),
                 .PWRITE(intf.PWRITE),
                 .PADDR(intf.PADDR),
                 .PWDATA(intf.PWDATA),
                 .PSELX(intf.PSELX),
                 .PENABLE(intf.PENABLE),
                 .PRDATA(intf.PRDATA),
                 .PREADY(intf.PREADY),
                 .PSLVERR(intf.PSLVERR)
                );
  
  //================================================
  //				ASSERTIONS						
  //================================================
  
  property p_sel_before_enable;
    @(posedge clk) disable iff(!intf.PRSTN)
    (intf.PSELX && !intf.PENABLE) |=> (intf.PSELX && intf.PENABLE);
  endproperty
  
  a_sel_before_enable: assert property(p_sel_before_enable)
      else $error("PENABLE asserted without a preceding SETUP cycle at %0t", $time);
 
    
property p_enable_requires_sel;
    @(posedge clk) disable iff (!intf.PRSTN)
    intf.PENABLE |-> intf.PSELX;
  endproperty
  
  a_enable_requires_sel: assert property (p_enable_requires_sel)
    else $error("APB PROTOCOL VIOLATION: PENABLE asserted without PSELX at time=%0t", $time);
    


  initial begin
    intf.PRSTN=0;
    repeat(2) @(posedge clk);
    #5;
    intf.PRSTN=1;
  end
    
  initial begin
  $dumpfile("dump.vcd"); // Name of the waveform database file
  $dumpvars(0, top);     // 'top' should match your top-level module name
end
  
  initial begin
    
    uvm_config_db#(virtual apb_if)::set(null,"*","vif",intf);
    run_test("apb_test");
    
  end
endmodule
