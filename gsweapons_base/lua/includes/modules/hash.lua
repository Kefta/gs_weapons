local band = bit.band
local bnot = bit.bnot
local bor = bit.bor
local bxor = bit.bxor
local floor = math.floor

module( "hash" )

// The four core functions - F1 is optimized somewhat
// local function f1(x, y, z) bit.bor( bit.band( x, y ), bit.band( bit.bnot( x ), z )) end
local function f1( x, y, z ) return bxor( z, band( x, bxor( y, z ))) end
local function f2( x, y, z ) return bxor( y, band( z, bxor( x, y ))) end
local function f3( x, y, z ) return bxor( bxor( x, y ), z ) end
local function f4( x, y, z ) return bxor( y, bor( x, bnot( z ))) end

// This is the central step in the MD5 algorithm.
local function Step( func, w, x, y, z, flData, iStep )
	w = w + func(x, y, z) + flData
	
	return bor( (w * 2^iStep) % 0x100000000, floor(w % 0x100000000 / 2^(0x20 - iStep)) ) + x
end

function Transform( a, b, c, d, tIn )
	local a1 = a
	local b1 = b
	local c1 = c
	local d1 = d
	
	a = Step(f1, a, b, c, d, tIn[1] + 0xd76aa478, 7);
	d = Step(f1, d, a, b, c, tIn[2] + 0xe8c7b756, 12);
	c = Step(f1, c, d, a, b, tIn[3] + 0x242070db, 17);
	b = Step(f1, b, c, d, a, tIn[4] + 0xc1bdceee, 22);
	a = Step(f1, a, b, c, d, tIn[5] + 0xf57c0faf, 7);
	d = Step(f1, d, a, b, c, tIn[6] + 0x4787c62a, 12);
	c = Step(f1, c, d, a, b, tIn[7] + 0xa8304613, 17);
	b = Step(f1, b, c, d, a, tIn[8] + 0xfd469501, 22);
	a = Step(f1, a, b, c, d, tIn[9] + 0x698098d8, 7);
	d = Step(f1, d, a, b, c, tIn[10] + 0x8b44f7af, 12);
	c = Step(f1, c, d, a, b, tIn[11] + 0xffff5bb1, 17);
	b = Step(f1, b, c, d, a, tIn[12] + 0x895cd7be, 22);
	a = Step(f1, a, b, c, d, tIn[13] + 0x6b901122, 7);
	d = Step(f1, d, a, b, c, tIn[14] + 0xfd987193, 12);
	c = Step(f1, c, d, a, b, tIn[15] + 0xa679438e, 17);
	b = Step(f1, b, c, d, a, tIn[16] + 0x49b40821, 22);

	a = Step(f2, a, b, c, d, tIn[2] + 0xf61e2562, 5);
	d = Step(f2, d, a, b, c, tIn[7] + 0xc040b340, 9);
	c = Step(f2, c, d, a, b, tIn[12] + 0x265e5a51, 14);
	b = Step(f2, b, c, d, a, tIn[1] + 0xe9b6c7aa, 20);
	a = Step(f2, a, b, c, d, tIn[6] + 0xd62f105d, 5);
	d = Step(f2, d, a, b, c, tIn[11] + 0x02441453, 9);
	c = Step(f2, c, d, a, b, tIn[16] + 0xd8a1e681, 14);
	b = Step(f2, b, c, d, a, tIn[5] + 0xe7d3fbc8, 20);
	a = Step(f2, a, b, c, d, tIn[10] + 0x21e1cde6, 5);
	d = Step(f2, d, a, b, c, tIn[15] + 0xc33707d6, 9);
	c = Step(f2, c, d, a, b, tIn[4] + 0xf4d50d87, 14);
	b = Step(f2, b, c, d, a, tIn[9] + 0x455a14ed, 20);
	a = Step(f2, a, b, c, d, tIn[14] + 0xa9e3e905, 5);
	d = Step(f2, d, a, b, c, tIn[3] + 0xfcefa3f8, 9);
	c = Step(f2, c, d, a, b, tIn[8] + 0x676f02d9, 14);
	b = Step(f2, b, c, d, a, tIn[13] + 0x8d2a4c8a, 20);

	a = Step(f3, a, b, c, d, tIn[6] + 0xfffa3942, 4);
	d = Step(f3, d, a, b, c, tIn[9] + 0x8771f681, 11);
	c = Step(f3, c, d, a, b, tIn[12] + 0x6d9d6122, 16);
	b = Step(f3, b, c, d, a, tIn[15] + 0xfde5380c, 23);
	a = Step(f3, a, b, c, d, tIn[2] + 0xa4beea44, 4);
	d = Step(f3, d, a, b, c, tIn[5] + 0x4bdecfa9, 11);
	c = Step(f3, c, d, a, b, tIn[8] + 0xf6bb4b60, 16);
	b = Step(f3, b, c, d, a, tIn[11] + 0xbebfbc70, 23);
	a = Step(f3, a, b, c, d, tIn[14] + 0x289b7ec6, 4);
	d = Step(f3, d, a, b, c, tIn[1] + 0xeaa127fa, 11);
	c = Step(f3, c, d, a, b, tIn[4] + 0xd4ef3085, 16);
	b = Step(f3, b, c, d, a, tIn[7] + 0x04881d05, 23);
	a = Step(f3, a, b, c, d, tIn[10] + 0xd9d4d039, 4);
	d = Step(f3, d, a, b, c, tIn[13] + 0xe6db99e5, 11);
	c = Step(f3, c, d, a, b, tIn[16] + 0x1fa27cf8, 16);
	b = Step(f3, b, c, d, a, tIn[3] + 0xc4ac5665, 23);

	a = Step(f4, a, b, c, d, tIn[1] + 0xf4292244, 6);
	d = Step(f4, d, a, b, c, tIn[8] + 0x432aff97, 10);
	c = Step(f4, c, d, a, b, tIn[15] + 0xab9423a7, 15);
	b = Step(f4, b, c, d, a, tIn[6] + 0xfc93a039, 21);
	a = Step(f4, a, b, c, d, tIn[13] + 0x655b59c3, 6);
	d = Step(f4, d, a, b, c, tIn[4] + 0x8f0ccc92, 10);
	c = Step(f4, c, d, a, b, tIn[11] + 0xffeff47d, 15);
	b = Step(f4, b, c, d, a, tIn[2] + 0x85845dd1, 21);
	a = Step(f4, a, b, c, d, tIn[9] + 0x6fa87e4f, 6);
	d = Step(f4, d, a, b, c, tIn[16] + 0xfe2ce6e0, 10);
	c = Step(f4, c, d, a, b, tIn[7] + 0xa3014314, 15);
	b = Step(f4, b, c, d, a, tIn[14] + 0x4e0811a1, 21);
	a = Step(f4, a, b, c, d, tIn[5] + 0xf7537e82, 6);
	d = Step(f4, d, a, b, c, tIn[12] + 0xbd3af235, 10);
	c = Step(f4, c, d, a, b, tIn[3] + 0x2ad7d2bb, 15);
	b = Step(f4, b, c, d, a, tIn[10] + 0xeb86d391, 21);
	
	return (a1 + a) % 0x100000000, (b1 + b) % 0x100000000,
		(c1 + c) % 0x100000000, (d1 + d) % 0x100000000
