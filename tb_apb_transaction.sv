class apb_transaction;

    //========================================
    // APB Transaction Inputs
    //========================================

    rand bit [7:0]  addr;
    rand bit [31:0] data;
    rand bit        write;


    //========================================
    // APB Transaction Outputs
    //========================================

    bit [31:0] rdata;
    bit        error;


    //========================================
    // Address Constraint
    //========================================

    constraint addr_range {
        addr inside {[0:124]};
    }


    //========================================
    // Display Transaction
    //========================================

    function void display(string name);

        $display("----------------------------------------");
        $display("%s", name);
        $display("ADDR  = %0h", addr);
        $display("WRITE = %0b", write);
        $display("WDATA = %0h", data);
        $display("RDATA = %0h", rdata);
        $display("ERROR = %0b", error);
        $display("----------------------------------------");

    endfunction

endclass