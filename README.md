# opusreader2

Read OPUS binary files in R using the hidden header info.

This is an improved reader derived from the {opusreader2} by Pierre Roudier and Philipp Baumann.
This package resolves one of the main issues, which is the reverse and buggy logic of heuristically finding the byte positions of different blocks in the OPUS binary file.
