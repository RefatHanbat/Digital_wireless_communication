% MATLAB - Arrays
% 
% All variables of all data types in MATLAB are multidimensional arrays. 
% A vector is a one-dimensional array and a matrix is a two-dimensional array.
% 
% We have already discussed vectors and matrices. In this chapter, 
% we will discuss multidimensional arrays. However, before that, 
% let us discuss some special types of arrays.
% For all these functions, a single argument creates a square array, 
% double arguments create rectangular array.
% 
% The zeros() function creates an array of all zeros −
zeros(5)

% The ones() function creates an array of all ones −


ones(4,3)


% The eye() function creates an identity matrix.

eye(4)

% The rand() function creates an array of uniformly distributed random 
% numbers on (0,1) −

rand(3, 5)

% A Magic Square
% A magic square is a square that produces the same sum, when its elements 
% are 
% added row-wise, column-wise or diagonally.
% 
% The magic() function creates a magic square array. It takes a singular 
% argument that gives the size of the square. The argument must be a scalar 
% greater than or 
% equal to 3.

magic(4)

% Multidimensional Arrays
% An array having more than two dimensions is called a multidimensional array in MATLAB. Multidimensional arrays in MATLAB are an extension of the normal two-dimensional matrix.
% 
% Generally to generate a multidimensional array, we first create a two-dimensional array and extend it.
% 
% For example, let's create a two-dimensional array a.

a = [7 9 5; 6 1 9; 4 3 2]
a(:, :, 2)= [ 1 2 3; 4 5 6; 7 8 9]

% The following examples illustrate some of the functions mentioned above.
% 
% Length, Dimension and Number of elements −
% 
% Create a script file and type the following code into it −

x = [7.1, 3.4, 7.2, 28/4, 3.6, 17, 9.4, 8.9];
length(x)

y = rand(3, 4, 5, 2);
ndims(y)       % no of dimensions in array y
s = ['Zara', 'Nuha', 'Shamim', 'Riz', 'Shadab'];
numel(s)       % no of elements in s


% Sorting Arrays

v = [ 23 45 12 9 5 0 19 17]  % horizontal vector

sort(v)

m = [2 6 4; 5 3 9; 2 0 1]    % two dimensional array
sort(m, 1)                   % sorting m along the row
sort(m, 2)                   % sorting m along the column