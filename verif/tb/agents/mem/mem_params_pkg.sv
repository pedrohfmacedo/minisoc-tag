package mem_params_pkg;

    typedef struct packed {
        int unsigned ADDR_WIDTH;
        int unsigned DATA_WIDTH;
        int unsigned DEPTH;
        int unsigned MIN_PERIOD_PS;
        int unsigned MAX_PERIOD_PS;
        int unsigned DEFAULT_PERIOD_PS;
    } mem_params_t;

    localparam mem_params_t MEM_PARAMS = '{
        ADDR_WIDTH:        10,
        DATA_WIDTH:        32,
        DEPTH:             1024,
        MIN_PERIOD_PS:     5000,
        MAX_PERIOD_PS:     100000,
        DEFAULT_PERIOD_PS: 5000
    };

endpackage