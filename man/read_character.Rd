% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_bin_types.R
\name{read_character}
\alias{read_character}
\title{read character from binary}
\usage{
read_character(raw, cursor, n = 1L, n_char, encoding = "latin1")
}
\arguments{
\item{raw}{raw vector}

\item{cursor}{offset}

\item{n}{number of elements}

\item{n_char}{integer with number of desired characters to read from raw}

\item{encoding}{encoding to assign character strings that are read. Default
is \code{"latin1"}., which will use Windows Latin 1 (ANSI) encoding. This is
how Bruker software OPUS is assumed to commonly store strings.}
}
\description{
read character from binary
}
\keyword{internal}
