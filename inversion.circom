
pragma circom 2.1.6;


template Inversion(s) {
    signal input in;
    signal output inv ;
    signal output sign;
    signal int_mag;
    signal int_sign;
    signal output out ;


    assert(in < 147946756881789319005730692170996259609 );


  int_sign <-- in%10;
  int_mag <-- in\10;
log(int_mag);

  var SCALE_SQUARE = s**2;

  inv <--  SCALE_SQUARE \ int_mag;
  sign <== int_sign;

  out <== (inv*10) + sign;
    
}

component main  = Inversion(1000000000000000000);