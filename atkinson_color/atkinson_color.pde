PImage src;
PImage res;
PImage img;
float levels = 4;
float num = 0;
float factor = 3.5;
color blue  = color(0, 0, 255);
color green = color(0, 255, 0);
void setup() {
  src = loadImage("2.jpg");  
  res = loadImage("2.jpg");
  img = createImage(src.width, src.height, RGB);
  size(1200, 400, JAVA2D);

  //smooth();
  noLoop();
  noStroke();
  noSmooth(); 
  //beginRecord(PDF, "canvas.pdf");
  //src.loadPixels();
  //for (int y = 0; y<src.height; y++) {
  //  for (int x = 0; x<src.width; x++) {
  //    int index = x + y * src.width;
  //    float inc = map(index, 0, src.width*src.height, 0, 1);
  //    color c = lerpColor(blue, green, inc);
  //    src.pixels[index] = c;
  //    res.pixels[index] = c;
  //  }
  //}
  //src.updatePixels();
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
  for (int x = 2; x < src.width-2; x+=s) {
    for (int y = 2; y < src.height-2; y+=s) {
      int index = x + y * src.width;
      color oldpixel = src.pixels[index];
      color newpixel = findClosestColor(oldpixel, 1);
      src.pixels[index] = newpixel;
      color quant_error = subColor(oldpixel, newpixel);

      //Atkinson
      color s1 = src.pixels[(x + s)+ ( y * src.width)];
      src.pixels[(x + s)+ ( y * src.width)] = quantizedColor(s1, quant_error, 1.0 / factor);
      
      color s2 = src.pixels[(x - s)+ ( (y + s)     * src.width)];
      src.pixels[(x - s)+ ( (y + s) * src.width)] = quantizedColor(s2, quant_error, 1.0 / factor);
      
      color s3 = src.pixels[x + ( (y + s) * src.width)];
      src.pixels[x + ( (y + s) * src.width)] = quantizedColor(s3, quant_error, 1.0 / factor);
      
      color s4 = src.pixels[(x + s)+ ((y + s ) * src.width)];
      src.pixels[(x + s)+ (y * src.width)] = quantizedColor(s4, quant_error, 1.0 / factor);
      
      color s5 = src.pixels[(x + (2 * s)) + (y  * src.width)];
      src.pixels[(x + (2 * s)) + ( y * src.width)] = quantizedColor(s5, quant_error, 1.0 / factor);
      
      color s6 = src.pixels[x + ((y + (2 * s) ) * src.width)];
      src.pixels[x + ((y + (2 * s) ) * src.width)] = quantizedColor(s6, quant_error, 1.0 / factor);
      
      float b = brightness(newpixel);
      int bwPix = b < 127 ? 0 : 255;
      img.pixels[index] = color(bwPix);
    }
  }
  src.updatePixels();
  image(res, 0, 0);
  image(src, 400, 0);
  image(img, 800, 0);
}

void keyPressed() {
  switch(key) {
    case('s'):
    String date = new java.text.SimpleDateFormat("yyyy_MM_dd_kkmmss").format(new java.util.Date ());
    saveFrame("dithering"+date+".jpg");
  }
}

///find the nearest color////
color findClosestColor(color in, float lev) {

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