# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os, re, numpy

def main():
    with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_All_Taxa2B_diagonalHessian_V3.xml","r") as infile:
        with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_All_Taxa2B_diagonalHessian_V4.xml","w") as outfile:
            lines=infile.readlines()
            for i in range(0,len(lines)):
                s = lines[i]
                if(re.match('(.*)<attr name=\"pdensMN\">(.*)', s)):
                    result = re.search('<attr name=\"pdensMN\">(.*)<', s)
                    result = str(result.group(1));
                    outfile.write('\t\t\t<attr name=\"pdensMN\">'+ str(numpy.log(float(result))) +'</attr>\n')
                else:
                    outfile.write(s)

if __name__ == '__main__':
    main()

# python get_locations_times.py
