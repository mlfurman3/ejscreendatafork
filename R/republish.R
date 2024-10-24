
republish <- function() {

  donow <- askYesNo(
    "To publish new files in pkgdown assets but not data\nin pins, do init_site() not this.\nUpdate metadata first, if relevant!\nSee source package data-raw folder for details.\nPUBLISH NOW?")
  if (is.na(donow)) {cat("halted\n")} else {
    if (donow) {
      cat("\n\nDoing pkgdown::build_site() now ... \n\n")
      pkgdown::build_site()
    }
  }

}
