LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.NUMERIC_STD.ALL;
	 USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
----------------------------------------------------------------------------------------	 
    PACKAGE sustitucion IS
	 
        FUNCTION sbox(index, dir: std_logic_vector(3 downto 0)) RETURN std_logic_vector;
    
	 END PACKAGE;
----------------------------------------------------------------------------------------
	 
    PACKAGE BODY sustitucion IS

		 FUNCTION sbox(index, dir: std_logic_vector(3 downto 0)) RETURN std_logic_vector IS
		 VARIABLE d_out:  std_logic_vector(3 downto 0); 
       BEGIN
		  	  			  
				--process (index, dir) 
				--begin 
				if    index="0000" then 

			CASE dir IS
				WHEN "0000" => d_out := "0111"; -- 0 -> 7
				WHEN "0001" => d_out := "1100"; -- 1 -> 12
				WHEN "0010" => d_out := "1110"; -- 2 -> 14
				WHEN "0011" => d_out := "1001"; -- 3 -> 9
				WHEN "0100" => d_out := "0010"; -- 4 -> 2
				WHEN "0101" => d_out := "0001"; -- 5 -> 1
				WHEN "0110" => d_out := "0101"; -- 6 -> 5
				WHEN "0111" => d_out := "1111"; -- 7 -> 15
				WHEN "1000" => d_out := "1011"; -- 8 -> 11
				WHEN "1001" => d_out := "0110"; -- 9 -> 6
				WHEN "1010" => d_out := "1101"; --10 -> 13
				WHEN "1011" => d_out := "0000"; --11 -> 0
				WHEN "1100" => d_out := "0100"; --12 -> 4
				WHEN "1101" => d_out := "1000"; --13 -> 8
				WHEN "1110" => d_out := "1010"; --14 -> 10
 				WHEN "1111" => d_out := "0011"; --15 -> 3
			 END CASE;
				
				elsif index="0001" then 
				
			 CASE dir IS
					WHEN "0000"=>d_out:= "0100"; -- 0 ->4
					WHEN "0001"=>d_out:= "1010"; -- 1 ->10
					WHEN "0010"=>d_out:= "0001"; -- 2 ->1
					WHEN "0011"=>d_out:= "0110"; -- 3 ->6
					WHEN "0100"=>d_out:= "1000"; -- 4 ->8
					WHEN "0101"=>d_out:= "1111"; -- 5 ->15
					WHEN "0110"=>d_out:= "0111"; -- 6 ->7
					WHEN "0111"=>d_out:= "1100"; -- 7 ->12
					WHEN "1000"=>d_out:= "0011"; -- 8 ->3
					WHEN "1001"=>d_out:= "0000"; -- 9 ->0
					WHEN "1010"=>d_out:= "1110"; --10 ->14
					WHEN "1011"=>d_out:= "1101"; --11 ->13
					WHEN "1100"=>d_out:= "0101"; --12 ->5
					WHEN "1101"=>d_out:= "1001"; --13 ->9
					WHEN "1110"=>d_out:= "1011"; --14 ->11
					WHEN "1111"=>d_out:= "0010"; --15 ->2
			 END CASE;

				elsif index="0010" then
				
			 CASE dir IS
					WHEN "0000"=>d_out:= "0010"; -- 0 ->2
					WHEN "0001"=>d_out:= "1111"; -- 1 ->15
					WHEN "0010"=>d_out:= "1100"; -- 2 ->12
					WHEN "0011"=>d_out:= "0001"; -- 3 ->1
					WHEN "0100"=>d_out:= "0101"; -- 4 ->5
					WHEN "0101"=>d_out:= "0110"; -- 5 ->6
					WHEN "0110"=>d_out:= "1010"; -- 6 ->10
					WHEN "0111"=>d_out:= "1101"; -- 7 ->13
					WHEN "1000"=>d_out:= "1110"; -- 8 ->14
					WHEN "1001"=>d_out:= "1000"; -- 9 ->8
					WHEN "1010"=>d_out:= "0011"; -- 10->3
					WHEN "1011"=>d_out:= "0100"; -- 11->4
					WHEN "1100"=>d_out:= "0000"; -- 12->0
					WHEN "1101"=>d_out:= "1011"; -- 13->11
					WHEN "1110"=>d_out:= "1001"; -- 14->9
					WHEN "1111"=>d_out:= "0111"; -- 15->7
	       END CASE;
				
				elsif index="0011" then
				
			 CASE dir IS
					WHEN "0000"=>d_out:= "1111"; -- 0->15
					WHEN "0001"=>d_out:= "0100"; -- 1->4
					WHEN "0010"=>d_out:= "0101"; -- 2->5
					WHEN "0011"=>d_out:= "1000"; -- 3->8
					WHEN "0100"=>d_out:= "1001"; -- 4->9
					WHEN "0101"=>d_out:= "0111"; -- 5->7
					WHEN "0110"=>d_out:= "0010"; -- 6->2
					WHEN "0111"=>d_out:= "0001"; -- 7->1
					WHEN "1000"=>d_out:= "1010"; -- 8->10
					WHEN "1001"=>d_out:= "0011"; -- 9->3
					WHEN "1010"=>d_out:= "0000"; --10->0
					WHEN "1011"=>d_out:= "1110"; --11->14
					WHEN "1100"=>d_out:= "0110"; --12->6
					WHEN "1101"=>d_out:= "1100"; --13->12
					WHEN "1110"=>d_out:= "1101"; --14->13
					WHEN "1111"=>d_out:= "1011"; --15->11
			 END CASE;
				
				end if;

			--	end process;
			  
			  			  
          RETURN d_out;
       END sbox;
    
	 END PACKAGE BODY;