# opusreader2

An improved OPUS binary reader for R that uses the hidden header info for
assigning spectral blocks.

This package has grown out of {opusreader} made by Pierre Roudier and Philipp
Baumann. {opusreder} brought some major improvements, but has one main issue. It
implements quite some reverse engineered logic, that assigns byte offsets to
read different data blocks in the OPUS binary file. As an unintended
side-effect, for some files not 100% of the spectral information is correctly
read.
