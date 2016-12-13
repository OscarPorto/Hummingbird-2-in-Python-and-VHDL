LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.NUMERIC_STD.ALL;
	 USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
	 USE WORK.sust_inv.ALL;
----------------------------------------------------------------------------------------	 
    PACKAGE func_inv IS
	 
        FUNCTION fi ( x: std_logic_vector(15 downto 0)) RETURN std_logic_vector;
    
	 END PACKAGE;
----------------------------------------------------------------------------------------
	 
    PACKAGE BODY func_inv IS
    
		 FUNCTION fi ( x: std_logic_vector(15 downto 0)) RETURN std_logic_vector IS
		 
		 VARIABLE Si0,Si1,Si2,Si3     :  std_logic_vector(3  downto 0); 
		 VARIABLE x2,x4,x12,x14,xx    :  std_logic_vector(15 downto 0); 
		 
       BEGIN
		    
		 	 x2  := to_stdlogicvector(to_bitvector(x(15 downto 0)) rol  2 ); -- << 2
			 x4  := to_stdlogicvector(to_bitvector(x(15 downto 0)) rol  4 ); -- << 4
			 x12 := to_stdlogicvector(to_bitvector(x(15 downto 0)) rol  12); -- << 12
			 x14 := to_stdlogicvector(to_bitvector(x(15 downto 0)) rol  14); -- << 14
			 
			  xx := x xor x2 xor x4 xor x12 xor x14;
		 
		  	  Si0:=xx(15 downto 12); 
			  Si1:=xx(11 downto  8); 
			  Si2:=xx(7  downto  4); 
			  Si3:=xx(3  downto  0); 
			  
			 xx  := sboxI("0000",Si0) & sboxI("0001",Si1) & sboxI("0010",Si2) & sboxI("0011",Si3);

			RETURN xx;
				
       END fi;
    
	 END PACKAGE BODY;