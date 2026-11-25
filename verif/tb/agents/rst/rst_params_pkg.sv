package rst_params_pkg;

    typedef struct packed {
        int unsigned MIN_DURATION_PS;
        int unsigned MAX_DURATION_PS;
        int unsigned MIN_CYCLES;
        int unsigned MAX_CYCLES;
    } rst_params_t;

    localparam rst_params_t RST_PARAMS = '{
        MIN_DURATION_PS: 1,
        MAX_DURATION_PS: 10000,
        MIN_CYCLES:      1,
        MAX_CYCLES:      1000
    };

endpackage