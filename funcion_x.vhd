LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.NUMERIC_STD.ALL;
	 USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
	 USE WORK.sustitucion.ALL;
----------------------------------------------------------------------------------------	 
    PACKAGE funcion_x IS
	 
        FUNCTION f ( x: std_logic_vector(15 downto 0)) RETURN std_logic_vector;
    
	 END PACKAGE;
----------------------------------------------------------------------------------------
	 
    PACKAGE BODY funcion_x IS
    
		 FUNCTION f ( x: std_logic_vector(15 downto 0)) RETURN std_logic_vector IS
		 
		 VARIABLE S0,S1,S2,S3     :  std_logic_vector(3  downto 0); 
		 VARIABLE xx,xx6,xx10     :  std_logic_vector(15 downto 0); 
		 
       BEGIN
		  	  S0:=x(15 downto 12); 
			  S1:=x(11 downto  8); 
			  S2:=x(7  downto  4); 
			  S3:=x(3  downto  0); 
			  
			 xx   := sbox("0000",S0) & sbox("0001",S1) & sbox("0010",S2) & sbox("0011",S3);
			 xx6  := to_stdlogicvector(to_bitvector(xx(15 downto 0)) rol  6); -- << 6
			 xx10 := to_stdlogicvector(to_bitvector(xx(15 downto 0)) rol 10); -- << 10
			  
			RETURN xx xor xx6 xor xx10;
				
       END f;
    
	 END PACKAGE BODY;