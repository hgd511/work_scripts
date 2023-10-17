# Take TGLF dumpfiles from JETTO run and run them standalone.
# Usage: bash run_jetto_tglf_dumpfiles.sh one_or_more_directories
# If executable in path: run_jetto_tglf_dumpfiles.sh one_or_more_directories

# Hard-coded variable.  = 0: Check before deleting existing files
#                      != 0: Doesn't check
brazen=0
		
# Main functionality
for directory in $@
do
	# Go into desired directory
	cd $directory
	
	# Count number of dumpfiles we have. If zero, exit program.
	number_of_tglf_points=$(ls *.out.tglf.localdump | wc -l)
	if [ $number_of_tglf_points -eq 0 ]; then
		echo "No dumpfiles found. Exiting."
		exit
	fi
	
	# Delete any existing profiles.CDF and timetraces.PDF files, 
	# then generate from data
	if test -f profiles.CDF || test -f timetraces.CDF; then
		if [ $brazen -eq 0 ]; then
			ls profiles.CDF timetraces.CDF
			echo "The above CDF files already exist and will be"\
			"overwritten. Continue?"
			select yn in "Yes" "No"; do
				case $yn in
					Yes ) break;;
					No ) exit;;
				esac
			done
		fi
		rm profiles.CDF timetraces.CDF
	fi
	convert_jsp_jst_to_transp.py
	
	# Delete existing standalone tglf runs if present
	if test -d tglf_standalone; then
		if [ $brazen -eq 0 ]; then
			echo "A tglf_standalone directory already exists and any"\
			"runs inside will be overwritten. Continue?"
			select yn in "Yes" "No"; do
				case $yn in
					Yes ) break;;
					No ) exit;;
				esac
			done
		fi
		rm -r tglf_standalone
	fi
	mkdir tglf_standalone
	
	# Copy dumpfiles into correspondingly numbered directories inside
	# tglf_standalone, renaming them to input.tglf, and execute tglf
	for i in $(seq 1 $number_of_tglf_points)
	do
		mkdir tglf_standalone/$i
		cp $i.out.tglf.localdump tglf_standalone/$i/input.tglf
		tglf -e tglf_standalone/$i
		reformat_tglf_outputs.sh tglf_standalone/$i
	done
	
	# Return to directory where script was executed
	cd -
done
