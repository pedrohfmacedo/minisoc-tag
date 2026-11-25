package spi_params_pkg;

    typedef struct packed {
        int unsigned ADDR_WIDTH;
        int unsigned DATA_WIDTH;
        int unsigned MIN_PERIOD_PS;
        int unsigned DEFAULT_PERIOD_PS;
        int unsigned MIN_NUM_BLOCKS;
        int unsigned MAX_NUM_BLOCKS;
    } spi_params_t;

    localparam spi_params_t SPI_PARAMS = '{
        ADDR_WIDTH:        6,
        DATA_WIDTH:        32,
        MIN_PERIOD_PS:     40000,
        DEFAULT_PERIOD_PS: 40000,
        MIN_NUM_BLOCKS:    1,
        MAX_NUM_BLOCKS:    256
    };

endpackage