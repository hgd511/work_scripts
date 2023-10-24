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
	
	# electron quantities
	elec_header=$(grep -n " rho ne Te vtor_e vpol_e Zeff ns" TCI_debug.dat | cut -d : -f 1)
	
	head -n $(( $elec_header + $NGRID )) TCI_debug.dat | tail -n $NGRID > reformatted_jetto_tci/electron_quantities
	
	head -n $(( $elec_header + (2*$NGRID) + 1 )) TCI_debug.dat | tail -n $NGRID > reformatted_jetto_tci/wexb_alpha_psi_ps_e_rad
	
	# geometry quantities
	geo_header=$(grep -n " a0,R0,Bt0, arho, Ip, BIC" TCI_debug.dat | cut -d : -f 1)
	
	head -n $(( $geo_header + 1 )) TCI_debug.dat | tail -n 1 > reformatted_jetto_tci/a0_R0_Bt0_arho_Ip_BIC
	
	i=1
	for filename in rminor_rmajor_kappa_vprime q_shear_grho1_grho2\
	b2_bm2_fhat_gr2bm2 fms ft_grth_psi_dpsidrho f_jdotBoverB0 delta_btor_bpol
	do
		head -n $(( $geo_header+2+($i*$NGRID)+$i-1 )) TCI_debug.dat | tail -n $NGRID > reformatted_jetto_tci/$filename
		i=$(($i+1))
	done
	
	echo "Reformatted jetto tci outputs generated."
	
	cd -
	
done
