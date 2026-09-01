`timescale 1ns/1ps

module tb_top;

    parameter ADDR_WIDTH = 8;
    parameter DATA_WIDTH = 32;


    //========================================
    // CLOCK
    //========================================

    logic PCLK;

    initial begin

        PCLK = 1'b0;

        forever
            #5 PCLK = ~PCLK;

    end


    //========================================
    // RESET
    //========================================

    logic PRESETn;

    initial begin

        PRESETn = 1'b0;

        #20;

        PRESETn = 1'b1;

    end


    //========================================
    // APB INTERFACE
    //========================================

    apb_interface #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )
    apb_if(PCLK);


    //========================================
    // APB MASTER
    //========================================

    apb_master #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )
    master (

        .PCLK    (PCLK),
        .PRESETn (PRESETn),

        // Testbench ? Master
        .start   (apb_if.start),
        .write   (apb_if.write),
        .addr    (apb_if.addr),
        .wdata   (apb_if.wdata),

        // Master ? Testbench
        .rdata   (apb_if.rdata),
        .done    (apb_if.done),
        .error   (apb_if.error),

        // Master ? APB Bus
        .PSEL    (apb_if.PSEL),
        .PENABLE (apb_if.PENABLE),
        .PWRITE  (apb_if.PWRITE),
        .PADDR   (apb_if.PADDR),
        .PWDATA  (apb_if.PWDATA),

        // Slave ? Master
        .PRDATA  (apb_if.PRDATA),
        .PREADY  (apb_if.PREADY),
        .PSLVERR (apb_if.PSLVERR)

    );


    //========================================
    // APB SLAVE
    //========================================

    apb_slave #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )
    slave (

        .PCLK    (PCLK),
        .PRESETn (PRESETn),

        // APB Bus
        .PSEL    (apb_if.PSEL),
        .PENABLE (apb_if.PENABLE),
        .PWRITE  (apb_if.PWRITE),
        .PADDR   (apb_if.PADDR),
        .PWDATA  (apb_if.PWDATA),

        // Slave ? Master
        .PRDATA  (apb_if.PRDATA),
        .PREADY  (apb_if.PREADY),
        .PSLVERR (apb_if.PSLVERR)

    );


    //========================================
    // START TEST
    //========================================

    initial begin

        apb_test test;

        // Create test
        test = new(apb_if);

        // Wait for reset
        wait(PRESETn == 1'b1);

        // Start test
        test.run();

    end


    //========================================
    // WAVEFORM DUMP
    //========================================

    initial begin

        $dumpfile("apb.vcd");

        $dumpvars(0, tb_top);

    end

endmodule