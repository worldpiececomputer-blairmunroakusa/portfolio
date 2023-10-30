
/*
 * onedimensional_cellularautomata module, input_data.rs
 *
 * This module contains structs and functions related to ingesting operator data about how they want
 * their CA simulation to perform.
 *
 * WORKLOG
 * blairmunroakusa@1159.012822.anch.AK
 * blairmunroakusa@9000.012622.anch.AK
 */

use std::str::FromStr;

// number of possible rules that apply to a cellular automaton's state
pub const POSSIBLE_RULES: usize = 8; // (self and two neighbors)

// this struct contains data we need from the operator about how to set up the simulation
pub struct InputData<'a> {

    pub size: &'a mut u32,      // how many cells do we line up ?
    pub time: &'a mut u32,      // how many times do we apply the rule to the cell lineup ?
    pub rule: &'a mut Vec<char>,// what computational rule do we apply to each cell on each iteration ?
    pub seed: &'a mut f32,      // what is the amount of randomness that determines how may cells start out black ?

}

impl InputData<'_> {

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// this method gets the simulation size from operator
    
    pub fn get_simulation_size(&mut self) -> Result<(), std::io::Error> {

        let mut input;

        // input loop for struct size member
        loop {
            
            // fill input buffer
            input = String::new();
            println!("\nPlease tell me how many 1D automotic cells you want to line up.\n\
                     (Enter a positive number, preferrably between 10 and 10,000.)\n");
            // check if prior entry exists and remind if so
            std::io::stdin().read_line(&mut input)?;

            // trim buffer contents
            input = input.trim().to_string();

            // check input cases ... should prevent most panics
            
            // check for a valid number and make sure it isn't too big
            if input.chars().all(|char| char.is_digit(10)) {
                
                // compare against struct size type to avoid overflow
                let intbuf: u64 = u64::from_str(&input).unwrap();
                if intbuf > (u64::pow(2,32) - 1) {
                    println!("\nThat number is absurdly large. Pick something smaller.");
                    continue // repeat input loop
                }

                break // to store input
            }
            // if not a valid number
            else {
                println!( "\nYou need to actually enter a positive whole number. Try again.");
                continue // repeat input loop
            }
        }

        // store valid size input in struct
        *self.size = u32::from_str(&input).unwrap();

        Ok(())

    }   // end InputData.get_simulation_size

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// this method gets the simulation time from operator
    
    pub fn get_simulation_time(&mut self) -> Result<(), std::io::Error> {

        let mut input;

        // input loop for struct time member
        loop {
            
            // fill input buffer (and print any prior value for convenience)
            input = String::new();
            println!("\nPlease tell me how many timesteps you want the simulation to run.\n\
                     (Enter a positive number, preferrably between 10 and 10,000,\n\
                     ideally the same number you chose for the number of cells to line up.)\n");
            // check if prior entry exists and remind if so
            std::io::stdin().read_line(&mut input)?;

            // trim buffer contents
            input = input.trim().to_string();

            // check input cases ... should prevent most panics
            
            // check for a valid number and make sure it isn't too big
            if input.chars().all(|char| char.is_digit(10)) {
                
                // compare against struct size type to avoid overflow
                let intbuf: u64 = u64::from_str(&input).unwrap();
                if intbuf > (u64::pow(2,16) - 1) {
                    println!("\nThat number is absurdly large. Pick something smaller.");
                    continue // repeat input loop
                }

                break // to store input
            }
            // if not a valid number
            else {
                println!( "\nYou need to actually enter a positive whole number. Try again.");
                continue // repeat input loop
            }
        }
        
        // store valid time input in struct
        *self.time = u32::from_str(&input).unwrap();

        Ok(())

    }   // end InputData.get_simulation_time

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// this method gets the rule type from operator
    
    pub fn get_simulation_rule(&mut self) -> Result<(), std::io::Error> {

        let mut input;

        println!("\nNow it's time to choose a rule.\n\
                 \n\
                 Each cell refers to it's prior state and neighbor states from the previous timestep.\n\
                 Depending on which neighbors are 'black' vs 'white', the cell will choose an outcome of black or white.\n\
                 \n\
                 There are eight possible combinations of prior cell states.\n\
                 You will choose a '1' for 'black' or a '0' for 'white' to be the result for each of these 8 prior states.\n\
                 \n\
                 List the eight '1'/'0' choices in a row,\n\
                 EXAMPLE, to turn 'black' for every possible prior cell state, ENTER 11111111\n\
                 EXAMPLE, to turn 'white' for every possible prior cell state, ENTER 00000000\n\
                 \n\
                 THE EIGHT POSSIBILE CHOICES/STATES ARE:\n\
                 \n\
                 (1)111\t(2)110\t(3)101\t(4)100\t(5)011\t(6)010\t(7)001\t(8)000\n\
                 \n\
                 EXAMPLE,\n\
                 If for state (3) I want the next cell to be 'black',\n\
                 I choose '1' for the third position,\n\
                 this means that every time t_initial happens, then t_final of 'black' follows ...\n\
                 \n\
                 Specifically, choosing '1' for (3) looks like so ...
                                                                     ________________
                        t_initial:                                   |&&&&|    |&&&&|
                        (two black cells sandwiching white cell)---> |&&&&|____|&&&&|
                        t_final:                                          |&&&&|
                        (this cell turns black)-------------------------> |&&&&|\n\
                 \n\
                 SOME INTERESTING RULE COMBINATIONS TO TRY:\n\
                 00010110   (rule 22)\n\
                 00011110   (rule 30)\n\
                 01001001   (rule 73)\n\
                 01101110   (rule 110)\n\
                 ");

        // input loop for struct rule member
        'outer: loop {
            
            // fill input buffer (and print any prior value for convenience)
            input = String::new();
            println!("\nType in a string of eight 1s and 0s to set the rule.\n");
            // check if prior entry exists and remind if so
            if *self.rule != Vec::new() {println!("**** Your last entry was {:?} ****\n", self.rule)}
            std::io::stdin().read_line(&mut input)?;

            // trim buffer contents
            input = input.trim().to_string();

            // make sure the input is the right length
            if input.len() != POSSIBLE_RULES {
                println!("\nYou need to enter a combination of EIGHT 1s and 0s, like 10101010 for example. Try again.");
                continue 'outer // repeat input prompt and checks
            }
            
            // make sure the buffer contains only 1s and 0s
            for char in input.chars() {
                if char != '1' && char != '0' {

                    println!("\nAll the characters you enter need to be the letter '1' or the letter '0'. Try again.");
                    continue 'outer // repeat input prompt and checks
                }
            }
               
            break // to store input
        }
        
        // store valid rule value in struct
        *self.rule = input.chars().collect();

        Ok(())

    }   // end InputData.get_simulation_rule

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// this method gets the simulation seed for initial conditions from operator
    
    pub fn get_simulation_seed(&mut self) -> Result<(), std::io::Error> {

        let mut input;

        // input loop for struct time member
        loop {
            
            // fill input buffer
            input = String::new();
            println!("\nPlease choose a percentage value to determine the number of random initial cells set to 'black'.\n\
                     (Enter a positive number, between 0 and 100, 0 corresponds to a single cell in the middle.\n\
                     For example, '3.5' indicates a 3.5% chance that an additional cell starts in the 'black' state.)\n");
            // check if prior entry exists and remind if so
            if *self.seed != 0.0 { println!("**** Your last entry was {} ****\n", self.seed)}
            std::io::stdin().read_line(&mut input)?;

            // trim buffer contents
            input = input.trim().to_string();

            // check input cases ... should prevent most panics
            
            // check for a valid number and make sure it isn't too big
            if input.chars().all(|char| char.is_digit(10) || char == '.') {
                
                // compare against struct size type to avoid overflow
                let intbuf: f64 = f64::from_str(&input).unwrap();
                if intbuf > 100.0 {
                    println!("\nThat number is too large. Pick something smaller.");
                    continue // repeat input loop
                }

                break // to store input
            }
            // if not a valid number
            else {
                println!( "\nYou need to actually enter a positive whole number. Try again.");
                continue // repeat input loop
            }
        }
        
        // store valid time input in struct
        *self.seed = f32::from_str(&input).unwrap();

        Ok(())

    }   // end InputData.get_simulation_seed

// end of InputData implementations

}
