eststo clear 
eststo: regress y x, cluster(b)
eststo: regress y x z, cluster(b) 
eststo: regress y x b , cluster(z)
eststo: regress y x z b, cluster(n)

esttab , b(10) se(10) keep(x)
