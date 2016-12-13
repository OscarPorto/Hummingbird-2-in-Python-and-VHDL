#!/usr/bin/env python
# https://github.com/bozhu/Hummingbird2-Python

# original S1 to S4
S0 = (7, 12, 14, 9, 2, 1, 5, 15, 11, 6, 13, 0, 4, 8, 10, 3)
S1 = (4, 10, 1, 6, 8, 15, 7, 12, 3, 0, 14, 13, 5, 9, 11, 2)
S2 = (2, 15, 12, 1, 5, 6, 10, 13, 14, 8, 3, 4, 0, 11, 9, 7)
S3 = (15, 4, 5, 8, 9, 7, 2, 1, 10, 3, 0, 14, 6, 12, 13, 11)


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


class Hummingbird2:
    def __init__(self, key, iv):
        self.init(key, iv)

    def init(self, key, iv):
        assert len(key) == 8
        assert len(iv)  == 4

        self.key = tuple(key)
        self.R = list(iv) + list(iv)

        for i in range(8):
            assert self.key[i] <= 0xFFFF and self.key[i] >= 0
            assert self.R[i]   <= 0xFFFF and self.R[i]   >= 0

        for i in range(4):
            t0 = f(f(f(f(_add(self.R[0],  i) ^ key[0]) ^ key[1]) ^ key[2]) ^ key[3])
            t1 = f(f(f(f(_add(self.R[1], t0) ^ key[4]) ^ key[5]) ^ key[6]) ^ key[7])
            t2 = f(f(f(f(_add(self.R[2], t1) ^ key[0]) ^ key[1]) ^ key[2]) ^ key[3])
            t3 = f(f(f(f(_add(self.R[3], t2) ^ key[4]) ^ key[5]) ^ key[6]) ^ key[7])
            self.R[0] = _csl(_add(self.R[0], t3), 3)
            self.R[1] = _csr(_add(self.R[1], t0), 1)
            self.R[2] = _csl(_add(self.R[2], t1), 8)
            self.R[3] = _csl(_add(self.R[3], t2), 1)
            self.R[4] ^= self.R[0]
            self.R[5] ^= self.R[1]
            self.R[6] ^= self.R[2]
            self.R[7] ^= self.R[3]

    def enc(self, p):
        t0 = f(f(f(f(_add(self.R[0],  p) ^ self.key[0]) \
                                         ^ self.key[1]) \
                                         ^ self.key[2]) \
                                         ^ self.key[3])
        t1 = f(f(f(f(_add(self.R[1], t0) ^ self.key[4] ^ self.R[4]) \
                                         ^ self.key[5] ^ self.R[5]) \
                                         ^ self.key[6] ^ self.R[6]) \
                                         ^ self.key[7] ^ self.R[7]) 
        t2 = f(f(f(f(_add(self.R[2], t1) ^ self.key[0] ^ self.R[4]) \
                                         ^ self.key[1] ^ self.R[5]) \
                                         ^ self.key[2] ^ self.R[6]) \
                                         ^ self.key[3] ^ self.R[7])
        c  = f(f(f(f(_add(self.R[3], t2) ^ self.key[4]) \
                                         ^ self.key[5]) \
                                         ^ self.key[6]) \
                                         ^ self.key[7])
        c  = _add(c, self.R[0])

        self.R[4] ^= _add(self.R[0], t2)
        self.R[5] ^= _add(self.R[1], t0)
        self.R[6] ^= _add(self.R[2], t1)
        self.R[7] ^= _add(_add(_add(self.R[3], self.R[0]), t2), t0)

        self.R[3]  = _add(_add(_add(self.R[3], self.R[0]), t2), t0)
        self.R[0]  = _add(self.R[0], t2)
        self.R[1]  = _add(self.R[1], t0)
        self.R[2]  = _add(self.R[2], t1)

        return c
    
import time
from time import sleep

if __name__ == '__main__':
  key = (0x2301, 0x6745, 0xAB89, 0xEFCD, 0xDCFE, 0x98BA, 0x5476, 0x1032)
  iv  = (0x3412, 0x7856, 0xBC9A, 0xF0DE)
  my_hb2 = Hummingbird2(key, iv)
  actu=0

  for q in range (7):
      
    if q==0:
      p = (0x1100, 0x3322)
    elif q==1:
      p = (0x1100, 0x3322, 0x5544)
    elif q==2:
      p = (0x1100, 0x3322, 0x5544, 0x7766)
    elif q==3:
      p = (0x1100, 0x3322, 0x5544, 0x7766, 0x9988)
    elif q==4:
      p   = (0x1100, 0x3322, 0x5544, 0x7766, 0x9988, 0xBBAA)
    elif q==5:
      p   = (0x1100, 0x3322, 0x5544, 0x7766, 0x9988, 0xBBAA, 0xDDCC)
    elif q==6:
      p   = (0x1100, 0x3322, 0x5544, 0x7766, 0x9988, 0xBBAA, 0xDDCC, 0xFFEE)      


    doc=open("EncTP"+str(q+2)+".txt",'w')
    
    start_time = time.time()
    
    for j in range(10000):
        
     for t in p:
        my_hb2.enc(t)

     ante=actu
     sleep(0.01)
     actu=time.time()-start_time-0.01
     doc.write(str(actu-ante)+'\n')
     
  doc.close()













































    
