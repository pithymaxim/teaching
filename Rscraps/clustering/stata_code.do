insheet using https://github.com/pithymaxim/teaching/raw/main/Rscraps/clustering/t.csv, comma names clear 
eststo clear 
eststo: regress y x, cluster(b)
eststo: regress y x z, cluster(b) 
eststo: regress y x b , cluster(z)
eststo: regress y x z b, cluster(n)

esttab , b(7) se(7) keep(x)
