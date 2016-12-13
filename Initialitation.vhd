-- Oscar Pablo Porto Solano, 2016. Algoritmo Hummingbird-2 

-- Initialitation of Hummingbird 2 Algorithm Cipher in behavorial mode

Library ieee;
	 use ieee.std_Logic_1164.all;
	 use ieee.std_logic_arith.all;
	 use ieee.std_logic_unsigned.all;
	 use work.funcion_x.all;

entity Initialitation is
  port(  IV    : in  std_logic_vector(63    downto 0); -- Vector de Inicializacion
			R     : out std_logic_vector(127   downto 0)  -- Señal de texto cifrado
);
  end;
---------------------------------------------------------------------------------------------------------  
  
  architecture init_rtl of Initialitation is

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
			process (IV)
			----------------------------------declaración de variables locales--------------------------------------
			variable t0,t1,t2,t3,it           :std_logic_vector(15 downto 0); -- temporales, plaintex temp, cifrado 1 y 2
			variable R0,R1,R2,R3,R4,R5,R6,R7  :std_logic_vector(15 downto 0); -- Registros de estado interno
			--------------------------------------------------------------------------------------------------------
			begin 
			
         --Inicializacion Registros Estado Interno 16 bits----
			R0:=IV(63 downto 48); R1:=IV(47 downto 32); R2:=IV(31 downto 16); R3:=IV(15 downto 0);
			R4:=IV(63 downto 48); R5:=IV(47 downto 32); R6:=IV(31 downto 16); R7:=IV(15 downto 0);
         -----------------------------------------------------	

			
					--////////////////////////  ALGORITMO DE INICIALIZACION DEL ALGORITMO  ///////////////////////////
					
   				--Inicializacion: INICIO------------------------------------------------------------
					for i in 0 to 3 loop
						-------------------------------------
						case i is
							when 0 => it:= x"0000";
							when 1 => it:= x"0001";
							when 2 => it:= x"0002";
							when 3 => it:= x"0003";			 
				      end case;
					   -------------------------------------
					t0:=f(f(f(f((R0+it) xor k0)xor k1)xor k2) xor k3);
					t1:=f(f(f(f((R1+t0) xor k4)xor k5)xor k6) xor k7);
					t2:=f(f(f(f((R2+t1) xor k0)xor k1)xor k2) xor k3);
					t3:=f(f(f(f((R3+t2) xor k4)xor k5)xor k6) xor k7);
					
				   R0:= to_stdlogicvector(to_bitvector(R0(15 downto 0)+t3(15 downto 0)) rol  3); -- <<3 
					R1:= to_stdlogicvector(to_bitvector(R1(15 downto 0)+t0(15 downto 0)) ror  1); -- >>1
					R2:= to_stdlogicvector(to_bitvector(R2(15 downto 0)+t1(15 downto 0)) rol  8); -- <<8
					R3:= to_stdlogicvector(to_bitvector(R3(15 downto 0)+t2(15 downto 0)) rol  1); -- <<1
					R4:= R4 xor R0;
					R5:= R5 xor R1;
					R6:= R6 xor R2;	
					R7:= R7 xor R3;
					
					--Inicializacion: FIN   ------------------------------------------------------------
					end loop;
					
					R(127 downto 112)<=R0;
					R(111 downto  96)<=R1;
					R(95  downto  80)<=R2;
					R(79  downto  64)<=R3;
					R(63  downto  48)<=R4;
					R(47  downto  32)<=R5;
					R(31  downto  16)<=R6;
					R(15  downto   0)<=R7;
							
			end process;
  end architecture;