class apb_monitor;

    // Virtual interface
    virtual apb_interface vif;

    // Mailbox to send transactions to Scoreboard
    mailbox #(apb_transaction) mon2scb;


    //========================================
    // Constructor
    //========================================

    function new(
        virtual apb_interface vif,
        mailbox #(apb_transaction) mon2scb
    );

        this.vif     = vif;
        this.mon2scb = mon2scb;

    endfunction


    //========================================
    // Monitor
    //========================================

    task run();

        apb_transaction tr;

        forever begin

            // Wait for clock
            @(posedge vif.PCLK);


            // Check APB ACCESS phase
            if (vif.PSEL &&
                vif.PENABLE &&
                vif.PREADY) begin


                // Create transaction object
                tr = new();


                // Capture APB signals
                tr.addr  = vif.PADDR;
                tr.write = vif.PWRITE;
                tr.data  = vif.PWDATA;

                tr.rdata = vif.PRDATA;
                tr.error = vif.PSLVERR;


                // Send transaction to Scoreboard
                mon2scb.put(tr);


                // Display
                tr.display("MONITOR");

            end

        end

    endtask

endclass