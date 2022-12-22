clc 
clear all
close all

%row vector
r = [7 8 9 10]

%column vector
 sr = [6,6,34,454,4345]

% Referencing the Elements of a Vector
% You can reference one or more of the elements of a vector in several ways. The ith component of a vector v is referred as v(i). For example 
% When you reference a vector with a colon, such as v(:), all the components of the vector are listed.
 v = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
  v( :)

% MATLAB allows you to select a range of elements from a vector.
% 
% For example, let us create a row vector rv of 9 elements, then we will reference the elements 3 to 7 by writing rv(3:7) and create a new vector named sub_rv.
  
rv = [1 2 3 4 5 6 7 8 9];
sub_rv = rv(3:7)