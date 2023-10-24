# Take TCI_debug and output easily-read anomalous transport outputs.
for directory in $@
do
	cd $directory
	
	# numerical parameters needed
	ANOM_HEADER=$(grep -n "ANOMALOUS TRANSPORT" TCI_debug.dat | cut -d : -f 1)
	NIONS=$(head -n 3 TCI_debug.dat | tail -n 1 | awk '{print $1}')
	NGRID=$(head -n 4 TCI_debug.dat | tail -n 1 | awk '{print $1}')
	
	# make directory to house reformatted data
	if test -d reformatted_jetto_tci; then
		rm -r reformatted_jetto_tci
	fi
	mkdir reformatted_jetto_tci

	# separate data, make files
	head -n $(( $ANOM_HEADER+4+$NGRID-1 )) TCI_debug.dat | tail -n $(($NGRID-1)) | awk '{print $1}' > reformatted_jetto_tci/tci_grid
	
	i=1
	for filename in heat_fluxes particle_fluxes heat_diffusivities_diagonal\
	particle_diffusivities_diagonal heat_pinch_velocities particle_pinch_velocities\
	toroidal_momentum_diffusivities effective_heat_diffusivities effective_particle_diffusivities
	do
		head_ind=$((($i*$NGRID)+$i-2))
		head -n $(( $ANOM_HEADER+4+$head_ind )) TCI_debug.dat | tail -n $(($NGRID-1)) > reformatted_jetto_tci/$filename
		i=$(($i+1))
	done
	
	echo "Reformatted jetto tci outputs generated."
	
done
