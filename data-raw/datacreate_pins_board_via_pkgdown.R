
# https://pins.rstudio.com/articles/using-board-url.html#publishing-platforms
# https://pins.rstudio.com/articles/using-board-url.html

# Using pkgdown, any files you save in the directory pkgdown/assets/ will be copied to the website’s root directory when pkgdown::build_site() is run.
#
# The R Packages book suggests using a folder called data-raw for working with datasets; this can be adapted to use pins. You would start with usethis::use_data_raw(). In a file in your /data-raw directory, wrangle and clean your datasets in the same way as if you were going to use usethis::use_data(). To offer such datasets on a web-based board instead of as a built-in package dataset, in your /data-raw file you would:
#
# - Create a board: board_folder(here::here("pkgdown/assets/data"))
#
# - Write your datasets to the board using pin_write().
#
# - At the end, call write_board_manifest().
#After writing pins but before publishing, call write_board_manifest():

# board %>% write_board_manifest()
# #> Manifest file written to root folder of board, as `_pins.yaml`
# The maintenance of this manifest file is not automated; it is your responsibility as the board publisher to keep the manifest up to date.
#
# Let’s confirm that there is a file called _pins.yaml:
#
#   withr::with_dir(board$path, fs::dir_ls())
# #> _pins.yaml mtcars

# Now when you build your pkgdown site and serve it (perhaps via GitHub Pages at a URL like
#   https://ejanalysis.github.io/ejscreendata/), your datasets are available as pins.
#
# The R Packages book offers this observation on CRAN and package data:
#
#   Generally, package data should be smaller than a megabyte - if it’s larger you’ll need to argue for an exemption.
#
# Publishing a board on your pkgdown site provides a way to offer datasets too large for CRAN or extended versions of your data.
# A consumer can read your pins by setting up a board like:
#
#   board <- board_url("https://ejanalysis.github.io/ejscreendata/data/")

# Setup ####

library(usethis)
library(pins)
library(pkgdown)
library(EJAM) # once it is public...
# see https://usepa.github.io/EJAM/articles/1_installing.html

## did once already - only need to do it once ever ####

  # pkgdown::use_pkgdown()
  # usethis::use_data_raw()
  # file.remove("./data-raw/DATASET.R")

############################################################# #

## CREATE A LOCAL PINS BOARD

if (!dir.exists(here::here("pkgdown/assets/pins"))) {
  dir.create(here::here("pkgdown/assets/pins"))
}
# local pins board will be in pkgdown/assets/data ####
cat('creating a local folder as a pins board, in a folder that will get published to a github pages pkgdown website\n')
localboard = pins::board_folder(here::here("pkgdown/assets/pins"))

############################################################# #

# Prepare to put files there

####################################### #
####################################### #

# WHICH FILES ? ####

# eval(  formals('dataload_from_pins')$varnames[[2]] )
# dput( eval(  formals('dataload_from_pins')$varnames[[2]] ))
# c("blockwts", "blockpoints", "blockid2fips", "quaddata", "bgej",
#   "bgid2fips", "frs", "frs_by_programid", "frs_by_naics", "frs_by_sic",
#   "frs_by_mact")

allvarnames = c("blockwts", "blockpoints", "blockid2fips", "quaddata", "bgej",
             "bgid2fips", "frs", "frs_by_programid", "frs_by_naics", "frs_by_sic",
             "frs_by_mact")
varnames <- allvarnames

####################################### #
## check data objects already loaded, or get them from local folder or even the posit connect server pins board ####
# x = EJAM::dataload_from_pins(varnames = 'all', justchecking = TRUE)
# if (is.null(x)) {
#   warning('lack access to pins board - might be able to get data from local copies but should confirm version is identical')
# }
# ## if not in globalenv already, get from local folder or pins connect server if not local
# EJAM::dataload_from_pins("all")
# ## confirm now all are in memory
# for (i in 1:length(varnames)) {
#   if (i == 1) {cat("\n\n")}
#   oname = varnames[i]
#   if (!exists(oname)) {stop(oname, ' not found')} else {cat(oname, '\n')}
#   if (i == length(varnames)) {cat("... all found. \n\n")}
# }
####################################### #

# metadata for pins board ####

# excerpted from  datawrite_to_pins()

### this is the metadata already inside each object (each dataset)
## we are checking the ejscreen_version info here:
# capture.output({
#   meta <- EJAM:::metadata_add(0)
# })
# # print(meta)
# 
# ### this is the metadata to write to the pins board:
# ###  A list containing additional metadata to store with the pin.
# ###  When retrieving the pin, this will be stored in the user key, to avoid potential clashes with the metadata that pins itself use.
# meta <- list(
#   date_pins_updated = c(pinsUploadDate = as.character(Sys.Date())),
#   # redundant - created date already stored by pins but ok
#   ejscreen_version = attr(meta, "ejscreen_version")  # from the default value in metadata_add
# )
# print(meta)
####################################### ######################################## #
####################################### ######################################## #
####################################### ######################################## #


