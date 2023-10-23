# Take TCI_debug and output TCI grid positions, 'tci_grid'
for directory in $@
do
	cd $directory
	
	NIONS=$(head -n 3 TCI_debug.dat | tail -n 1 | awk '{print $1}')
	NGRID=$(head -n 4 TCI_debug.dat | tail -n 1 | awk '{print $1}')

	head -n $(( 7+$NIONS+$NGRID )) TCI_debug.dat | tail -n $NGRID  > tci_grid
	
	echo "tci_grid generated."
done
