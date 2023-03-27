* Put list of packages you want below
local ssc_packages binscatter ftools gtools reghdfe 

* This loop will look for the package and install it if it is missing 
foreach pkg in `ssc_packages' {
	display "On this package: `pkg'"
	capture noisily which `pkg'
	if _rc==111 {
		display "`pkg' not found. Installing `pkg' and placing in personal folder"
		ssc install `pkg', replace
		cd U:\ado 
		* Copy adofile to personal ado folder 
		ssc copy `pkg'.ado 
		* Copy help file to personal ado folder 
		cap n ssc copy `pkg'.sthlp 
	}
}
