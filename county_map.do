ssc install spmap 
ssc install maptile 
maptile_install using "http://files.michaelstepner.com/geo_county2010.zip"

import delimited using "county_data_extract.csv", delim(",") varnames(1) clear 
maptile total_population, geo(county2010) cutvalues(500 20000 100000 500000) legformat(%15.0fc) ///
 twopt( legend(pos(4) size(*.7)) title(County Population)) 
