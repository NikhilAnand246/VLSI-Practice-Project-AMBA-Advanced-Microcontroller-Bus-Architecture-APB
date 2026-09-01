class apb_driver;

    // Virtual interface
    virtual apb_interface vif;

    // Mailbox from Generator
    mailbox #(apb_transaction) gen2drv;


    //========================================
    // Constructor
    //========================================

    function new(
        virtual apb_interface vif,
        mailbox #(apb_transaction) gen2drv
    );

        this.vif     = vif;
        this.gen2drv = gen2drv;

    endfunction


    //========================================
    // Reset
    //========================================

    task reset();

        vif.start <= 1'b0;
        vif.write <= 1'b0;
        vif.addr  <= '0;
        vif.wdata <= '0;

        repeat (2)
            @(posedge vif.PCLK);

    endtask


    //========================================
    // Drive Transaction
    //========================================

    task drive(apb_transaction tr);

        // Send transaction to APB Master
        @(posedge vif.PCLK);

        vif.write <= tr.write;
        vif.addr  <= tr.addr;
        vif.wdata <= tr.data;

        // Start the APB transaction
        vif.start <= 1'b1;


        // Start is a one-clock pulse
        @(posedge vif.PCLK);

        vif.start <= 1'b0;


        // Wait for APB Master to finish
        wait(vif.done == 1'b1);


        // Capture result
        tr.rdata = vif.rdata;
        tr.error = vif.error;


        // Display transaction
        tr.display("DRIVER");

    endtask


    //========================================
    // Driver Main Task
    //========================================

    task run();

        apb_transaction tr;

        forever begin

            // Get transaction from Generator
            gen2drv.get(tr);

            // Drive transaction
            drive(tr);

        end

    endtask

endclass