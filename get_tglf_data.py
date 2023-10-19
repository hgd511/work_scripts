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
