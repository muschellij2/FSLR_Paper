library(bibtex)
x = read.bib("FSLR.bib")

x$note = lapply(x$note, function(x) NULL)
nifty = citation("RNiftyReg")
ind = which(x$key == 'modat_rniftyreg:_2013')
x = x[-ind]
nifty$key = 'modat_rniftyreg:_2013'
auths = nifty$author 
nifty$author = nifty$author[1]
nifty$author = gsub(";.*", "", nifty$author )
auths = gsub(".*;", "", auths)
auths = paste(auths, collapse = " and ")
nifty$title = paste0(nifty$title, ", ", auths)
x = c(x, nifty)
write.bib(entry=x, file= "FSLR.bib")
