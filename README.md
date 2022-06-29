# opusreader2

An improved OPUS binary reader for R that uses the hidden header info for assigning spectral blocks.

This package is an improved version of {opusreader} by Pierre Roudier and Philipp Baumann.
This package resolves one of the main issues, which is the reverse and buggy logic of heuristically finding the byte positions of different blocks in the OPUS binary file.
