#!/bin/awk -f

function trim (string) {
	gsub (/^ */, "", string)
	gsub (/ *$/, "", string)
	return string
}

BEGIN {
#	# get c_expname
	"ls ../REMIND_generic_*.mif" | getline c_expname


	if ((getline header < c_expname) < 1) {
		print "Could not read from REMIND_generic file" > "/dev/stderr"
		exit
	}

	sub (/\.\.\/REMIND_generic_/, "", c_expname)
	sub (/\.mif/,               "", c_expname)
	
    n_tokens = split (header, tokens, ";")

	# skip all non-period columns
	for (column = 1; column <= n_tokens && tokens[column] !~ /[0-9]+/; ++column)
		;

	# store all periods
	for (n_periods = 0; column <= n_tokens && tokens[column] ~ /[0-9]+/; ++column)
		periods[++n_periods] = trim(tokens[column])

	# initialize some variables
	n_calculations = 0
	quantity       = ""
	n_items        = 0
}

# Read the configuration file, which is passed as a parameter to the script.
{
	if ($0 == "") {
		# empty lines start a new block, so save the number of calculation 
		# steps for the last block, if any
		if (n_items > 0)
			calculation[n_calculations,"n_items"] = n_items

		# in any case, clear the name of the quantity and reset the number of 
		# calculation steps
		quantity = ""
		n_items  = 0

	} else if (quantity == "") {
		# if quantity is empty but the line is not, a new block starts
		# get the name of the quantity to calculate
		quantity = trim($0)
		calculation[++n_calculations,"quantity"] = quantity
	
	} else {
		# all other lines constitute calculation steps within a block
		x = index ($0, " ")
		operation = trim(substr ($0, 1, x-1))
		item      = trim(substr ($0, x+1))

		calculation[n_calculations,++n_items,"operation"] = operation
		calculation[n_calculations,  n_items,"item"]      = item
		items[item] = 1
	}
}

# Process all calculation
END {
	# make extra array with all periods for easy referencing
	for (p = 1; p <= n_periods; ++p)
		period_strings[periods[p]] = p

	# gather all data needed for calculations
	for (item in items) {
		# data from files
		if (0 + item == 0) {
			while ((getline < item) > 0) {
				if ($1 in period_strings)
					data[item,$1] = $2
			}
		# or as fixed numbers
		} else {
			for (p in period_strings)
				data[item,p] = item
		}
	}

	# write header
#	printf "Model;Scenario;Region;Variable;Unit"
#	for (p = 1; p <= n_periods; ++p)
#		printf ";" periods[p]
#	printf "\n"

	# perform all calculations and write results
	for (c = 1; c <= n_calculations; ++c) {
		printf "REMIND;" c_expname ";glob;" calculation[c,"quantity"]
		for (p = 1; p <= n_periods; ++p) {
			value = 0

			for (i = 1; i <= calculation[c,"n_items"]; ++i) {

				operation = calculation[c,i,"operation"]
				item      = calculation[c,i,"item"]

				if (operation == "+")
					value = value + data[item,periods[p]]
				else if (operation == "-")
					value = value - data[item,periods[p]]
				else if (operation == "*")
					value = value * data[item,periods[p]]
				else if (operation == "/")
					value = value / data[item,periods[p]]
			}
			printf (";%10f", value)
		}
		printf ";\n"
	}
}

