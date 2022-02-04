% This is a function wriiten in Matlab that implements the exlusive or rule
% for determining the evolving initial state of a linear array of cellular
% automata. Cellular automata are cool.

function [ out ] = XORrule( x, n )

	out = zeros( 1, length(n) );

	edgeWindowL = [ x(end) x(2) ];
	edgeWindowR = [ x(end-1) x(1) ];

%	This block is dealing with the XOR rule for the edge cases (left side)
	if ( sum(edgeWindowL) == 1 )
        	if ( x(1) == 0 )
        		out(1) = 1;
        	else
        		out(1) = 0;
        	end
	else
        	if ( x(1) == 1 )
        		out(1) = 1;
        	else
        		out(1) = 0;
        	end
	end


%	This block is dealing with the XOR rule for the edge cases (right side)
	if ( sum(edgeWindowR) == 1 )
        	if ( x(end) == 0 )
        		out(end) = 1;
        	else
        		out(end) = 0;
        	end
	else
        	if ( x(end) == 1 )
        		out(end) = 1;
        	else
        		out(end) = 0;
        	end
	end

%	This block is the XOR rule application to cells in the main body of the simulation
	for i = n(1:end-2)
	
		window = [ x(i) x(i+2) ];

		if ( sum(window) == 1 )
            		if ( x(i+1) == 0 )
            			out(i+1) = 1;
            		else
            			out(i+1) = 0;
            		end
		else
            		if ( x(i+1) == 1 )
            			out(i+1) = 1;
            		else
            			out(i+1) = 0;
            		end
		end
	end


end
