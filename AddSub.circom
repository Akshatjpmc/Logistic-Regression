pragma circom 2.1.4;
 

// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";
include "../node_modules/circomlib/circuits/mux2.circom"; 
include "../node_modules/circomlib/circuits/mux1.circom"; 
include "../node_modules/circomlib/circuits/comparators.circom"; 


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
    in1 === int_mag1*10 + int_sign1;




// extracting magnitude and sign bit for in2

  int_sign2 <-- in2%10;
  int_mag2 <-- in2\10;
    in2 === int_mag2*10 + int_sign2;


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

