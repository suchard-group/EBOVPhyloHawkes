# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os, re, numpy

def main():
#     file_data = numpy.genfromtxt("FluHawkes/data/xml_order_to_remove.csv", usecols=(0), skip_header=0, dtype=None)
#     print(file_data)
#     x = file_data[:]
#     file_data = numpy.genfromtxt("FluHawkes/data/xml_names_to_remove.csv", usecols=(0), skip_header=0, dtype=str)
#     print(file_data)
#     y = file_data[:]
    with open("EBOVPhyloHawkes/xml/Makona_1610_cds_ig.xml","r") as infile:
        with open("EBOVPhyloHawkes/xml/Makona_1610_Hawkes_v1.xml","w") as outfile:
            #k = 1
            for s in infile:
#                 if re.match("(.*)<taxon id=(.*)", s):
#                     if k in x:        
#                         outfile.write(s.replace("<taxon id=","<!-- <taxon id="))
#                     else:
#                         outfile.write(s)    
#                 elif(re.match("(.*)</taxon>(.*)", s)):
#                     if k in x:        
#                         outfile.write(s.replace("</taxon>","</taxon> -->"))
#                     else:
#                         outfile.write(s)
#                     k = k + 1
#                 elif(re.match("(.*)<taxon idref=(.*)", s)):
#                     result = re.search('<taxon idref=\"(.*)\"/>', s)
#                     result = str(result.group(1));
#                     if result in y:
#                         outfile.write(s.replace("<taxon idref=","<!-- <taxon idref=").replace(">","> -->"))
#                     else:
#                         outfile.write(s)
                if(re.match('(.*)<date value=(.*)', s)):
                    result = re.search('<date value=\"(.*)\" direction', s)
                    result = str(result.group(1));
                    outfile.write(s)
                    outfile.write('\t\t\t<attr name=\"dateDecimal\">'+result+'</attr>\n')
                    #s = s+1
                else:
                    outfile.write(s)

if __name__ == '__main__':
    main()

# python get_locations_times.py
