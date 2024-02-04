pragma circom 2.1.6;


include "AddSub.circom";
include "Multiplication.circom"
include "circomlib/comparators.circom";
include "taylorSeries.circom";


template logisticRegression(m,n) {
    signal input a[m][n];
    signal input w[n];
    signal ins[m+2][n+2];

    signal input x;


// component mult = Mul();
// component adds = AddSub();

// for(j =0; j<m; j++){
//     ins[j][0] <== 0;

//     for(var i=0;i<28;i++){
//         ins[j][i+1] <== ins[j][i] + a[j][i]*w[i];
//     }

//     for(var i=0;i<n;i++){
//         mult.a <== a[j][i] 
//         mult.b <== w[i];
//         ins[j][i+1] <== mult.out;

//         adds.in1 <== ins[j][i];
//         adds.in2 <== ins[j][i+1];
//         ins[j][i+2] <== adds.out;

//     }
// }


component taylor = taylorSeries();
taylor.x <== 12000000000000000000;



component compare = LessThan(252);








}