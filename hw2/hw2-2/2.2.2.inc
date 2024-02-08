set I /bookcase,desk,chair,bedframe,coffeetable/;
set R /work,metal,wood/;

table a(R,I)
        bookcase desk chair bedframe 
work      3       2     1      2          
metal     1       1     1      1          
wood      4       3     3      4;

parameters
 profitMargin(I) /"bookcase" 19,"desk" 15,"chair" 12, "bedframe" 17/
 resourcebound(R) /"work" 225, "metal" 125, "wood" 420/;
 
