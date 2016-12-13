LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.NUMERIC_STD.ALL;
	 USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
	 USE WORK.func_inv.ALL;
----------------------------------------------------------------------------------------	 
    PACKAGE WD16_i IS
	 
        FUNCTION WD16i ( y,Kd,Kc,Kb,Ka: std_logic_vector(15 downto 0)) RETURN std_logic_vector;
    
	 END PACKAGE;
----------------------------------------------------------------------------------------
	 
    PACKAGE BODY WD16_i IS
    
		 FUNCTION WD16i ( y,Kd,Kc,Kb,Ka: std_logic_vector(15 downto 0)) RETURN std_logic_vector IS
	
		 VARIABLE yy :  std_logic_vector(15 downto 0); 
		 
         BEGIN
		    
			 yy := fi(fi(fi(fi(y) xor Kd) xor Kc) xor Kb) xor Ka;

			RETURN yy;
				
       END WD16i;
    
	 END PACKAGE BODY;