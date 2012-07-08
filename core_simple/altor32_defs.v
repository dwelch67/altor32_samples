//-----------------------------------------------------------------
// ALU Operations
//-----------------------------------------------------------------
`define ALU_NONE                                4'b0000
`define ALU_SHIFTL                              4'b0001
`define ALU_SHIFTR                              4'b0010
`define ALU_SHIRTR_ARITH                        4'b0011
`define ALU_ADD                                 4'b0100
`define ALU_SUB                                 4'b0101
`define ALU_AND                                 4'b0110
`define ALU_OR                                  4'b0111
`define ALU_XOR                                 4'b1000

//-----------------------------------------------------------------
// ALU Instructions
//-----------------------------------------------------------------
`define INST_OR32_ALU                            8'h38
`define INST_OR32_ADD                            8'h00
`define INST_OR32_AND                            8'h03
`define INST_OR32_OR                             8'h04
`define INST_OR32_SLL                            8'h08
`define INST_OR32_SRA                            8'h28
`define INST_OR32_SRL                            8'h18
`define INST_OR32_SUB                            8'h02
`define INST_OR32_XOR                            8'h05

//-----------------------------------------------------------------
// INST_OR32_SHIFTI Instructions
//-----------------------------------------------------------------
`define INST_OR32_SHIFTI                         8'h2E
`define INST_OR32_SLLI                           2'b00
`define INST_OR32_SRAI                           2'b10
`define INST_OR32_SRLI                           2'b01

//-----------------------------------------------------------------
// General Instructions
//-----------------------------------------------------------------
`define INST_OR32_ADDI                           8'h27
`define INST_OR32_ANDI                           8'h29
`define INST_OR32_BF                             8'h04
`define INST_OR32_BNF                            8'h03
`define INST_OR32_J                              8'h00
`define INST_OR32_JAL                            8'h01
`define INST_OR32_JALR                           8'h12
`define INST_OR32_JR                             8'h11
`define INST_OR32_MFSPR                          8'h2D
`define INST_OR32_MOVHI                          8'h06
`define INST_OR32_MTSPR                          8'h30
`define INST_OR32_NOP                            8'h05
`define INST_OR32_ORI                            8'h2A
`define INST_OR32_RFE                            8'h09
`define INST_OR32_SB                             8'h36
`define INST_OR32_SH                             8'h37
`define INST_OR32_SW                             8'h35
`define INST_OR32_XORI                           8'h2B
`define INST_OR32_LBS                            8'h24
`define INST_OR32_LBZ                            8'h23
`define INST_OR32_LHS                            8'h26
`define INST_OR32_LHZ                            8'h25
`define INST_OR32_LWZ                            8'h21
`define INST_OR32_LWS                            8'h22

//-----------------------------------------------------------------
// Set Flag Instructions
//-----------------------------------------------------------------
`define INST_OR32_SFXX                           8'h2F
`define INST_OR32_SFXXI                          8'h39
`define INST_OR32_SFEQ                           16'h0720
`define INST_OR32_SFEQI                          16'h05E0
`define INST_OR32_SFGES                          16'h072B
`define INST_OR32_SFGESI                         16'h05EB
`define INST_OR32_SFGEU                          16'h0723
`define INST_OR32_SFGEUI                         16'h05E3
`define INST_OR32_SFGTS                          16'h072A
`define INST_OR32_SFGTSI                         16'h05EA
`define INST_OR32_SFGTU                          16'h0722
`define INST_OR32_SFGTUI                         16'h05E2
`define INST_OR32_SFLES                          16'h072D
`define INST_OR32_SFLESI                         16'h05ED
`define INST_OR32_SFLEU                          16'h0725
`define INST_OR32_SFLEUI                         16'h05E5
`define INST_OR32_SFLTS                          16'h072C
`define INST_OR32_SFLTSI                         16'h05EC
`define INST_OR32_SFLTU                          16'h0724
`define INST_OR32_SFLTUI                         16'h05E4
`define INST_OR32_SFNE                           16'h0721
`define INST_OR32_SFNEI                          16'h05E1

//-----------------------------------------------------------------
// Misc Instructions
//-----------------------------------------------------------------
`define INST_OR32_MISC                           8'h08
`define INST_OR32_SYS                            8'h20
`define INST_OR32_TRAP                           8'h21

//-----------------------------------------------------------------
// SPR Register Map
//-----------------------------------------------------------------
`define SPR_REG_VR                               16'h0000
`define SPR_VERSION_CURRENT                      8'h00
`define SPR_REG_SR                               16'h0011
`define SPR_REG_EPCR                             16'h0020
`define SPR_REG_ESR                              16'h0040

//-----------------------------------------------------------------
// SR Register bits
//-----------------------------------------------------------------
`define OR32_SR_SM                               0
`define OR32_SR_TEE                              1
`define OR32_SR_IEE                              2
`define OR32_SR_DCE                              3
`define OR32_SR_ICE                              4
`define OR32_SR_DME                              5
`define OR32_SR_IME                              6
`define OR32_SR_LEE                              7
`define OR32_SR_CE                               8
`define OR32_SR_F                                9
`define OR32_SR_CY                               10
`define OR32_SR_OV                               11
`define OR32_SR_OVE                              12
`define OR32_SR_DSX                              13
`define OR32_SR_EPH                              14
`define OR32_SR_FO                               15
`define OR32_SR_TED                              16

//-----------------------------------------------------------------
// OR32 Vectors
// NOTE: These differ from the real OR32 vectors for space reasons
//-----------------------------------------------------------------
`define VECTOR_RESET                             32'h00000100
`define VECTOR_ILLEGAL_INST                      32'h00000200
`define VECTOR_EXTINT                            32'h00000300
`define VECTOR_SYSCALL                           32'h00000400
`define VECTOR_TICK_TIMER                        32'h00000500
`define VECTOR_TRAP                              32'h00000600
