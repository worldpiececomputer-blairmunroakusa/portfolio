
/*
 * onedimensional_cellularautomata module, output_data.rs
 *
 * This module contains structs and functions related to plotting the simulation after it runs.
 *
 * WORKLOG
 * blairmunroakusa@1139.012922.anch.AK
 * blairmunroakusa@1559.012822.anch.AK
 *
 * TODO
 *
 */

use std::str::FromStr;
use image::ColorType;
use image::png::PNGEncoder;
use std::fs::File;

// this struct contains the data we need to turn the simulation results into an image
pub struct OutputData<'a> {

    pub ppcell: &'a mut u32,            // this is the number of operator specified pixels per cell
    pub pixelvector: &'a mut Vec<u8>,   // this is the final grid of pixels for writing to image

}

impl OutputData<'_> {

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// this method gets the number of pixels per cell from the operatorFuse

    pub fn get_ppcell(&mut self) -> Result<(), std::io::Error> {
            
        let mut input;

        // input loop for struct size member
        loop {
            
            // fill input buffer
            input = String::new();
            println!("\nPlease tell me how many pixels you want to allocate per cell.
                     (Enter a positive integer greater than zero, preferrably between 1 and 100.)\n");
            // check if prior entry exists and remind if so
            std::io::stdin().read_line(&mut input)?;

            // trim buffer contents
            input = input.trim().to_string();

            // check input cases ... should prevent most panics 
            
            // check for a valid number and make sure it isn't too big
            if input.chars().all(|char| char.is_digit(10)) {
                
                // compare against struct size type to avoid overflow
                let intbuf: u64 = u64::from_str(&input).unwrap();
                if intbuf > 100 {
                    println!("\nThat number is too large. Pick something smaller.\n");
                    continue // repeat loop
                }  
                // make sure input isn't zero
                else if intbuf == 0 {
                    println!("\nWe need at least one pixel per cell to plot. Zero cannot do. Try again.\n");
                    continue // repeat loop
                }

                break // to store input
            }
            // if not a valid number
            else {
                println!( "\nYou need to actually enter a positive whole number. Try again.");
                continue // repeat input loop
            }
        }
        
        // store valid pixel per cell input in struct
        *self.ppcell = u32::from_str(&input).unwrap();

        Ok(())

        // we now know how big (in pixels) that each cell should be

    }   // end OutputData.get_ppcell

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// this method computes the final output from the Simulate struct

    pub fn compute(&mut self, size: &u32, time: &u32, cellvec_full: &mut Vec<u8>) {
        
        // setup black and white building blocks
        let black: Vec<u8> = vec![0; *self.ppcell as usize];
        let white: Vec<u8> = vec![255; *self.ppcell as usize];

        // iterate through the finished simluation to expand each pixel into block of pixels

        for t in 0..*time {             // for each timestep (row)

            for _ in 0..*self.ppcell {  // add ppcell number of rows

                for s in 0..*size {     // and extend each cell by ppcell pixels for given color

                    if cellvec_full[(t * *size + s) as usize] == 0 {

                        self.pixelvector                // if the simulation cell is white, extend by white
                            .extend(white.to_vec());
                    }
                    else {

                        self.pixelvector                // is the simulation cell is black, extend by black
                            .extend(black.to_vec());
                    }
                }   // carry on to next block in row
            }       // carry on to next row in block
        }           // iterate through all blocks

        // pixelvector now contains the complete simulation with each pixel expanded into a block

    }   // end OutputData.compute

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// this method writes the final output to PNG image

    pub fn plot(&mut self, size: &u32, time: &u32) -> Result<(), std::io::Error> {
        
        // create file pointer
        let output = File::create("CAsimulationPlot.png")?;
        
        // define encoder type
        let encoder = PNGEncoder::new(output);

        // encode to png
        encoder.encode(self.pixelvector,
                       *size * *self.ppcell,    // with bounds size X time
                       *time * *self.ppcell,
                       ColorType::Gray(8))?;    // using 8 bit grayscale

        Ok(())

        // CAsimulationPlot.png now lives in project 'src' directory

    }   // end OutputData.plot

// end of OutputData implementations

}
