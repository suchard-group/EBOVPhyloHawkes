# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os, re, numpy

def main():
	file_data = numpy.genfromtxt("EBOVPhyloHawkes/data/unsequencedDataWPdensMN.csv", skip_header=1, dtype=str,delimiter=",")
	x = file_data[:]
	with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_All_Taxa2B_diagonalHessian_V2.xml","r") as infile:
		with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_All_Taxa2B_diagonalHessian_V3.xml","w") as outfile:
			lines=infile.readlines()
			for i in range(0,len(lines)):
				s = lines[i]
				if(re.match('(.*)</taxa> <!-- end taxa2 -->(.*)', s)):
					for j in range(0,len(x)):
						outfile.write('\t\t<taxon id=\"Unsequenced'+x[j,0]+'\">\n\t\t\t<attr name=\"rate\">1.0</attr>\n\t\t\t<attr name=\"km2\">'+x[j,5]+'</attr>\n\t\t\t<attr name=\"centroid\">'+x[j,3]+' '+x[j,4]+'</attr>\n\t\t\t<attr name=\"dateDecimal\">'+x[j,6]+'</attr>\n\t\t\t<attr name=\"pdensMN\">'+x[j,7]+'</attr>\n\t\t</taxon>\n')
					outfile.write(s)
				else:
					outfile.write(s)

if __name__ == '__main__':
	main()

# python get_locations_times.py
