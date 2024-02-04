pragma circom 2.1.6;

include "Multiplication.circom";
include "AddSub.circom";
// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";


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





