#' Hyperbolic transform
#'
#' Functions for transforming and back-transforming data using a hyperbolic
#'function.
#'
#' If \code{x} contains missing values, then \code{scale} is computed after
#'omitting the missing values and the output vector has a missing value
#'wherever \code{x} has a missing value.\cr
#'
#'The basic equation for the hyberbolic transform is 1/(1 + (10^\code{factor} * \code{x})/
#'\code{scale}). The basic equation is adjusted to produce fairly consistent values for small changes
#'in \code{factor} and increase for increasing values in \code{x}.\cr
#'
#'The function \code{hyperbolic} computes the forward transform and the
#'function \code{Ihyperbolic} computes the inverse [hyperbolic] transform, or back-transform.
#'
#' @aliases hyperbolic Ihyperbolic
#' @param x a numeric vector to be transformed by \code{hyperbolic} or
#'back-trasnformed by \code{Ihyperbolic}. Must be strictly positive. Missing
#'values are allowed. See \bold{Details}.
#' @param factor the hyperbolic adjustment term in the hyperbolic equation.
#' @param scale the scaling factor for the data.
#' @return A numeric vector of the transformed or back-transformed values in
#'\code{x} with an attribute "scale" of the values used for \code{scale}. The range
#'of the values returned from \code{hyperbolic} is between 0 and 2 times \code{scale}.
#' @note The original hyperbolic transform used a linear factor. The version in
#'these functions uses the common log of the factor to make the factors easier
#'to use.\cr
#'
#'When used with the default value for \code{scale}, \code{factor} values
#'outside the range of +/- 3 have very little effect on the transform.
#' @seealso \code{\link{boxCox}}
#' @references The use of a variable hyperbolic transform to help model the
#'relations between stream water chemistry and flow was first described in:
#'
#'Johnson, N.M., Likens, G.E., Borman, F.H., Fisher, D.W., and Pierce, R.S.,
#'1969, A working model for the variation in stream water chemistry at the
#'Hubbard Brook Experimental Forest, New Hampshire: Water Resources Research,
#'v. 5, no. 6, p. 1353--1363.
#' @keywords manip
#' @examples
#'X.test <- c(1,4,9,16,25,36,49)
#'hyperbolic(X.test) # accept the defaults
#'hyperbolic(X.test, factor=1)
#'hyperbolic(X.test, factor=-1)
#' @export
hyperbolic <- function(x, factor = 0, scale = mean(x, na.rm=TRUE)) {
  ## Coding history:
  ##    2010Mar24 DLLorenz First dated version
  ##    2012Aug17 DLLorenz Allow NAs
  ##    2013Feb02 DLLorenz Prep for gitHub
  ##    2013Jun12 DLLorenz Added class, necessary for safe predictions
  ##    2014Dec12 DLLorenz Modified scaling
  ##
  ## Use common logs for factor--easier to understand
  retval <- 2*scale*(1 - 1/(1 + (10^factor * x)/scale))
  attr(retval, "scale") <- scale
  class(retval) <- "hyperbolic"
  return(retval)
}

#' @rdname hyperbolic
#' @export
Ihyperbolic <- function(x, factor = 0, scale) {
  if(missing(scale)) # get the attribute if scale is missing
    scale <- attr(x, "scale")
  if(missing(scale)) # get the attribute if scale is missing
    scale <- attr(x, "scale")
  retval <- scale*((1 - x/2/scale)^-1 - 1)/(10^factor)
  return(as.vector(retval))
}
