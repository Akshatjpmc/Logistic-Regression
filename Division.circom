pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/mux2.circom"; 
include "../node_modules/circomlib/circuits/mux1.circom"; 
include "../node_modules/circomlib/circuits/comparators.circom"; 




template IntegerDivision () {
     signal input in1;
    signal input in2;
    signal  Out;

    signal int_sign1;
  signal int_sign2;
  signal  int_mag1;
  signal int_mag2;
  signal quotient;
  signal  sign;
  signal output out;

  // asserting input signal values to be less than sqaure rooot of prime field

   assert(in1 < 147946756881789319005730692170996259609 );
   assert(in2 < 147946756881789319005730692170996259609 );

// extracting magnitude and sign bit for in1

  int_sign1 <-- in1%10;
  int_mag1 <-- in1\10;
log(int_mag1);
in1  === (int_mag1*10) + int_sign1;


// extracting magnitude and sign bit for in2

  
  int_sign2 <-- in2%10;
  int_mag2 <-- in2\10;
log(int_mag2);
in2  === (int_mag2*10) + int_sign2;



    // performing division and floor operations 
    quotient <-- int_mag1 \ int_mag2;
    signal rem;
    rem <-- int_mag1 % int_mag2;

    int_mag1 ===  int_mag2 * quotient + rem;

    var scale = 100000000000000000 ;

    Out <== quotient;
    

// assignibg sign bit 
    component mux = Mux2(); 
    mux.c[0] <== 0;
    mux.c[1] <== 1;
    mux.c[2] <== 1;
    mux.c[3] <== 0;

    mux.s[0] <== int_sign1;
    mux.s[1] <== int_sign2;
    
    sign <== mux.out;

    out <== (Out*10)*scale + sign;


}

component main  = IntegerDivision();

/* INPUT = {
    "in1": "123456789444440000000000",
    "in2": "987656789444440000000001"
} */