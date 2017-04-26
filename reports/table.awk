# should be called:
# awk -v mode=mean -f table.awk stats_file
# mode can be max,min, mean, median 

BEGIN {
	new_block = 0
	n=0
	print mode
}

# get prms
/^ *#/ { 
	n++;

	deg[n] = $6
	description[n] = $9 " " $11
	next 
}

/^ / { 

	# $2    $3   $4     $5
	# max, min, mean, median
	switch(mode) {
	case "max" :
		data[$1][n] = $2
		break
	case "min" :
		data[$1][n] = $3
		break
	case "mean" :
		data[$1][n] = $4
		break
	case "median" :
		data[$1][n] = $5
		break
	default:
		data[$1][n] = $5
	}

}


END{

	for (form in data)
		printf "%+7s", form
	printf " deg  interval\n"

	for (i = 1; i<= n; i++){
		for (form in data){
			printf "%+7s", data[form][i] 
		}
		printf " " deg[i] "\t" description[i] "\n"

		# warning: maxic constant
		if (i % 9 ==0)
			printf "\n"

	}
}

