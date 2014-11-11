rm(list=ls())

library(oro.dicom)
library(oro.nifti)
library(cttools)
rootdir = path.expand("~/Dropbox/FSLR/")
datadir = file.path(rootdir, "data")
dcmdir = file.path(rootdir, "SublimeDicoms")
dirs = list.dirs(path = dcmdir, full.names = TRUE, recursive = FALSE)

idir = 1
for (idir in seq_along(dirs)){
  iddir = dirs[idir]
  id = basename(iddir)
  id = gsub("Sublime", "", id)
  dcm2nii(basedir = iddir, rescale= FALSE)
  niis = list.files(path = iddir, full.names = FALSE, 
                    pattern = ".*[.]nii[.]gz")
  new.files = file.path(datadir, paste0(id, "_", niis))
  file.copy(file.path(iddir, niis), new.files, overwrite = TRUE)
}
