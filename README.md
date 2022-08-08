# opusreader2

## Scope

This is a universal OPUS binary reader for R. It parses the header for
assigning spectral blocks.

This package has grown out of {opusreader} made by Pierre Roudier and Philipp
Baumann. {opusreader} works, but not for all OPUS files. It
implements a reverse engineered logic, that assigns byte offsets to
read different data blocks in the OPUS binary file. This is not 100% robust and
causes some read failures in edge cases.
