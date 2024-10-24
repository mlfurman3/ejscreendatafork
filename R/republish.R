
republish <- function() {

  donow <- askYesNo("Update metadata first, if relevant!\nSee source package data-raw folder for details.\nPUBLISH NOW?")
  if (is.na(donow)) {cat("halted\n")} else {
    if (donow) {
      cat("\n\nDoing pkgdown::build_site() now ... \n\n")
      pkgdown::build_site()
    }
  }

}
