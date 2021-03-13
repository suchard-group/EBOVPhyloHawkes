# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os, re, numpy

def main():
	file_data = numpy.genfromtxt("EBOVPhyloHawkes/data/unsequencedData.csv", skip_header=1, dtype=str,delimiter=",")
	x = file_data[:]
	with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_All_Taxa.xml","r") as infile:
		with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_All_Taxa2.xml","w") as outfile:
			lines=infile.readlines()
			for i in range(0,len(lines)):
				s = lines[i]
				if(re.match('(.*)<taxon id=\"Unsequenced(.*)', s)):
					result = re.search('<taxon id=\"Unsequenced(.*)\"', s)
					result = str(result.group(1));
					outfile.write(s)
					s = lines[i+1]
					outfile.write(s)
					s = lines[i+2]
					outfile.write(s)
					s = lines[i+3]
					outfile.write('\t\t\t<attr name=\"dateDecimal\">'+x[int(result)-1,6]+'</attr>\n')
				else:
					outfile.write(s)

if __name__ == '__main__':
	main()

# python get_locations_times.py
