pragma circom 2.1.6;

include "../node_modules/circomlib/circuits/mux2.circom"; 
include "../node_modules/circomlib/circuits/mux1.circom"; 
include "../node_modules/circomlib/circuits/comparators.circom"; 

// include "../node_modules/circomlib/circuits/poseidon.circom"; 



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


 

// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";



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

template logisticRegression() {
    signal input a[5][2];
    signal input w[2];
    signal  insm[7][4];
    signal insa[7][4];

     component mult[2];
     component adds[2]; 




for(var j =0; j<5; j++){
    insa[j][0] <== 0;

    for(var i=0;i<2;i++){
        mult[i] = Mul();
        adds[i] = AddSub();
        mult[i].a <== a[j][i] ;
        mult[i].b <== w[i];
        insa[j][i+1] <== mult[i].out;
        log(mult[i].out);

         adds[i].in1 <== insa[j][i];
        adds[i].in2 <== insa[j][i+1];
         insm[j][i] <== adds[i].out;

    }
}
}

component main = logisticRegression();





/* INPUT = {
    "a":[[10,20],[10,20],[10,20],[10,20],[10,20]],
    "w": [10,20]
} */