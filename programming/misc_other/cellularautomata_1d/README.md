#### [..](https://github.com/blairmunroakusaBRANCH/rust.cellularautomata)
#### [ROOT](https://github.com/blairmunroakusa)
#### [TRUNK](https://github.com/blairmunroakusaTRUNK)
#### [BRANCH](https://github.com/blairmunroakusaBRANCH)
#### [LEAF](https://github.com/blairmunroakusaLEAF)

A newjack's first Rust program,
basic 1D cellular automata simulator.

Here's a sample simulation, 1000 cells, 1000 timesteps, rule 22, three seeds:
![a sample simulation, 1000 cells, 1000 timesteps, rule 22, three seeds](./CAsimulationPlotEG.png)

```
TODO
. address boundary cases
. change loop to let input in loop within input_data
. use Vec<bool> instead of u8 for sim
. find out why shuffle() is expensive
. create stand-alone readme (here) for the onedimensional_cellularautomata program itself
. add multithreading to speed up process time for big simulations
. create a 'two seed' initial condition where two initial 'black' cells are equidistant from boundary
? make the operator input decimal instead of binary
. collect more rules to suggest for the operator to play with
. practice implementing unit tests (better late than never)
. make a GUI
```
```
SELFEVAL
. casting was difficult
. everything is a &mut .. necessary ?
. digging into iterators may be more elegant than nested for loops
. probably could do with less commenting

```

