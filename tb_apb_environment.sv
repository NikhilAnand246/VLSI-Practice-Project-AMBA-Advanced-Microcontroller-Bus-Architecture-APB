class apb_environment;

    //========================================
    // Verification Components
    //========================================

    apb_generator  gen;
    apb_driver     drv;
    apb_monitor    mon;
    apb_scoreboard scb;


    //========================================
    // Mailboxes
    //========================================

    mailbox #(apb_transaction) gen2drv;
    mailbox #(apb_transaction) mon2scb;


    //========================================
    // Virtual Interface
    //========================================

    virtual apb_interface vif;


    //========================================
    // Constructor
    //========================================

    function new(virtual apb_interface vif);

        this.vif = vif;


        // Create mailboxes
        gen2drv = new();
        mon2scb = new();


        // Create Generator
        gen = new(gen2drv);


        // Create Driver
        drv = new(
            vif,
            gen2drv
        );


        // Create Monitor
        mon = new(
            vif,
            mon2scb
        );


        // Create Scoreboard
        scb = new(
            mon2scb
        );

    endfunction


    //========================================
    // Start All Components
    //========================================

    task run();

        fork

            gen.run();

            drv.run();

            mon.run();

            scb.run();

        join_none

    endtask

endclass