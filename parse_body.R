parse_body = function(file, outfname) {
  x = readLines(file)
  start = grep("\\\\begin\\{\\s*article\\s*\\}", x)
  stopifnot(length(start) > 0)
  x = x[seq(start, length(x))]
  x[1] = gsub("\\\\begin\\{\\s*article\\s*\\}", "", x[1])
  end = grep("\\\\end\\{\\s*article\\s*\\}", x)
  stopifnot(length(end) > 0)  
  x = x[seq(1, end)]
  x[length(x)] = gsub("\\\\end\\{\\s*article\\s*\\}", "", x[length(x)])
  writeLines(x, con= outfname)
  invisible()
}
parse_body("muschelli_FSLR.tex", "muschelli.tex")