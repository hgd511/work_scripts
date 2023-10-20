import numpy as np

# Read TGLF ky spectrum
def tglf_ky_spectrum(tglf_directory):
	data = np.loadtxt(tglf_directory + 
		   'reformatted_outputs/ky_spectrum')[:]
	return data

# Read TGLF growth rate spectrum of given mode
def tglf_growth_rates(mode, tglf_directory):
	data = np.loadtxt(tglf_directory + 
		   'reformatted_outputs/eigenvalue_spectrum')[:, 2 * (mode - 1)]
	return data

# Read TGLF frequency spectrum of given mode
def tglf_frequency(mode, tglf_directory):
	data = np.loadtxt(tglf_directory + 
		   'reformatted_outputs/eigenvalue_spectrum')[:, (2 * mode) - 1]
	return data

# Read TGLF spectral shift spectrum
def tglf_spectral_shift(tglf_directory):
	data = np.loadtxt(tglf_directory + 
		   'reformatted_outputs/spectral_shift_spectrum')[:]
	return data

# Read TGLF field spectrum
def tglf_field_spectrum(field, mode, tglf_directory):
	data = np.loadtxt(tglf_directory + 
		   'reformatted_outputs/m' + str(mode) + '_field_spectrum')[:, field]
	return data
	
# Read TGLF sum flux spectrum
def tglf_flux_spectrum(flux_type, species, field, tglf_directory):
	flux_index = get_flux_type_index(flux_type)
	data = (np.loadtxt(tglf_directory + 
		   'reformatted_outputs/s' + str(species) + '_f' + 
		   str(field) + '_sum_flux_spectrum')[:, flux_index])
	return data

# Read TGLF QL flux spectrum (weights)
def tglf_QL_flux_spectrum(flux_type, species, field, mode, tglf_directory):
	flux_index = get_flux_type_index(flux_type)
	data = (np.loadtxt(tglf_directory + 
		   'reformatted_outputs/s' + str(species) + '_f' + 
		   str(field) + '_m' + str(mode) + '_QL_flux_spectrum')[:, flux_index])
	return data

# Calculate the flux spectrum for a given mode from the TGLF outputs
def get_tglf_flux_spectrum_for_given_mode(flux_type, species, field, mode, tglf_directory):
	field_data = tglf_field_spectrum(field, mode, tglf_directory)
	QL_weight_data = tglf_QL_flux_spectrum(flux_type, species, field, mode, tglf_directory)
	kys = tglf_ky_spectrum(tglf_directory)
	NKY = len(kys)
	
	pre_integral_flux = field_data * QL_weight_data
	dky0, ky0 = 0.0, 0.0 # initialise integration quantities
	flux0, flux1, flux_out = 0.0, 0.0, 0.0
	
	fluxes = []
	for i in range(NKY):
		ky1 = kys[i]
		if (i==0):
			dky1=ky1
		else:
			dky = np.log(ky1/ky0)/(ky1-ky0)
			dky1 = ky1*(1.0 - ky0*dky)
			dky0 = ky0*(ky1*dky - 1.0)
		flux1 = pre_integral_flux[i]
		flux_out = dky0*flux0 + dky1*flux1
		fluxes.append(flux_out)
		flux0 = flux1
		ky0 = ky1
	return np.array(fluxes)


# Return index for given flux type string
def get_flux_type_index(flux_type):
	if flux_type == 'particle':
		flux_index = 0
	elif flux_type == 'energy':
		flux_index = 1
	elif flux_type == 'toroidal':
		flux_index = 2
	elif flux_type == 'parallel':
		flux_index = 3
	elif flux_type == 'exchange':
		flux_index = 4
	else:
		print("Flux type not recognised. Please check guide.")
		raise NameError
	return flux_index
