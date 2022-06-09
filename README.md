# opusreader2

Read OPUS binary files in R using the magic header info.

This is an improved reader derived from the {opusreader2} by Pierre Roudier and Philipp Baumann.
The package resolved one of the main issues, which is the reverse and buggy logic of assigining the byte positions of different blocks in the OPUS binaray file.
