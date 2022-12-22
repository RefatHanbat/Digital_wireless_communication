clc
clear all
close all

mymaximum(34, 78, 89, 23, 11);

function max = mymaximum(n1, n2, n3, n4, n5)


    max =  n1;
    if(n2 > max)
       max = n2;
    end
    if(n3 > max)
       max = n3;
    end
    if(n4 > max)
       max = n4;
    end
    if(n5 > max)
       max = n5;
    end
    % help mymax
end
