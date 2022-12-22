% The colon(:) is one of the most useful operator in MATLAB. 
% It is used to create vectors, subscript arrays, and specify for iterations.
1:10
% If you want to specify an increment value other than one, for example −

100: -5: 50

0:pi/8:pi

A = [1 2 3 4; 4 5 6 7; 7 8 9 10]
A(:,2)      % second column of A
A(:,2:3)    % second and third column of A
A(2:3,2:3)  % second and third rows and second and third columns