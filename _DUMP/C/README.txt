README

. this directory contains some old C samples
. I am rather embarrassed by the quality of work in hindsight, but showing something for C may be better than nothing

.
.
.

. the roboShopCleaner program was an 'intro to C' final I banged out
.. I give myself an F (for fail) on documentation
.. final was relatively low priority compared to PDE, EMAG, MATLAB courses competing for attention .. sloppy work
x

. the initTidbit program I was tinkering with to implement an idea called the 'txt file computer'
. The txt file computer was meant to emulate a digital processor, by exploiting a directory trees to process 'tidbits'
.. (I give myself an F (for fail) on documentation)
.. txt (or rtf) files would contain information, representing single tidbits
.. depending on the 'wholeness' of the information contained, a txt file would represent a '1' or a '0'
... these are tidbits
... 1 == a closed tidbit, ie, a body of information with a conclusion, or a 'point', greater than the whole of contents
... 0 == an open tidbit, ie, a body of information with no real 'point', ie the contents are the contents
.. a collection of directories was to act as a 'register'
.. a string of tidbits were to act as a thought chain, or sequence of project work
.. incoming tidbits were to append to a tidbit string via a push shift mechanism
... if not clear, tidbits were to contain, say, bits of thought toward a particular research project
.. operations on tidbit registers were to manipulate different strings of thought, toward project end
... eg, say I want to combine two strings of thought
... I arrange the strings in order of significance
... then, I use a custom algebra to correspond to the boolean notions of AND, OR, XOR
.... mix and mash ...see what happens...see what works best... let the txt file computer generate a range of outputs
..... eg algebra: 0 + 0 = 0	; 0 + 1 = 1	; 1 + 0 = 1	; 1 + 1 = ?
..... or maybe	  0 + 0 = 0	; 0 + 1 = '1	; 1 + 0 = 1'	; 1 + 1 = 1
..... omitting multiplication for now, but that's the idea
...... eg 0 = the visible universe ; plasma
......		1 = 99% of the visible universe is plasma
......		00 = the visible (matter in) universe ; plasma ; physicis gives three defining characteristics (not stated here)
......		01 = 99% of the visible universe is plasma; physicis gives three defining characteristics
......		10 = 99% of the visible universe is plasma thus our physics defines the majority of bulk matter relatively well in terms of three characteristics
......		11 = given 10, 100% of the visible matter may be described by relaxing definition of plasma
......    a little abstract, but it gets the gestalt across I think
......    this was an example from one of my personal projects
... part of the purpose of the tidbit txt computer was to generate .bib files for LaTeX and manage sources
.. so I wanted to build a basic program to run from shell that would allow me to enter academic articles as tidbits
... and of course include comments and sub-tidbits for every tidbit
.. the tx file computer goes deep into briefcase cluster and world piece computer
. unfortunately, directory trees for txt file computer initialization were written in Applescript also :/ .. sorry, universe
. that's all for now
x


