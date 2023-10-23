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
	
	head -n $(( $ANOM_HEADER+4+$NGRID-1 )) TCI_debug.dat | tail -n $(($NGRID-1)) > reformatted_jetto_tci/heat_fluxes
	
	head -n $(( $ANOM_HEADER+4+(2*$NGRID) )) TCI_debug.dat | tail -n $(($NGRID-1)) > reformatted_jetto_tci/particle_fluxes
	
	head -n $(( $ANOM_HEADER+4+(3*$NGRID) + 1 )) TCI_debug.dat | tail -n $(($NGRID-1)) > reformatted_jetto_tci/heat_diffusivities_diagonal
	
	head -n $(( $ANOM_HEADER+4+(4*$NGRID) + 2 )) TCI_debug.dat | tail -n $(($NGRID-1)) > reformatted_jetto_tci/particle_diffusivities_diagonal
	
	head -n $(( $ANOM_HEADER+4+(5*$NGRID) + 3 )) TCI_debug.dat | tail -n $(($NGRID-1)) > reformatted_jetto_tci/heat_pinch_velocities
	
	head -n $(( $ANOM_HEADER+4+(6*$NGRID) + 4 )) TCI_debug.dat | tail -n $(($NGRID-1)) > reformatted_jetto_tci/particle_pinch_velocities
	
	head -n $(( $ANOM_HEADER+4+(7*$NGRID) + 5 )) TCI_debug.dat | tail -n $(($NGRID-1)) > reformatted_jetto_tci/toroidal_mom_diff
	
	head -n $(( $ANOM_HEADER+4+(8*$NGRID) + 6 )) TCI_debug.dat | tail -n $(($NGRID-1)) > reformatted_jetto_tci/eff_heat_diffs
	
	head -n $(( $ANOM_HEADER+4+(9*$NGRID) + 7 )) TCI_debug.dat | tail -n $(($NGRID-1)) > reformatted_jetto_tci/eff_particle_diffs
	
	echo "Reformatted jetto tci outputs generated."
	
done
