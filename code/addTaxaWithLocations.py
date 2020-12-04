# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os, re, numpy

def main():
	file_data = numpy.genfromtxt("EBOVPhyloHawkes/data/taxaWithLocations.csv", usecols=0, skip_header=1, dtype=str,delimiter=",")
	x = file_data[:]
	with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_v4.xml","r") as infile:
		with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_v5.xml","w") as outfile:
			lines=infile.readlines()
			for i in range(0,len(lines)):
				s = lines[i]
				if(re.match('(.*)</taxa>(.*)', s)):
					outfile.write(s)
					outfile.write('\n\t<taxa id="taxa2">\n')
					i -= 2
					for k in range(0,len(x)):
						outfile.write('\t\t<taxon idref=\"'+x[k]+'\"/>\n')
						i -= 1
					outfile.write('\t</taxa>\n')
					i -= 1
				else:
					outfile.write(s)

if __name__ == '__main__':
	main()

# python get_locations_times.py
