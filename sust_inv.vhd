LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.NUMERIC_STD.ALL;
	 USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
----------------------------------------------------------------------------------------	 
    PACKAGE sust_inv IS
	 
        FUNCTION sboxI(index, dir: std_logic_vector(3 downto 0)) RETURN std_logic_vector;
    
	 END PACKAGE;
----------------------------------------------------------------------------------------
	 
    PACKAGE BODY sust_inv IS

		 FUNCTION sboxI(index, dir: std_logic_vector(3 downto 0)) RETURN std_logic_vector IS
		 VARIABLE d_out:  std_logic_vector(3 downto 0); 
       BEGIN
		  	  			  
				--process (index, dir) 
				--begin 
				if    index="0000" then 

			CASE dir IS
						WHEN "0000"=>d_out:="1011"; --0 -> 11
						WHEN "0001"=>d_out:="0101"; --1 -> 5
						WHEN "0010"=>d_out:="0100"; --2 -> 4
						WHEN "0011"=>d_out:="1111"; --3 -> 15
						WHEN "0100"=>d_out:="1100"; --4 -> 12
						WHEN "0101"=>d_out:="0110"; --5 -> 6
						WHEN "0110"=>d_out:="1001"; --6 -> 9
						WHEN "0111"=>d_out:="0000"; --7 -> 0
						WHEN "1000"=>d_out:="1101"; --8 -> 13
						WHEN "1001"=>d_out:="0011"; --9 -> 3
						WHEN "1010"=>d_out:="1110"; --10 -> 14
						WHEN "1011"=>d_out:="1000"; --11 -> 8
						WHEN "1100"=>d_out:="0001"; --12 -> 1
						WHEN "1101"=>d_out:="1010"; --13 -> 10
						WHEN "1110"=>d_out:="0010"; --14 -> 2
						WHEN "1111"=>d_out:="0111"; --15 -> 7
			 END CASE;
				
				elsif index="0001" then 
				
			 CASE dir IS
						WHEN "0000"=>d_out:= "1001"; --0->9
						WHEN "0001"=>d_out:= "0010"; --1->2
						WHEN "0010"=>d_out:= "1111"; --2->15
						WHEN "0011"=>d_out:= "1000"; --3->8
						WHEN "0100"=>d_out:= "0000"; --4->0
						WHEN "0101"=>d_out:= "1100"; --5->12
						WHEN "0110"=>d_out:= "0011"; --6->3
						WHEN "0111"=>d_out:= "0110"; --7->6
						WHEN "1000"=>d_out:= "0100"; --8->4
						WHEN "1001"=>d_out:= "1101"; --9->13
						WHEN "1010"=>d_out:= "0001"; --10->1
						WHEN "1011"=>d_out:= "1110"; --11->14
						WHEN "1100"=>d_out:= "0111"; --12->7
						WHEN "1101"=>d_out:= "1011"; --13->11
						WHEN "1110"=>d_out:= "1010"; --14->10
						WHEN "1111"=>d_out:= "0101"; --15->5
			 END CASE;

				elsif index="0010" then
				
			 CASE dir IS
						WHEN "0000"=>d_out:= "1100"; --0->12
						WHEN "0001"=>d_out:= "0011"; --1->3
						WHEN "0010"=>d_out:= "0000"; --2->0
						WHEN "0011"=>d_out:= "1010"; --3->10
						WHEN "0100"=>d_out:= "1011"; --4->11
						WHEN "0101"=>d_out:= "0100"; --5->4
						WHEN "0110"=>d_out:= "0101"; --6->5
						WHEN "0111"=>d_out:= "1111"; --7->15
						WHEN "1000"=>d_out:= "1001"; --8->9
						WHEN "1001"=>d_out:= "1110"; --9->14
						WHEN "1010"=>d_out:= "0110"; --10->6
						WHEN "1011"=>d_out:= "1101"; --11->13
						WHEN "1100"=>d_out:= "0010"; --12->2
						WHEN "1101"=>d_out:= "0111"; --13->7
						WHEN "1110"=>d_out:= "1000"; --14->8
						WHEN "1111"=>d_out:= "0001"; --15->1
	       END CASE;
				
				elsif index="0011" then
				
			 CASE dir IS
						WHEN "0000"=>d_out:= "1010"; --0->10
						WHEN "0001"=>d_out:= "0111"; --1->7
						WHEN "0010"=>d_out:= "0110"; --2->6
						WHEN "0011"=>d_out:= "1001"; --3->9
						WHEN "0100"=>d_out:= "0001"; --4->1
						WHEN "0101"=>d_out:= "0010"; --5->2
						WHEN "0110"=>d_out:= "1100"; --6->12
						WHEN "0111"=>d_out:= "0101"; --7->5
						WHEN "1000"=>d_out:= "0011"; --8->3
						WHEN "1001"=>d_out:= "0100"; --9->4
						WHEN "1010"=>d_out:= "1000"; --10->8
						WHEN "1011"=>d_out:= "1111"; --11->15
						WHEN "1100"=>d_out:= "1101"; --12->13
						WHEN "1101"=>d_out:= "1110"; --13->14
						WHEN "1110"=>d_out:= "1011"; --14->11
						WHEN "1111"=>d_out:= "0000"; --15->0
			 END CASE;
				
				end if;

			--	end process;
			  
			  			  
          RETURN d_out;
       END sboxI;
    
	 END PACKAGE BODY;