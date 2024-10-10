
library(EJAM)
library(pins)

localboard = pins::board_folder(here::here("pkgdown/assets/pins"))


allvarnames = c("blockwts", "blockpoints", "blockid2fips", "quaddata", "bgej",
"bgid2fips", "frs", "frs_by_programid", "frs_by_naics", "frs_by_sic",
"frs_by_mact")

varnames <- allvarnames

####################################### #
## check data objects already loaded, or get them from local folder or even the posit connect server pins board ####
x = EJAM::dataload_from_pins(varnames = 'all', justchecking = TRUE)
EJAM::dataload_from_pins(varnames = 'all', folder_local_source = file.path(.libPaths()[1],'EJAM','data'))

web_board <- board_url('https://ejanalysis.github.io/ejscreendata/pins/')
pin_read(web_board, 'bgid2fips')

dl <- pin_download(web_board, 'bgid2fips')
arrow::read_ipc_file(dl)

arrow::write_ipc_file(bgid2fips, sink='pkgdown/assets/pins/bgid2fips/20240930T032500Z-04aae/bgid2fips.arrow',compression='zstd')
bgid2fips_zstd <- arrow::read_ipc_file('pkgdown/assets/pins/bgid2fips/20240930T032500Z-04aae/bgid2fips.arrow')

capture.output({
meta <- EJAM:::metadata_add(0)
})
meta <- list(
  date_pins_updated = c(pinsUploadDate = as.character(Sys.Date())),
  # redundant - created date already stored by pins but ok
  ejscreen_version = attr(meta, "ejscreen_version")  # from the default value in metadata_add
)

pin_name = metadata4pins$name[metadata4pins$varlist == varnames[1]]
pin_title = metadata4pins$title[metadata4pins$varlist == varnames[1]]
pin_description = metadata4pins$description[metadata4pins$varlist == varnames[1]]

pin_write(board = localboard, bgid2fips_zstd, name='bgid2fips',type='arrow', title=pin_title, description=pin_description, metadata = meta)
pin_read(localboard, 'bgid2fips')

localboard %>% write_board_manifest()

pkgdown::build_site()
