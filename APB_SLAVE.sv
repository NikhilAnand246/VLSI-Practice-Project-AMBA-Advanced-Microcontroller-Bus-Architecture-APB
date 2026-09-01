module apb_slave #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter DEPTH      = 32
)(
    input  logic                  PCLK,
    input  logic                  PRESETn,

    // APB signals
    input  logic                  PSEL,
    input  logic                  PENABLE,
    input  logic                  PWRITE,
    input  logic [ADDR_WIDTH-1:0] PADDR,
    input  logic [DATA_WIDTH-1:0] PWDATA,

    output logic [DATA_WIDTH-1:0] PRDATA,
    output logic                  PREADY,
    output logic                  PSLVERR
);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    integer i;


    //========================================
    // Reset Memory
    //========================================

    always_ff @(posedge PCLK or negedge PRESETn) begin

        if (!PRESETn) begin

            for (i = 0; i < DEPTH; i = i + 1)
                mem[i] <= '0;

        end

    end


    //========================================
    // Write Operation
    //========================================

    always_ff @(posedge PCLK or negedge PRESETn) begin

        if (!PRESETn) begin

            // Nothing required here

        end

        else begin

            if (PSEL &&
                PENABLE &&
                PWRITE &&
                PREADY) begin

                mem[PADDR[ADDR_WIDTH-1:2]] <= PWDATA;

            end

        end

    end


    //========================================
    // Read Operation
    //========================================

    always_comb begin

        PRDATA = '0;

        if (PSEL &&
            PENABLE &&
            !PWRITE) begin

            PRDATA = mem[PADDR[ADDR_WIDTH-1:2]];

        end

    end


    //========================================
    // APB Response
    //========================================

    always_comb begin

        PREADY  = 1'b0;
        PSLVERR = 1'b0;

        if (PSEL && PENABLE) begin

            PREADY = 1'b1;

        end

    end

endmodule