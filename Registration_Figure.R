

## ----echo=FALSE--------------------------------------
rm(list=ls())
library(fslr)
library(plyr)
homedir = path.expand("~/Dropbox/FSLR")
datadir = file.path(homedir, "data")
resdir = file.path(homedir, "figure")



## ----echo = FALSE----------------------------------
# Get Files
mods = c("T1", "T2", "FLAIR", "PD")
# mods = c("T1")
# mods = paste0(mods, "norm")
files = c(outer(
  outer(c("01-", "02-"), 
        c("Baseline_", "Followup_"), 
        paste0),
  paste0(mods, ".nii.gz"),
  paste0))
files = c(sapply(c("Baseline_", "Followup_"), function(x){
  paste0("01-", x, mods, ".nii.gz")
}))
files = file.path(datadir, files)

#### remove .nii.gz extension and use basename
stub = nii.stub(files, bn=TRUE)
bias_files = file.path(datadir, paste0(stub, "_FSL_BiasCorrect"))

imgs = llply(bias_files, readNIfTI, reorient=FALSE, 
             .progress= "text")
names(imgs) = nii.stub(bias_files, bn=TRUE)
modes = gsub("01-", "", names(imgs))
modes = gsub("_FSL.*", "", modes)
modes = gsub("_", " ", modes)

imgs = lapply(imgs, robust_window)
zs = sapply(imgs, nsli)

remake_img = function(img, arr){
  img@dim_[2:4] = dim(arr)
  ### subtract 1 for first observation
  img@.Data = arr
  img
}
imgs = lapply(imgs, function(img) {
	limits = 256/2 + c(-1, 1) * 80
	arr = img[ limits[1]:limits[2], ,]
	remake_img(img, arr)
})


pngs = file.path(resdir, 
	 paste0(nii.stub(bias_files, bn=TRUE), ".png")
	 )
mapply(function(img, mod, pngname){
	dimg = dim(img)
	z = floor(dimg[3]/2)
	png(pngname, type="cairo", height=7, width=6.5, 
		res=600, units= "in")
	image.nifti(robust_window(img), z = z, plot.type="single")
	title(main = mod, col.main= "white", cex.main = 2)
	dev.off()

}, imgs, modes, pngs)