# WRITE TO LOCAL PINS BOARD ####


# excerpted from  datawrite_to_pins()

# test for 1 first
# varnames = varnames[1]
# varnames = "bgid2fips"
# 
# for (i in seq_along(varnames)) {
# 
#   if (!exists(varnames[i])) {
#     warning(paste0("Cannot find ", varnames[i], " so it was not saved to pins."))
#   } else {
#     cat("pinning", varnames[i], "\n")
# 
#     if (varnames[i] %in% metadata4pins$varlist) {
#       pin_name = metadata4pins$name[metadata4pins$varlist == varnames[i]]
#       pin_title = metadata4pins$title[metadata4pins$varlist == varnames[i]]
#       pin_description = metadata4pins$description[metadata4pins$varlist == varnames[i]]
#     } else {
#       pin_name = varnames[i]
#       pin_title = varnames[i]
#       pin_description = varnames[i]
#     }
# 
#     type = "qs"
# 
#     text_to_do <- paste0("pins::pin_write(",
#                          "board = localboard, ",
#                          "x = ", varnames[i],", ",
#                          "name = pin_name, ",
#                          "title = pin_title, ",
#                          "description = pin_description, ",
#                          # "versioned = TRUE, ",               # unlike datawrite_to_pins() versioning here would be done via a manifest probably
#                          "metadata = meta, ",
#                          "type = type ",
#                          # "access_type = access_type",   # not used by pin_write for a local board?
#                          ")"
#     )
#     # NOT via datawrite_to_pins() which was coded to write to a connect server, not to a local board (a folder)
# 
#     cat(" ", text_to_do, '\n')
#     x <- eval(parse(text = text_to_do))
#     # executes the command with unquoted string that is the varnames[i] element, e.g., frs
#     rm(x)
#   }
# }
# rm( pin_name, pin_description, pin_title, i, type) # board, meta  may be used again
####################################### #

localboard %>% pin_write(mtcars, type='qs')

# WRITE MANIFEST every time files are updated/added, BEFORE PUBLISHING board ####

localboard %>% write_board_manifest()

## to check the yaml file created
# fs::path(localboard$path, "_pins.yaml") %>% readLines() %>% cat(sep = "\n")
####################################### #

#   have to do manifest and this step again if updated datasets/manifest
# because it copies dataset and manifest etc into the docs folder that you then commit/push to trigger gh action
# PUBLISH updated pages including data pins  ####

###
   # pkgdown::build_site()

# COMMIT AND PUSH CHANGES ####
cat('commit changes and push to github now, then automatic republishing takes maybe 30 seconds after that \n')

# AND

# browseURL("https://github.com/ejanalysis/ejscreendata/actions")
# browseURL("https://github.com/ejanalysis/ejscreendata/settings/pages")
# browseURL("https://ejanalysis.github.io/ejscreendata/")

####################################### ######################################## #
####################################### ######################################## #
####################################### ######################################## #
####################################### ######################################## #


# HOW TO READ THOSE PINS NOW ####


# With an up-to-date manifest file, a board_url() can behave as a read-only version of a board_folder().

# library(pins)
# 
# gurl <- "https://ejanalysis.github.io/ejscreendata/data/"
# # OR IS IT THIS:   ??
# # 'https://ejanalysis.github.io/ejscreendata/pins/'
# 
# gboard  <- pins::board_url(gurl)
# 
# gboard  %>% pins::pin_list()
# # gboard  %>% pins::pin_search()
# # gboard %>% pins::pin_read("bgid2fips")
# 
# library(EJAM)
# EJAM::dataload_from_urlpins("bgid2fips", justchecking = TRUE)
# 
# EJAM::dataload_from_urlpins("bgid2fips")


####################################### ######################################## #

### OLDER NOTES:   tried a few ways to use public pins...
#
# ## pin_download and read ipc ? ####
# dl <- pin_download(gboard, 'bgid2fips')
# arrow::read_ipc_file(dl)
#
# ## write_ipc? ####
# arrow::write_ipc_file(bgid2fips, sink = 'pkgdown/assets/pins/bgid2fips/20240930T032500Z-04aae/bgid2fips.arrow',compression = 'zstd')
#
# ## read_ipc? ####
# bgid2fips_zstd <- arrow::read_ipc_file('pkgdown/assets/pins/bgid2fips/20240930T032500Z-04aae/bgid2fips.arrow')
