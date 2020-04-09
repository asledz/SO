/*
    Pi digits implementation using https://math.stackexchange.com/questions/880904/how-do-you-use-the-bbp-formula-to-calculate-the-nth-digit-of-%CF%80
    Uses __uint128_t from g++ other compilers might have different names for it. Compiles with g++ 9.3.0 on a 64bit CPU 
*/

#include <iostream>
#include <iomanip>

using u64 = uint64_t;
using u32 = uint32_t;
using u128 = __uint128_t;

// Returns {a/b}
u64 getDivFraction(u64 a, u64 b)
{
    u128 aShifted = a;
    aShifted <<= 64;
    u128 divisionResult = aShifted/b; // Division result holds 2^64 * a/b
    u64 result = (u64)divisionResult; // Take lower 64bits of division result as fractional part 
    return result;
}

// Returns (value^p) % m
u64 getPowerModulo(u64 value, u64 p, u64 m)
{
    u128 result = 1 % m;
    for(u64 i = 0; i < p; i++)
        result = (result * value) % m;

    return result;
}

// Multiplies two fractions giving third fraction
// 2^-64 * result = (2^-64 * a) * (2^-64 * b)
u64 fracMul(u64 a, u64 b)
{
    u128 a128 = a;
    u128 b128 = b;
    u128 mulRes = a128*b128;
    return (mulRes >> 64);
}


// Gets {16^n * Sj}
u64 getSjForN(u64 j, u64 n)
{
    u64 result = 0; 
    
    for(u64 k = 0; k <= n; k++)
    {
        u64 numerator = getPowerModulo(16, n-k, (u64)8*k + j); 
        u64 denominator = (u64)8*k + j;
        result += getDivFraction(numerator, denominator);
    }
    
    u64 cur16Pow = getDivFraction(1, 16); // {1/16};

    for(u64 k = n+1; ;k++)
    {
        u64 numerator = cur16Pow;
        u64 denominator = (u64)8*k + j;
        u64 curPart = numerator/denominator; 

        if(curPart == 0)
            break;

        result += curPart;
        cur16Pow = fracMul(cur16Pow, getDivFraction(1, 16)); 
    }

    return result;

    // TODO - what if 8k + j exceeds 64 bits?
}

// Gets {16^n * pi}
u64 getPiForN(u64 n)
{
    u64 S1 = getSjForN(1, n);
    u64 S4 = getSjForN(4, n);  
    u64 S5 = getSjForN(5, n);  
    u64 S6 = getSjForN(6, n);  

    return ((u64)4*S1 - (u64)2*S4 - S5 - S6);
}

#include "pix.h"

int main()
{
    const int N = 8;
    u32 table[N];
    u64 index = 0;
    pix(table, &index, N);
   
    for(int i = 0; i < N; i++)
        std::cout << std::hex << std::uppercase << std::setfill('0') << std::setw(8) << table[i] << '\n';
}

void pix(uint32_t *ppi, uint64_t *pidx, uint64_t max)
{
    for(; *pidx < max; (*pidx)++)
    {
        uint64_t m = *pidx;
        u64 curData = getPiForN(8*m); 
        ppi[m] = (u32)(curData >> 32);
    }
}
