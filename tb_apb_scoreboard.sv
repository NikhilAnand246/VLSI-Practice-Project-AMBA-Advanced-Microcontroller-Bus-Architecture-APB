class apb_scoreboard;

    //========================================
    // Mailbox from Monitor
    //========================================

    mailbox #(apb_transaction) mon2scb;


    //========================================
    // Expected Memory
    //========================================

    bit [31:0] expected_mem [0:31];


    //========================================
    // Constructor
    //========================================

    function new(
        mailbox #(apb_transaction) mon2scb
    );

        this.mon2scb = mon2scb;


        // Initialize expected memory
        for (int i = 0; i < 32; i++) begin
            expected_mem[i] = 32'h00000000;
        end

    endfunction


    //========================================
    // Scoreboard Main Task
    //========================================

    task run();

        apb_transaction tr;

        forever begin

            // Get transaction from Monitor
            mon2scb.get(tr);


            //====================================
            // WRITE CHECK
            //====================================

            if (tr.write) begin

                // Update expected memory
                expected_mem[tr.addr >> 2] = tr.data;


                $display(
                    "[SCOREBOARD] WRITE PASS | ADDR=%0h DATA=%0h",
                    tr.addr,
                    tr.data
                );

            end


            //====================================
            // READ CHECK
            //====================================

            else begin

                if (tr.rdata == expected_mem[tr.addr >> 2]) begin

                    $display(
                        "[SCOREBOARD] READ PASS | ADDR=%0h EXPECTED=%0h ACTUAL=%0h",
                        tr.addr,
                        expected_mem[tr.addr >> 2],
                        tr.rdata
                    );

                end

                else begin

                    $display(
                        "[SCOREBOARD] READ FAIL | ADDR=%0h EXPECTED=%0h ACTUAL=%0h",
                        tr.addr,
                        expected_mem[tr.addr >> 2],
                        tr.rdata
                    );

                end

            end

        end

    endtask

endclass