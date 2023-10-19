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