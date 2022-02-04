function [ out ] = mod2rule3( x, n )

	out = zeros( 1, length(n) );

	edgeWindowL = [ x(1:2) x(end) ];
	edgeWindowR = [ x(1) x(end-1:end) ];

% 	This block applies rule to cells on the left edge of simulation
	if ( sum(edgeWindowL) == 0 ) || ( sum(edgeWindowL) == 2 )
		out(1) = 0;
	else
		out(1) = 1;
	end
	
% 	This block applies rule to cells on the right edge of simulation
	if ( sum(edgeWindowR) == 0 ) || ( sum(edgeWindowR) == 2 )
		out(end) = 0;
	else
		out(end) = 1;
	end
	
% 	This block applies rule to cells in the main body of the simulation
	for i = n(1:end-2)
	
		window = x(i:i+2);

		if ( sum(window) == 0 ) || ( sum(window) == 2 )
			out(i+1) = 0;
		else
			out(i+1) = 1;
		end
	end

end
