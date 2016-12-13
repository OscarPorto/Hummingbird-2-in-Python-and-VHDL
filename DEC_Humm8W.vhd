-- Oscar Pablo Porto Solano, 2016. Algoritmo DESCIFRADO Hummingbird-2-----------------------------------------------
-- Diseñado para desencriptar 8 palabras de 16 bits.

Library ieee;
	 use ieee.std_Logic_1164.all;
	 use ieee.std_logic_arith.all;
	 use ieee.std_logic_unsigned.all;
	 use work.WD16_i.all;

entity DEC_Humm8W is
  port( c      : in  std_logic_vector(127  downto 0); -- Señal de Texto plano
		  p      : out std_logic_vector(127  downto 0)  -- Señal de texto cifrado
);
  end;
---------------------------------------------------------------------------------------------------------  
  
  architecture humm_rtl of DEC_Humm8W is

  ------- SubClaves 16 bits ------		
  Constant k0 : std_logic_vector(15 downto 0) :=x"2301";
  Constant k1 : std_logic_vector(15 downto 0) :=x"6745";
  Constant k2 : std_logic_vector(15 downto 0) :=x"AB89";
  Constant k3 : std_logic_vector(15 downto 0) :=x"EFCD";
  Constant k4 : std_logic_vector(15 downto 0) :=x"DCFE";
  Constant k5 : std_logic_vector(15 downto 0) :=x"98BA";
  Constant k6 : std_logic_vector(15 downto 0) :=x"5476";
  Constant k7 : std_logic_vector(15 downto 0) :=x"1032";
  
  	begin
			process (c)
			----------------------------------declaración de variables locales--------------------------------------
			variable t0,t1,t2,t3,pt,p1,p2,p3,p4,p5,p6,p7,u1,u2,u3  :std_logic_vector(15 downto 0); -- temporales, plaintex temp, cifrado 1 y 2
			variable it,ct                    :std_logic_vector(15 downto 0); -- i to vector 16Bits, cifrado temporal
			variable R0,R1,R2,R3,R4,R5,R6,R7  :std_logic_vector(15 downto 0); -- Registros de estado interno
			--------------------------------------------------------------------------------------------------------
			begin 
			
         --Inicializacion Registros Estado Interno 16 bits----
			R0:=x"77F6"; R1:=x"CC41"; R2:=x"3077"; R3:=x"7C6D";
			R4:=x"7B39"; R5:=x"9536"; R6:=x"AFFB"; R7:=x"CCD6";
         -----------------------------------------------------				
		
	   		--///////////////////////////  CIFRADO TEXTO PLANO  ///////////////////////////////
					
   			for j in 0 to 3 loop
				
				-- Se escoge el texto cifrado 
				case j is
					when 0 => ct:=c(127 downto 112);  -- Se selecciona el primer texto plano
				   when 1 => ct:=c(111 downto  96); p1:=pt;-- Se selecciona el segundo texto plano 
					when 2 => ct:=c(95  downto  80); p2:=pt;-- Se selecciona el primer texto plano
				   when 3 => ct:=c(79  downto  64); p3:=pt;-- Se selecciona el segundo texto plano 
					--when 4 => ct:=c(63  downto  48); p4:=pt;-- Se selecciona el primer texto plano
				   --when 5 => ct:=c(47  downto  32); p5:=pt;-- Se selecciona el segundo texto plano 
					--when 6 => ct:=c(31  downto  16); p6:=pt;-- Se selecciona el primer texto plano
				   --when 7 => ct:=c(15  downto   0); p7:=pt;-- Se selecciona el segundo texto plano 
		      end case;
					
				
					-- Descifrado : INICIO -----------------------------------------------------------
						  u3  := WD16i((ct - R0), k7, k6, k5, k4);
						  u2  := WD16i((u3 - R3), k3 xor R7, k2 xor R6, k1 xor R5, k0 xor R4); 
						  u1  := WD16i((u2 - R2), k7 xor R7, k6 xor R6, k5 xor R5, k4 xor R4);
						  pt  := WD16i((u1 - R1), k3, k2, k1, k0);
						  
						  pt  := pt - R0;
					
	            -- Descifrado : FIN --------------------------------------------------------------
					
				   t2 := u3 - R3;
					t1 := u2 - R2;
				   t0 := u1 - R1;					
										
					R4 := R4 xor ( R0 + t2);
					R5 := R5 xor ( R1 + t0);
					R6 := R6 xor ( R2 + t1);
					R7 := R7 xor (((R3 + R0) + t2) + t0);

					R3 := ((R3 + R0) + t2) + t0;
					R0 := R0+t2;
					R1 := R1+t0;
					R2 := R2+t1;
              --/////////////////////////////////////////////////////////////////////////////////////////
				  					
				end loop; 
				
				  --p<=pt & x"0000" & x"0000" & x"0000" & x"0000" & x"0000" & x"0000" & x"0000";	-- Out 1 word 16Bits: In 16  Bits
				  --p<=p1 & pt & x"0000" & x"0000" & x"0000" & x"0000" & x"0000" & x"0000"; 			-- Out 2 word 16Bits: In 32  Bits
				  --p<=p1 & p2 & pt & x"0000" & x"0000" & x"0000" & x"0000" & x"0000";					-- Out 3 word 16Bits: In 48  Bits
				  p<=p1 & p2 & p3 & pt & x"0000" & x"0000" & x"0000" & x"0000";						-- Out 4 word 16Bits: In 64  Bits
				  --p<=p1 & p2 & p3 & p4 & pt & x"0000" & x"0000" & x"0000";								-- Out 5 word 16Bits: In 80  Bits
				  --p<=p1 & p2 & p3 & p4 & p5 & pt & x"0000" & x"0000";										-- Out 6 word 16Bits: In 96  Bits
				  --p<=p1 & p2 & p3 & p4 & p5 & p6 & pt & x"0000";											-- Out 7 word 16Bits: In 112 Bits
				  --p<=p1 & p2 & p3 & p4 & p5 & p6 & p7 & pt;													-- Out 8 word 16Bits: In 128 Bits

			end process;
  end architecture;