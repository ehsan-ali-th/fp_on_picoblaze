--
-------------------------------------------------------------------------------------------
-- Copyright © 2010-2014, Xilinx, Inc.
-- This file contains confidential and proprietary information of Xilinx, Inc. and is
-- protected under U.S. and international copyright and other intellectual property laws.
-------------------------------------------------------------------------------------------
--
-- Disclaimer:
-- This disclaimer is not a license and does not grant any rights to the materials
-- distributed herewith. Except as otherwise provided in a valid license issued to
-- you by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE
-- MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY
-- DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
-- INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT,
-- OR FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable
-- (whether in contract or tort, including negligence, or under any other theory
-- of liability) for any loss or damage of any kind or nature related to, arising
-- under or in connection with these materials, including for any direct, or any
-- indirect, special, incidental, or consequential loss or damage (including loss
-- of data, profits, goodwill, or any type of loss or damage suffered as a result
-- of any action brought by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-safe, or for use in any
-- application requiring fail-safe performance, such as life-support or safety
-- devices or systems, Class III medical devices, nuclear facilities, applications
-- related to the deployment of airbags, or any other applications that could lead
-- to death, personal injury, or severe property or environmental damage
-- (individually and collectively, "Critical Applications"). Customer assumes the
-- sole risk and liability of any use of Xilinx products in Critical Applications,
-- subject only to applicable laws and regulations governing limitations on product
-- liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------------------
--
--
-- Definition of a program memory for KCPSM6 including generic parameters for the 
-- convenient selection of device family, program memory size and the ability to include 
-- the JTAG Loader hardware for rapid software development.
--
-- This file is primarily for use during code development and it is recommended that the 
-- appropriate simplified program memory definition be used in a final production design. 
--
--    Generic                  Values             Comments
--    Parameter                Supported
--  
--    C_FAMILY                 "7S"               7-Series device 
--                                                  (Artix-7, Kintex-7, Virtex-7 or Zynq)
--                             "US"               UltraScale device
--                                                  (Kintex UltraScale and Virtex UltraScale)
--
--    C_RAM_SIZE_KWORDS        1, 2 or 4          Size of program memory in K-instructions
--
--    C_JTAG_LOADER_ENABLE     0 or 1             Set to '1' to include JTAG Loader
--
-- Notes
--
-- If your design contains MULTIPLE KCPSM6 instances then only one should have the 
-- JTAG Loader enabled at a time (i.e. make sure that C_JTAG_LOADER_ENABLE is only set to 
-- '1' on one instance of the program memory). Advanced users may be interested to know 
-- that it is possible to connect JTAG Loader to multiple memories and then to use the 
-- JTAG Loader utility to specify which memory contents are to be modified. However, 
-- this scheme does require some effort to set up and the additional connectivity of the 
-- multiple BRAMs can impact the placement, routing and performance of the complete 
-- design. Please contact the author at Xilinx for more detailed information. 
--
-- Regardless of the size of program memory specified by C_RAM_SIZE_KWORDS, the complete 
-- 12-bit address bus is connected to KCPSM6. This enables the generic to be modified 
-- without requiring changes to the fundamental hardware definition. However, when the 
-- program memory is 1K then only the lower 10-bits of the address are actually used and 
-- the valid address range is 000 to 3FF hex. Likewise, for a 2K program only the lower 
-- 11-bits of the address are actually used and the valid address range is 000 to 7FF hex.
--
-- Programs are stored in Block Memory (BRAM) and the number of BRAM used depends on the 
-- size of the program and the device family. 
--
-- In any 7-Series or UltraScale device a BRAM is capable of holding 2K instructions so 
-- obviously a 2K program requires only a single BRAM. Each BRAM can also be divided into 
-- 2 smaller memories supporting programs of 1K in half of a 36k-bit BRAM (generally 
-- reported as being an 18k-bit BRAM). For a program of 4K instructions, 2 BRAMs are used.
--
--
-- Program defined by 'Z:\home\esi\workspace\pico_blaze_conversion\pBlaze_prog.psm'.
--
-- Generated by KCPSM6 Assembler: 03 Mar 2019 - 02:07:34. 
--
-- Assembler used ROM_form template: ROM_form_JTAGLoader_Vivado_2June14.vhd
--
-- Standard IEEE libraries
--
--
package jtag_loader_pkg is
 function addr_width_calc (size_in_k: integer) return integer;
end jtag_loader_pkg;
--
package body jtag_loader_pkg is
  function addr_width_calc (size_in_k: integer) return integer is
   begin
    if (size_in_k = 1) then return 10;
      elsif (size_in_k = 2) then return 11;
      elsif (size_in_k = 4) then return 12;
      else report "Invalid BlockRAM size. Please set to 1, 2 or 4 K words." severity FAILURE;
    end if;
    return 0;
  end function addr_width_calc;
end package body;
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.jtag_loader_pkg.ALL;
--
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
--  
library unisim;
use unisim.vcomponents.all;
--
--
entity pBlaze_prog is
  generic(             C_FAMILY : string := "US"; 
              C_RAM_SIZE_KWORDS : integer := 4;
           C_JTAG_LOADER_ENABLE : integer := 1);
  Port (      address : in std_logic_vector(11 downto 0);
          instruction : out std_logic_vector(17 downto 0);
               enable : in std_logic;
                  rdl : out std_logic;                    
                  clk : in std_logic);
  end pBlaze_prog;
--
architecture low_level_definition of pBlaze_prog is
--
signal       address_a : std_logic_vector(15 downto 0);
signal       data_in_a : std_logic_vector(35 downto 0);
signal      data_out_a : std_logic_vector(35 downto 0);
signal    data_out_a_l : std_logic_vector(35 downto 0);
signal    data_out_a_h : std_logic_vector(35 downto 0);
signal       address_b : std_logic_vector(15 downto 0);
signal       data_in_b : std_logic_vector(35 downto 0);
signal     data_in_b_l : std_logic_vector(35 downto 0);
signal      data_out_b : std_logic_vector(35 downto 0);
signal    data_out_b_l : std_logic_vector(35 downto 0);
signal     data_in_b_h : std_logic_vector(35 downto 0);
signal    data_out_b_h : std_logic_vector(35 downto 0);
signal        enable_b : std_logic;
signal           clk_b : std_logic;
signal            we_b : std_logic_vector(7 downto 0);
-- 
signal       jtag_addr : std_logic_vector(11 downto 0);
signal         jtag_we : std_logic;
signal       jtag_we_l : std_logic;
signal       jtag_we_h : std_logic;
signal        jtag_clk : std_logic;
signal        jtag_din : std_logic_vector(17 downto 0);
signal       jtag_dout : std_logic_vector(17 downto 0);
signal     jtag_dout_1 : std_logic_vector(17 downto 0);
signal         jtag_en : std_logic_vector(0 downto 0);
-- 
signal picoblaze_reset : std_logic_vector(0 downto 0);
signal         rdl_bus : std_logic_vector(0 downto 0);
--
constant BRAM_ADDRESS_WIDTH  : integer := addr_width_calc(C_RAM_SIZE_KWORDS);
--
--
component jtag_loader_6
generic(                C_JTAG_LOADER_ENABLE : integer := 1;
                                    C_FAMILY : string  := "US";
                             C_NUM_PICOBLAZE : integer := 1;
                       C_BRAM_MAX_ADDR_WIDTH : integer := 10;
          C_PICOBLAZE_INSTRUCTION_DATA_WIDTH : integer := 18;
                                C_JTAG_CHAIN : integer := 4;
                              C_ADDR_WIDTH_0 : integer := 10;
                              C_ADDR_WIDTH_1 : integer := 10;
                              C_ADDR_WIDTH_2 : integer := 10;
                              C_ADDR_WIDTH_3 : integer := 10;
                              C_ADDR_WIDTH_4 : integer := 10;
                              C_ADDR_WIDTH_5 : integer := 10;
                              C_ADDR_WIDTH_6 : integer := 10;
                              C_ADDR_WIDTH_7 : integer := 10);
port(              picoblaze_reset : out std_logic_vector(C_NUM_PICOBLAZE-1 downto 0);
                           jtag_en : out std_logic_vector(C_NUM_PICOBLAZE-1 downto 0);
                          jtag_din : out STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                         jtag_addr : out STD_LOGIC_VECTOR(C_BRAM_MAX_ADDR_WIDTH-1 downto 0);
                          jtag_clk : out std_logic;
                           jtag_we : out std_logic;
                       jtag_dout_0 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_1 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_2 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_3 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_4 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_5 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_6 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
                       jtag_dout_7 : in STD_LOGIC_VECTOR(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0));
end component;
--
begin
  --
  --  
  ram_1k_generate : if (C_RAM_SIZE_KWORDS = 1) generate
    --
    akv7 : if (C_FAMILY = "7S") generate
      --
      address_a(13 downto 0) <= address(9 downto 0) & "1111";
      instruction <= data_out_a(17 downto 0);
      data_in_a(17 downto 0) <= "0000000000000000" & address(11 downto 10);
      jtag_dout <= data_out_b(17 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b(17 downto 0) <= data_out_b(17 downto 0);
        address_b(13 downto 0) <= "11111111111111";
        we_b(3 downto 0) <= "0000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b(17 downto 0) <= jtag_din(17 downto 0);
        address_b(13 downto 0) <= jtag_addr(9 downto 0) & "1111";
        we_b(3 downto 0) <= jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      -- 
      kcpsm6_rom: RAMB18E1
      generic map ( READ_WIDTH_A => 18,
                    WRITE_WIDTH_A => 18,
                    DOA_REG => 0,
                    INIT_A => "000000000000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => "000000000000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 18,
                    WRITE_WIDTH_B => 18,
                    DOB_REG => 0,
                    INIT_B => "000000000000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => "000000000000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    RAM_MODE => "TDP",
                    RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
                    SIM_DEVICE => "7SERIES",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"F02DF022100000E318081508160000E3180015001600008B2004200420042004",
                    INIT_01 => X"F04AF049F048F047F046F045F044F043F042F041F040F03CF03BF03AF02EF039",
                    INIT_02 => X"F05BF05AF059F058F057F056F055F054F053F052F051F050F04EF04DF04CF04B",
                    INIT_03 => X"1A531B000108048E00A0203A00FD010806B8603BD70100ED160F15FCF05DF05C",
                    INIT_04 => X"2042D553204C008200FD009400C51910009400C51908009400C5190000940099",
                    INIT_05 => X"1520156F157415201565156D156F1563156C15651557150A150D2042604CD573",
                    INIT_06 => X"15751562156515441528152015211521152115201536154D155315501543154B",
                    INIT_07 => X"B600950116411519D5006078D60496001500152915651564156F154D15201567",
                    INIT_08 => X"175116605000B001B031500095012083100097016089D608960017A75000607E",
                    INIT_09 => X"20993B001A0100781000D5004BA050000078150A0078150D50006090B7009601",
                    INIT_0A => X"07505000007815480078155B0078151B0078154A007815320078155B0078151B",
                    INIT_0B => X"173020C1A0BFD70A370F0078155720BA153020B9A0B7D50A450E450E450E450E",
                    INIT_0C => X"153020D1A0CFD50A450E450E450E450E0750A5901808500000780570175720C2",
                    INIT_0D => X"1000D8FF9801190100780570175720DA173020D9A0D7D70A370F0078155720D2",
                    INIT_0E => X"D602D50156805000A0E5C890180136001501E78000ED190809805000500020C6",
                    INIT_0F => X"4550D50415005000D602363F4550D602D501D70356C05000D602367F97024550",
                    INIT_10 => X"00F5B7161511160000F5B717151016005000D5041500610396011640D5041501",
                    INIT_11 => X"00F5B7121515160000F5B7131514160000F5B7141513160000F5B71515121600",
                    INIT_12 => X"213AD110B23BB13A032402FA034E500000F5B7101517160000F5B71115161600",
                    INIT_13 => X"61BCD21061CFD2202141D120217721BCD308B3262177D308B31B21776133D210",
                    INIT_14 => X"48004900480049004800490061BCD21021AA61BCD2106156D2402148D1402165",
                    INIT_15 => X"F014F013F012F011100031802120B223B1181FFF21F26165D24061AAD2204900",
                    INIT_16 => X"F611F710B007B106B205B304B403B502B601B7001FFF5000F110F017F016F015",
                    INIT_17 => X"B106B205B304B403B5025608B601B7001FFF5000F017F116F215F314F413F512",
                    INIT_18 => X"0A9038803980B808B9001FFF5000F017F116F215F314F413F512F611F710B007",
                    INIT_19 => X"B106B205B304B403B5024680B60147A0B7001800219718082196D98069802A80",
                    INIT_1A => X"B30CB40BB50AB609B7081FFF5000F017F116F215F314F413F512F611F710B007",
                    INIT_1B => X"5608B609B7081FFF5000F017F116F215F314F413F512F611F710B00FB10EB20D",
                    INIT_1C => X"1FFF5000F017F116F215F314F413F512F611F710B00FB10EB20DB30CB40BB50A",
                    INIT_1D => X"61E2D980B609578021DD377F61DCDA80B70869802A800A9038803980B808B900",
                    INIT_1E => X"F116F215F314F413F512F611F710B00FB10EB20DB30CB40BB50A560821E336F7",
                    INIT_1F => X"E3B0E2A0C19002A7029E70016207A206E130C020B225B324B01AB1195000F017",
                    INIT_20 => X"B43AF030F12FFF2EBF18B225B324B01AB11902B0E2077000E7F0E6E0E5D0E4C0",
                    INIT_21 => X"1038A221F100D0382247A1308020330012016219D401B43B310010016214D401",
                    INIT_22 => X"4D084E084F0E223CB1009001480849084A084B084C084D084E084F0E02A71100",
                    INIT_23 => X"FC29FD28FE27FF26622DB1009001F22D12202239D820480849084A084B084C08",
                    INIT_24 => X"03D3F02E10802252D080B0232257D080B018F82D38E04820B22DF92CFA2BFB2A",
                    INIT_25 => X"1000226303ED029EF02E1000225FD080B008226302A703D3F02E1080226303ED",
                    INIT_26 => X"72FF71FF70E02280D74027F026E025D024C023B022A02190008002A7029EF02E",
                    INIT_27 => X"2282F82E188037003600350034003300320031001020777F76FF75FF74FF73FF",
                    INIT_28 => X"4800490048004900480049004806B92FB830040702E3040702E30407F82E1800",
                    INIT_29 => X"B61CB71B5000F910F711F612F513F414F315F216F11749A0BA2E4780370F4900",
                    INIT_2A => X"5000B82DB92CBA2BBB2ABC29BD28BE27BF265000B022B121B220B31FB41EB51D",
                    INIT_2B => X"BA0DBB0CBC0BBD0ABE09BF08B822B007B106B205B304B403B502B601B7007001",
                    INIT_2C => X"FC03FD02FE01FF00F82DF00FB62DB70FF10EF20DF30CF40BF50AF609F708B90E",
                    INIT_2D => X"A2E24807190050007000032402FAF63AF53BB63BB53AF622F707F906FA05FB04",
                    INIT_2E => X"22F21801100022F0D10162EDD02022ED22E9D04022F062E6D080500022DE1901",
                    INIT_2F => X"10802300100062FFD780B7005000370036003500340033003200018018001000",
                    INIT_30 => X"6312D080B03AF61AF7194608470E4608470E4608470E4608470E377FB601F018",
                    INIT_31 => X"F31EF41DF51CB007B106B205B304B403B502F61B4600360FB601100023131010",
                    INIT_32 => X"470E4608470E377FB609F0231080232A10006329D780B7085000F021F120F21F",
                    INIT_33 => X"4600360FB6091000233D1010633CD080B03BF625F7244608470E4608470E4608",
                    INIT_34 => X"B601B7005000F02CF12BF22AF329F428F527B00FB10EB20DB30CB40BB50AF626",
                    INIT_35 => X"F2FFF3FFF4FFF5FFD60FB007B106B205B304B403B502B6016373F77FD6F0377F",
                    INIT_36 => X"B03A2394F03A5040B03A4808490E4808490E4808490E4808490E636FF0FFF1FF",
                    INIT_37 => X"B106B205B304B403B502B6016391F77FD6F036F0377FB601B7002394F03A5080",
                    INIT_38 => X"F03A5020B03A2394F03A5010B03A238DF0FFF1FFF2FFF3FFF4FFF5FFD60FB007",
                    INIT_39 => X"BA0EBB0DBC0CBD0BBE0ABF0963B1F77FD6F0377FB609B708F03A5001B03A2394",
                    INIT_3A => X"F03B5080B03B5000F03B5040B03B63ADF9FFFAFFFBFFFCFFFDFFFEFFDF0FB90F",
                    INIT_3B => X"DF0FB90FBA0EBB0DBC0CBD0BBE0ABF0963CFF77FD6F036F0377FB609B7085000",
                    INIT_3C => X"B03B5000F03B5020B03B5000F03B5010B03B23CBF9FFFAFFFBFFFCFFFDFFFEFF",
                    INIT_3D => X"3300320031001020777F76FF75FF74FF73FF72FF71FF70E0029E5000F03B5001",
                    INIT_3E => X"79FF78E002A75000F022F121F220F31FF41EF51DF61CF71B3700360035003400",
                    INIT_3F => X"FE27FF263F003E003D003C003B003A00390018207F7F7EFF7DFF7CFF7BFF7AFF",
                   INITP_00 => X"50B0AAAAAAAAAAAAAAAAAAADDEA8A28A0AAAB20AAAAAAAAAAAAAAAAAA20202AA",
                   INITP_01 => X"2282A280A2D5692AC5866D266D5502866D266D552888888896DA88B50AA2DC0B",
                   INITP_02 => X"00002AAAA00002AAAA000B31555CB332CCCB0C2CC0AA8080808080808080A348",
                   INITP_03 => X"56BF500AAAA80008C08C00002AAAA00000AAAA80000AAAA8000008C0000AAAA8",
                   INITP_04 => X"A15554000315556A2A8C2A8AA30C202AAAD631555755555835D5705C2A002F55",
                   INITP_05 => X"230955508332CB29D2EA82AAAAA0AAA800000003800020000AAAA80155542AA8",
                   INITP_06 => X"000D402828155570000000C00AAA8002008C2955542230AAA8002008C2955542",
                   INITP_07 => X"A55550000AAAAA55550000A8282830000000D40282830000000C008282830000")
      port map(   ADDRARDADDR => address_a(13 downto 0),
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                        DOADO => data_out_a(15 downto 0),
                      DOPADOP => data_out_a(17 downto 16), 
                        DIADI => data_in_a(15 downto 0),
                      DIPADIP => data_in_a(17 downto 16), 
                          WEA => "00",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b(13 downto 0),
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                        DOBDO => data_out_b(15 downto 0),
                      DOPBDOP => data_out_b(17 downto 16), 
                        DIBDI => data_in_b(15 downto 0),
                      DIPBDIP => data_in_b(17 downto 16), 
                        WEBWE => we_b(3 downto 0),
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0');
      --
    end generate akv7;
    --
    --
    us : if (C_FAMILY = "US") generate
      --
      address_a(13 downto 0) <= address(9 downto 0) & "1111";
      instruction <= data_out_a(17 downto 0);
      data_in_a(17 downto 0) <= "0000000000000000" & address(11 downto 10);
      jtag_dout <= data_out_b(17 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b(17 downto 0) <= data_out_b(17 downto 0);
        address_b(13 downto 0) <= "11111111111111";
        we_b(3 downto 0) <= "0000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b(17 downto 0) <= jtag_din(17 downto 0);
        address_b(13 downto 0) <= jtag_addr(9 downto 0) & "1111";
        we_b(3 downto 0) <= jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      -- 
      kcpsm6_rom: RAMB18E2
      generic map ( READ_WIDTH_A => 18,
                    WRITE_WIDTH_A => 18,
                    DOA_REG => 0,
                    INIT_A => "000000000000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => "000000000000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 18,
                    WRITE_WIDTH_B => 18,
                    DOB_REG => 0,
                    INIT_B => "000000000000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => "000000000000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    CASCADE_ORDER_A => "NONE",
                    CASCADE_ORDER_B => "NONE",
                    CLOCK_DOMAINS => "INDEPENDENT",
                    ENADDRENA => "FALSE",
                    ENADDRENB => "FALSE",
                    RDADDRCHANGEA => "FALSE",
                    RDADDRCHANGEB => "FALSE",
                    SLEEP_ASYNC => "FALSE",
                    INIT_00 => X"F02DF022100000E318081508160000E3180015001600008B2004200420042004",
                    INIT_01 => X"F04AF049F048F047F046F045F044F043F042F041F040F03CF03BF03AF02EF039",
                    INIT_02 => X"F05BF05AF059F058F057F056F055F054F053F052F051F050F04EF04DF04CF04B",
                    INIT_03 => X"1A531B000108048E00A0203A00FD010806B8603BD70100ED160F15FCF05DF05C",
                    INIT_04 => X"2042D553204C008200FD009400C51910009400C51908009400C5190000940099",
                    INIT_05 => X"1520156F157415201565156D156F1563156C15651557150A150D2042604CD573",
                    INIT_06 => X"15751562156515441528152015211521152115201536154D155315501543154B",
                    INIT_07 => X"B600950116411519D5006078D60496001500152915651564156F154D15201567",
                    INIT_08 => X"175116605000B001B031500095012083100097016089D608960017A75000607E",
                    INIT_09 => X"20993B001A0100781000D5004BA050000078150A0078150D50006090B7009601",
                    INIT_0A => X"07505000007815480078155B0078151B0078154A007815320078155B0078151B",
                    INIT_0B => X"173020C1A0BFD70A370F0078155720BA153020B9A0B7D50A450E450E450E450E",
                    INIT_0C => X"153020D1A0CFD50A450E450E450E450E0750A5901808500000780570175720C2",
                    INIT_0D => X"1000D8FF9801190100780570175720DA173020D9A0D7D70A370F0078155720D2",
                    INIT_0E => X"D602D50156805000A0E5C890180136001501E78000ED190809805000500020C6",
                    INIT_0F => X"4550D50415005000D602363F4550D602D501D70356C05000D602367F97024550",
                    INIT_10 => X"00F5B7161511160000F5B717151016005000D5041500610396011640D5041501",
                    INIT_11 => X"00F5B7121515160000F5B7131514160000F5B7141513160000F5B71515121600",
                    INIT_12 => X"213AD110B23BB13A032402FA034E500000F5B7101517160000F5B71115161600",
                    INIT_13 => X"61BCD21061CFD2202141D120217721BCD308B3262177D308B31B21776133D210",
                    INIT_14 => X"48004900480049004800490061BCD21021AA61BCD2106156D2402148D1402165",
                    INIT_15 => X"F014F013F012F011100031802120B223B1181FFF21F26165D24061AAD2204900",
                    INIT_16 => X"F611F710B007B106B205B304B403B502B601B7001FFF5000F110F017F016F015",
                    INIT_17 => X"B106B205B304B403B5025608B601B7001FFF5000F017F116F215F314F413F512",
                    INIT_18 => X"0A9038803980B808B9001FFF5000F017F116F215F314F413F512F611F710B007",
                    INIT_19 => X"B106B205B304B403B5024680B60147A0B7001800219718082196D98069802A80",
                    INIT_1A => X"B30CB40BB50AB609B7081FFF5000F017F116F215F314F413F512F611F710B007",
                    INIT_1B => X"5608B609B7081FFF5000F017F116F215F314F413F512F611F710B00FB10EB20D",
                    INIT_1C => X"1FFF5000F017F116F215F314F413F512F611F710B00FB10EB20DB30CB40BB50A",
                    INIT_1D => X"61E2D980B609578021DD377F61DCDA80B70869802A800A9038803980B808B900",
                    INIT_1E => X"F116F215F314F413F512F611F710B00FB10EB20DB30CB40BB50A560821E336F7",
                    INIT_1F => X"E3B0E2A0C19002A7029E70016207A206E130C020B225B324B01AB1195000F017",
                    INIT_20 => X"B43AF030F12FFF2EBF18B225B324B01AB11902B0E2077000E7F0E6E0E5D0E4C0",
                    INIT_21 => X"1038A221F100D0382247A1308020330012016219D401B43B310010016214D401",
                    INIT_22 => X"4D084E084F0E223CB1009001480849084A084B084C084D084E084F0E02A71100",
                    INIT_23 => X"FC29FD28FE27FF26622DB1009001F22D12202239D820480849084A084B084C08",
                    INIT_24 => X"03D3F02E10802252D080B0232257D080B018F82D38E04820B22DF92CFA2BFB2A",
                    INIT_25 => X"1000226303ED029EF02E1000225FD080B008226302A703D3F02E1080226303ED",
                    INIT_26 => X"72FF71FF70E02280D74027F026E025D024C023B022A02190008002A7029EF02E",
                    INIT_27 => X"2282F82E188037003600350034003300320031001020777F76FF75FF74FF73FF",
                    INIT_28 => X"4800490048004900480049004806B92FB830040702E3040702E30407F82E1800",
                    INIT_29 => X"B61CB71B5000F910F711F612F513F414F315F216F11749A0BA2E4780370F4900",
                    INIT_2A => X"5000B82DB92CBA2BBB2ABC29BD28BE27BF265000B022B121B220B31FB41EB51D",
                    INIT_2B => X"BA0DBB0CBC0BBD0ABE09BF08B822B007B106B205B304B403B502B601B7007001",
                    INIT_2C => X"FC03FD02FE01FF00F82DF00FB62DB70FF10EF20DF30CF40BF50AF609F708B90E",
                    INIT_2D => X"A2E24807190050007000032402FAF63AF53BB63BB53AF622F707F906FA05FB04",
                    INIT_2E => X"22F21801100022F0D10162EDD02022ED22E9D04022F062E6D080500022DE1901",
                    INIT_2F => X"10802300100062FFD780B7005000370036003500340033003200018018001000",
                    INIT_30 => X"6312D080B03AF61AF7194608470E4608470E4608470E4608470E377FB601F018",
                    INIT_31 => X"F31EF41DF51CB007B106B205B304B403B502F61B4600360FB601100023131010",
                    INIT_32 => X"470E4608470E377FB609F0231080232A10006329D780B7085000F021F120F21F",
                    INIT_33 => X"4600360FB6091000233D1010633CD080B03BF625F7244608470E4608470E4608",
                    INIT_34 => X"B601B7005000F02CF12BF22AF329F428F527B00FB10EB20DB30CB40BB50AF626",
                    INIT_35 => X"F2FFF3FFF4FFF5FFD60FB007B106B205B304B403B502B6016373F77FD6F0377F",
                    INIT_36 => X"B03A2394F03A5040B03A4808490E4808490E4808490E4808490E636FF0FFF1FF",
                    INIT_37 => X"B106B205B304B403B502B6016391F77FD6F036F0377FB601B7002394F03A5080",
                    INIT_38 => X"F03A5020B03A2394F03A5010B03A238DF0FFF1FFF2FFF3FFF4FFF5FFD60FB007",
                    INIT_39 => X"BA0EBB0DBC0CBD0BBE0ABF0963B1F77FD6F0377FB609B708F03A5001B03A2394",
                    INIT_3A => X"F03B5080B03B5000F03B5040B03B63ADF9FFFAFFFBFFFCFFFDFFFEFFDF0FB90F",
                    INIT_3B => X"DF0FB90FBA0EBB0DBC0CBD0BBE0ABF0963CFF77FD6F036F0377FB609B7085000",
                    INIT_3C => X"B03B5000F03B5020B03B5000F03B5010B03B23CBF9FFFAFFFBFFFCFFFDFFFEFF",
                    INIT_3D => X"3300320031001020777F76FF75FF74FF73FF72FF71FF70E0029E5000F03B5001",
                    INIT_3E => X"79FF78E002A75000F022F121F220F31FF41EF51DF61CF71B3700360035003400",
                    INIT_3F => X"FE27FF263F003E003D003C003B003A00390018207F7F7EFF7DFF7CFF7BFF7AFF",
                   INITP_00 => X"50B0AAAAAAAAAAAAAAAAAAADDEA8A28A0AAAB20AAAAAAAAAAAAAAAAAA20202AA",
                   INITP_01 => X"2282A280A2D5692AC5866D266D5502866D266D552888888896DA88B50AA2DC0B",
                   INITP_02 => X"00002AAAA00002AAAA000B31555CB332CCCB0C2CC0AA8080808080808080A348",
                   INITP_03 => X"56BF500AAAA80008C08C00002AAAA00000AAAA80000AAAA8000008C0000AAAA8",
                   INITP_04 => X"A15554000315556A2A8C2A8AA30C202AAAD631555755555835D5705C2A002F55",
                   INITP_05 => X"230955508332CB29D2EA82AAAAA0AAA800000003800020000AAAA80155542AA8",
                   INITP_06 => X"000D402828155570000000C00AAA8002008C2955542230AAA8002008C2955542",
                   INITP_07 => X"A55550000AAAAA55550000A8282830000000D40282830000000C008282830000")
      port map(   ADDRARDADDR => address_a(13 downto 0),
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                    DOUTADOUT => data_out_a(15 downto 0),
                  DOUTPADOUTP => data_out_a(17 downto 16), 
                      DINADIN => data_in_a(15 downto 0),
                    DINPADINP => data_in_a(17 downto 16), 
                          WEA => "00",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b(13 downto 0),
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                    DOUTBDOUT => data_out_b(15 downto 0),
                  DOUTPBDOUTP => data_out_b(17 downto 16), 
                      DINBDIN => data_in_b(15 downto 0),
                    DINPBDINP => data_in_b(17 downto 16), 
                        WEBWE => we_b(3 downto 0),
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                      ADDRENA => '1',
                      ADDRENB => '1',
                    CASDIMUXA => '0',
                    CASDIMUXB => '0',
                      CASDINA => "0000000000000000",  
                      CASDINB => "0000000000000000",
                     CASDINPA => "00",
                     CASDINPB => "00",
                    CASDOMUXA => '0',
                    CASDOMUXB => '0',
                 CASDOMUXEN_A => '1',
                 CASDOMUXEN_B => '1',
                 CASOREGIMUXA => '0',
                 CASOREGIMUXB => '0',
              CASOREGIMUXEN_A => '0',
              CASOREGIMUXEN_B => '0',
                        SLEEP => '0');
      --
    end generate us;
    --
  end generate ram_1k_generate;
  --
  --
  --
  ram_2k_generate : if (C_RAM_SIZE_KWORDS = 2) generate
    --
    --
    akv7 : if (C_FAMILY = "7S") generate
      --
      address_a <= '1' & address(10 downto 0) & "1111";
      instruction <= data_out_a(33 downto 32) & data_out_a(15 downto 0);
      data_in_a <= "00000000000000000000000000000000000" & address(11);
      jtag_dout <= data_out_b(33 downto 32) & data_out_b(15 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b <= "00" & data_out_b(33 downto 32) & "0000000000000000" & data_out_b(15 downto 0);
        address_b <= "1111111111111111";
        we_b <= "00000000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b <= "00" & jtag_din(17 downto 16) & "0000000000000000" & jtag_din(15 downto 0);
        address_b <= '1' & jtag_addr(10 downto 0) & "1111";
        we_b <= jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      --
      kcpsm6_rom: RAMB36E1
      generic map ( READ_WIDTH_A => 18,
                    WRITE_WIDTH_A => 18,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 18,
                    WRITE_WIDTH_B => 18,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    RAM_MODE => "TDP",
                    RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
                    EN_ECC_READ => FALSE,
                    EN_ECC_WRITE => FALSE,
                    RAM_EXTENSION_A => "NONE",
                    RAM_EXTENSION_B => "NONE",
                    SIM_DEVICE => "7SERIES",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"F02DF022100000E318081508160000E3180015001600008B2004200420042004",
                    INIT_01 => X"F04AF049F048F047F046F045F044F043F042F041F040F03CF03BF03AF02EF039",
                    INIT_02 => X"F05BF05AF059F058F057F056F055F054F053F052F051F050F04EF04DF04CF04B",
                    INIT_03 => X"1A531B000108048E00A0203A00FD010806B8603BD70100ED160F15FCF05DF05C",
                    INIT_04 => X"2042D553204C008200FD009400C51910009400C51908009400C5190000940099",
                    INIT_05 => X"1520156F157415201565156D156F1563156C15651557150A150D2042604CD573",
                    INIT_06 => X"15751562156515441528152015211521152115201536154D155315501543154B",
                    INIT_07 => X"B600950116411519D5006078D60496001500152915651564156F154D15201567",
                    INIT_08 => X"175116605000B001B031500095012083100097016089D608960017A75000607E",
                    INIT_09 => X"20993B001A0100781000D5004BA050000078150A0078150D50006090B7009601",
                    INIT_0A => X"07505000007815480078155B0078151B0078154A007815320078155B0078151B",
                    INIT_0B => X"173020C1A0BFD70A370F0078155720BA153020B9A0B7D50A450E450E450E450E",
                    INIT_0C => X"153020D1A0CFD50A450E450E450E450E0750A5901808500000780570175720C2",
                    INIT_0D => X"1000D8FF9801190100780570175720DA173020D9A0D7D70A370F0078155720D2",
                    INIT_0E => X"D602D50156805000A0E5C890180136001501E78000ED190809805000500020C6",
                    INIT_0F => X"4550D50415005000D602363F4550D602D501D70356C05000D602367F97024550",
                    INIT_10 => X"00F5B7161511160000F5B717151016005000D5041500610396011640D5041501",
                    INIT_11 => X"00F5B7121515160000F5B7131514160000F5B7141513160000F5B71515121600",
                    INIT_12 => X"213AD110B23BB13A032402FA034E500000F5B7101517160000F5B71115161600",
                    INIT_13 => X"61BCD21061CFD2202141D120217721BCD308B3262177D308B31B21776133D210",
                    INIT_14 => X"48004900480049004800490061BCD21021AA61BCD2106156D2402148D1402165",
                    INIT_15 => X"F014F013F012F011100031802120B223B1181FFF21F26165D24061AAD2204900",
                    INIT_16 => X"F611F710B007B106B205B304B403B502B601B7001FFF5000F110F017F016F015",
                    INIT_17 => X"B106B205B304B403B5025608B601B7001FFF5000F017F116F215F314F413F512",
                    INIT_18 => X"0A9038803980B808B9001FFF5000F017F116F215F314F413F512F611F710B007",
                    INIT_19 => X"B106B205B304B403B5024680B60147A0B7001800219718082196D98069802A80",
                    INIT_1A => X"B30CB40BB50AB609B7081FFF5000F017F116F215F314F413F512F611F710B007",
                    INIT_1B => X"5608B609B7081FFF5000F017F116F215F314F413F512F611F710B00FB10EB20D",
                    INIT_1C => X"1FFF5000F017F116F215F314F413F512F611F710B00FB10EB20DB30CB40BB50A",
                    INIT_1D => X"61E2D980B609578021DD377F61DCDA80B70869802A800A9038803980B808B900",
                    INIT_1E => X"F116F215F314F413F512F611F710B00FB10EB20DB30CB40BB50A560821E336F7",
                    INIT_1F => X"E3B0E2A0C19002A7029E70016207A206E130C020B225B324B01AB1195000F017",
                    INIT_20 => X"B43AF030F12FFF2EBF18B225B324B01AB11902B0E2077000E7F0E6E0E5D0E4C0",
                    INIT_21 => X"1038A221F100D0382247A1308020330012016219D401B43B310010016214D401",
                    INIT_22 => X"4D084E084F0E223CB1009001480849084A084B084C084D084E084F0E02A71100",
                    INIT_23 => X"FC29FD28FE27FF26622DB1009001F22D12202239D820480849084A084B084C08",
                    INIT_24 => X"03D3F02E10802252D080B0232257D080B018F82D38E04820B22DF92CFA2BFB2A",
                    INIT_25 => X"1000226303ED029EF02E1000225FD080B008226302A703D3F02E1080226303ED",
                    INIT_26 => X"72FF71FF70E02280D74027F026E025D024C023B022A02190008002A7029EF02E",
                    INIT_27 => X"2282F82E188037003600350034003300320031001020777F76FF75FF74FF73FF",
                    INIT_28 => X"4800490048004900480049004806B92FB830040702E3040702E30407F82E1800",
                    INIT_29 => X"B61CB71B5000F910F711F612F513F414F315F216F11749A0BA2E4780370F4900",
                    INIT_2A => X"5000B82DB92CBA2BBB2ABC29BD28BE27BF265000B022B121B220B31FB41EB51D",
                    INIT_2B => X"BA0DBB0CBC0BBD0ABE09BF08B822B007B106B205B304B403B502B601B7007001",
                    INIT_2C => X"FC03FD02FE01FF00F82DF00FB62DB70FF10EF20DF30CF40BF50AF609F708B90E",
                    INIT_2D => X"A2E24807190050007000032402FAF63AF53BB63BB53AF622F707F906FA05FB04",
                    INIT_2E => X"22F21801100022F0D10162EDD02022ED22E9D04022F062E6D080500022DE1901",
                    INIT_2F => X"10802300100062FFD780B7005000370036003500340033003200018018001000",
                    INIT_30 => X"6312D080B03AF61AF7194608470E4608470E4608470E4608470E377FB601F018",
                    INIT_31 => X"F31EF41DF51CB007B106B205B304B403B502F61B4600360FB601100023131010",
                    INIT_32 => X"470E4608470E377FB609F0231080232A10006329D780B7085000F021F120F21F",
                    INIT_33 => X"4600360FB6091000233D1010633CD080B03BF625F7244608470E4608470E4608",
                    INIT_34 => X"B601B7005000F02CF12BF22AF329F428F527B00FB10EB20DB30CB40BB50AF626",
                    INIT_35 => X"F2FFF3FFF4FFF5FFD60FB007B106B205B304B403B502B6016373F77FD6F0377F",
                    INIT_36 => X"B03A2394F03A5040B03A4808490E4808490E4808490E4808490E636FF0FFF1FF",
                    INIT_37 => X"B106B205B304B403B502B6016391F77FD6F036F0377FB601B7002394F03A5080",
                    INIT_38 => X"F03A5020B03A2394F03A5010B03A238DF0FFF1FFF2FFF3FFF4FFF5FFD60FB007",
                    INIT_39 => X"BA0EBB0DBC0CBD0BBE0ABF0963B1F77FD6F0377FB609B708F03A5001B03A2394",
                    INIT_3A => X"F03B5080B03B5000F03B5040B03B63ADF9FFFAFFFBFFFCFFFDFFFEFFDF0FB90F",
                    INIT_3B => X"DF0FB90FBA0EBB0DBC0CBD0BBE0ABF0963CFF77FD6F036F0377FB609B7085000",
                    INIT_3C => X"B03B5000F03B5020B03B5000F03B5010B03B23CBF9FFFAFFFBFFFCFFFDFFFEFF",
                    INIT_3D => X"3300320031001020777F76FF75FF74FF73FF72FF71FF70E0029E5000F03B5001",
                    INIT_3E => X"79FF78E002A75000F022F121F220F31FF41EF51DF61CF71B3700360035003400",
                    INIT_3F => X"FE27FF263F003E003D003C003B003A00390018207F7F7EFF7DFF7CFF7BFF7AFF",
                    INIT_40 => X"4608470E1F00240E1F20240DD020241ED7205000F82DF92CFA2BFB2AFC29FD28",
                    INIT_41 => X"2431D710248D40F0F92FF83039001801B92FB830400841084208430844084508",
                    INIT_42 => X"F83C1801F92FF83039001801B92FB830648DD801B83C248DDF802FE0BE3BBF3A",
                    INIT_43 => X"246BD9FF02DD48074807480748070870377F1A01248DFBFFDA0FBA30BB2F248D",
                    INIT_44 => X"2452D90802DD08501A08246B0A90244BD90802DD08601A04246B0A902444D904",
                    INIT_45 => X"246B0A902460D90802DD08301A08246B0A902459D90802DD08401A08246B0A90",
                    INIT_46 => X"4100400609A02478DAFF0A9002DD08101A08246B0A902467D90802DD08201A08",
                    INIT_47 => X"470E248DF830F92FB90088A0B830B92F646E9901470046004500440043004200",
                    INIT_48 => X"02FA034E5000F830F92F39001801B830B92F4008410842084308440845084608",
                    INIT_49 => X"B247B346B445B544B643B742B841B94005B205000691067924FFDFFF05CB0324",
                    INIT_4A => X"460847084808490E24FEA4AC24FEF100D0353100100170FF71FF24B7D1800F10",
                    INIT_4B => X"430844084508460847084808490E24C3D90264ACB10090014208430844084508",
                    INIT_4C => X"4400430042064900480047004600450044004300420664CDDF80310010014208",
                    INIT_4D => X"4400430042064900480047004600450044004300420649004800470046004500",
                    INIT_4E => X"4900390F4100400641004006410040064100400606A949004800470046004500",
                    INIT_4F => X"500005EE24FFF110F911F812F713F614F515F416F31741F03F806FE0BE23BF18",
                    INIT_50 => X"FC51FD50B021B120B21FB31EB41DB51CB61B1700180019001A001B001C001D00",
                    INIT_51 => X"B527B6261E001F00F05DF15CF25BF35AF459F558F657F756F855F954FA53FB52",
                    INIT_52 => X"400841084208430844084508460E6533D00125B1DF35B02CB12BB22AB329B428",
                    INIT_53 => X"B855B954BA53BB52BC51BD50F02CF12BF22AF329F428F527F62625251F011E01",
                    INIT_54 => X"4500440043004200410040062568DE00B05DB15CB25BB35AB459B558B657B756",
                    INIT_55 => X"F855F954FA53FB52FC51FD50654A9E014D004C004B004A004900480047004600",
                    INIT_56 => X"0070B74DB84CB94BBA4ABB49BC48BD47F05DF15CF25BF35AF459F558F657F756",
                    INIT_57 => X"BB42BC41BD40F04DF14CF24BF34AF449F548F64726D025C024B023A022902180",
                    INIT_58 => X"24B023A0229021802070B056B155B254B353B452B551B650B746B845B944BA43",
                    INIT_59 => X"B02CB12BB22AB329B428B527B626F046F145F244F343F442F541F64026D025C0",
                    INIT_5A => X"1E011F01F02CF12BF22AF329F428F527F626400841084208430844084508460E",
                    INIT_5B => X"DF80BF3BB225B324B10390FE25BCB10390FF65BADF80BF3AB01AB1195000251E",
                    INIT_5C => X"D21025D2D110B23BB13A5000310310FF21300020B30392FE25C6B30392FF65C4",
                    INIT_5D => X"25EE65E3D21065E3D22025E0D140260E61BCD210661FD24025D9D12021776631",
                    INIT_5E => X"B1181FFF50001F0065EED24065FDD22021BCFD082DE0BD081E7F25E865E3D210",
                    INIT_5F => X"B423B3181FFF5000F110F017F016F015F014F013F012F011100031806120B223",
                    INIT_60 => X"B3181FFF5000F017F016F015F014F013F012F111F2101000423011F0127F6340",
                    INIT_61 => X"1FFF5000F017F016F015F014F013F012F111F2101000423011F0127F6340B423",
                    INIT_62 => X"F017F016F015F014F013F012F111F210100011F042B0127F3B806BA0BA23BB18",
                    INIT_63 => X"02DD480748074807480708601A01217721BCDE0821776636DF08BE26BF1B5000",
                    INIT_64 => X"02DD08401A08266D0A90264DD90802DD08501A04266D0A902646D904266DD9FF",
                    INIT_65 => X"2662D90802DD08201A08266D0A90265BD90802DD08301A08266D0A902654D908",
                    INIT_66 => X"4100400609A00A9002DD08001A08266D0A902669D90802DD08101A08266D0A90",
                    INIT_67 => X"B21FB31EB41DB51C6690D610B61B5000666E9901470046004500440043004200",
                    INIT_68 => X"FF19FE1ABF008EA0BF19BE1AF021F120F21FF31EF41DF51CF61B0639B021B120",
                    INIT_69 => X"F22AF329F428F527F6260639B02CB12BB22AB329B428B52766A8D610B6265000",
                    INIT_6A => X"D24026B766AFD280522026ACD2105000FF24FE25BF008EA0BF24BE25F02CF12B",
                    INIT_6B => X"069106792757DFFF0758032402FA034E5000130126B7D30166B6D22026B626B2",
                    INIT_6C => X"B047B146B245B344B443B542B641B740F12FF0301C0026C61C01E6C507D7077D",
                    INIT_6D => X"DA343B001A017AFF7BFF26F2DB80BA30BB2F66D29E015020E6D54F0E0F001E06",
                    INIT_6E => X"FA3066E4BB009A014008410842084308440845084608470E2756A6E42756FB00",
                    INIT_6F => X"46004500440043004200410040066710D780280CA6F726F7FB07DAFF2708FB2F",
                    INIT_70 => X"4008410842084308440845084608470E2710FF2FFE30BF009E01BF2FBE304700",
                    INIT_71 => X"4008410842084308440845084608470E4008410842084308440845084608470E",
                    INIT_72 => X"45084608470E6735FB00DA002735DC014008410842084308440845084608470E",
                    INIT_73 => X"4E06BF2FBE303700360035003400330032000802370F40084108420843084408",
                    INIT_74 => X"F315F216F1174FB03B806BA0BA23BB184E704F004E064F004E064F004E064F00",
                    INIT_75 => X"D12021776631D210275FD110B23BB13A500005EE2757FF10FE11F612F513F414",
                    INIT_76 => X"D21025EE65E3D21067F0D240276FD140260E61BCD210681ED220661FD2402768",
                    INIT_77 => X"11001000700150001F00660ED24065EED22021BCFD082DE0BD081E7F27776772",
                    INIT_78 => X"1F00B021B120B21FB31EB41DB51CB61B17007000170016001500140013001200",
                    INIT_79 => X"E5D0E4C0E3B0E2A0E190C08070001F407001B82CB92BBA2ABB29BC28BD27BE26",
                    INIT_7A => X"43004200410040077001A7F0A6E0A5D0A4C0A3B0A2A0A1908080A7B6E7F0E6E0",
                    INIT_7B => X"700047004600450044004300420041004006700127C070004700460045004400",
                    INIT_7C => X"F542F641F7407001679A70009F01700147004600450044004300420041004006",
                    INIT_7D => X"90FE27E1B10390FF67DFDF80BF3AB01AB11950007000F047F146F245F344F443",
                    INIT_7E => X"5000310310FFA1308020B30392FE27EBB30392FF67E9DF80BF3BB225B324B103",
                    INIT_7F => X"F116F215F314F413F512F611F71010001100120013001400150016F8177F1FFF",
                   INITP_00 => X"50B0AAAAAAAAAAAAAAAAAAADDEA8A28A0AAAB20AAAAAAAAAAAAAAAAAA20202AA",
                   INITP_01 => X"2282A280A2D5692AC5866D266D5502866D266D552888888896DA88B50AA2DC0B",
                   INITP_02 => X"00002AAAA00002AAAA000B31555CB332CCCB0C2CC0AA8080808080808080A348",
                   INITP_03 => X"56BF500AAAA80008C08C00002AAAA00000AAAA80000AAAA8000008C0000AAAA8",
                   INITP_04 => X"A15554000315556A2A8C2A8AA30C202AAAD631555755555835D5705C2A002F55",
                   INITP_05 => X"230955508332CB29D2EA82AAAAA0AAA800000003800020000AAAA80155542AA8",
                   INITP_06 => X"000D402828155570000000C00AAA8002008C2955542230AAA8002008C2955542",
                   INITP_07 => X"A55550000AAAAA55550000A8282830000000D40282830000000C008282830000",
                   INITP_08 => X"6A50D555531867619D867619D867619DC9540C028A50C300C8A5055552332AAA",
                   INITP_09 => X"AAAAA8000555595555555555555557155557355555BD54300000AADAAA941555",
                   INITP_0A => X"02AAA5554000AAAAAAAD5555555D0000000AAAA55557340000AAAAAAA0000000",
                   INITP_0B => X"02AAAA0008CCA02CB332CCCB302555970059700A1AAA95550002AAA555400000",
                   INITP_0C => X"00C2D55551867619D867619D867619DC9542CB02AAAA00002AAAA0000AAAA800",
                   INITP_0D => X"55572F5AB55555BD543034D00000A23AADAA9CCB2C32A50AAAA000C2A50AAAA0",
                   INITP_0E => X"0E33280B2CCCB3332CC0AAAAA800155541556155575C5555555555555555A941",
                   INITP_0F => X"AAA8000095565C0165C02EAAABF75555D5557B5555D55575555CC00000003000")
      port map(   ADDRARDADDR => address_a,
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                        DOADO => data_out_a(31 downto 0),
                      DOPADOP => data_out_a(35 downto 32), 
                        DIADI => data_in_a(31 downto 0),
                      DIPADIP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b,
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                        DOBDO => data_out_b(31 downto 0),
                      DOPBDOP => data_out_b(35 downto 32), 
                        DIBDI => data_in_b(31 downto 0),
                      DIPBDIP => data_in_b(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                   CASCADEINA => '0',
                   CASCADEINB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0');
      --
    end generate akv7;
    --
    --
    us : if (C_FAMILY = "US") generate
      --
      address_a(14 downto 0) <= address(10 downto 0) & "1111";
      instruction <= data_out_a(33 downto 32) & data_out_a(15 downto 0);
      data_in_a <= "00000000000000000000000000000000000" & address(11);
      jtag_dout <= data_out_b(33 downto 32) & data_out_b(15 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b <= "00" & data_out_b(33 downto 32) & "0000000000000000" & data_out_b(15 downto 0);
        address_b(14 downto 0) <= "111111111111111";
        we_b <= "00000000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b <= "00" & jtag_din(17 downto 16) & "0000000000000000" & jtag_din(15 downto 0);
        address_b(14 downto 0) <= jtag_addr(10 downto 0) & "1111";
        we_b <= jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      --
      kcpsm6_rom: RAMB36E2
      generic map ( READ_WIDTH_A => 18,
                    WRITE_WIDTH_A => 18,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 18,
                    WRITE_WIDTH_B => 18,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    EN_ECC_READ => "FALSE",
                    EN_ECC_WRITE => "FALSE",
                    CASCADE_ORDER_A => "NONE",
                    CASCADE_ORDER_B => "NONE",
                    CLOCK_DOMAINS => "INDEPENDENT",
                    ENADDRENA => "FALSE",
                    ENADDRENB => "FALSE",
                    EN_ECC_PIPE => "FALSE",
                    RDADDRCHANGEA => "FALSE",
                    RDADDRCHANGEB => "FALSE",
                    SLEEP_ASYNC => "FALSE",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"F02DF022100000E318081508160000E3180015001600008B2004200420042004",
                    INIT_01 => X"F04AF049F048F047F046F045F044F043F042F041F040F03CF03BF03AF02EF039",
                    INIT_02 => X"F05BF05AF059F058F057F056F055F054F053F052F051F050F04EF04DF04CF04B",
                    INIT_03 => X"1A531B000108048E00A0203A00FD010806B8603BD70100ED160F15FCF05DF05C",
                    INIT_04 => X"2042D553204C008200FD009400C51910009400C51908009400C5190000940099",
                    INIT_05 => X"1520156F157415201565156D156F1563156C15651557150A150D2042604CD573",
                    INIT_06 => X"15751562156515441528152015211521152115201536154D155315501543154B",
                    INIT_07 => X"B600950116411519D5006078D60496001500152915651564156F154D15201567",
                    INIT_08 => X"175116605000B001B031500095012083100097016089D608960017A75000607E",
                    INIT_09 => X"20993B001A0100781000D5004BA050000078150A0078150D50006090B7009601",
                    INIT_0A => X"07505000007815480078155B0078151B0078154A007815320078155B0078151B",
                    INIT_0B => X"173020C1A0BFD70A370F0078155720BA153020B9A0B7D50A450E450E450E450E",
                    INIT_0C => X"153020D1A0CFD50A450E450E450E450E0750A5901808500000780570175720C2",
                    INIT_0D => X"1000D8FF9801190100780570175720DA173020D9A0D7D70A370F0078155720D2",
                    INIT_0E => X"D602D50156805000A0E5C890180136001501E78000ED190809805000500020C6",
                    INIT_0F => X"4550D50415005000D602363F4550D602D501D70356C05000D602367F97024550",
                    INIT_10 => X"00F5B7161511160000F5B717151016005000D5041500610396011640D5041501",
                    INIT_11 => X"00F5B7121515160000F5B7131514160000F5B7141513160000F5B71515121600",
                    INIT_12 => X"213AD110B23BB13A032402FA034E500000F5B7101517160000F5B71115161600",
                    INIT_13 => X"61BCD21061CFD2202141D120217721BCD308B3262177D308B31B21776133D210",
                    INIT_14 => X"48004900480049004800490061BCD21021AA61BCD2106156D2402148D1402165",
                    INIT_15 => X"F014F013F012F011100031802120B223B1181FFF21F26165D24061AAD2204900",
                    INIT_16 => X"F611F710B007B106B205B304B403B502B601B7001FFF5000F110F017F016F015",
                    INIT_17 => X"B106B205B304B403B5025608B601B7001FFF5000F017F116F215F314F413F512",
                    INIT_18 => X"0A9038803980B808B9001FFF5000F017F116F215F314F413F512F611F710B007",
                    INIT_19 => X"B106B205B304B403B5024680B60147A0B7001800219718082196D98069802A80",
                    INIT_1A => X"B30CB40BB50AB609B7081FFF5000F017F116F215F314F413F512F611F710B007",
                    INIT_1B => X"5608B609B7081FFF5000F017F116F215F314F413F512F611F710B00FB10EB20D",
                    INIT_1C => X"1FFF5000F017F116F215F314F413F512F611F710B00FB10EB20DB30CB40BB50A",
                    INIT_1D => X"61E2D980B609578021DD377F61DCDA80B70869802A800A9038803980B808B900",
                    INIT_1E => X"F116F215F314F413F512F611F710B00FB10EB20DB30CB40BB50A560821E336F7",
                    INIT_1F => X"E3B0E2A0C19002A7029E70016207A206E130C020B225B324B01AB1195000F017",
                    INIT_20 => X"B43AF030F12FFF2EBF18B225B324B01AB11902B0E2077000E7F0E6E0E5D0E4C0",
                    INIT_21 => X"1038A221F100D0382247A1308020330012016219D401B43B310010016214D401",
                    INIT_22 => X"4D084E084F0E223CB1009001480849084A084B084C084D084E084F0E02A71100",
                    INIT_23 => X"FC29FD28FE27FF26622DB1009001F22D12202239D820480849084A084B084C08",
                    INIT_24 => X"03D3F02E10802252D080B0232257D080B018F82D38E04820B22DF92CFA2BFB2A",
                    INIT_25 => X"1000226303ED029EF02E1000225FD080B008226302A703D3F02E1080226303ED",
                    INIT_26 => X"72FF71FF70E02280D74027F026E025D024C023B022A02190008002A7029EF02E",
                    INIT_27 => X"2282F82E188037003600350034003300320031001020777F76FF75FF74FF73FF",
                    INIT_28 => X"4800490048004900480049004806B92FB830040702E3040702E30407F82E1800",
                    INIT_29 => X"B61CB71B5000F910F711F612F513F414F315F216F11749A0BA2E4780370F4900",
                    INIT_2A => X"5000B82DB92CBA2BBB2ABC29BD28BE27BF265000B022B121B220B31FB41EB51D",
                    INIT_2B => X"BA0DBB0CBC0BBD0ABE09BF08B822B007B106B205B304B403B502B601B7007001",
                    INIT_2C => X"FC03FD02FE01FF00F82DF00FB62DB70FF10EF20DF30CF40BF50AF609F708B90E",
                    INIT_2D => X"A2E24807190050007000032402FAF63AF53BB63BB53AF622F707F906FA05FB04",
                    INIT_2E => X"22F21801100022F0D10162EDD02022ED22E9D04022F062E6D080500022DE1901",
                    INIT_2F => X"10802300100062FFD780B7005000370036003500340033003200018018001000",
                    INIT_30 => X"6312D080B03AF61AF7194608470E4608470E4608470E4608470E377FB601F018",
                    INIT_31 => X"F31EF41DF51CB007B106B205B304B403B502F61B4600360FB601100023131010",
                    INIT_32 => X"470E4608470E377FB609F0231080232A10006329D780B7085000F021F120F21F",
                    INIT_33 => X"4600360FB6091000233D1010633CD080B03BF625F7244608470E4608470E4608",
                    INIT_34 => X"B601B7005000F02CF12BF22AF329F428F527B00FB10EB20DB30CB40BB50AF626",
                    INIT_35 => X"F2FFF3FFF4FFF5FFD60FB007B106B205B304B403B502B6016373F77FD6F0377F",
                    INIT_36 => X"B03A2394F03A5040B03A4808490E4808490E4808490E4808490E636FF0FFF1FF",
                    INIT_37 => X"B106B205B304B403B502B6016391F77FD6F036F0377FB601B7002394F03A5080",
                    INIT_38 => X"F03A5020B03A2394F03A5010B03A238DF0FFF1FFF2FFF3FFF4FFF5FFD60FB007",
                    INIT_39 => X"BA0EBB0DBC0CBD0BBE0ABF0963B1F77FD6F0377FB609B708F03A5001B03A2394",
                    INIT_3A => X"F03B5080B03B5000F03B5040B03B63ADF9FFFAFFFBFFFCFFFDFFFEFFDF0FB90F",
                    INIT_3B => X"DF0FB90FBA0EBB0DBC0CBD0BBE0ABF0963CFF77FD6F036F0377FB609B7085000",
                    INIT_3C => X"B03B5000F03B5020B03B5000F03B5010B03B23CBF9FFFAFFFBFFFCFFFDFFFEFF",
                    INIT_3D => X"3300320031001020777F76FF75FF74FF73FF72FF71FF70E0029E5000F03B5001",
                    INIT_3E => X"79FF78E002A75000F022F121F220F31FF41EF51DF61CF71B3700360035003400",
                    INIT_3F => X"FE27FF263F003E003D003C003B003A00390018207F7F7EFF7DFF7CFF7BFF7AFF",
                    INIT_40 => X"4608470E1F00240E1F20240DD020241ED7205000F82DF92CFA2BFB2AFC29FD28",
                    INIT_41 => X"2431D710248D40F0F92FF83039001801B92FB830400841084208430844084508",
                    INIT_42 => X"F83C1801F92FF83039001801B92FB830648DD801B83C248DDF802FE0BE3BBF3A",
                    INIT_43 => X"246BD9FF02DD48074807480748070870377F1A01248DFBFFDA0FBA30BB2F248D",
                    INIT_44 => X"2452D90802DD08501A08246B0A90244BD90802DD08601A04246B0A902444D904",
                    INIT_45 => X"246B0A902460D90802DD08301A08246B0A902459D90802DD08401A08246B0A90",
                    INIT_46 => X"4100400609A02478DAFF0A9002DD08101A08246B0A902467D90802DD08201A08",
                    INIT_47 => X"470E248DF830F92FB90088A0B830B92F646E9901470046004500440043004200",
                    INIT_48 => X"02FA034E5000F830F92F39001801B830B92F4008410842084308440845084608",
                    INIT_49 => X"B247B346B445B544B643B742B841B94005B205000691067924FFDFFF05CB0324",
                    INIT_4A => X"460847084808490E24FEA4AC24FEF100D0353100100170FF71FF24B7D1800F10",
                    INIT_4B => X"430844084508460847084808490E24C3D90264ACB10090014208430844084508",
                    INIT_4C => X"4400430042064900480047004600450044004300420664CDDF80310010014208",
                    INIT_4D => X"4400430042064900480047004600450044004300420649004800470046004500",
                    INIT_4E => X"4900390F4100400641004006410040064100400606A949004800470046004500",
                    INIT_4F => X"500005EE24FFF110F911F812F713F614F515F416F31741F03F806FE0BE23BF18",
                    INIT_50 => X"FC51FD50B021B120B21FB31EB41DB51CB61B1700180019001A001B001C001D00",
                    INIT_51 => X"B527B6261E001F00F05DF15CF25BF35AF459F558F657F756F855F954FA53FB52",
                    INIT_52 => X"400841084208430844084508460E6533D00125B1DF35B02CB12BB22AB329B428",
                    INIT_53 => X"B855B954BA53BB52BC51BD50F02CF12BF22AF329F428F527F62625251F011E01",
                    INIT_54 => X"4500440043004200410040062568DE00B05DB15CB25BB35AB459B558B657B756",
                    INIT_55 => X"F855F954FA53FB52FC51FD50654A9E014D004C004B004A004900480047004600",
                    INIT_56 => X"0070B74DB84CB94BBA4ABB49BC48BD47F05DF15CF25BF35AF459F558F657F756",
                    INIT_57 => X"BB42BC41BD40F04DF14CF24BF34AF449F548F64726D025C024B023A022902180",
                    INIT_58 => X"24B023A0229021802070B056B155B254B353B452B551B650B746B845B944BA43",
                    INIT_59 => X"B02CB12BB22AB329B428B527B626F046F145F244F343F442F541F64026D025C0",
                    INIT_5A => X"1E011F01F02CF12BF22AF329F428F527F626400841084208430844084508460E",
                    INIT_5B => X"DF80BF3BB225B324B10390FE25BCB10390FF65BADF80BF3AB01AB1195000251E",
                    INIT_5C => X"D21025D2D110B23BB13A5000310310FF21300020B30392FE25C6B30392FF65C4",
                    INIT_5D => X"25EE65E3D21065E3D22025E0D140260E61BCD210661FD24025D9D12021776631",
                    INIT_5E => X"B1181FFF50001F0065EED24065FDD22021BCFD082DE0BD081E7F25E865E3D210",
                    INIT_5F => X"B423B3181FFF5000F110F017F016F015F014F013F012F011100031806120B223",
                    INIT_60 => X"B3181FFF5000F017F016F015F014F013F012F111F2101000423011F0127F6340",
                    INIT_61 => X"1FFF5000F017F016F015F014F013F012F111F2101000423011F0127F6340B423",
                    INIT_62 => X"F017F016F015F014F013F012F111F210100011F042B0127F3B806BA0BA23BB18",
                    INIT_63 => X"02DD480748074807480708601A01217721BCDE0821776636DF08BE26BF1B5000",
                    INIT_64 => X"02DD08401A08266D0A90264DD90802DD08501A04266D0A902646D904266DD9FF",
                    INIT_65 => X"2662D90802DD08201A08266D0A90265BD90802DD08301A08266D0A902654D908",
                    INIT_66 => X"4100400609A00A9002DD08001A08266D0A902669D90802DD08101A08266D0A90",
                    INIT_67 => X"B21FB31EB41DB51C6690D610B61B5000666E9901470046004500440043004200",
                    INIT_68 => X"FF19FE1ABF008EA0BF19BE1AF021F120F21FF31EF41DF51CF61B0639B021B120",
                    INIT_69 => X"F22AF329F428F527F6260639B02CB12BB22AB329B428B52766A8D610B6265000",
                    INIT_6A => X"D24026B766AFD280522026ACD2105000FF24FE25BF008EA0BF24BE25F02CF12B",
                    INIT_6B => X"069106792757DFFF0758032402FA034E5000130126B7D30166B6D22026B626B2",
                    INIT_6C => X"B047B146B245B344B443B542B641B740F12FF0301C0026C61C01E6C507D7077D",
                    INIT_6D => X"DA343B001A017AFF7BFF26F2DB80BA30BB2F66D29E015020E6D54F0E0F001E06",
                    INIT_6E => X"FA3066E4BB009A014008410842084308440845084608470E2756A6E42756FB00",
                    INIT_6F => X"46004500440043004200410040066710D780280CA6F726F7FB07DAFF2708FB2F",
                    INIT_70 => X"4008410842084308440845084608470E2710FF2FFE30BF009E01BF2FBE304700",
                    INIT_71 => X"4008410842084308440845084608470E4008410842084308440845084608470E",
                    INIT_72 => X"45084608470E6735FB00DA002735DC014008410842084308440845084608470E",
                    INIT_73 => X"4E06BF2FBE303700360035003400330032000802370F40084108420843084408",
                    INIT_74 => X"F315F216F1174FB03B806BA0BA23BB184E704F004E064F004E064F004E064F00",
                    INIT_75 => X"D12021776631D210275FD110B23BB13A500005EE2757FF10FE11F612F513F414",
                    INIT_76 => X"D21025EE65E3D21067F0D240276FD140260E61BCD210681ED220661FD2402768",
                    INIT_77 => X"11001000700150001F00660ED24065EED22021BCFD082DE0BD081E7F27776772",
                    INIT_78 => X"1F00B021B120B21FB31EB41DB51CB61B17007000170016001500140013001200",
                    INIT_79 => X"E5D0E4C0E3B0E2A0E190C08070001F407001B82CB92BBA2ABB29BC28BD27BE26",
                    INIT_7A => X"43004200410040077001A7F0A6E0A5D0A4C0A3B0A2A0A1908080A7B6E7F0E6E0",
                    INIT_7B => X"700047004600450044004300420041004006700127C070004700460045004400",
                    INIT_7C => X"F542F641F7407001679A70009F01700147004600450044004300420041004006",
                    INIT_7D => X"90FE27E1B10390FF67DFDF80BF3AB01AB11950007000F047F146F245F344F443",
                    INIT_7E => X"5000310310FFA1308020B30392FE27EBB30392FF67E9DF80BF3BB225B324B103",
                    INIT_7F => X"F116F215F314F413F512F611F71010001100120013001400150016F8177F1FFF",
                   INITP_00 => X"50B0AAAAAAAAAAAAAAAAAAADDEA8A28A0AAAB20AAAAAAAAAAAAAAAAAA20202AA",
                   INITP_01 => X"2282A280A2D5692AC5866D266D5502866D266D552888888896DA88B50AA2DC0B",
                   INITP_02 => X"00002AAAA00002AAAA000B31555CB332CCCB0C2CC0AA8080808080808080A348",
                   INITP_03 => X"56BF500AAAA80008C08C00002AAAA00000AAAA80000AAAA8000008C0000AAAA8",
                   INITP_04 => X"A15554000315556A2A8C2A8AA30C202AAAD631555755555835D5705C2A002F55",
                   INITP_05 => X"230955508332CB29D2EA82AAAAA0AAA800000003800020000AAAA80155542AA8",
                   INITP_06 => X"000D402828155570000000C00AAA8002008C2955542230AAA8002008C2955542",
                   INITP_07 => X"A55550000AAAAA55550000A8282830000000D40282830000000C008282830000",
                   INITP_08 => X"6A50D555531867619D867619D867619DC9540C028A50C300C8A5055552332AAA",
                   INITP_09 => X"AAAAA8000555595555555555555557155557355555BD54300000AADAAA941555",
                   INITP_0A => X"02AAA5554000AAAAAAAD5555555D0000000AAAA55557340000AAAAAAA0000000",
                   INITP_0B => X"02AAAA0008CCA02CB332CCCB302555970059700A1AAA95550002AAA555400000",
                   INITP_0C => X"00C2D55551867619D867619D867619DC9542CB02AAAA00002AAAA0000AAAA800",
                   INITP_0D => X"55572F5AB55555BD543034D00000A23AADAA9CCB2C32A50AAAA000C2A50AAAA0",
                   INITP_0E => X"0E33280B2CCCB3332CC0AAAAA800155541556155575C5555555555555555A941",
                   INITP_0F => X"AAA8000095565C0165C02EAAABF75555D5557B5555D55575555CC00000003000")
      port map(   ADDRARDADDR => address_a(14 downto 0),
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                    DOUTADOUT => data_out_a(31 downto 0),
                  DOUTPADOUTP => data_out_a(35 downto 32), 
                      DINADIN => data_in_a(31 downto 0),
                    DINPADINP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b(14 downto 0),
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                    DOUTBDOUT => data_out_b(31 downto 0),
                  DOUTPBDOUTP => data_out_b(35 downto 32), 
                      DINBDIN => data_in_b(31 downto 0),
                    DINPBDINP => data_in_b(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0',
                      ADDRENA => '1',
                      ADDRENB => '1',
                    CASDIMUXA => '0',
                    CASDIMUXB => '0',
                      CASDINA => "00000000000000000000000000000000",  
                      CASDINB => "00000000000000000000000000000000",
                     CASDINPA => "0000",
                     CASDINPB => "0000",
                    CASDOMUXA => '0',
                    CASDOMUXB => '0',
                 CASDOMUXEN_A => '1',
                 CASDOMUXEN_B => '1',
                 CASINDBITERR => '0',
                 CASINSBITERR => '0',
                 CASOREGIMUXA => '0',
                 CASOREGIMUXB => '0',
              CASOREGIMUXEN_A => '0',
              CASOREGIMUXEN_B => '0',
                    ECCPIPECE => '0',
                        SLEEP => '0');
      --
    end generate us;
    --
  end generate ram_2k_generate;
  --
  --	
  ram_4k_generate : if (C_RAM_SIZE_KWORDS = 4) generate
    --
    --
    akv7 : if (C_FAMILY = "7S") generate
      --
      address_a <= '1' & address(11 downto 0) & "111";
      instruction <= data_out_a_h(32) & data_out_a_h(7 downto 0) & data_out_a_l(32) & data_out_a_l(7 downto 0);
      data_in_a <= "000000000000000000000000000000000000";
      jtag_dout <= data_out_b_h(32) & data_out_b_h(7 downto 0) & data_out_b_l(32) & data_out_b_l(7 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b_l <= "000" & data_out_b_l(32) & "000000000000000000000000" & data_out_b_l(7 downto 0);
        data_in_b_h <= "000" & data_out_b_h(32) & "000000000000000000000000" & data_out_b_h(7 downto 0);
        address_b <= "1111111111111111";
        we_b <= "00000000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b_h <= "000" & jtag_din(17) & "000000000000000000000000" & jtag_din(16 downto 9);
        data_in_b_l <= "000" & jtag_din(8) & "000000000000000000000000" & jtag_din(7 downto 0);
        address_b <= '1' & jtag_addr(11 downto 0) & "111";
        we_b <= jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      --
      kcpsm6_rom_l: RAMB36E1
      generic map ( READ_WIDTH_A => 9,
                    WRITE_WIDTH_A => 9,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 9,
                    WRITE_WIDTH_B => 9,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    RAM_MODE => "TDP",
                    RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
                    EN_ECC_READ => FALSE,
                    EN_ECC_WRITE => FALSE,
                    RAM_EXTENSION_A => "NONE",
                    RAM_EXTENSION_B => "NONE",
                    SIM_DEVICE => "7SERIES",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"4A494847464544434241403C3B3A2E392D2200E3080800E30000008B04040404",
                    INIT_01 => X"5300088EA03AFD08B83B01ED0FFC5D5C5B5A595857565554535251504E4D4C4B",
                    INIT_02 => X"206F7420656D6F636C65570A0D424C7342534C82FD94C51094C50894C5009499",
                    INIT_03 => X"0001411900780400002965646F4D206775626544282021212120364D5350434B",
                    INIT_04 => X"990001780000A000780A780D0090000151600001310001830001890800A7007E",
                    INIT_05 => X"30C1BF0A0F7857BA30B9B70A0E0E0E0E50007848785B781B784A7832785B781B",
                    INIT_06 => X"00FF0101787057DA30D9D70A0F7857D230D1CF0A0E0E0E0E50900800787057C2",
                    INIT_07 => X"50040000023F50020103C000027F025002018000E59001000180ED08800000C6",
                    INIT_08 => X"F5121500F5131400F5141300F5151200F5161100F51710000004000301400401",
                    INIT_09 => X"BC10CF20412077BC082677081B7733103A103B3A24FA4E00F5101700F5111600",
                    INIT_0A => X"141312110080202318FFF26540AA2000000000000000BC10AABC105640484065",
                    INIT_0B => X"0605040302080100FF0017161514131211100706050403020100FF0010171615",
                    INIT_0C => X"06050403028001A000009708968080809080800800FF00171615141312111007",
                    INIT_0D => X"080908FF0017161514131211100F0E0D0C0B0A0908FF00171615141312111007",
                    INIT_0E => X"E2800980DD7FDC800880809080800800FF0017161514131211100F0E0D0C0B0A",
                    INIT_0F => X"B0A090A79E010706302025241A190017161514131211100F0E0D0C0B0A08E3F7",
                    INIT_10 => X"38210038473020000119013B000114013A302F2E1825241A19B00700F0E0D0C0",
                    INIT_11 => X"292827262D00012D203920080808080808080E3C0001080808080808080EA700",
                    INIT_12 => X"0063ED9E2E005F800863A7D32E8063EDD32E805280235780182DE0202D2C2B2A",
                    INIT_13 => X"822E8000000000000000207FFFFFFFFFFFFFE08040F0E0D0C0B0A09080A79E2E",
                    INIT_14 => X"1C1B001011121314151617A02E800F00000000000000062F3007E307E3072E00",
                    INIT_15 => X"0D0C0B0A090822070605040302010001002D2C2B2A29282726002221201F1E1D",
                    INIT_16 => X"E20700000024FA3A3B3B3A2207060504030201002D0F2D0F0E0D0C0B0A09080E",
                    INIT_17 => X"800000FF800000000000000000800000F20100F001ED20EDE940F0E68000DE01",
                    INIT_18 => X"1E1D1C0706050403021B000F0100131012803A1A19080E080E080E080E7F0118",
                    INIT_19 => X"000F09003D103C803B2524080E080E080E080E7F0923802A002980080021201F",
                    INIT_1A => X"FFFFFFFF0F07060504030201737FF07F0100002C2B2A2928270F0E0D0C0B0A26",
                    INIT_1B => X"060504030201917FF0F07F0100943A803A943A403A080E080E080E080E6FFFFF",
                    INIT_1C => X"0E0D0C0B0A09B17FF07F09083A013A943A203A943A103A8DFFFFFFFFFFFF0F07",
                    INIT_1D => X"0F0F0E0D0C0B0A09CF7FF0F07F0908003B803B003B403BADFFFFFFFFFFFF0F0F",
                    INIT_1E => X"000000207FFFFFFFFFFFFFE09E003B013B003B203B003B103BCBFFFFFFFFFFFF",
                    INIT_1F => X"272600000000000000207FFFFFFFFFFFFFE0A7002221201F1E1D1C1B00000000",
                    INIT_20 => X"31108DF02F3000012F30080808080808080E000E200D201E20002D2C2B2A2928",
                    INIT_21 => X"6BFFDD07070707707F018DFF0F302F8D3C012F3000012F308D013C8D80E03B3A",
                    INIT_22 => X"6B906008DD30086B905908DD40086B905208DD50086B904B08DD60046B904404",
                    INIT_23 => X"0E8D302F00A0302F6E010000000000000006A078FF90DD10086B906708DD2008",
                    INIT_24 => X"4746454443424140B2009179FFFFCB24FA4E00302F0001302F08080808080808",
                    INIT_25 => X"0808080808080EC302AC0001080808080808080EFEACFE00350001FFFFB78010",
                    INIT_26 => X"000006000000000000000600000000000000060000000000000006CD80000108",
                    INIT_27 => X"00EEFF1011121314151617F080E02318000F0006000600060006A90000000000",
                    INIT_28 => X"272600005D5C5B5A5958575655545352515021201F1E1D1C1B00000000000000",
                    INIT_29 => X"5554535251502C2B2A292827262501010808080808080E3301B1352C2B2A2928",
                    INIT_2A => X"5554535251504A01000000000000000000000000000668005D5C5B5A59585756",
                    INIT_2B => X"4241404D4C4B4A494847D0C0B0A09080704D4C4B4A4948475D5C5B5A59585756",
                    INIT_2C => X"2C2B2A2928272646454443424140D0C0B0A09080705655545352515046454443",
                    INIT_2D => X"803B252403FEBC03FFBA803A1A19001E01012C2B2A292827260808080808080E",
                    INIT_2E => X"EEE310E320E0400EBC101F40D920773110D2103B3A0003FF302003FEC603FFC4",
                    INIT_2F => X"2318FF0010171615141312110080202318FF0000EE40FD20BC08E0087FE8E310",
                    INIT_30 => X"FF0017161514131211100030F07F402318FF0017161514131211100030F07F40",
                    INIT_31 => X"DD07070707600177BC08773608261B00171615141312111000F0B07F80A02318",
                    INIT_32 => X"6208DD20086D905B08DD30086D905408DD40086D904D08DD50046D9046046DFF",
                    INIT_33 => X"1F1E1D1C90101B006E010000000000000006A090DD00086D906908DD10086D90",
                    INIT_34 => X"2A29282726392C2B2A292827A8102600191A00A0191A21201F1E1D1C1B392120",
                    INIT_35 => X"917957FF5824FA4E0001B701B620B6B240B7AF8020AC1000242500A024252C2B",
                    INIT_36 => X"340001FFFFF280302FD20120D50E000647464544434241402F3000C601C5D77D",
                    INIT_37 => X"0000000000000610800CF7F707FF082F30E40001080808080808080E56E45600",
                    INIT_38 => X"080808080808080E080808080808080E080808080808080E102F3000012F3000",
                    INIT_39 => X"062F30000000000000020F080808080808080E3500003501080808080808080E",
                    INIT_3A => X"207731105F103B3A00EE571011121314151617B080A023187000060006000600",
                    INIT_3B => X"00000100000E40EE20BC08E0087F777210EEE310F0406F400EBC101E201F4068",
                    INIT_3C => X"D0C0B0A090800040012C2B2A292827260021201F1E1D1C1B0000000000000000",
                    INIT_3D => X"00000000000000000601C000000000000000000701F0E0D0C0B0A09080B6F0E0",
                    INIT_3E => X"FEE103FFDF803A1A1900004746454443424140019A0001010000000000000006",
                    INIT_3F => X"16151413121110000000000000F87FFF0003FF302003FEEB03FFE9803B252403",
                    INIT_40 => X"18FF00171615141312111000F0B07F80A02318FF00010A200A08400B05800017",
                    INIT_41 => X"000000000000000000000000000000000000171615141312111000F87F80A023",
                    INIT_42 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_43 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_44 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_45 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_00 => X"E2C340D8169A9FC69A9F95554652824458FFFFFFFFF941246124000000000440",
                   INITP_01 => X"A094AAAADEC5955532AAACAAA9AE2CAAA995556806F556D7AFFEDA6666666673",
                   INITP_02 => X"4D54080124AD51AB54AA2A955AB7550015554D5020118005540AA95525083A8A",
                   INITP_03 => X"6AAA855AAAA0006AD5CA01AB57511154AB2C42AD52AD4AAA0A2AB172AA828AAC",
                   INITP_04 => X"5ABDEA955555554CAAA5514B55C74CAA996AA0081020408140922A0D4A956895",
                   INITP_05 => X"6806DAF6D68E6AADDB75552A54A952AAAA95555556AAAA555556556A95555555",
                   INITP_06 => X"558B255B4A8655833D5000A95150A951506AA0204081020501AA024D808AC045",
                   INITP_07 => X"AAAB55BB6E8AAAAA552AA556A92AAAAA897B6B41CD72BD55552ABA55555555D5",
                   INITP_08 => X"00000000000000000000000000000000000000000000000000000096C049B400",
                   INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
      port map(   ADDRARDADDR => address_a,
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                        DOADO => data_out_a_l(31 downto 0),
                      DOPADOP => data_out_a_l(35 downto 32), 
                        DIADI => data_in_a(31 downto 0),
                      DIPADIP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b,
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                        DOBDO => data_out_b_l(31 downto 0),
                      DOPBDOP => data_out_b_l(35 downto 32), 
                        DIBDI => data_in_b_l(31 downto 0),
                      DIPBDIP => data_in_b_l(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                   CASCADEINA => '0',
                   CASCADEINB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0');
      --
      kcpsm6_rom_h: RAMB36E1
      generic map ( READ_WIDTH_A => 9,
                    WRITE_WIDTH_A => 9,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 9,
                    WRITE_WIDTH_B => 9,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    RAM_MODE => "TDP",
                    RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
                    EN_ECC_READ => FALSE,
                    EN_ECC_WRITE => FALSE,
                    RAM_EXTENSION_A => "NONE",
                    RAM_EXTENSION_B => "NONE",
                    SIM_DEVICE => "7SERIES",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"78787878787878787878787878787878787808000C0A0B000C0A0B0010101010",
                    INIT_01 => X"0D0D00020010000003B06B000B0A787878787878787878787878787878787878",
                    INIT_02 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A10B0EA90EA90000000000C00000C00000C0000",
                    INIT_03 => X"DBCA0B0A6AB06B4B0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_04 => X"109D8D0088EA2528000A000A28B0DBCB0B0B285858284A1088CBB06B4B0B28B0",
                    INIT_05 => X"8B10D0EB1B008A108A10D0EAA2A2A2A20328000A000A000A000A000A000A000A",
                    INIT_06 => X"886CCC8C00028B108B10D0EB1B008A108A10D0EAA2A2A2A203520C2800028B10",
                    INIT_07 => X"226A0A286B1B226B6A6B2B286B1B4B226B6A2B28D0E48C9B8A73008C04282810",
                    INIT_08 => X"005B0A0B005B0A0B005B0A0B005B0A0B005B0A0B005B0A0B286A0AB0CB0B6A0A",
                    INIT_09 => X"B069B06990681090695990695910B0699068595801010128005B0A0B005B0A0B",
                    INIT_0A => X"7878787808181059580F10B069B069A4A4A4A4A4A4A4B06910B069B069906810",
                    INIT_0B => X"5859595A5A2B5B5B0F28787879797A7A7B7B585859595A5A5B5B0F2878787878",
                    INIT_0C => X"5859595A5A235B235B0C100C906C3415051C1C5C5C0F28787879797A7A7B7B58",
                    INIT_0D => X"2B5B5B0F28787879797A7A7B7B585859595A5A5B5B0F28787879797A7A7B7B58",
                    INIT_0E => X"B06C5B2B101BB06D5B3415051C1C5C5C0F28787879797A7A7B7B585859595A5A",
                    INIT_0F => X"F1F1E00101B8B1D1F0E05959585828787879797A7A7B7B585859595A5A2B101B",
                    INIT_10 => X"08D1F8E891D0C09989B16A5A9888B16A5A78787F5F5959585801F1B8F3F3F2F2",
                    INIT_11 => X"7E7E7F7FB1D8C87909916CA4A4A5A5A6A6A7A791D8C8A4A4A5A5A6A6A7A70108",
                    INIT_12 => X"081101017808916858110101780811010178089168589168587C1C24597C7D7D",
                    INIT_13 => X"117C0C9B9B9A9A999998883B3B3A3A39393838916B9393929291919080010178",
                    INIT_14 => X"5B5B287C7B7B7A7A797978245D231BA4A4A4A4A4A4A4A45C5C02010201027C0C",
                    INIT_15 => X"5D5D5E5E5F5F5C585859595A5A5B5BB8285C5C5D5D5E5E5F5F28585859595A5A",
                    INIT_16 => X"D1A40C28B801017B7A5B5A7B7B7C7D7D7E7E7F7F7C785B5B7879797A7A7B7B5C",
                    INIT_17 => X"081108B16B5B289B9B9A9A9999800C08110C089168B16811916811B16828118C",
                    INIT_18 => X"797A7A585859595A5A7B231B5B081108B168587B7BA3A3A3A3A3A3A3A31B5B78",
                    INIT_19 => X"231B5B081108B168587B7BA3A3A3A3A3A3A3A31B5B78081108B16B5B28787879",
                    INIT_1A => X"79797A7A6B585859595A5A5BB17B6B1B5B5B28787879797A7A585859595A5A7B",
                    INIT_1B => X"5859595A5A5BB1FBEB1B1B5B5B1178285811782858A4A4A4A4A4A4A4A4B17878",
                    INIT_1C => X"5D5D5E5E5F5FB17B6B1B5B5B782858117828581178285891787879797A7A6B58",
                    INIT_1D => X"6F5C5D5D5E5E5F5FB1FBEB1B1B5B5B2878285828782858B17C7D7D7E7E7F6F5C",
                    INIT_1E => X"999998883B3B3A3A3939383801287828582878285828782858917C7D7D7E7E7F",
                    INIT_1F => X"7F7F9F9F9E9E9D9D9C8C3F3F3E3E3D3D3C3C0128787879797A7A7B7B9B9B9A9A",
                    INIT_20 => X"926B12207C7C9C8C5C5CA0A0A1A1A2A2A3A30F120F9268926B287C7C7D7D7E7E",
                    INIT_21 => X"926C01A4A4A4A4041B0D927D6D5D5D127C0C7C7C9C8C5C5CB26C5C926F175F5F",
                    INIT_22 => X"128592EC01048D128592EC01048D128592EC01048D128592EC01048D128592EC",
                    INIT_23 => X"A3127C7CDCC45C5CB2CCA3A3A2A2A1A1A0A004926D8501048D128592EC01048D",
                    INIT_24 => X"59595A5A5B5B5C5C0202030392EF02010101287C7C9C8C5C5CA0A0A1A1A2A2A3",
                    INIT_25 => X"A1A2A2A3A3A4A4926CB2D8C8A1A1A2A2A3A3A4A412D292F8E898883838926807",
                    INIT_26 => X"A2A1A1A4A4A3A3A2A2A1A1A4A4A3A3A2A2A1A1A4A4A3A3A2A2A1A1B26F9888A1",
                    INIT_27 => X"280212787C7C7B7B7A7A79201F375F5F241CA0A0A0A0A0A0A0A003A4A4A3A3A2",
                    INIT_28 => X"5A5B0F0F787879797A7A7B7B7C7C7D7D7E7E585859595A5A5B0B0C0C0D0D0E0E",
                    INIT_29 => X"5C5C5D5D5E5E787879797A7A7B128F8FA0A0A1A1A2A2A3B26892EF585859595A",
                    INIT_2A => X"7C7C7D7D7E7EB2CFA6A6A5A5A4A4A3A3A2A2A1A1A0A092EF585859595A5A5B5B",
                    INIT_2B => X"5D5E5E787879797A7A7B939292919190805B5C5C5D5D5E5E787879797A7A7B7B",
                    INIT_2C => X"585859595A5A5B787879797A7A7B93929291919090585859595A5A5B5B5C5C5D",
                    INIT_2D => X"6F5F5959D8C812D8C8B26F5F585828120F8F787879797A7A7BA0A0A1A1A2A2A3",
                    INIT_2E => X"12B269B269926813B069B369926810B369926859582898889080D9C912D9C9B2",
                    INIT_2F => X"5A590F28787878787878787808183059580F280FB269B269107E165E0F12B269",
                    INIT_30 => X"0F28787878787878787908210809315A590F2878787878787878790821080931",
                    INIT_31 => X"01A4A4A4A4040D10906F10B36F5F5F287878787878787879080821091D355D5D",
                    INIT_32 => X"93EC01048D138593EC01048D138593EC01048D138593EC01048D138593EC936C",
                    INIT_33 => X"59595A5AB36B5B28B3CCA3A3A2A2A1A1A0A0048501048D138593EC01048D1385",
                    INIT_34 => X"79797A7A7B03585859595A5AB36B5B287F7FDFC75F5F787879797A7A7B035858",
                    INIT_35 => X"030393EF0301010128899369B36913936913B369299369287F7FDFC75F5F7878",
                    INIT_36 => X"ED9D8D3D3D936D5D5DB3CF28F3A7070F585859595A5A5B5B78780E130EF30303",
                    INIT_37 => X"A3A2A2A1A1A0A0B36B14D393FDED137D7DB3DDCDA0A0A1A1A2A2A3A313D393FD",
                    INIT_38 => X"A0A0A1A1A2A2A3A3A0A0A1A1A2A2A3A3A0A0A1A1A2A2A3A3137F7FDFCF5F5FA3",
                    INIT_39 => X"A75F5F9B9B9A9A9999041BA0A0A1A1A2A2A3A3B3FDED936EA0A0A1A1A2A2A3A3",
                    INIT_3A => X"6810B369936859582802137F7F7B7A7A797978271D355D5D27A7A7A7A7A7A7A7",
                    INIT_3B => X"0808B8280FB369B269107E165E0F13B36912B269B369936813B069B469B36993",
                    INIT_3C => X"F2F2F1F1F0E0B80FB85C5C5D5D5E5E5F0F585859595A5A5B0BB80B0B0A0A0909",
                    INIT_3D => X"B8A3A3A2A2A1A1A0A0B813B8A3A3A2A2A1A1A0A0B8D3D3D2D2D1D1D0C0D3F3F3",
                    INIT_3E => X"C813D8C8B36F5F585828B8787879797A7A7B7BB8B3B8CFB8A3A3A2A2A1A1A0A0",
                    INIT_3F => X"7879797A7A7B7B080809090A0A0B0B0F289888D0C0D9C913D9C9B36F5F5959D8",
                    INIT_40 => X"5D0F287878787878787879080821091D355D5D0F2888B46814946814B4682878",
                    INIT_41 => X"00000000000000000000000000000000002878787878787878790808091D355D",
                    INIT_42 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_43 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_44 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_45 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_00 => X"59D8D8678965601965606AAA9BAC3DA30CFFFFFFFFFEBEDB3FD3FFFFFFFFD11F",
                   INITP_01 => X"1F03FE028A007FC00FF803FE002803FE007FC01FF03402D5AB268F88888888D2",
                   INITP_02 => X"520095B69F9FFCFE000180403FE0007EC00010077A7BD247F940100248427070",
                   INITP_03 => X"C0003FF0000E664000819900020999000206600400083F810A60054FE0429801",
                   INITP_04 => X"FFE000200000001001400E0400FBF80070801254A952A54AA021B090AC00157F",
                   INITP_05 => X"1FF02AC6D5AB440902433F8001FC00001FC000FFFE00020003FC01400FFFC000",
                   INITP_06 => X"0173C00E044800D7EFAB65C3FC09C3FC09800952A54A952A81B1FF007FC03FE0",
                   INITP_07 => X"FE008120487FFD00807008040280004035636AD568FFE00000401200000000E0",
                   INITP_08 => X"00000000000000000000000000000000000000000000000000007FC03FE00ADB",
                   INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
      port map(   ADDRARDADDR => address_a,
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                        DOADO => data_out_a_h(31 downto 0),
                      DOPADOP => data_out_a_h(35 downto 32), 
                        DIADI => data_in_a(31 downto 0),
                      DIPADIP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b,
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                        DOBDO => data_out_b_h(31 downto 0),
                      DOPBDOP => data_out_b_h(35 downto 32), 
                        DIBDI => data_in_b_h(31 downto 0),
                      DIPBDIP => data_in_b_h(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                   CASCADEINA => '0',
                   CASCADEINB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0');
      --
    end generate akv7;
    --
    --
    us : if (C_FAMILY = "US") generate
      --
      address_a(14 downto 0) <= address(11 downto 0) & "111";
      instruction <= data_out_a_h(32) & data_out_a_h(7 downto 0) & data_out_a_l(32) & data_out_a_l(7 downto 0);
      data_in_a <= "000000000000000000000000000000000000";
      jtag_dout <= data_out_b_h(32) & data_out_b_h(7 downto 0) & data_out_b_l(32) & data_out_b_l(7 downto 0);
      --
      no_loader : if (C_JTAG_LOADER_ENABLE = 0) generate
        data_in_b_l <= "000" & data_out_b_l(32) & "000000000000000000000000" & data_out_b_l(7 downto 0);
        data_in_b_h <= "000" & data_out_b_h(32) & "000000000000000000000000" & data_out_b_h(7 downto 0);
        address_b(14 downto 0) <= "111111111111111";
        we_b <= "00000000";
        enable_b <= '0';
        rdl <= '0';
        clk_b <= '0';
      end generate no_loader;
      --
      loader : if (C_JTAG_LOADER_ENABLE = 1) generate
        data_in_b_h <= "000" & jtag_din(17) & "000000000000000000000000" & jtag_din(16 downto 9);
        data_in_b_l <= "000" & jtag_din(8) & "000000000000000000000000" & jtag_din(7 downto 0);
        address_b(14 downto 0) <= jtag_addr(11 downto 0) & "111";
        we_b <= jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we & jtag_we;
        enable_b <= jtag_en(0);
        rdl <= rdl_bus(0);
        clk_b <= jtag_clk;
      end generate loader;
      --
      kcpsm6_rom_l: RAMB36E2
      generic map ( READ_WIDTH_A => 9,
                    WRITE_WIDTH_A => 9,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 9,
                    WRITE_WIDTH_B => 9,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    EN_ECC_READ => "FALSE",
                    EN_ECC_WRITE => "FALSE",
                    CASCADE_ORDER_A => "NONE",
                    CASCADE_ORDER_B => "NONE",
                    CLOCK_DOMAINS => "INDEPENDENT",
                    ENADDRENA => "FALSE",
                    ENADDRENB => "FALSE",
                    EN_ECC_PIPE => "FALSE",
                    RDADDRCHANGEA => "FALSE",
                    RDADDRCHANGEB => "FALSE",
                    SLEEP_ASYNC => "FALSE",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"4A494847464544434241403C3B3A2E392D2200E3080800E30000008B04040404",
                    INIT_01 => X"5300088EA03AFD08B83B01ED0FFC5D5C5B5A595857565554535251504E4D4C4B",
                    INIT_02 => X"206F7420656D6F636C65570A0D424C7342534C82FD94C51094C50894C5009499",
                    INIT_03 => X"0001411900780400002965646F4D206775626544282021212120364D5350434B",
                    INIT_04 => X"990001780000A000780A780D0090000151600001310001830001890800A7007E",
                    INIT_05 => X"30C1BF0A0F7857BA30B9B70A0E0E0E0E50007848785B781B784A7832785B781B",
                    INIT_06 => X"00FF0101787057DA30D9D70A0F7857D230D1CF0A0E0E0E0E50900800787057C2",
                    INIT_07 => X"50040000023F50020103C000027F025002018000E59001000180ED08800000C6",
                    INIT_08 => X"F5121500F5131400F5141300F5151200F5161100F51710000004000301400401",
                    INIT_09 => X"BC10CF20412077BC082677081B7733103A103B3A24FA4E00F5101700F5111600",
                    INIT_0A => X"141312110080202318FFF26540AA2000000000000000BC10AABC105640484065",
                    INIT_0B => X"0605040302080100FF0017161514131211100706050403020100FF0010171615",
                    INIT_0C => X"06050403028001A000009708968080809080800800FF00171615141312111007",
                    INIT_0D => X"080908FF0017161514131211100F0E0D0C0B0A0908FF00171615141312111007",
                    INIT_0E => X"E2800980DD7FDC800880809080800800FF0017161514131211100F0E0D0C0B0A",
                    INIT_0F => X"B0A090A79E010706302025241A190017161514131211100F0E0D0C0B0A08E3F7",
                    INIT_10 => X"38210038473020000119013B000114013A302F2E1825241A19B00700F0E0D0C0",
                    INIT_11 => X"292827262D00012D203920080808080808080E3C0001080808080808080EA700",
                    INIT_12 => X"0063ED9E2E005F800863A7D32E8063EDD32E805280235780182DE0202D2C2B2A",
                    INIT_13 => X"822E8000000000000000207FFFFFFFFFFFFFE08040F0E0D0C0B0A09080A79E2E",
                    INIT_14 => X"1C1B001011121314151617A02E800F00000000000000062F3007E307E3072E00",
                    INIT_15 => X"0D0C0B0A090822070605040302010001002D2C2B2A29282726002221201F1E1D",
                    INIT_16 => X"E20700000024FA3A3B3B3A2207060504030201002D0F2D0F0E0D0C0B0A09080E",
                    INIT_17 => X"800000FF800000000000000000800000F20100F001ED20EDE940F0E68000DE01",
                    INIT_18 => X"1E1D1C0706050403021B000F0100131012803A1A19080E080E080E080E7F0118",
                    INIT_19 => X"000F09003D103C803B2524080E080E080E080E7F0923802A002980080021201F",
                    INIT_1A => X"FFFFFFFF0F07060504030201737FF07F0100002C2B2A2928270F0E0D0C0B0A26",
                    INIT_1B => X"060504030201917FF0F07F0100943A803A943A403A080E080E080E080E6FFFFF",
                    INIT_1C => X"0E0D0C0B0A09B17FF07F09083A013A943A203A943A103A8DFFFFFFFFFFFF0F07",
                    INIT_1D => X"0F0F0E0D0C0B0A09CF7FF0F07F0908003B803B003B403BADFFFFFFFFFFFF0F0F",
                    INIT_1E => X"000000207FFFFFFFFFFFFFE09E003B013B003B203B003B103BCBFFFFFFFFFFFF",
                    INIT_1F => X"272600000000000000207FFFFFFFFFFFFFE0A7002221201F1E1D1C1B00000000",
                    INIT_20 => X"31108DF02F3000012F30080808080808080E000E200D201E20002D2C2B2A2928",
                    INIT_21 => X"6BFFDD07070707707F018DFF0F302F8D3C012F3000012F308D013C8D80E03B3A",
                    INIT_22 => X"6B906008DD30086B905908DD40086B905208DD50086B904B08DD60046B904404",
                    INIT_23 => X"0E8D302F00A0302F6E010000000000000006A078FF90DD10086B906708DD2008",
                    INIT_24 => X"4746454443424140B2009179FFFFCB24FA4E00302F0001302F08080808080808",
                    INIT_25 => X"0808080808080EC302AC0001080808080808080EFEACFE00350001FFFFB78010",
                    INIT_26 => X"000006000000000000000600000000000000060000000000000006CD80000108",
                    INIT_27 => X"00EEFF1011121314151617F080E02318000F0006000600060006A90000000000",
                    INIT_28 => X"272600005D5C5B5A5958575655545352515021201F1E1D1C1B00000000000000",
                    INIT_29 => X"5554535251502C2B2A292827262501010808080808080E3301B1352C2B2A2928",
                    INIT_2A => X"5554535251504A01000000000000000000000000000668005D5C5B5A59585756",
                    INIT_2B => X"4241404D4C4B4A494847D0C0B0A09080704D4C4B4A4948475D5C5B5A59585756",
                    INIT_2C => X"2C2B2A2928272646454443424140D0C0B0A09080705655545352515046454443",
                    INIT_2D => X"803B252403FEBC03FFBA803A1A19001E01012C2B2A292827260808080808080E",
                    INIT_2E => X"EEE310E320E0400EBC101F40D920773110D2103B3A0003FF302003FEC603FFC4",
                    INIT_2F => X"2318FF0010171615141312110080202318FF0000EE40FD20BC08E0087FE8E310",
                    INIT_30 => X"FF0017161514131211100030F07F402318FF0017161514131211100030F07F40",
                    INIT_31 => X"DD07070707600177BC08773608261B00171615141312111000F0B07F80A02318",
                    INIT_32 => X"6208DD20086D905B08DD30086D905408DD40086D904D08DD50046D9046046DFF",
                    INIT_33 => X"1F1E1D1C90101B006E010000000000000006A090DD00086D906908DD10086D90",
                    INIT_34 => X"2A29282726392C2B2A292827A8102600191A00A0191A21201F1E1D1C1B392120",
                    INIT_35 => X"917957FF5824FA4E0001B701B620B6B240B7AF8020AC1000242500A024252C2B",
                    INIT_36 => X"340001FFFFF280302FD20120D50E000647464544434241402F3000C601C5D77D",
                    INIT_37 => X"0000000000000610800CF7F707FF082F30E40001080808080808080E56E45600",
                    INIT_38 => X"080808080808080E080808080808080E080808080808080E102F3000012F3000",
                    INIT_39 => X"062F30000000000000020F080808080808080E3500003501080808080808080E",
                    INIT_3A => X"207731105F103B3A00EE571011121314151617B080A023187000060006000600",
                    INIT_3B => X"00000100000E40EE20BC08E0087F777210EEE310F0406F400EBC101E201F4068",
                    INIT_3C => X"D0C0B0A090800040012C2B2A292827260021201F1E1D1C1B0000000000000000",
                    INIT_3D => X"00000000000000000601C000000000000000000701F0E0D0C0B0A09080B6F0E0",
                    INIT_3E => X"FEE103FFDF803A1A1900004746454443424140019A0001010000000000000006",
                    INIT_3F => X"16151413121110000000000000F87FFF0003FF302003FEEB03FFE9803B252403",
                    INIT_40 => X"18FF00171615141312111000F0B07F80A02318FF00010A200A08400B05800017",
                    INIT_41 => X"000000000000000000000000000000000000171615141312111000F87F80A023",
                    INIT_42 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_43 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_44 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_45 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_00 => X"E2C340D8169A9FC69A9F95554652824458FFFFFFFFF941246124000000000440",
                   INITP_01 => X"A094AAAADEC5955532AAACAAA9AE2CAAA995556806F556D7AFFEDA6666666673",
                   INITP_02 => X"4D54080124AD51AB54AA2A955AB7550015554D5020118005540AA95525083A8A",
                   INITP_03 => X"6AAA855AAAA0006AD5CA01AB57511154AB2C42AD52AD4AAA0A2AB172AA828AAC",
                   INITP_04 => X"5ABDEA955555554CAAA5514B55C74CAA996AA0081020408140922A0D4A956895",
                   INITP_05 => X"6806DAF6D68E6AADDB75552A54A952AAAA95555556AAAA555556556A95555555",
                   INITP_06 => X"558B255B4A8655833D5000A95150A951506AA0204081020501AA024D808AC045",
                   INITP_07 => X"AAAB55BB6E8AAAAA552AA556A92AAAAA897B6B41CD72BD55552ABA55555555D5",
                   INITP_08 => X"00000000000000000000000000000000000000000000000000000096C049B400",
                   INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
      port map(   ADDRARDADDR => address_a(14 downto 0),
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                    DOUTADOUT => data_out_a_l(31 downto 0),
                  DOUTPADOUTP => data_out_a_l(35 downto 32), 
                      DINADIN => data_in_a(31 downto 0),
                    DINPADINP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b(14 downto 0),
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                    DOUTBDOUT => data_out_b_l(31 downto 0),
                  DOUTPBDOUTP => data_out_b_l(35 downto 32), 
                      DINBDIN => data_in_b_l(31 downto 0),
                    DINPBDINP => data_in_b_l(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0',
                      ADDRENA => '1',
                      ADDRENB => '1',
                    CASDIMUXA => '0',
                    CASDIMUXB => '0',
                      CASDINA => "00000000000000000000000000000000",  
                      CASDINB => "00000000000000000000000000000000",
                     CASDINPA => "0000",
                     CASDINPB => "0000",
                    CASDOMUXA => '0',
                    CASDOMUXB => '0',
                 CASDOMUXEN_A => '1',
                 CASDOMUXEN_B => '1',
                 CASINDBITERR => '0',
                 CASINSBITERR => '0',
                 CASOREGIMUXA => '0',
                 CASOREGIMUXB => '0',
              CASOREGIMUXEN_A => '0',
              CASOREGIMUXEN_B => '0',
                    ECCPIPECE => '0',
                        SLEEP => '0');
      --
      kcpsm6_rom_h: RAMB36E2
      generic map ( READ_WIDTH_A => 9,
                    WRITE_WIDTH_A => 9,
                    DOA_REG => 0,
                    INIT_A => X"000000000",
                    RSTREG_PRIORITY_A => "REGCE",
                    SRVAL_A => X"000000000",
                    WRITE_MODE_A => "WRITE_FIRST",
                    READ_WIDTH_B => 9,
                    WRITE_WIDTH_B => 9,
                    DOB_REG => 0,
                    INIT_B => X"000000000",
                    RSTREG_PRIORITY_B => "REGCE",
                    SRVAL_B => X"000000000",
                    WRITE_MODE_B => "WRITE_FIRST",
                    INIT_FILE => "NONE",
                    SIM_COLLISION_CHECK => "ALL",
                    EN_ECC_READ => "FALSE",
                    EN_ECC_WRITE => "FALSE",
                    CASCADE_ORDER_A => "NONE",
                    CASCADE_ORDER_B => "NONE",
                    CLOCK_DOMAINS => "INDEPENDENT",
                    ENADDRENA => "FALSE",
                    ENADDRENB => "FALSE",
                    EN_ECC_PIPE => "FALSE",
                    RDADDRCHANGEA => "FALSE",
                    RDADDRCHANGEB => "FALSE",
                    SLEEP_ASYNC => "FALSE",
                    IS_CLKARDCLK_INVERTED => '0',
                    IS_CLKBWRCLK_INVERTED => '0',
                    IS_ENARDEN_INVERTED => '0',
                    IS_ENBWREN_INVERTED => '0',
                    IS_RSTRAMARSTRAM_INVERTED => '0',
                    IS_RSTRAMB_INVERTED => '0',
                    IS_RSTREGARSTREG_INVERTED => '0',
                    IS_RSTREGB_INVERTED => '0',
                    INIT_00 => X"78787878787878787878787878787878787808000C0A0B000C0A0B0010101010",
                    INIT_01 => X"0D0D00020010000003B06B000B0A787878787878787878787878787878787878",
                    INIT_02 => X"0A0A0A0A0A0A0A0A0A0A0A0A0A10B0EA90EA90000000000C00000C00000C0000",
                    INIT_03 => X"DBCA0B0A6AB06B4B0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A",
                    INIT_04 => X"109D8D0088EA2528000A000A28B0DBCB0B0B285858284A1088CBB06B4B0B28B0",
                    INIT_05 => X"8B10D0EB1B008A108A10D0EAA2A2A2A20328000A000A000A000A000A000A000A",
                    INIT_06 => X"886CCC8C00028B108B10D0EB1B008A108A10D0EAA2A2A2A203520C2800028B10",
                    INIT_07 => X"226A0A286B1B226B6A6B2B286B1B4B226B6A2B28D0E48C9B8A73008C04282810",
                    INIT_08 => X"005B0A0B005B0A0B005B0A0B005B0A0B005B0A0B005B0A0B286A0AB0CB0B6A0A",
                    INIT_09 => X"B069B06990681090695990695910B0699068595801010128005B0A0B005B0A0B",
                    INIT_0A => X"7878787808181059580F10B069B069A4A4A4A4A4A4A4B06910B069B069906810",
                    INIT_0B => X"5859595A5A2B5B5B0F28787879797A7A7B7B585859595A5A5B5B0F2878787878",
                    INIT_0C => X"5859595A5A235B235B0C100C906C3415051C1C5C5C0F28787879797A7A7B7B58",
                    INIT_0D => X"2B5B5B0F28787879797A7A7B7B585859595A5A5B5B0F28787879797A7A7B7B58",
                    INIT_0E => X"B06C5B2B101BB06D5B3415051C1C5C5C0F28787879797A7A7B7B585859595A5A",
                    INIT_0F => X"F1F1E00101B8B1D1F0E05959585828787879797A7A7B7B585859595A5A2B101B",
                    INIT_10 => X"08D1F8E891D0C09989B16A5A9888B16A5A78787F5F5959585801F1B8F3F3F2F2",
                    INIT_11 => X"7E7E7F7FB1D8C87909916CA4A4A5A5A6A6A7A791D8C8A4A4A5A5A6A6A7A70108",
                    INIT_12 => X"081101017808916858110101780811010178089168589168587C1C24597C7D7D",
                    INIT_13 => X"117C0C9B9B9A9A999998883B3B3A3A39393838916B9393929291919080010178",
                    INIT_14 => X"5B5B287C7B7B7A7A797978245D231BA4A4A4A4A4A4A4A45C5C02010201027C0C",
                    INIT_15 => X"5D5D5E5E5F5F5C585859595A5A5B5BB8285C5C5D5D5E5E5F5F28585859595A5A",
                    INIT_16 => X"D1A40C28B801017B7A5B5A7B7B7C7D7D7E7E7F7F7C785B5B7879797A7A7B7B5C",
                    INIT_17 => X"081108B16B5B289B9B9A9A9999800C08110C089168B16811916811B16828118C",
                    INIT_18 => X"797A7A585859595A5A7B231B5B081108B168587B7BA3A3A3A3A3A3A3A31B5B78",
                    INIT_19 => X"231B5B081108B168587B7BA3A3A3A3A3A3A3A31B5B78081108B16B5B28787879",
                    INIT_1A => X"79797A7A6B585859595A5A5BB17B6B1B5B5B28787879797A7A585859595A5A7B",
                    INIT_1B => X"5859595A5A5BB1FBEB1B1B5B5B1178285811782858A4A4A4A4A4A4A4A4B17878",
                    INIT_1C => X"5D5D5E5E5F5FB17B6B1B5B5B782858117828581178285891787879797A7A6B58",
                    INIT_1D => X"6F5C5D5D5E5E5F5FB1FBEB1B1B5B5B2878285828782858B17C7D7D7E7E7F6F5C",
                    INIT_1E => X"999998883B3B3A3A3939383801287828582878285828782858917C7D7D7E7E7F",
                    INIT_1F => X"7F7F9F9F9E9E9D9D9C8C3F3F3E3E3D3D3C3C0128787879797A7A7B7B9B9B9A9A",
                    INIT_20 => X"926B12207C7C9C8C5C5CA0A0A1A1A2A2A3A30F120F9268926B287C7C7D7D7E7E",
                    INIT_21 => X"926C01A4A4A4A4041B0D927D6D5D5D127C0C7C7C9C8C5C5CB26C5C926F175F5F",
                    INIT_22 => X"128592EC01048D128592EC01048D128592EC01048D128592EC01048D128592EC",
                    INIT_23 => X"A3127C7CDCC45C5CB2CCA3A3A2A2A1A1A0A004926D8501048D128592EC01048D",
                    INIT_24 => X"59595A5A5B5B5C5C0202030392EF02010101287C7C9C8C5C5CA0A0A1A1A2A2A3",
                    INIT_25 => X"A1A2A2A3A3A4A4926CB2D8C8A1A1A2A2A3A3A4A412D292F8E898883838926807",
                    INIT_26 => X"A2A1A1A4A4A3A3A2A2A1A1A4A4A3A3A2A2A1A1A4A4A3A3A2A2A1A1B26F9888A1",
                    INIT_27 => X"280212787C7C7B7B7A7A79201F375F5F241CA0A0A0A0A0A0A0A003A4A4A3A3A2",
                    INIT_28 => X"5A5B0F0F787879797A7A7B7B7C7C7D7D7E7E585859595A5A5B0B0C0C0D0D0E0E",
                    INIT_29 => X"5C5C5D5D5E5E787879797A7A7B128F8FA0A0A1A1A2A2A3B26892EF585859595A",
                    INIT_2A => X"7C7C7D7D7E7EB2CFA6A6A5A5A4A4A3A3A2A2A1A1A0A092EF585859595A5A5B5B",
                    INIT_2B => X"5D5E5E787879797A7A7B939292919190805B5C5C5D5D5E5E787879797A7A7B7B",
                    INIT_2C => X"585859595A5A5B787879797A7A7B93929291919090585859595A5A5B5B5C5C5D",
                    INIT_2D => X"6F5F5959D8C812D8C8B26F5F585828120F8F787879797A7A7BA0A0A1A1A2A2A3",
                    INIT_2E => X"12B269B269926813B069B369926810B369926859582898889080D9C912D9C9B2",
                    INIT_2F => X"5A590F28787878787878787808183059580F280FB269B269107E165E0F12B269",
                    INIT_30 => X"0F28787878787878787908210809315A590F2878787878787878790821080931",
                    INIT_31 => X"01A4A4A4A4040D10906F10B36F5F5F287878787878787879080821091D355D5D",
                    INIT_32 => X"93EC01048D138593EC01048D138593EC01048D138593EC01048D138593EC936C",
                    INIT_33 => X"59595A5AB36B5B28B3CCA3A3A2A2A1A1A0A0048501048D138593EC01048D1385",
                    INIT_34 => X"79797A7A7B03585859595A5AB36B5B287F7FDFC75F5F787879797A7A7B035858",
                    INIT_35 => X"030393EF0301010128899369B36913936913B369299369287F7FDFC75F5F7878",
                    INIT_36 => X"ED9D8D3D3D936D5D5DB3CF28F3A7070F585859595A5A5B5B78780E130EF30303",
                    INIT_37 => X"A3A2A2A1A1A0A0B36B14D393FDED137D7DB3DDCDA0A0A1A1A2A2A3A313D393FD",
                    INIT_38 => X"A0A0A1A1A2A2A3A3A0A0A1A1A2A2A3A3A0A0A1A1A2A2A3A3137F7FDFCF5F5FA3",
                    INIT_39 => X"A75F5F9B9B9A9A9999041BA0A0A1A1A2A2A3A3B3FDED936EA0A0A1A1A2A2A3A3",
                    INIT_3A => X"6810B369936859582802137F7F7B7A7A797978271D355D5D27A7A7A7A7A7A7A7",
                    INIT_3B => X"0808B8280FB369B269107E165E0F13B36912B269B369936813B069B469B36993",
                    INIT_3C => X"F2F2F1F1F0E0B80FB85C5C5D5D5E5E5F0F585859595A5A5B0BB80B0B0A0A0909",
                    INIT_3D => X"B8A3A3A2A2A1A1A0A0B813B8A3A3A2A2A1A1A0A0B8D3D3D2D2D1D1D0C0D3F3F3",
                    INIT_3E => X"C813D8C8B36F5F585828B8787879797A7A7B7BB8B3B8CFB8A3A3A2A2A1A1A0A0",
                    INIT_3F => X"7879797A7A7B7B080809090A0A0B0B0F289888D0C0D9C913D9C9B36F5F5959D8",
                    INIT_40 => X"5D0F287878787878787879080821091D355D5D0F2888B46814946814B4682878",
                    INIT_41 => X"00000000000000000000000000000000002878787878787878790808091D355D",
                    INIT_42 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_43 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_44 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_45 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_46 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_47 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_48 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_49 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_4F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_50 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_51 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_52 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_53 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_54 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_55 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_56 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_57 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_58 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_59 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_5F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_60 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_61 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_62 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_63 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_64 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_65 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_66 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_67 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_68 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_69 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_6F => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_70 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_71 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_72 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_73 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_74 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_75 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_76 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_77 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_78 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_79 => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7A => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7B => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7C => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7D => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7E => X"0000000000000000000000000000000000000000000000000000000000000000",
                    INIT_7F => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_00 => X"59D8D8678965601965606AAA9BAC3DA30CFFFFFFFFFEBEDB3FD3FFFFFFFFD11F",
                   INITP_01 => X"1F03FE028A007FC00FF803FE002803FE007FC01FF03402D5AB268F88888888D2",
                   INITP_02 => X"520095B69F9FFCFE000180403FE0007EC00010077A7BD247F940100248427070",
                   INITP_03 => X"C0003FF0000E664000819900020999000206600400083F810A60054FE0429801",
                   INITP_04 => X"FFE000200000001001400E0400FBF80070801254A952A54AA021B090AC00157F",
                   INITP_05 => X"1FF02AC6D5AB440902433F8001FC00001FC000FFFE00020003FC01400FFFC000",
                   INITP_06 => X"0173C00E044800D7EFAB65C3FC09C3FC09800952A54A952A81B1FF007FC03FE0",
                   INITP_07 => X"FE008120487FFD00807008040280004035636AD568FFE00000401200000000E0",
                   INITP_08 => X"00000000000000000000000000000000000000000000000000007FC03FE00ADB",
                   INITP_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
                   INITP_0F => X"0000000000000000000000000000000000000000000000000000000000000000")
      port map(   ADDRARDADDR => address_a(14 downto 0),
                      ENARDEN => enable,
                    CLKARDCLK => clk,
                    DOUTADOUT => data_out_a_h(31 downto 0),
                  DOUTPADOUTP => data_out_a_h(35 downto 32), 
                      DINADIN => data_in_a(31 downto 0),
                    DINPADINP => data_in_a(35 downto 32), 
                          WEA => "0000",
                  REGCEAREGCE => '0',
                RSTRAMARSTRAM => '0',
                RSTREGARSTREG => '0',
                  ADDRBWRADDR => address_b(14 downto 0),
                      ENBWREN => enable_b,
                    CLKBWRCLK => clk_b,
                    DOUTBDOUT => data_out_b_h(31 downto 0),
                  DOUTPBDOUTP => data_out_b_h(35 downto 32), 
                      DINBDIN => data_in_b_h(31 downto 0),
                    DINPBDINP => data_in_b_h(35 downto 32), 
                        WEBWE => we_b,
                       REGCEB => '0',
                      RSTRAMB => '0',
                      RSTREGB => '0',
                INJECTDBITERR => '0',
                INJECTSBITERR => '0',
                      ADDRENA => '1',
                      ADDRENB => '1',
                    CASDIMUXA => '0',
                    CASDIMUXB => '0',
                      CASDINA => "00000000000000000000000000000000",  
                      CASDINB => "00000000000000000000000000000000",
                     CASDINPA => "0000",
                     CASDINPB => "0000",
                    CASDOMUXA => '0',
                    CASDOMUXB => '0',
                 CASDOMUXEN_A => '1',
                 CASDOMUXEN_B => '1',
                 CASINDBITERR => '0',
                 CASINSBITERR => '0',
                 CASOREGIMUXA => '0',
                 CASOREGIMUXB => '0',
              CASOREGIMUXEN_A => '0',
              CASOREGIMUXEN_B => '0',
                    ECCPIPECE => '0',
                        SLEEP => '0');
      --
    end generate us;
    --
  end generate ram_4k_generate;	              
  --
  --
  --
  --
  -- JTAG Loader
  --
  instantiate_loader : if (C_JTAG_LOADER_ENABLE = 1) generate
  --
    jtag_loader_6_inst : jtag_loader_6
    generic map(              C_FAMILY => C_FAMILY,
                       C_NUM_PICOBLAZE => 1,
                  C_JTAG_LOADER_ENABLE => C_JTAG_LOADER_ENABLE,
                 C_BRAM_MAX_ADDR_WIDTH => BRAM_ADDRESS_WIDTH,
	                  C_ADDR_WIDTH_0 => BRAM_ADDRESS_WIDTH)
    port map( picoblaze_reset => rdl_bus,
                      jtag_en => jtag_en,
                     jtag_din => jtag_din,
                    jtag_addr => jtag_addr(BRAM_ADDRESS_WIDTH-1 downto 0),
                     jtag_clk => jtag_clk,
                      jtag_we => jtag_we,
                  jtag_dout_0 => jtag_dout,
                  jtag_dout_1 => jtag_dout, -- ports 1-7 are not used
                  jtag_dout_2 => jtag_dout, -- in a 1 device debug 
                  jtag_dout_3 => jtag_dout, -- session.  However, Synplify
                  jtag_dout_4 => jtag_dout, -- etc require all ports to
                  jtag_dout_5 => jtag_dout, -- be connected
                  jtag_dout_6 => jtag_dout,
                  jtag_dout_7 => jtag_dout);
    --  
  end generate instantiate_loader;
  --
end low_level_definition;
--
--
-------------------------------------------------------------------------------------------
--
-- JTAG Loader 
--
-------------------------------------------------------------------------------------------
--
--
-- JTAG Loader 6 - Version 6.00
-- Kris Chaplin 4 February 2010
-- Ken Chapman 15 August 2011 - Revised coding style
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--
library unisim;
use unisim.vcomponents.all;
--
entity jtag_loader_6 is
generic(              C_JTAG_LOADER_ENABLE : integer := 1;
                                  C_FAMILY : string := "7S";
                           C_NUM_PICOBLAZE : integer := 1;
                     C_BRAM_MAX_ADDR_WIDTH : integer := 10;
        C_PICOBLAZE_INSTRUCTION_DATA_WIDTH : integer := 18;
                              C_JTAG_CHAIN : integer := 4;
                            C_ADDR_WIDTH_0 : integer := 10;
                            C_ADDR_WIDTH_1 : integer := 10;
                            C_ADDR_WIDTH_2 : integer := 10;
                            C_ADDR_WIDTH_3 : integer := 10;
                            C_ADDR_WIDTH_4 : integer := 10;
                            C_ADDR_WIDTH_5 : integer := 10;
                            C_ADDR_WIDTH_6 : integer := 10;
                            C_ADDR_WIDTH_7 : integer := 10);
port(   picoblaze_reset : out std_logic_vector(C_NUM_PICOBLAZE-1 downto 0);
                jtag_en : out std_logic_vector(C_NUM_PICOBLAZE-1 downto 0) := (others => '0');
               jtag_din : out std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0) := (others => '0');
              jtag_addr : out std_logic_vector(C_BRAM_MAX_ADDR_WIDTH-1 downto 0) := (others => '0');
               jtag_clk : out std_logic := '0';
                jtag_we : out std_logic := '0';
            jtag_dout_0 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_1 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_2 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_3 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_4 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_5 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_6 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
            jtag_dout_7 : in  std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0));
end jtag_loader_6;
--
architecture Behavioral of jtag_loader_6 is
  --
  signal num_picoblaze       : std_logic_vector(2 downto 0);
  signal picoblaze_instruction_data_width : std_logic_vector(4 downto 0);
  --
  signal drck                : std_logic;
  signal shift_clk           : std_logic;
  signal shift_din           : std_logic;
  signal shift_dout          : std_logic;
  signal shift               : std_logic;
  signal capture             : std_logic;
  --
  signal control_reg_ce      : std_logic;
  signal bram_ce             : std_logic_vector(C_NUM_PICOBLAZE-1 downto 0);
  signal bus_zero            : std_logic_vector(C_NUM_PICOBLAZE-1 downto 0) := (others => '0');
  signal jtag_en_int         : std_logic_vector(C_NUM_PICOBLAZE-1 downto 0);
  signal jtag_en_expanded    : std_logic_vector(7 downto 0) := (others => '0');
  signal jtag_addr_int       : std_logic_vector(C_BRAM_MAX_ADDR_WIDTH-1 downto 0);
  signal jtag_din_int        : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal control_din         : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0):= (others => '0');
  signal control_dout        : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0):= (others => '0');
  signal control_dout_int    : std_logic_vector(7 downto 0):= (others => '0');
  signal bram_dout_int       : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0) := (others => '0');
  signal jtag_we_int         : std_logic;
  signal jtag_clk_int        : std_logic;
  signal bram_ce_valid       : std_logic;
  signal din_load            : std_logic;
  --
  signal jtag_dout_0_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_1_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_2_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_3_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_4_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_5_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_6_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal jtag_dout_7_masked  : std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto 0);
  signal picoblaze_reset_int : std_logic_vector(C_NUM_PICOBLAZE-1 downto 0) := (others => '0');
  --        
begin
  bus_zero <= (others => '0');
  --
  jtag_loader_gen: if (C_JTAG_LOADER_ENABLE = 1) generate
    --
    -- Insert BSCAN primitive for target device architecture.
    --
    BSCAN_7SERIES_gen: if (C_FAMILY="7S") generate
    begin
      BSCAN_BLOCK_inst: BSCANE2
      generic map(    JTAG_CHAIN => C_JTAG_CHAIN,
                    DISABLE_JTAG => "FALSE")
      port map( CAPTURE => capture,
                   DRCK => drck,
                  RESET => open,
                RUNTEST => open,
                    SEL => bram_ce_valid,
                  SHIFT => shift,
                    TCK => open,
                    TDI => shift_din,
                    TMS => open,
                 UPDATE => jtag_clk_int,
                    TDO => shift_dout);
    end generate BSCAN_7SERIES_gen;   
    --
    BSCAN_UltraScale_gen: if (C_FAMILY="US") generate
    begin
      BSCAN_BLOCK_inst: BSCANE2
      generic map(    JTAG_CHAIN => C_JTAG_CHAIN,
                    DISABLE_JTAG => "FALSE")
      port map( CAPTURE => capture,
                   DRCK => drck,
                  RESET => open,
                RUNTEST => open,
                    SEL => bram_ce_valid,
                  SHIFT => shift,
                    TCK => open,
                    TDI => shift_din,
                    TMS => open,
                 UPDATE => jtag_clk_int,
                    TDO => shift_dout);
    end generate BSCAN_UltraScale_gen;   
    --
    --
    -- Insert clock buffer to ensure reliable shift operations.
    --
    upload_clock: BUFG
    port map( I => drck,
              O => shift_clk);
    --        
    --        
    --  Shift Register      
    --        
    --
    control_reg_ce_shift: process (shift_clk)
    begin
      if shift_clk'event and shift_clk = '1' then
        if (shift = '1') then
          control_reg_ce <= shift_din;
        end if;
      end if;
    end process control_reg_ce_shift;
    --        
    bram_ce_shift: process (shift_clk)
    begin
      if shift_clk'event and shift_clk='1' then  
        if (shift = '1') then
          if(C_NUM_PICOBLAZE > 1) then
            for i in 0 to C_NUM_PICOBLAZE-2 loop
              bram_ce(i+1) <= bram_ce(i);
            end loop;
          end if;
          bram_ce(0) <= control_reg_ce;
        end if;
      end if;
    end process bram_ce_shift;
    --        
    bram_we_shift: process (shift_clk)
    begin
      if shift_clk'event and shift_clk='1' then  
        if (shift = '1') then
          jtag_we_int <= bram_ce(C_NUM_PICOBLAZE-1);
        end if;
      end if;
    end process bram_we_shift;
    --        
    bram_a_shift: process (shift_clk)
    begin
      if shift_clk'event and shift_clk='1' then  
        if (shift = '1') then
          for i in 0 to C_BRAM_MAX_ADDR_WIDTH-2 loop
            jtag_addr_int(i+1) <= jtag_addr_int(i);
          end loop;
          jtag_addr_int(0) <= jtag_we_int;
        end if;
      end if;
    end process bram_a_shift;
    --        
    bram_d_shift: process (shift_clk)
    begin
      if shift_clk'event and shift_clk='1' then  
        if (din_load = '1') then
          jtag_din_int <= bram_dout_int;
         elsif (shift = '1') then
          for i in 0 to C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-2 loop
            jtag_din_int(i+1) <= jtag_din_int(i);
          end loop;
          jtag_din_int(0) <= jtag_addr_int(C_BRAM_MAX_ADDR_WIDTH-1);
        end if;
      end if;
    end process bram_d_shift;
    --
    shift_dout <= jtag_din_int(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1);
    --
    --
    din_load_select:process (bram_ce, din_load, capture, bus_zero, control_reg_ce) 
    begin
      if ( bram_ce = bus_zero ) then
        din_load <= capture and control_reg_ce;
       else
        din_load <= capture;
      end if;
    end process din_load_select;
    --
    --
    -- Control Registers 
    --
    num_picoblaze <= conv_std_logic_vector(C_NUM_PICOBLAZE-1,3);
    picoblaze_instruction_data_width <= conv_std_logic_vector(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1,5);
    --	
    control_registers: process(jtag_clk_int) 
    begin
      if (jtag_clk_int'event and jtag_clk_int = '1') then
        if (bram_ce_valid = '1') and (jtag_we_int = '0') and (control_reg_ce = '1') then
          case (jtag_addr_int(3 downto 0)) is 
            when "0000" => -- 0 = version - returns (7 downto 4) illustrating number of PB
                           --               and (3 downto 0) picoblaze instruction data width
                           control_dout_int <= num_picoblaze & picoblaze_instruction_data_width;
            when "0001" => -- 1 = PicoBlaze 0 reset / status
                           if (C_NUM_PICOBLAZE >= 1) then 
                            control_dout_int <= picoblaze_reset_int(0) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_0-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "0010" => -- 2 = PicoBlaze 1 reset / status
                           if (C_NUM_PICOBLAZE >= 2) then 
                             control_dout_int <= picoblaze_reset_int(1) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_1-1,5) );
                            else 
                             control_dout_int <= (others => '0');
                           end if;
            when "0011" => -- 3 = PicoBlaze 2 reset / status
                           if (C_NUM_PICOBLAZE >= 3) then 
                            control_dout_int <= picoblaze_reset_int(2) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_2-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "0100" => -- 4 = PicoBlaze 3 reset / status
                           if (C_NUM_PICOBLAZE >= 4) then 
                            control_dout_int <= picoblaze_reset_int(3) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_3-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "0101" => -- 5 = PicoBlaze 4 reset / status
                           if (C_NUM_PICOBLAZE >= 5) then 
                            control_dout_int <= picoblaze_reset_int(4) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_4-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "0110" => -- 6 = PicoBlaze 5 reset / status
                           if (C_NUM_PICOBLAZE >= 6) then 
                            control_dout_int <= picoblaze_reset_int(5) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_5-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "0111" => -- 7 = PicoBlaze 6 reset / status
                           if (C_NUM_PICOBLAZE >= 7) then 
                            control_dout_int <= picoblaze_reset_int(6) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_6-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "1000" => -- 8 = PicoBlaze 7 reset / status
                           if (C_NUM_PICOBLAZE >= 8) then 
                            control_dout_int <= picoblaze_reset_int(7) & "00" & (conv_std_logic_vector(C_ADDR_WIDTH_7-1,5) );
                           else 
                            control_dout_int <= (others => '0');
                           end if;
            when "1111" => control_dout_int <= conv_std_logic_vector(C_BRAM_MAX_ADDR_WIDTH -1,8);
            when others => control_dout_int <= (others => '1');
          end case;
        else 
          control_dout_int <= (others => '0');
        end if;
      end if;
    end process control_registers;
    -- 
    control_dout(C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-1 downto C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-8) <= control_dout_int;
    --
    pb_reset: process(jtag_clk_int) 
    begin
      if (jtag_clk_int'event and jtag_clk_int = '1') then
        if (bram_ce_valid = '1') and (jtag_we_int = '1') and (control_reg_ce = '1') then
          picoblaze_reset_int(C_NUM_PICOBLAZE-1 downto 0) <= control_din(C_NUM_PICOBLAZE-1 downto 0);
        end if;
      end if;
    end process pb_reset;    
    --
    --
    -- Assignments 
    --
    control_dout (C_PICOBLAZE_INSTRUCTION_DATA_WIDTH-9 downto 0) <= (others => '0') when (C_PICOBLAZE_INSTRUCTION_DATA_WIDTH > 8);
    --
    -- Qualify the blockram CS signal with bscan select output
    jtag_en_int <= bram_ce when bram_ce_valid = '1' else (others => '0');
    --      
    jtag_en_expanded(C_NUM_PICOBLAZE-1 downto 0) <= jtag_en_int;
    jtag_en_expanded(7 downto C_NUM_PICOBLAZE) <= (others => '0') when (C_NUM_PICOBLAZE < 8);
    --        
    bram_dout_int <= control_dout or jtag_dout_0_masked or jtag_dout_1_masked or jtag_dout_2_masked or jtag_dout_3_masked or jtag_dout_4_masked or jtag_dout_5_masked or jtag_dout_6_masked or jtag_dout_7_masked;
    --
    control_din <= jtag_din_int;
    --        
    jtag_dout_0_masked <= jtag_dout_0 when jtag_en_expanded(0) = '1' else (others => '0');
    jtag_dout_1_masked <= jtag_dout_1 when jtag_en_expanded(1) = '1' else (others => '0');
    jtag_dout_2_masked <= jtag_dout_2 when jtag_en_expanded(2) = '1' else (others => '0');
    jtag_dout_3_masked <= jtag_dout_3 when jtag_en_expanded(3) = '1' else (others => '0');
    jtag_dout_4_masked <= jtag_dout_4 when jtag_en_expanded(4) = '1' else (others => '0');
    jtag_dout_5_masked <= jtag_dout_5 when jtag_en_expanded(5) = '1' else (others => '0');
    jtag_dout_6_masked <= jtag_dout_6 when jtag_en_expanded(6) = '1' else (others => '0');
    jtag_dout_7_masked <= jtag_dout_7 when jtag_en_expanded(7) = '1' else (others => '0');
    --
    jtag_en <= jtag_en_int;
    jtag_din <= jtag_din_int;
    jtag_addr <= jtag_addr_int;
    jtag_clk <= jtag_clk_int;
    jtag_we <= jtag_we_int;
    picoblaze_reset <= picoblaze_reset_int;
    --        
  end generate jtag_loader_gen;
--
end Behavioral;
--
--
------------------------------------------------------------------------------------
--
-- END OF FILE pBlaze_prog.vhd
--
------------------------------------------------------------------------------------
