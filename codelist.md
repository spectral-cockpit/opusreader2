# Codelist according to ono:

according to brukeropusreader:
  cursor <- 24

## text type

p1 = cursor + 2
p2 = cursor + 3

  - 8: 'Info Block'
  - 104: 'History'
  - 152: 'Curve Fit'
  - 168: 'Signature'
  - 240: 'Integration Method'
  - else: 'Text Information'
  
## data type

p1 = cursor
p2 = cursor + 1

  - 0
  - 7
  - 11
  - 15
  - 23
  - 27
  - 31
  - 32
  - 40
  - 48
  - 56
  - 64
  - 72
  - 96
  - 104
  - 160
  
## channel type
  
p1 = cursor + 1
p2 = cursor + 2
  
  - 4
  - 8
  - 12
  
## chunk size

p1 = cursor + 4
p2 = cursor + 8

## read offset

p1 = cursor + 8
p2 = cursor + 12

## read chunk

p1 = block_meta.offset
p2 = p1 + 4 * block_meta.chunk_size



HEADER_LEN = 504
UNSIGNED_INT = "<I"
UNSIGNED_CHAR = "<B"
UNSIGNED_SHORT = "<H"
INT = "<i"
DOUBLE = "<d"
NULL_BYTE = b"\x00"
NULL_STR = "\x00"
FIRST_CURSOR_POSITION = 24
META_BLOCK_SIZE = 12
ENCODING_LATIN = "latin-1"
ENCODING_UTF = "utf-8"
PARAM_TYPES = {0: "int", 1: "float", 2: "str", 3: "str", 4: "str"}
