from get_tglf_data import *
from get_tglf_params import *
import matplotlib.pyplot as plt

# Compare sum of flux spectrum data to the total fluxes outputted in
# out.tglf.gbflux, to check formatting and indexing is correct
# ----------------------------------------------------------------------
def flux_output_test(flux_type, species, tglf_directory):
	
	# Obtain number of fields, species
	NFIELDS = get_tglf_Nparameter('NFIELDS', tglf_directory)
	NSPECIES = get_tglf_Nparameter('NSPECIES', tglf_directory)
	
	# Calculate total flux from flux spectrum data
	flux_data = 0.0
	for field in range(1, NFIELDS+1):
		flux_data = flux_data + np.sum(tglf_flux_spectrum(flux_type, species, field, tglf_directory))

	# test particle fluxes
	if flux_type == 'particle':
		# get gb particle flux of given species
		flux_out = get_gbflux_out(flux_type, species, tglf_directory)
		if ((flux_data / flux_out) - 1.0 > 1E-4):
			print(flux_data, flux_out)
			print("Flux data and output do not match. Please investigate before continuining.")
			print("flux_type = " + str(flux_type) + ", species = " + str(species) + ", field = " + str(field))
			raise ValueError
	
	# test energy fluxes
	elif flux_type == 'energy':
		flux_out = get_gbflux_out(flux_type, species, tglf_directory)
		if ((flux_data / flux_out) - 1.0 > 1E-4):
			print(flux_data, flux_out)
			print("Flux data and output do not match. Please investigate before continuining.")
			print("flux_type = " + str(flux_type) + ", species = " + str(species) + ", field = " + str(field))
			raise ValueError


# Compare flux calculation from fields and weights with flux spectrum
# data, to check formatting, indexing and integration is correct
# ----------------------------------------------------------------------
def flux_spectrum_test(flux_type, species, field, tglf_directory):
	
	# Calculate flux spectrum from field data and weights
	NMODES = get_tglf_Nparameter('NMODES', tglf_directory)
	flux_calc = 0.0
	for mode in range(1, NMODES+1):
		flux_calc = flux_calc + np.sum(get_tglf_flux_spectrum_for_given_mode(flux_type, species, field, mode, tglf_directory))
	
	# Load flux data
	flux_data = np.sum(tglf_flux_spectrum(flux_type, species, field, tglf_directory))
	
	if ((flux_calc / flux_data) - 1.0 > 1E-4):
		print(flux_data, flux_calc)
		print("Flux calculation and data do not match. Please investigate before continuining.")
		print("flux_type = " + str(flux_type) + ", species = " + str(species) + ", field = " + str(field))
		raise ValueError
