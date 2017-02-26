PImage src;
PImage res;
PImage img;
int levels = 4;
int factor = 16;
void setup() {
  src = loadImage("1.jpg");  
  res = loadImage("1.jpg");
  img = createImage(src.width, src.height, RGB);
  size(1200, 400, JAVA2D);

  //smooth();
  //noLoop();
  noStroke();
  noSmooth(); 
  //beginRecord(PDF, "canvas.pdf");
}

void draw() {  
  // Init canvas
  background(0, 0, 0);
  // Define step
  int s = 1;
  //factor = round(map(mouseX, 0, width, 1, 20));
  println(factor);
  // Scan image
  src.loadPixels();
  for (int x = 1; x < src.width-1; x+=s) {
    for (int y = 1; y < src.height-1; y+=s) {
      int index = x + y * src.width;
      color oldpixel = src.pixels[index];
      color newpixel = findClosestColor(oldpixel, 8);
      src.pixels[index] = newpixel;
      color quant_error = subColor(oldpixel, newpixel);

      //Floyd Steinberg
      color s1 = src.pixels[(x + s)+ ( y * src.width)];
      src.pixels[(x + s)+ ( y * src.width)] = quantizedColor(s1, quant_error, 7.0/factor);
      color s2 = src.pixels[(x - s)+ ( (y + s)     * src.width)];
      src.pixels[(x - s)+ ( (y + s) * src.width)] = quantizedColor(s2, quant_error, 3.0/factor);
      color s3 = src.pixels[x + ( (y + s) * src.width)];
      src.pixels[x + ( (y + s) * src.width)] = quantizedColor(s3, quant_error, 5.0/factor);
      color s4 = src.pixels[(x + s)+ ((y + s ) * src.width)];
      src.pixels[(x + s)+ ((y + s ) * src.width)] = quantizedColor(s4, quant_error, 1.0/factor);
    }
  }
  src.updatePixels();
  image(res, 0, 0);
  image(src, 400, 0);
  image(img, 800, 0);
}

///find the nearest color////
color findClosestColor(color in, int lev) {

  float r = (in >> 16) & 0xFF;
  float g = (in >> 8) & 0xFF;
  float b = in & 0xFF;
  ///Normalizing the colors///
  levels = lev;
  float norm = 255.0 / levels;
  float nR = round((r / 255) * levels) * norm;
  float nG = round((g / 255) * levels) * norm;
  float nB = round((b / 255) * levels) * norm;
  color newPix = color (nR, nG, nB);
  return newPix;
}

/////subtracting two different colors (a - b)////
color subColor (color a, color b) {

  float r1 = (a >> 16) & 0xFF;
  float g1 = (a >> 8) & 0xFF;
  float b1 = a & 0xFF;

  float r2 = (b >> 16) & 0xFF;
  float g2 = (b >> 8) & 0xFF;
  float b2 = b & 0xFF;

  float r3 = r1 - r2;
  float g3 = g1 - g2;
  float b3 = b1 - b2;

  color c = color(r3, g3, b3);
  return c;
}

/////returns the result between the original color and the quantization error////
color quantizedColor(color c1, color c2, float mult ) {
  
  float r1 = (c1 >> 16) & 0xFF;
  float g1 = (c1>> 8) & 0xFF;
  float b1 = c1 & 0xFF;
  
  float r2 = (c2 >> 16) & 0xFF;
  float g2 = (c2>> 8) & 0xFF;
  float b2 = c2 & 0xFF;
  
  float nR = r1 + mult * r2;
  float nG = g1 + mult * g2;
  float nB = b1 + mult * b2;
  
  color c3 = color (nR, nG, nB);
  return c3;
}