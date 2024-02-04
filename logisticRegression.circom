pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/mux2.circom"; 
include "../node_modules/circomlib/circuits/mux1.circom"; 
include "../node_modules/circomlib/circuits/comparators.circom"; 
// include "Multiplication.circom";
// include "AddSub.circom";


template AddSub () {
  signal input in1;
  signal input in2;

 // Decalring intermediate signals
  signal int_sign1;
  signal int_sign2;
  signal  int_mag1;
  signal int_mag2;
  signal  result ;
  signal  finalResult;
  signal  sign;
  signal output out;


  // asserting input signal values to be less than sqaure rooot of prime field
     assert(in1 < 147946756881789319005730692170996259609 );
     assert(in2 < 147946756881789319005730692170996259609 );

// extracting magnitude and sign bit for in1
  int_sign1 <-- in1%10;
  int_mag1 <-- in1\10;



// extracting magnitude and sign bit for in2

  int_sign2 <-- in2%10;
  int_mag2 <-- in2\10;

//performing add/sub operations

 component mux3 = Mux2();

 mux3.c[0] <== int_mag1 + int_mag2;
 mux3.c[1] <== int_mag1 - int_mag2;
 mux3.c[2] <== int_mag2 - int_mag1;
 mux3.c[3] <== int_mag1 + int_mag2;
 mux3.s[0] <== int_sign1;
 mux3.s[1] <== int_sign2;
 result <== mux3.out;

 signal checker;

component check = LessThan(252);

 check.in[0] <== 0;
 check.in[1] <== result;

checker <== check.out;

component mux4 = Mux1();

mux4.c[0] <== (int_mag1 - int_mag2);
mux4.c[1] <==  result;
mux4.s <== checker;

finalResult <== mux4.out;

// assigning sign bit 

signal checker1;

component check2 =  LessThan(252);

check2.in[0] <==  int_mag1;
check2.in[1] <== int_mag2;


checker1 <==  check2.out;


 component mux5 = Mux1();

 mux5.c[0] <== int_sign1;
 mux5.c[1] <== int_sign2;
 mux5.s <== checker1;

 sign <== mux5.out;

 out <== (finalResult*10) + sign;



}

template Mul() {
    signal input a;
    signal input b;
    signal output out;

    var scale = 1000000000000000000;

    // assert(a < 147946756881789319005730692170996259609 );
    // assert(b < 147946756881789319005730692170996259609 );

    signal a_sign <-- a % 10; //no constraint
    signal a_value <-- a \ 10; //no constraint
    a === (a_value*10) + a_sign; // constrain

    signal b_sign <-- b % 10;
    signal b_value <-- b \ 10;
    b === (b_value*10) + b_sign;

    signal out_value_scaled <== a_value*b_value;
    signal out_value <-- out_value_scaled \ scale;
    //out_value_scaled === out_value*scale;

        // assigning sign bit
    component mux = Mux2(); 
    mux.c[0] <== 0;
    mux.c[1] <== 1;
    mux.c[2] <== 1;
    mux.c[3] <== 0;

    mux.s[0] <== a_sign;
    mux.s[1] <== b_sign;
    
    signal out_sign <== mux.out;

    out <== (out_value*10) + out_sign;
}




template taylorSeries () {
    signal input x;
    signal one <== 2500000000000000000;
    signal two <== 208333333333333331;
    signal three <== 20833333333333330;
    signal four <== 5000000000000000000;
    signal output out ;


component mul = Mul();

mul.a <== one;
mul.b <== x;
signal first_term <== mul.out;

component mul1 = Mul();

mul1.a <== x;
mul1.b <== x;
signal second_term_one <== mul1.out;

component mul2 = Mul();

mul2.a <== x;
mul2.b <== second_term_one;
signal second_term_second <== mul1.out;

component mul3 = Mul();

mul3.a <== second_term_second ;
mul3.b <== two;

signal second_term_final <== mul3.out;

component mul4 = Mul();

mul4.a <== second_term_second;
mul4.b <== second_term_one;
signal third_term_first <== mul4.out;

component mul5 = Mul();

mul5.a <== third_term_first;
mul5.b <== three;

signal third_term_final <== mul5.out;


log(first_term);
log(second_term_final);
log(third_term_final);

//signal series <== 5000000000000000000 + first_term + second_term_final + third_term_final ;

component add = AddSub();

add.in1 <== four;
add.in2 <== first_term;
signal int1 <== add.out;

component add1  = AddSub();
add1.in1 <== int1;
add1.in2 <== second_term_final;
signal int2 <== add1.out;

component add2  = AddSub();
add2.in1 <== int2;
add2.in2 <== third_term_final;
signal series <== add2.out;
log(int1);
log(int2);
log(series);

out <== series ;

}

template logisticRegression2(m,n) {
  signal input a[m][n];
  signal input w[n];
  signal input ans[m];
  signal ins[m+1][n+1];
  signal  insa[m+1][n+1];
  signal x[m];
  signal output taylorResult[m];
  signal output result[m];
  signal efficiencyDivisor;
   signal output efficiencySignal;
   signal output  efficiencyCheck ;
   signal efficiency;
  

 
component mult[m+1][n+1] ;
component adds[m+1][n+1] ;
component taylor[m+1];
component check[m+1];
component checker;


       var count = 0;

for(var j =0; j<m; j++){
    ins[j][0] <== 0;
    insa[j][0] <== 0;
    
    // for(var i=0;i<28;i++){
    //     ins[j][i+1] <== ins[j][i] + a[j][i]*w[i];
    // }


    for(var i=0;i<n;i++){

        mult[j][i] = Mul();
        adds[j][i] = AddSub();
        mult[j][i].a <== a[j][i] ;
        mult[j][i].b <== w[i];
        ins[j][i+1] <== mult[j][i].out;

        adds[j][i].in1 <== insa[j][i];
         adds[j][i].in2 <== ins[j][i+1];
         insa[j][i+1] <== adds[j][i].out;

    }

    x[j] <==  insa[j][n];


    taylor[j] = taylorSeries();
    taylor[j].x <== x[j];
    taylorResult[j] <-- taylor[j].out \ 10;
 

    check[j] = LessThan(252);
    check[j].in[0] <== 500000000000000000;
    check[j].in[1] <== taylorResult[j];
    result[j] <== check[j].out;    


    if(result[j] == ans[j]){
        count ++;
    }
    log(count);
 
    //14731249999999997840
    //500000000000000000
    //9.0000000000000000000
    //1.0000000000000000000
} 

  efficiency <-- (count/m);
   efficiencySignal <== efficiency*1000;


    checker  = GreaterThan(252);

 checker.in[0] <== 900;
 checker.in[1] <== efficiency;
  efficiencyCheck <== checker.out;

  efficiencyCheck === 1;

}

component main = logisticRegression2(25,28);
