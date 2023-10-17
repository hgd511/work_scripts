# Take default tglf output files and make new ones that are easier to 
# read using np.loadtxt.
# Usage: bash run_jetto_tglf_dumpfiles.sh one_or_more_directories
# If executable in path: run_jetto_tglf_dumpfiles.sh one_or_more_directories

f_ext="" # file extension

for directory in $@
do
	cd $directory
	
	# Make new directory for reformatted outputs
	if test -d reformatted_outputs; then
		rm -r reformatted_outputs
	fi
	mkdir reformatted_outputs

	# Get number of kys in the simulation
	NKY=$(( $(cat out.tglf.ky_spectrum | wc -l) - 2 ))
	NKY2=$(head -n 2 out.tglf.ky_spectrum | tail -n 1)
	if [ $NKY != $NKY2 ]; then
		echo "A check has failed, implying the out.tglf.ky_spectrum"\
		"format has changed. Please investigate before continuing."
		exit
	fi
	
	# Make ky_spectrum file 
	tail -n $NKY out.tglf.ky_spectrum > reformatted_outputs/ky_spectrum${f_ext}
	
	# Number of species
	NSPECIES=$(grep -w 'NS' input.tglf.gen | cut -d " " -f 1)
	
	# Number of fields
	NFIELDS=1
	BPER_SWITCH=$(grep -w 'USE_BPER' input.tglf.gen | cut -d " " -f 1)
	if [ $BPER_SWITCH == "T" ]; then
		NFIELDS=$(($NFIELDS+1))
	fi
	BPAR_SWITCH=$(grep -w 'USE_BPAR' input.tglf.gen | cut -d " " -f 1)
	if [ $BPAR_SWITCH == "T" ]; then
		NFIELDS=$(($NFIELDS+1))
	fi
	
	# Number of modes
	NMODES=$(grep -w 'NMODES' input.tglf.gen | cut -d " " -f 1)

	# Eigenvalue spectrum
	doc_length=$(cat out.tglf.eigenvalue_spectrum | wc -l)
	expected_length=$(( $NKY + 2 ))
	if [ $doc_length != $expected_length ]; then
		echo "A check has failed, implying the out.tglf.eigenvalue_spectrum"\
		"format has changed. Please investigate before continuing."
		exit
	fi
	tail -n $NKY out.tglf.eigenvalue_spectrum > reformatted_outputs/eigenvalue_spectrum${f_ext}
	
	# Flux spectrum
	doc_length=$(cat out.tglf.sum_flux_spectrum | wc -l)
	expected_length=$(( ($NKY + 2) * $NSPECIES * $NFIELDS ))
	if [ $doc_length != $expected_length ]; then
		echo "A check has failed, implying the out.tglf.sum_flux_spectrum"\
		"format has changed. Please investigate before continuing."
		exit
	fi
	for species in $(seq 1 $NSPECIES)
	do
		for field in $(seq 1 $NFIELDS)
		do
			head_index=$(( (($species-1)*$NFIELDS + $field) * ($NKY+2)))			
			head -n $head_index out.tglf.sum_flux_spectrum | \
			tail -n $NKY > \
			reformatted_outputs/s${species}_f${field}_sum_flux_spectrum${f_ext}
		done
	done
	
	# Field spectrum
	doc_length=$(cat out.tglf.field_spectrum | wc -l)
	expected_length=$(( 6 + ($NKY * $NMODES) ))
	if [ $doc_length != $expected_length ]; then
		echo "A check has failed, implying the out.tglf.field_spectrum"\
		"format has changed. Please investigate before continuing."
		exit
	fi
	num_of_vals=$(($NKY * $NMODES))
	for mode in $(seq 1 $NMODES)
	do
		for n in $(seq 1 $NKY)
		do
			line=$(( $mode + ($n-1)*$NMODES ))
			tail -n $num_of_vals out.tglf.field_spectrum | head -n $line\
			| tail -n 1 >> \
			reformatted_outputs/m${mode}_field_spectrum${f_ext}
		done
	done
	
	# Weight spectrum
	doc_length=$(cat out.tglf.QL_flux_spectrum | wc -l)
	expected_length=$(( 4 + (1 + (($NKY+1) * $NMODES)) * $NSPECIES * $NFIELDS ))
	if [ $doc_length != $expected_length ]; then
		echo "A check has failed, implying the out.tglf.QL_flux_spectrum"\
		"format has changed. Please investigate before continuing."
		exit
	fi
	for species in $(seq 1 $NSPECIES); do
		for field in $(seq 1 $NFIELDS); do
			for mode in $(seq 1 $NMODES); do
				head_index=$((4+(1+$NMODES*($NKY+1))*($NFIELDS*($species-1)+($field-1))+1+$mode*($NKY+1)))
				head -n $head_index out.tglf.QL_flux_spectrum | \
				tail -n $NKY > \
				reformatted_outputs/s${species}_f${field}_m${mode}_QL_flux_spectrum${f_ext}
			done
		done
	done	
done
