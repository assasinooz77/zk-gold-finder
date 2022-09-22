include "node_modules/circomlib/circuits/pedersen.circom";

template GoldFinder() {
    signal input goldX;
    signal input goldY;
    signal input goldHash[2];
    signal input targetX;
    signal input targetY;
    signal output out;

    signal isInRange;
    signal hasGold;

    // hash check
    component hash = Pedersen(256);
    component n2b = Num2Bits(256);
    n2b.in <== goldX + goldY * 16;
    for (var i = 0; i < 256; i++) {
        hash.in[i] <== n2b.out[i];
    }
    goldHash[0] === hash.out[0];
    goldHash[1] === hash.out[1];

    // map check
    isInRange <-- (targetX >= 0 && targetX <= 2 && targetY >= 0 && targetY <= 2);
    isInRange === 1;

    // gold check
    hasGold <-- (targetX == goldX && targetY == goldY);

    out <== hasGold;
}

component main {public [goldHash, targetX, targetY]} = GoldFinder();
