
# DESCIFRADO HUMMINGBIR-2 ALGORITHM In Python by Oscar Porto Solano. Cartagena de Indias, Colombia.


# original S1 to S4
S0 = (7, 12, 14, 9, 2, 1, 5, 15, 11, 6, 13, 0, 4, 8, 10, 3)
S1 = (4, 10, 1, 6, 8, 15, 7, 12, 3, 0, 14, 13, 5, 9, 11, 2)
S2 = (2, 15, 12, 1, 5, 6, 10, 13, 14, 8, 3, 4, 0, 11, 9, 7)
S3 = (15, 4, 5, 8, 9, 7, 2, 1, 10, 3, 0, 14, 6, 12, 13, 11)

# Inverse S-boxes: refer to Table 2 in Pag 5 of "A Cryptanalysis of HummingBird-2: The Diferential Sequence Analysis", Guang Gong.
Si0 =  (11, 5,  4, 15, 12,  6,  9,  0, 13,  3, 14,  8,  1, 10,  2, 7)
Si1 =  (9 , 2, 15,  8,  0, 12,  3,  6,  4, 13,  1, 14,  7, 11, 10, 5)
Si2 =  (12, 3,  0, 10, 11,  4,  5, 15,  9, 14,  6, 13,  2,  7,  8, 1)
Si3 =  (10, 7,  6,  9,  1,  2, 12,  5,  3,  4,  8, 15, 13, 14, 11, 0)
#---------------------------------------------------------------------------------------------------------------------------------

def _csl(x, s):
    "cyclic shift to left"
    assert x <= 0xFFFF and x >= 0
    assert s >= 0

    return ((x << s) & 0xFFFF) | (x >> (16 - s))

def _csr(x, s):
    "to right"
    assert x <= 0xFFFF and x >= 0
    assert s >= 0

    return (x >> s) | ((x << (16 - s)) & 0xFFFF)

def _add(a, b):
    "addition module 2^{16}"
    assert a <= 0xFFFF and a >= 0
    assert b <= 0xFFFF and b >=0

    return (a + b) % 0x10000

# A rest module is agregate. Warning: the rest in binary does not consider a valid answer when a<b
def _rest(a, b):
    "rest module 2^{16}"
    assert a <= 0xFFFF and a >= 0
    assert b <= 0xFFFF and b >=0

    return (a - b) % 0x10000

def f(x):
    assert x <= 0xFFFF and x >= 0

    x0 = (x >> 12) & 0xF
    x1 = (x >>  8) & 0xF
    x2 = (x >>  4) & 0xF
    x3 = (x >>  0) & 0xF

    xx = (S0[x0] << 12) \
       | (S1[x1] <<  8) \
       | (S2[x2] <<  4) \
       | (S3[x3] <<  0)
    xx ^= _csl(xx, 6) ^ _csl(xx, 10)

    return xx

# fi(x) is the inverse function of f(x). Refer to pag 94 of "ECRYPT Workshop on Lightweight Cryptography" - November 2011, Gregor Leander and Francois-Xavier Standaert
def fi(x):
    assert x <= 0xFFFF and x >= 0

    x ^= _csl(x, 2) ^ _csl(x, 4) ^ _csl(x, 12) ^ _csl(x, 14)

    x0 = (x >> 12) & 0xF
    x1 = (x >>  8) & 0xF
    x2 = (x >>  4) & 0xF
    x3 = (x >>  0) & 0xF

    xx = (Si0[x0] << 12) \
       | (Si1[x1] <<  8) \
       | (Si2[x2] <<  4) \
       | (Si3[x3] <<  0)
    
    return xx

# WD16i(x) is the inverse function of WD16(x). Refer to pag 4 of "A Cryptanalysis of HummingBird-2: The Dierential Sequence Analysis"
def WD16i(y,Kd,Kc,Kb,Ka):
    
    assert y  <= 0xFFFF and y  >= 0
    assert Kd <= 0xFFFF and Kd >= 0
    assert Kc <= 0xFFFF and Kc >= 0
    assert Kb <= 0xFFFF and Kb >= 0
    assert Ka <= 0xFFFF and Ka >= 0

    yy = fi(fi(fi(fi(y) ^ Kd) ^ Kc) ^ Kb) ^ Ka
    
    return yy