end

-- This is called every tick so it has to be super optimised
function PseudoRandom( nSeed )
	nSeed = nSeed % 0x100000000
	
	local a = Step(f1, 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, nSeed + 0xd76aa478, 7)
	local d = Step(f1, 0x10325476, a, 0xefcdab89, 0x98badcfe, 0xe8c7b7d6, 12)
	local c = Step(f1, 0x98badcfe, d, a, 0xefcdab89, 0x242070db, 17)
	local b = Step(f1, 0xefcdab89, c, d, a, 0xc1bdceee, 22)
	a = Step(f1, a, b, c, d, 0xf57c0faf, 7)
	d = Step(f1, d, a, b, c, 0x4787c62a, 12)
	c = Step(f1, c, d, a, b, 0xa8304613, 17)
	b = Step(f1, b, c, d, a, 0xfd469501, 22)
	a = Step(f1, a, b, c, d, 0x698098d8, 7)
	d = Step(f1, d, a, b, c, 0x8b44f7af, 12)
	c = Step(f1, c, d, a, b, 0xffff5bb1, 17)
	b = Step(f1, b, c, d, a, 0x895cd7be, 22)
	a = Step(f1, a, b, c, d, 0x6b901122, 7)
	d = Step(f1, d, a, b, c, 0xfd987193, 12)
	c = Step(f1, c, d, a, b, 0xa67943ae, 17)
	b = Step(f1, b, c, d, a, 0x49b40821, 22)
	
	a = Step(f2, a, b, c, d, 0xf61e25e2, 5)
	d = Step(f2, d, a, b, c, 0xc040b340, 9)
	c = Step(f2, c, d, a, b, 0x265e5a51, 14)
	b = Step(f2, b, c, d, a, nSeed + 0xe9b6c7aa, 20)
	a = Step(f2, a, b, c, d, 0xd62f105d, 5)
	d = Step(f2, d, a, b, c, 0x02441453, 9)
	c = Step(f2, c, d, a, b, 0xd8a1e681, 14)
	b = Step(f2, b, c, d, a, 0xe7d3fbc8, 20)
	a = Step(f2, a, b, c, d, 0x21e1cde6, 5)
	d = Step(f2, d, a, b, c, 0xc33707f6, 9)
	c = Step(f2, c, d, a, b, 0xf4d50d87, 14)
	b = Step(f2, b, c, d, a, 0x455a14ed, 20)
	a = Step(f2, a, b, c, d, 0xa9e3e905, 5)
	d = Step(f2, d, a, b, c, 0xfcefa3f8, 9)
	c = Step(f2, c, d, a, b, 0x676f02d9, 14)
	b = Step(f2, b, c, d, a, 0x8d2a4c8a, 20)

	a = Step(f3, a, b, c, d, 0xfffa3942, 4)
	d = Step(f3, d, a, b, c, 0x8771f681, 11)
	c = Step(f3, c, d, a, b, 0x6d9d6122, 16)
	b = Step(f3, b, c, d, a, 0xfde5382c, 23)
	a = Step(f3, a, b, c, d, 0xa4beeac4, 4)
	d = Step(f3, d, a, b, c, 0x4bdecfa9, 11)
	c = Step(f3, c, d, a, b, 0xf6bb4b60, 16)
	b = Step(f3, b, c, d, a, 0xbebfbc70, 23)
	a = Step(f3, a, b, c, d, 0x289b7ec6, 4)
	d = Step(f3, d, a, b, c, nSeed + 0xeaa127fa, 11)
	c = Step(f3, c, d, a, b, 0xd4ef3085, 16)
	b = Step(f3, b, c, d, a, 0x04881d05, 23)
	a = Step(f3, a, b, c, d, 0xd9d4d039, 4)
	d = Step(f3, d, a, b, c, 0xe6db99e5, 11)
	c = Step(f3, c, d, a, b, 0x1fa27cf8, 16)
	b = Step(f3, b, c, d, a, 0xc4ac5665, 23)
	
	a = Step(f4, a, b, c, d, nSeed + 0xf4292244, 6)
	d = Step(f4, d, a, b, c, 0x432aff97, 10)
	c = Step(f4, c, d, a, b, 0xab9423c7, 15)
	b = Step(f4, b, c, d, a, 0xfc93a039, 21)
	a = Step(f4, a, b, c, d, 0x655b59c3, 6)
	d = Step(f4, d, a, b, c, 0x8f0ccc92, 10)
	c = Step(f4, c, d, a, b, 0xffeff47d, 15)
	b = Step(f4, b, c, d, a, 0x85845e51, 21)
	a = Step(f4, a, b, c, d, 0x6fa87e4f, 6)
	d = Step(f4, d, a, b, c, 0xfe2ce6e0, 10)
	c = Step(f4, c, d, a, b, 0xa3014314, 15)
	b = Step(f4, b, c, d, a, 0x4e0811a1, 21)
	a = Step(f4, a, b, c, d, 0xf7537e82, 6)
	d = Step(f4, d, a, b, c, 0xbd3af235, 10)
	c = (0x98badcfe + Step(f4, c, d, a, b, 0x2ad7d2bb, 15)) % 0x100000000
	b = (0xefcdab89 + Step(f4, b, c, d, a, 0xeb86d391, 21)) % 0x100000000
	
	return floor( b / 0x10000 ) % 0x100 + floor( b / 0x1000000 ) % 0x100 * 0x100 + c % 0x100 * 0x10000 + floor( c / 0x100 ) % 0x100 * 0x1000000
end
