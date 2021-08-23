#!/bin/bash
cd hawkes/build/

	# no simd
	./benchmark --locations 25000 --dimension 2 --iterations 10
	
	# sse
	./benchmark --locations 25000 --dimension 2 --iterations 10 --sse
	
	./benchmark --tbb 1 --locations 25000 --dimension 2 --iterations 10 --avx

	./benchmark --tbb 2 --locations 25000 --dimension 2 --iterations 10 --avx


# (AVX, SSE, NO SIMD) x threads + gpu
for t in {4..104..10}; do
	
	# avx
	./benchmark --tbb $t --locations 25000 --dimension 2 --iterations 10 --avx

done

# gpu
./benchmark --locations 25000 --dimension 2 --iterations 1000 --gpu 1