class Hummingbird2:
    def __init__(s, k, iv):
        s.init(k, iv)

    # Followed by the same initialization, come the decryption. Refer to page VI of "A Cryptanalysis of HummingBird-2: The Diferential Sequence Analysis"
    # The initialization is the same for encryption and decryption, for that the IV vector are the same for both encryption and decryption.
    def init(s, k, iv):
        # Verification of the k vector has 128 bits. it is 8_word*16_bits = 128 bits
        # Verification of the IV vector has 64 bits. it is 8_word*16_bits = 128 bits
        
        assert len(k) == 8 # Verification of the k vector has 8 word
        assert len(iv)  == 4 # Verification of the IV vector has 4 word

        s.k = tuple(k) # The k are value that aren't modifies, for that it is set as a tuple 
        s.R = list(iv) + list(iv) # (R(0)1;:::;R(0)8) = (IV1; IV2; IV3; IV4; IV1; IV2; IV3; IV4).

        for i in range(8):
            assert s.k[i] <= 0xFFFF and s.k[i] >= 0 #Verification of the k word has 16 bits. it is 8_word*16_bits = 128 bits
            assert s.R[i]   <= 0xFFFF and s.R[i]   >= 0 #Verification of the IV word has 16 bits. it is 2_list*4_word*16_bits = 128 bits

        for i in range(4):
            t0 = f(f(f(f(_add(s.R[0],  i) ^ k[0]) ^ k[1]) ^ k[2]) ^ k[3])
            t1 = f(f(f(f(_add(s.R[1], t0) ^ k[4]) ^ k[5]) ^ k[6]) ^ k[7])
            t2 = f(f(f(f(_add(s.R[2], t1) ^ k[0]) ^ k[1]) ^ k[2]) ^ k[3])
            t3 = f(f(f(f(_add(s.R[3], t2) ^ k[4]) ^ k[5]) ^ k[6]) ^ k[7])
            s.R[0] = _csl(_add(s.R[0], t3), 3)
            s.R[1] = _csr(_add(s.R[1], t0), 1)
            s.R[2] = _csl(_add(s.R[2], t1), 8)
            s.R[3] = _csl(_add(s.R[3], t2), 1)
            s.R[4] ^= s.R[0]
            s.R[5] ^= s.R[1]
            s.R[6] ^= s.R[2]
            s.R[7] ^= s.R[3]

    # The Decryption of a single word Ci followed by the same initialization is. Refer to page VI of "A Cryptanalysis of HummingBird-2: The Diferential Sequence Analysis"
    # Usar s.k[0]...  s.R[0]...
    def dec(s, c):
        u3 = WD16i(_rest(c , s.R[0]), s.k[7], s.k[6], s.k[5], s.k[4])
        u2 = WD16i(_rest(u3, s.R[3]), s.k[3]^s.R[7], s.k[2]^s.R[6], s.k[1]^s.R[5], s.k[0]^s.R[4])
        u1 = WD16i(_rest(u2, s.R[2]), s.k[7]^s.R[7], s.k[6]^s.R[6], s.k[5]^s.R[5], s.k[4]^s.R[4])
        p  = WD16i(_rest(u1, s.R[1]), s.k[3], s.k[2], s.k[1], s.k[0])
        p  = _rest(p,s.R[0])

        t2=_rest(u3,s.R[3])
        t1=_rest(u2,s.R[2])
        t0=_rest(u1,s.R[1])

        s.R[4] ^= _add(s.R[0], t2)
        s.R[5] ^= _add(s.R[1], t0)
        s.R[6] ^= _add(s.R[2], t1)
        s.R[7] ^= _add(_add(_add(s.R[3], s.R[0]), t2), t0)

        s.R[3]  = _add(_add(_add(s.R[3], s.R[0]), t2), t0)
        s.R[0]  = _add(s.R[0], t2)
        s.R[1]  = _add(s.R[1], t0)
        s.R[2]  = _add(s.R[2], t1)

        return p


if __name__ == '__main__':
    k   = (0x2301, 0x6745, 0xAB89, 0xEFCD, 0xDCFE, 0x98BA, 0x5476, 0x1032)
    iv  = (0x3412, 0x7856, 0xBC9A, 0xF0DE)
    c   = (0xd15b, 0xadf8, 0x1423, 0xf420, 0xb1ba, 0xc254, 0x2945, 0x383d)
    my_hb2 = Hummingbird2(k, iv)
    for t in c:
        print hex(my_hb2.dec(t))


