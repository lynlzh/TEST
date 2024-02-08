sets
    i /1*15/  
    j /1*7/;
parameters
    c(j) / 1 1.8, 2 1.3, 3 4.0, 4 3.5, 5 3.8, 6 2.6, 7 2.1 / ,
    p(i) / 1 2, 2 4, 3 13, 4 6, 5 9, 6 4, 7 8, 8 12, 9 10, 10 11, 11 6, 12 14, 13 9, 14 3, 15 6 /;

table covering(i,j) 
   1 2 3 4 5 6 7
1  1 0 0 0 0 0 0
2  1 1 0 0 0 0 0
3  0 1 0 0 0 0 0
4  0 0 1 0 0 0 0
5  0 1 0 1 0 0 0
6  0 0 0 1 1 0 0
7  0 0 1 0 0 1 0
8  0 0 1 1 1 0 0
9  0 0 0 1 1 0 0
10 0 0 1 0 0 1 0
11 0 0 0 0 0 1 0
12 0 0 0 0 1 1 1
13 0 0 0 0 0 0 1
14 0 0 0 0 0 0 1
15 0 0 0 0 0 1 1;

variables 
    pop_covered;
    
binary variables
    x(j)
    y(i);

equations 
obj 'Objective function for total population covered'
budget
coverage(i);  

obj..
pop_covered =e= sum(i, y(i) * p(i));

budget..
sum(j, c(j) * x(j)) =l= 10;

coverage(i)..
y(i) =l= sum(j, covering(i,j) * x(j));   

model phoenixsite /all/;

option optcr = 0; option optca = 0;

solve phoenixsite using mip maximizing pop_covered;

set open(J); open(J) = yes$(x.l(J) > 0.5);

option open:0:0:1;display open, pop_covered.l;

