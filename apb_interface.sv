interface apb_interface #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32
)(
    input logic PCLK
);

    //========================================
    // Signals from Testbench to APB Master
    //========================================

    logic                  start;
    logic                  write;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] wdata;


    //========================================
    // Signals from APB Master to Testbench
    //========================================

    logic [DATA_WIDTH-1:0] rdata;
    logic                  done;
    logic                  error;


    //========================================
    // APB BUS SIGNALS
    //========================================

    logic                  PSEL;
    logic                  PENABLE;
    logic                  PWRITE;

    logic [ADDR_WIDTH-1:0] PADDR;
    logic [DATA_WIDTH-1:0] PWDATA;

    logic [DATA_WIDTH-1:0] PRDATA;

    logic                  PREADY;
    logic                  PSLVERR;

endinterface