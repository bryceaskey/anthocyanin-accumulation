# Function for color space conversion from sRGB to HSV, YIQ, YCbCr, or L*a*b*
# sRGBpixels is dataframe of all leaf pixels in an image in the sRGB color space, and the desired output color space
# Available color spaces: HSV, YIQ, YCbCr, and L*a*b*

convertColorSpace <- function(sRGBpixels, outputColorSpace){
  
  # sRGB to HSV
  if(outputColorSpace == "HSV"){
    H <- vector(mode="numeric", length=nrow(sRGBpixels))
    S <- vector(mode="numeric", length=nrow(sRGBpixels))
    V <- vector(mode="numeric", length=nrow(sRGBpixels))
    for(i in 1:nrow(sRGBpixels)){
      sRGBpixel <- sRGBpixels[i, ]
      HSVpixel <- rgb2hsv(sRGBpixel[[1]], sRGBpixel[[2]], sRGBpixel[[3]], maxColorValue=1) #use built in function for conversion
      H[i] <- HSVpixel[1]
      S[i] <- HSVpixel[2]
      V[i] <- HSVpixel[3]
    }
  output <- data.frame(H, S, V, stringsAsFactors=FALSE)
  }
  
  # sRGB to YIQ
  else if(outputColorSpace == "YIQ"){ 
    Y <- vector(mode="numeric", length=nrow(sRGBpixels))
    I <- vector(mode="numeric", length=nrow(sRGBpixels))
    Q <- vector(mode="numeric", length=nrow(sRGBpixels))
    for(i in 1:nrow(sRGBpixels)){
      sRGBpixel <- sRGBpixels[i, ]
      Y[i] <- 0.299*sRGBpixel$R + 0.587*sRGBpixel$G + 0.114*sRGBpixel$B
      I[i] <- 0.5959*sRGBpixel$R + -0.2746*sRGBpixel$G + -0.3213*sRGBpixel$B
      Q[i] <- 0.2115*sRGBpixel$R + -0.5227*sRGBpixel$G + 0.3112*sRGBpixel$B
    }
  output <- data.frame(Y, I, Q, stringsAsFactors=FALSE)
  }
  
  # sRGB to YCbCr
  else if (outputColorSpace == "YCbCr"){
    Y <- vector(mode="numeric", length=nrow(sRGBpixels))
    Cb <- vector(mode="numeric", length=nrow(sRGBpixels))
    Cr <- vector(mode="numeric", length=nrow(sRGBpixels))
    for(i in 1:nrow(sRGBpixels)){
      sRGBpixel <- (sRGBpixels[i, ])*255
      Y[i] <- 0.299*sRGBpixel$R + 0.587*sRGBpixel$G + sRGBpixel$B
      Cb[i] <- -0.1687*sRGBpixel$R + -0.3313*sRGBpixel$G + 0.5*sRGBpixel$B + 128
      Cr[i] <- 0.5*sRGBpixel$R + -0.4187*sRGBpixel$G + -0.0813*sRGBpixel$B + 128
    }
  output <- data.frame(Y, Cb, Cr, stringsAsFactors=FALSE)
  }
  
  # sRGB to L*a*b*
  else{
    L <- vector(mode="numeric", length=nrow(sRGBpixels))
    a <- vector(mode="numeric", length=nrow(sRGBpixels))
    b <- vector(mode="numeric", length=nrow(sRGBpixels))
    for(i in 1:nrow(sRGBpixels)){
      sRGBpixel <- sRGBpixels[i, ]
      Labpixel <- as.numeric(convertColor(sRGBpixel, from="sRGB", to="Lab")) #use built in function for conversion
      L[i] <- Labpixel[[1]]
      a[i] <- Labpixel[[2]]
      b[i] <- Labpixel[[3]]
    }
  output <- data.frame(L, a, b, stringsAsFactors=FALSE)
  }
  
  return(output)
}