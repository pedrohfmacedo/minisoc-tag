package clk_params_pkg;

    typedef struct packed {
        int unsigned MIN_PERIOD_PS;
        int unsigned MAX_PERIOD_PS;

        int unsigned MIN_PHASE_PS;
        int unsigned MAX_PHASE_PS;

        int unsigned MIN_CYCLES;
        int unsigned MAX_CYCLES;

        int unsigned DEFAULT_PERIOD_PS;
        int unsigned DEFAULT_TIME_LOW_PS;
        int unsigned DEFAULT_TIME_HIGH_PS;

        int unsigned CFG_MIN_PERIOD_PS;
        int unsigned CFG_MAX_PERIOD_PS;
    } clk_params_t;

    localparam clk_params_t CLK_PARAMS = '{
        MIN_PERIOD_PS:        2,
        MAX_PERIOD_PS:        100000,

        MIN_PHASE_PS:         1,
        MAX_PHASE_PS:         99999,

        MIN_CYCLES:           1,
        MAX_CYCLES:           100000,

        DEFAULT_PERIOD_PS:    500,
        DEFAULT_TIME_LOW_PS:  250,
        DEFAULT_TIME_HIGH_PS: 250,

        CFG_MIN_PERIOD_PS:    100,
        CFG_MAX_PERIOD_PS:    10000
    };

endpackage