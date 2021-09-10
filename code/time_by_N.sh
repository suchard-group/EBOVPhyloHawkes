#!/bin/bash
cd hawkes/build/
#for n in 10000 20000 30000 40000 50000 60000 70000 80000 90000; do
#	./benchmark --tbb 1 --locations $n --iterations 1 --avx
#	./benchmark --tbb 2 --locations $n --iterations 1 --avx
#	for t in {4..104..10}; do
#	./benchmark --tbb $t --locations $n --iterations 1 --avx
#	done
#done

for n in 10000 20000 30000 40000 50000 60000 70000 80000 90000; do
	./benchmark --gpu 1 --locations $n --iterations 10
done
