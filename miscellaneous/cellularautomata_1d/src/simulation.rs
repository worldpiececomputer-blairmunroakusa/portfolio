
/*
 * onedimensional_cellularautomata module, simulation.rs
 *
 * This module contains structs and functions related to setting up a simulation after the operator
 * has input their initial condition data.
 *
 * WORKLOG
 * blairmunroakusa@1200.012822.anch.AK
 * blairmunroakusa@1001.012722.anch.AK
 *
 * TODO
 * fix bad 100% logic
 *
 */

use rand::seq::SliceRandom;
use rand::thread_rng;

// this struct contains sets up the input into the actual simulation funtions
pub struct Simulation<'a> {

    pub cellvec_t0: &'a mut Vec<u8>,    // this is the initial string of cellular automata
    pub cellvec_full: &'a mut Vec<u8>,  // this is the 2D grid of cellular automata

}

impl Simulation<'_> {

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// this method sets up a fresh simulation given InputData struct

    pub fn initialize(&mut self, size: &mut u32, time: &mut u32, seed: &mut f32) {

        // generate initial row of callular automata

        {   // begin temporary initial black cell count
            let mut black_initcount: f32;
            black_initcount = ((*size as f32) / 100.0 ) * *seed; // this is how many cells we want to start out 'black'
            black_initcount = black_initcount.floor();

            // initialize at () from self
            *self.cellvec_t0 = vec![1; black_initcount as usize];

            {   // begin temporary vec of zeros to append to block of ones
                let mut zeros: Vec<u8> = vec![0; (*size as f32 - black_initcount) as usize];
                self.cellvec_t0.append(&mut zeros); // finish building up cellvec_t0
            }   // end temporary vec of zeros

        }   // end temporary initial black cell count

        // shuffle the initial 'black' cells
        self.cellvec_t0.shuffle(&mut thread_rng());

        // now force the middle cell to be 'black' (for seed = zero case & all others)
        self.cellvec_t0[(*size / 2) as usize] = 1;

        // generate initial grid of timestep cellular automata rows
        
        // start building out the simlulation space in cellvec_full
        *self.cellvec_full = self.cellvec_t0.to_vec();
        
        // new vector of zeros to finish building cellvec_full
        let zeros: Vec<u8> = vec![0; *size as usize];

        // now extend to vector of timesteps of length size X time
        for _ in 0..*time {
            self.cellvec_full
                .extend(zeros.to_vec());
        }

        // cellvec_full is ready, memory properly allocated for simulation
    
    }   // end Simulation.inialize

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// this method runs the basic simulation

    pub fn run(&mut self, size: &mut u32, time: &mut u32, rule: &mut Vec<char>) {

        // iterate through the seeded array of zeros, applying the rule to initial row and following

        for t in 0..*time {             // for all timesteps (rows)
            
            for s in 1..(*size - 1) {   // for each cell in given timestep row

                // check three neighbor cells (n-1, n, n+1) from previous timestep and match for given rule
                match self.cellvec_full[((t * *size + s - 1) as usize)..((t * *size + s + 2) as usize)] {
                    
                    // if  match, set the current cell to 'black' (1) and continue inner loop
                    [1, 1, 1] => {
                        if rule[0] == '1' {self.cellvec_full[((t + 1) * *size +s) as usize] = 1} },
                    [1, 1, 0] => { 
                        if rule[1] == '1' {self.cellvec_full[((t + 1) * *size +s) as usize] = 1} },
                    [1, 0, 1] => {
                        if rule[2] == '1' {self.cellvec_full[((t + 1) * *size +s) as usize] = 1} },
                    [1, 0, 0] => {
                        if rule[3] == '1' {self.cellvec_full[((t + 1) * *size +s) as usize] = 1} },
                    [0, 1, 1] => {
                        if rule[4] == '1' {self.cellvec_full[((t + 1) * *size +s) as usize] = 1} },
                    [0, 1, 0] => { 
                        if rule[5] == '1' {self.cellvec_full[((t + 1) * *size +s) as usize] = 1} },
                    [0, 0, 1] => {
                        if rule[6] == '1' {self.cellvec_full[((t + 1) * *size +s) as usize] = 1} },
                    [0, 0, 0] => {
                        if rule[7] == '1' {self.cellvec_full[((t + 1) * *size +s) as usize] = 1} },
                    _ => panic!("Something's wrong! Abort!")
                }   // if no match, leave current cell 'white' (0)

            }       // carry on to next cell in row
        }           // carry on to next timestep (row) in simulation

        // cellvec_full now contains a complete simulation and is ready for processing and plotting

    }   // end Simulation.run
    
// end of Simulation implementations 

}
