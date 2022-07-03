# opusreader2

An improved OPUS binary reader for R that uses the hidden header info for assigning spectral blocks.

This is an improved reader derived from the {opusreader2} by Pierre Roudier and Philipp Baumann. This package resolves one of the main issues, which is the reverse logic of assigining the byte positions of different blocks in the OPUS binaray file. This is known to cause unintended side-effects, which means not 100% of the spectral information is correctly read.
