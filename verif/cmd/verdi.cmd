simSetSimulator "-vcssv" -exec \
           "/home/pedro.macedo/minisoc-tag/verif/tb/workspace/build/vcs/simv" \
           -args \
           "+UVM_TESTNAME=minisoc_test_reset_clock +ntb_random_seed=1 +UVM_TR_RECORD +UVM_LOG_RECORD -l /home/pedro.macedo/minisoc-tag/verif/tb/workspace/build/vcs/logs/sim_gui.log" \
           -uvmDebug on -simDelim
debImport "-i" "-simflow" "-dbdir" \
          "/home/pedro.macedo/minisoc-tag/verif/tb/workspace/build/vcs/simv.daidir"
srcTBInvokeSim
verdiSetActWin -dock widgetDock_<Member>
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvCreateWindow
verdiSetActWin -win $_nWave3
srcHBDrag -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
wvDumpScope "top_tb.dut"
wvSetPosition -win $_nWave3 {("dut" 0)}
wvRenameGroup -win $_nWave3 {G1} {dut}
wvAddSignal -win $_nWave3 "/top_tb/dut/clk" "/top_tb/dut/rst_n" \
           "/top_tb/dut/spi_sclk" "/top_tb/dut/spi_cs_n" \
           "/top_tb/dut/spi_mosi" "/top_tb/dut/spi_miso" "/top_tb/dut/mem_clk" \
           "/top_tb/dut/mem_i_data\[31:0\]" "/top_tb/dut/mem_i_wr_en" \
           "/top_tb/dut/mem_i_addr\[9:0\]" "/top_tb/dut/mem_o_data\[31:0\]"
wvSetPosition -win $_nWave3 {("dut" 0)}
wvSetPosition -win $_nWave3 {("dut" 11)}
wvSetPosition -win $_nWave3 {("dut" 11)}
verdiSetActWin -win $_nWave3
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave3 {("G2" 0)}
wvDumpScope "top_tb.clk_vif"
wvSetPosition -win $_nWave3 {("clk_vif(clk_if)" 0)}
wvRenameGroup -win $_nWave3 {G2} {clk_vif(clk_if)}
wvAddSignal -win $_nWave3 "/top_tb/clk_vif/clk"
wvSetPosition -win $_nWave3 {("clk_vif(clk_if)" 0)}
wvSetPosition -win $_nWave3 {("clk_vif(clk_if)" 1)}
wvSetPosition -win $_nWave3 {("clk_vif(clk_if)" 1)}
wvSetPosition -win $_nWave3 {("G3" 0)}
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave3 {("dut" 9)}
wvSetPosition -win $_nWave3 {("dut" 10)}
wvSetPosition -win $_nWave3 {("dut" 11)}
wvSetPosition -win $_nWave3 {("clk_vif(clk_if)" 0)}
wvSetPosition -win $_nWave3 {("clk_vif(clk_if)" 1)}
wvSetPosition -win $_nWave3 {("G3" 0)}
wvDumpScope "top_tb.rst_vif"
wvSetPosition -win $_nWave3 {("rst_vif(rst_if)" 0)}
wvRenameGroup -win $_nWave3 {G3} {rst_vif(rst_if)}
wvAddSignal -win $_nWave3 "/top_tb/rst_vif/clk" "/top_tb/rst_vif/rst_n"
wvSetPosition -win $_nWave3 {("rst_vif(rst_if)" 0)}
wvSetPosition -win $_nWave3 {("rst_vif(rst_if)" 2)}
wvSetPosition -win $_nWave3 {("rst_vif(rst_if)" 2)}
wvSetPosition -win $_nWave3 {("G4" 0)}
verdiDockWidgetHide -dock widgetDock_<Member>
srcTBSetHiddenView -view MemberView
verdiSetActWin -win $_nWave3
srcTBRunSim
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomIn -win $_nWave3
