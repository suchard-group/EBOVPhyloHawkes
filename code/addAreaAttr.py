# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os, re, numpy

def main():
	file_data = numpy.genfromtxt("EBOVPhyloHawkes/data/Location_Data_2016-05-27.csv", usecols=18, skip_header=1, dtype=str,delimiter=",")
	x = file_data[:]
	file_data = numpy.genfromtxt("EBOVPhyloHawkes/data/Location_Data_2016-05-27.csv", usecols=0, skip_header=1, dtype=str,delimiter=",")
	y = file_data[:]
	with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_v2.xml","r") as infile:
		with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_v3.xml","w") as outfile:
			lines=infile.readlines()
			for i in range(0,len(lines)):
				s = lines[i]
				if(re.match('(.*)<taxon id=(.*)', s)):
					token=False
					for k in range(0,len(y)):
						if(re.match('(.*)\|'+y[k]+'\|(.*)', s)):
							outfile.write(s+'\t\t\t<attr name=\"km2\">'+x[k]+'</attr>\n')
							token=True
					i += 1
					if(token==False):
						outfile.write(s)
				else:
					outfile.write(s)

if __name__ == '__main__':
	main()

# python get_locations_times.py
