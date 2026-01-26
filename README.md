# WiNDC.GMS

Notable changes:

1. In `windc_build` the parameter `ys0`, Intermediate_Supply, had domain (sector, commodity, year). This has been changed to (commodity, sector, year) to align with other parameters. The old domain came from the Make table, which is the transpose of the Supply table. 