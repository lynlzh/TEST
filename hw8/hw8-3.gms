$if not set N $set N 50
$eval NM1 %N%-1
set t times /0*%N%/;
set i /x, y, dx, dy/; alias (i, j);
set ct(t) control times /0*%NM1%/;
parameter A(i,j) /x.x 1, x.y -0.1, y.x -0.5, y.y 0.5, dx.dx 0.1,
dx.dy -1.1, dy.dx 0.5, dy.y -0.5/,
b(i) /x 1, y 1, dx 1, dy 1/,
xdes(i) /x -5, y 2, dx 0, dy 0 /
s(i) /x 0, y 0, dx 0, dy 0/;
    
variables
    obj
    x(t,i) 
    u(t)     
    z(t);
        
equations
objective
dynamic(t,i)
state1(i) 
state0(i)
constraint1(t)
constraint2(t)
constraint3(t)
constraint4(t);

dynamic(t, i)$(ct(t))..
x(t+1, i)=e=sum(j, A(i,j)*x(t,j)) + b(i)*u(t);

objective..
obj=g=sum(t$(ct(t)), z(t));
    
state1(i)..
x('%N%', i)=e=xdes(i);
    
state0(i)..
x('0',i)=e=s(i);
    
constraint1(t)..
u(t)=l=z(t);

constraint2(t)..
2*u(t)-1=l=z(t);
    
constraint3(t)..
-u(t)=l=z(t);
    
constraint4(t)..
-2*u(t)-1=l=z(t);
    
model fuel /all/;
solve fuel using lp minimizing obj;
display obj.l,x.l, u.l,z.l;