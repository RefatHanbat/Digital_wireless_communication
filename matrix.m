% A matrix is a two-dimensional array of numbers.
% 
% In MATLAB, you create a matrix by entering elements in each row as comma or space delimited numbers and using semicolons to mark the end of each row.
% 
% For example, let us create a 4-by-5 matrix a −

clc
close all
clear all

a = [ 1 2 3 4 5; 2 3 4 5 6; 3 4 5 6 7; 4 5 6 7 8];

% For example, to refer to the element in the 2nd row and 5th column, 
% of the matrix a, as created in the last section, we type −

a(2,5)

% Let us create a column vector v, from the elements of the 4th row of 
% the matrix a −

v = a(:,4)


% Let us create a smaller matrix taking the elements from the second and 
% third columns −

a(:, 2:3)

% In the same way, you can create a sub-matrix taking a sub-part of a 
% matrix.
% 
% For example, let us create a sub-matrix sa taking the inner subpart 
% of a −

sa = a(2:3,2:4)


% Deleting a Row or a Column in a Matrix
% You can delete an entire row or column of a matrix by assigning an 
% empty set of square braces [] to that row or column. Basically, [] 
% denotes an empty array.
% 
% For example, let us delete the fourth row of a −

b = [ 1 2 3 4 5; 2 3 4 5 6; 3 4 5 6 7; 4 5 6 7 8];
b( 4 , : ) = []

% Next, let us delete the fifth column of b −
c = [ 1 2 3 4 5; 2 3 4 5 6; 3 4 5 6 7; 4 5 6 7 8];
c(: , 5)=[]

% Addition and substraction of a matrix

a = [ 1 2 3 ; 4 5 6; 7 8 9];
b = [ 7 5 6 ; 2 0 8; 5 7 1];
c = a + b
d = a - b

% MATLAB - Division (Left, Right) of Matrics

a = [ 1 2 3 ; 4 5 6; 7 8 9];
b = [ 7 5 6 ; 2 0 8; 5 7 1];
c = a / b
d = a \ b


% MATLAB - Scalar Operations of Matrices

a = [ 10 12 23 ; 14 8 6; 27 8 9];
b = 2;
c = a + b
d = a - b
e = a * b
f = a / b

% MATLAB - Transpose of a Matrix

a = [ 10 12 23 ; 14 8 6; 27 8 9]

b = a'

% MATLAB - Concatenating Matrices

% MATLAB allows two types of concatenations −
% 
% Horizontal concatenation
% Vertical concatenation
% When you concatenate two matrices by separating those using commas, 
% they are just appended horizontally. It is called horizontal 
% concatenation.
% 
% Alternatively, if you concatenate two matrices by separating those using
% semicolons, they are appended vertically. It is called vertical 
% concatenation.


a = [ 10 12 23 ; 14 8 6; 27 8 9]
b = [ 12 31 45 ; 8 0 -9; 45 2 11]
c = [a, b]
d = [a; b]

% MATLAB - Matrix Multiplication

a = [ 1 2 3; 2 3 4; 1 2 5]
b = [ 2 1 3 ; 5 0 -2; 2 3 -1]
prod = a * b

% MATLAB - Determinant of a Matrix

a = [ 1 2 3; 2 3 4; 1 2 5]
det(a)

% MATLAB - Inverse of a Matrix

a = [ 1 2 3; 2 3 4; 1 2 5]
inv(a)
