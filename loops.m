% a = 10;
% % while loop execution 
% while( a < 20 )
%    fprintf('value of a: %d\n', a);
%    a = a + 1;
% end
clc 
close all
clear all

a = 10 ;
 while (a < 20)

     fprintf('value of a: %d\n', a);
     a = a + 1;
 end 

%  for loop 
 for b = 10:20 
   fprintf('value of b: %d\n', b);
 end

 %nested loop 

 for i = 2:100
   for j = 2:100
      if(~mod(i,j)) 
         break; % if factor found, not prime
      end 
   end
   if(j > (i/j))
      fprintf('%d is prime\n', i);
   end
end