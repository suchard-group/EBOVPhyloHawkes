# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os, re, numpy

def main():
	file_data = numpy.genfromtxt("EBOVPhyloHawkes/data/Location_Data_2016-05-27.csv", usecols=0, skip_header=1, dtype=str,delimiter=",")
	y = file_data[:]
	with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_v4.xml","r") as infile:
		with open("EBOVPhyloHawkes/data/taxaWithLocations.csv","w") as outfile:
			lines=infile.readlines()
			for i in range(0,len(lines)):
				s = lines[i]
				if(re.match('(.*)<taxon id=(.*)', s)):
					token=False
					for k in range(0,len(y)):
						if(re.match('(.*)\|'+y[k]+'\|(.*)', s)):
							token=True
					if(token==True):
						result = re.search('\"(.*)\"', s)
						result = str(result.group(1));
						outfile.write(result+'\n')

if __name__ == '__main__':
	main()

# python get_locations_times.py
