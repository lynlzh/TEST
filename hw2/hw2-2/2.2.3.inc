set I /bookcase,desk,chair,bedframe,coffeetable/;
set R /work,metal,wood/;

table a(R,I)
         bookcase desk chair bedframe coffeetable
work      3       2     1      2          3
metal     1       1     1      1          1
wood      4       3     3      4          2;

parameters
 profitMargin(I) /"bookcase" 19,"desk" 15,"chair" 12, "bedframe" 17,"coffeetable" 14/
 resourcebound(R) /"work" 225, "metal" 125, "wood" 420/;