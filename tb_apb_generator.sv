class apb_generator;

    // Mailbox to send transactions to Driver
    mailbox #(apb_transaction) gen2drv;


    //========================================
    // Constructor
    //========================================

    function new(mailbox #(apb_transaction) gen2drv);

        this.gen2drv = gen2drv;

    endfunction


    //========================================
    // Generate Transactions
    //========================================

    task run();

        apb_transaction tr;


        //====================================
        // WRITE TRANSACTION 1
        //====================================

        tr = new();

        tr.write = 1'b1;
        tr.addr  = 8'h10;
        tr.data  = 32'hAAAA1111;

        gen2drv.put(tr);


        //====================================
        // WRITE TRANSACTION 2
        //====================================

        tr = new();

        tr.write = 1'b1;
        tr.addr  = 8'h14;
        tr.data  = 32'hBBBB2222;

        gen2drv.put(tr);


        //====================================
        // READ TRANSACTION 1
        //====================================

        tr = new();

        tr.write = 1'b0;
        tr.addr  = 8'h10;
        tr.data  = 32'h00000000;

        gen2drv.put(tr);


        //====================================
        // READ TRANSACTION 2
        //====================================

        tr = new();

        tr.write = 1'b0;
        tr.addr  = 8'h14;
        tr.data  = 32'h00000000;

        gen2drv.put(tr);

    endtask

endclass