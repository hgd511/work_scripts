import pandas as pd

# Read TGLF scalar saturation parameter string, returns float
def tglf_scal_sat_param(variable, tglf_directory):
	df = (pd.read_csv(tglf_directory + 'out.tglf.scalar_' + 
	      'saturation_parameters',skiprows=1, sep='=', header = None))
	df = df.T
	df = df.rename(columns=lambda x: df[x][0].strip())
	df = df.drop(index = 0)
	val = float(df[variable][1])
	return val
	
# Read TGLF input parameter string, returns float
def tglf_input_param(variable, tglf_directory):
	df = (pd.read_csv(tglf_directory + 'input.tglf.gen',
	      sep=' ', header = None))
	df = df.drop(columns = 1)
	df = df.T
	df = df.rename(columns=lambda x: df[x][2].strip())
	df = df.drop(index = 2)
	val = float(df[variable][0])
	return val

# Read TGLF NX parameter string, returns float
def get_tglf_Nparameter(variable, tglf_directory):
	file = open(tglf_directory + 'out.tglf.QL_flux_spectrum') 
	content = file.readlines() 
	data = content[3].split()
	if variable == 'NSPECIES':
		val = data[1]
	elif variable == 'NFIELDS':
		val = data[2]
	elif variable == 'NKY':
		val = data[3]
	elif variable == 'NMODES':
		val = data[4]
	else:
		print("Nparameter not recognised. Please check guide.")
		raise NameError
	return val
