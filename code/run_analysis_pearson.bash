java -jar -Djava.library.path=/usr/lib/jvm -Dhph.library.path=/home/aholbrook/hawkes/build -Dhph.required.flags=20 -Dhph.resource=2 /home/aholbrook/beast-mcmc/build/dist/beast.jar  -seed 666 -save_state checkpoint.state -save_every 1000000 -overwrite /home/aholbrook/EBOVPhyloHawkes/xml/Makona_1610_Hawkes_All_Taxa4.xml
