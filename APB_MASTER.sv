module apb_master #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32
)(
    input  logic                  PCLK,
    input  logic                  PRESETn,

    // Command from external logic
    input  logic                  start,
    input  logic                  write,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] wdata,

    // Response to external logic
    output logic [DATA_WIDTH-1:0] rdata,
    output logic                  done,
    output logic                  error,

    // APB signals
    output logic                  PSEL,
    output logic                  PENABLE,
    output logic                  PWRITE,
    output logic [ADDR_WIDTH-1:0] PADDR,
    output logic [DATA_WIDTH-1:0] PWDATA,

    input  logic [DATA_WIDTH-1:0] PRDATA,
    input  logic                  PREADY,
    input  logic                  PSLVERR
);

    //========================================
    // APB States
    //========================================

    typedef enum logic [1:0] {
        IDLE,
        SETUP,
        ACCESS
    } state_t;

    state_t state, next_state;


    //========================================
    // Registers
    //========================================

    logic [ADDR_WIDTH-1:0] addr_reg;
    logic [DATA_WIDTH-1:0] wdata_reg;
    logic                  write_reg;


    //========================================
    // State Register
    //========================================

    always_ff @(posedge PCLK or negedge PRESETn) begin

        if (!PRESETn)
            state <= IDLE;
        else
            state <= next_state;

    end


    //========================================
    // Next State Logic
    //========================================

    always_comb begin

        next_state = state;

        case (state)

            IDLE: begin

                if (start)
                    next_state = SETUP;

            end


            SETUP: begin

                next_state = ACCESS;

            end


            ACCESS: begin

                if (PREADY)
                    next_state = IDLE;

            end


            default: begin

                next_state = IDLE;

            end

        endcase

    end


    //========================================
    // Store Transaction
    //========================================

    always_ff @(posedge PCLK or negedge PRESETn) begin

        if (!PRESETn) begin

            addr_reg  <= '0;
            wdata_reg <= '0;
            write_reg <= 1'b0;

        end

        else begin

            if (state == IDLE && start) begin

                addr_reg  <= addr;
                wdata_reg <= wdata;
                write_reg <= write;

            end

        end

    end


    //========================================
    // APB Output Signals
    //========================================

    always_comb begin

        // Default values

        PSEL    = 1'b0;
        PENABLE = 1'b0;
        PWRITE  = write_reg;
        PADDR   = addr_reg;
        PWDATA  = wdata_reg;


        case (state)

            IDLE: begin

                PSEL    = 1'b0;
                PENABLE = 1'b0;

            end


            SETUP: begin

                PSEL    = 1'b1;
                PENABLE = 1'b0;

            end


            ACCESS: begin

                PSEL    = 1'b1;
                PENABLE = 1'b1;

            end

        endcase

    end


    //========================================
    // Response
    //========================================

    always_ff @(posedge PCLK or negedge PRESETn) begin

        if (!PRESETn) begin

            rdata <= '0;
            done  <= 1'b0;
            error <= 1'b0;

        end

        else begin

            done <= 1'b0;

            if (state == ACCESS && PREADY) begin

                rdata <= PRDATA;
                error <= PSLVERR;
                done  <= 1'b1;

            end

        end

    end

endmodule