%% This is a script written in Matlab for tinkering with different rules for a linear cellular automata simulation.
%% ...just for funsies.

clear all
close all


%% SETUP
%	generate random bit train
%	initialize display matrix
%	pad x boundary

N = 500;

n = 1 : 1 : N;
x = ones( 1, N );

for i = n

    r = rand();
    
    if r < 0.99
        x(i) = 0;
    else
        x(i) = 1;
    end
end


%% BEGIN TINKER ZONE %%%%%%%%%%%%%%%%
% for i = 1:N/2
% 
%     x(2*i-1:2*i) = [ 0 1 ];
% 
% end
%
% for i = 1:N/500
%     x(500*i-499:500*i) = [ zeros( 1,250) ones( 1, 250) ];
% end
%
% x = [ zeros(1,N/2) ones(1,N/2) ];
%% END TINKER ZONE %%%%%%%%%%%%%%%%%%%


bitPixel = round( 1000/N );
XX1 = ones( N*bitPixel );

xx1 = [ zeros( length(x) ) ; zeros( length(x) )  ];
xx1(1,:) = x;

%%	SIMULATE %%%%%%%%%%%%%%%%%%%%%%%%%
%	apply rules

% for i = n(1:end-1)
% 	xx1( i+1, : ) = majorityRule3( xx1( i, : ), n );
% end

% for i = n(1:end-1)
% 	xx1( i+1, : ) = majorityRule5( xx1( i, : ), n );
% end

 for i = 1:2*N-1
 	xx1( i+1, : ) = mod2rule3( xx1( i, : ), n );
 end

% for i = n(1:end-1)
% 	xx1( i+1, : ) = mod2rule5( xx1( i, : ), n );
% end

% for i = n(1:end-1)
% 	xx1( i+1, : ) = mod2rule5( xx1( i, : ), n );
% end

% for i = n(1:end-1)
% 	xx1( i+1, : ) = XORrule( xx1( i, : ), n );
% end




%% CONDITION AND PLOT %%%%%%%%%%%%%%%%%

on = find( xx1==0 );
off = find( xx1==1 );

xx1( on ) = 1;
xx1( off ) = 0;

	l = 0;
for k = n
	j = 0;
for i = n

	XX1( k+l*bitPixel-l : k*bitPixel, i+j*bitPixel-j : i*bitPixel ) = xx1(k,i)*ones( bitPixel );
	j = j + 1;
end
	l = l + 1;
end

imshow(XX1)
imwrite(XX1, 'XORrule.png')


