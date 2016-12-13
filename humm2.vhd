-- Oscar Pablo Porto Solano, 2016. Algoritmo Hummingbird-2-----------------------------------------------

-- Cipher Module in behavioral mode. These can be modified for : n 16-bits words

Library ieee;
	 use ieee.std_Logic_1164.all;
	 use ieee.std_logic_arith.all;
	 use ieee.std_logic_unsigned.all;
	 use work.funcion_x.all;

entity humm2 is
  port(  p     : in  std_logic_vector(127  downto 0);  -- Señal de Texto plano
			c     : out std_logic_vector(127  downto 0)  -- Señal de texto cifrado
);
  end;
---------------------------------------------------------------------------------------------------------  
  
  architecture humm_rtl of humm2 is

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
			process (p)
			----------------------------------declaración de variables locales--------------------------------------
			variable t0,t1,t2,t3,pt,c1,c2,c3,c4,c5,c6,c7     :std_logic_vector(15 downto 0); -- temporales, plaintex temp, cifrado 1 y 2
			variable it,ct                    :std_logic_vector(15 downto 0); -- i to vector 16Bits, cifrado temporal
			variable R0,R1,R2,R3,R4,R5,R6,R7  :std_logic_vector(15 downto 0); -- Registros de estado interno
			--------------------------------------------------------------------------------------------------------
			begin 
			
         --Inicializacion Registros Estado Interno 16 bits----
			-- See entity Initialitation
			
			R0:=x"77F6"; R1:=x"CC41"; R2:=x"3077"; R3:=x"7C6D";
			R4:=x"7B39"; R5:=x"9536"; R6:=x"AFFB"; R7:=x"CCD6";
         -----------------------------------------------------				
								
			--///////////////////////////  CIFRADO TEXTO PLANO  ///////////////////////////////
			for j in 0 to 7 loop
				
				-- Se escoge el texto plano 
				case j is
					when 0 => pt:=p(127 downto 112);  -- Se selecciona el primer texto plano
				   when 1 => pt:=p(111 downto  96); c1:=ct;-- Se selecciona el segundo texto plano 
				   when 2 => pt:=p(95  downto  80); c2:=ct;-- Se selecciona el primer texto plano
				   when 3 => pt:=p(79  downto  64); c3:=ct;-- Se selecciona el segundo texto plano 
				   when 4 => pt:=p(63  downto  48); c4:=ct;-- Se selecciona el primer texto plano
				   when 5 => pt:=p(47  downto  32); c5:=ct;-- Se selecciona el segundo texto plano 
				   when 6 => pt:=p(31  downto  16); c6:=ct;-- Se selecciona el primer texto plano
				   when 7 => pt:=p(15  downto   0); c7:=ct;-- Se selecciona el segundo texto plano 
		      end case;
					
				
					-- Encriptacion : INICIO -----------------------------------------------------------
					t0:=f(f(f(f((R0+pt) xor k0)xor k1) xor k2) xor k3);
					t1:=f(f(f(f((R1+t0) xor k4 xor R4) xor k5  xor R5) xor k6 xor R6)xor k7 xor R7);
					t2:=f(f(f(f((R2+t1) xor k0 xor R4) xor k1  xor R5) xor k2 xor R6)xor k3 xor R7);
					ct:=f(f(f(f((R3+t2) xor k4)xor k5) xor k6) xor k7);
					
				   ct:=ct + R0; -- Se selecciona el primer texto plano
					
	            -- Encriptacion : FIN --------------------------------------------------------------
					
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
								
				  c<=ct & x"0000" & x"0000" & x"0000" & x"0000" & x"0000" & x"0000" & x"0000";	-- Out 1 word 16Bits: In 16  Bits
				  c<=c1 & ct & x"0000" & x"0000" & x"0000" & x"0000" & x"0000" & x"0000"; 			-- Out 2 word 16Bits: In 32  Bits
				  c<=c1 & c2 & ct & x"0000" & x"0000" & x"0000" & x"0000" & x"0000";					-- Out 3 word 16Bits: In 48  Bits
				  c<=c1 & c2 & c3 & ct & x"0000" & x"0000" & x"0000" & x"0000";						-- Out 4 word 16Bits: In 64  Bits
				  c<=c1 & c2 & c3 & c4 & ct & x"0000" & x"0000" & x"0000";								-- Out 5 word 16Bits: In 80  Bits
				  c<=c1 & c2 & c3 & c4 & c5 & ct & x"0000" & x"0000";										-- Out 6 word 16Bits: In 96  Bits
				  c<=c1 & c2 & c3 & c4 & c5 & c6 & ct & x"0000";											-- Out 7 word 16Bits: In 112 Bits
				  c<=c1 & c2 & c3 & c4 & c5 & c6 & c7 & ct;													-- Out 8 word 16Bits: In 128 Bits
			end process;
  end architecture;