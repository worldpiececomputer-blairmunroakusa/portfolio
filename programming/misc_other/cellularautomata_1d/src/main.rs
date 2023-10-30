
/*
 * One dimensional cellular automata simulator (crude af)
 *
 * 1D cellular automata are simple computing 'elements' that evolve by determining their present
 * state according to their predefined 'rule', by applying the rule to their previous state and
 * the previous states of their local neighboring cells.
 *
 * The customary way to simulate cellular automata behavior is to line a bunch up in a row, 
 * with one neighbor to the left and one to the right. This row iterates through discrete time,
 * updating the states of the individual cells at each timestep. Capturing the history of each
 * cell's state, we are left with a 2D grid, with the top row definiting t_initial, and the bottom
 * row defining t_final for the simulation.
 *
 * The big takehome here is that simple elements following simple rules, when aggregated, can
 * exhibit interesting and complex behavior. To see an example of 2D cellular automata, see
 * Conway's Game of Life.
 *
 * WORKLOG
 * blairmunroakusa@1404.012922.anch.AK
 * blairmunroakusa@1200.012822.anch.AK
 * blairmunroakusa@1001.012722.anch.AK
 *
 * TODO
 * update simulate.run() to incorporate boundary values instead of fixing to 'white'
 * collect more interesting rules to suggest
 * implement multithreading to speed up simulation
 *
 */


mod input_data;
mod simulation;
mod output_data;

fn main() {
   
    // initialize simulation parameters
    let mut inputdata = input_data::InputData {
        size: &mut 0,
        time: &mut 0,
        rule: &mut Vec::new(),
        seed: &mut 0.0,
    };

    // initialize simulation vectors
    let mut simulate = simulation::Simulation {
        cellvec_t0: &mut Vec::new(),
        cellvec_full: &mut Vec::new(),
    };

    // initialize plot parameters and vectors
    let mut outputdata = output_data::OutputData {
        ppcell: &mut 1,
        pixelvector: &mut Vec::new(),
    };

    // get input data
    inputdata.get_simulation_size()
        .expect("FAIL: bad input.");     // operator inputs initial number of cellular automata`

    inputdata.get_simulation_time()
        .expect("FAIL: bad input.");     // operator inputs initial number of timesteps

    inputdata.get_simulation_rule()
        .expect("FAIL: bad input.");     // operator specifies the automata rule as character array

    inputdata.get_simulation_seed()
        .expect("FAIL: bad input.");     // operator specifies how many random initial 'on' automata exist
    
    // begin simulation
    simulate.initialize(
        inputdata.size,
        inputdata.time,
        inputdata.seed);                // setup simulation

    simulate.run(
        inputdata.size,
        inputdata.time,
        inputdata.rule);                // execute simulation
    
    // plot results
    outputdata.get_ppcell()
        .expect("FAIL: bad input.");     // operator inputs number of pixels per cell

    outputdata.compute(
        inputdata.size,
        inputdata.time,
        simulate.cellvec_full);         // compute final output vector

    outputdata.plot(
        inputdata.size,
        inputdata.time)
        .expect("Image write FAIL.");   // write output to image
        
}
