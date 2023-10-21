from tglf_data_tests import *
import sys
import os

# Get path to tglf directory
tglf_directory = os.path.abspath(sys.argv[1]) + '/'

# Get required Nparameters
NSPECIES = get_tglf_Nparameter('NSPECIES', tglf_directory)
NFIELDS = get_tglf_Nparameter('NFIELDS', tglf_directory)

# flux type strings
flux_types = ['particle', 'energy', 'toroidal', 'parallel', 'exchange']

# Scan across flux types, species and fields to check data is as expected
for flux_type in flux_types:
	for species in range(1, NSPECIES + 1):
		for field in range(1, NFIELDS + 1):
			flux_output_test(flux_type, species, tglf_directory)
			flux_spectrum_test(flux_type, species, field, tglf_directory)

