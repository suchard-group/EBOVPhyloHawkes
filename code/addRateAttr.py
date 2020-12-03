# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os, re, numpy

def main():
	with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_v3.xml","r") as infile:
		with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_v4.xml","w") as outfile:
			lines=infile.readlines()
			for i in range(0,len(lines)):
				s = lines[i]
				if(re.match('(.*)<taxon id=(.*)', s)):
					outfile.write(s+'\t\t\t<attr name=\"rate\">0.0</attr>\n')
					i += 1
				else:
					outfile.write(s)

if __name__ == '__main__':
	main()

# python get_locations_times.py
