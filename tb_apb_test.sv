class apb_test;

    apb_environment env;

    virtual apb_interface vif;

    function new(virtual apb_interface vif);

        this.vif = vif;
        env = new(vif);

    endfunction

    task run();

        env.drv.reset();

        env.run();

        #300;

        $display("");
        $display("========================================");
        $display("          APB TEST COMPLETED");
        $display("========================================");

        $finish;

    endtask

endclass