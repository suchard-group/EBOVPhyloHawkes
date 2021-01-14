#!/bin/bash
cd hawkes/build/
for n in 10000 20000 30000 40000 50000 60000 70000 80000 90000; do
	for t in 1 2 4 6 8 10 12 14 16 18 20; do
	./benchmark --tbb $t --locations $n --iterations 1 --avx
	done
done

for n in 10000 20000 30000 40000 50000 60000 70000 80000 90000; do
	./benchmark --gpu 1 --locations $n --iterations 100
done