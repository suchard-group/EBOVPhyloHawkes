#!/bin/bash
cd hawkes/build/

	# no simd
	./benchmark --locations 25000 --dimension 2 --iterations 1
	
	# sse
	./benchmark --locations 25000 --dimension 2 --iterations 1 --sse

# (AVX, SSE, NO SIMD) x threads + gpu
for t in 1 2 4 6 8 10 12 14 16 18 20; do
	
	# avx
	./benchmark --tbb $t --locations 25000 --dimension 2 --iterations 1 --avx

done

# gpu
./benchmark --locations 25000 --dimension 2 --iterations 10 --gpu 2
