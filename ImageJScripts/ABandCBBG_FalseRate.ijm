
//Get image name for generic macro
img_name=getTitle();

//Define output variable
output="G:/Microscopy/AllFalseDiscovery_Output/"

//Set global scale
run("Properties...", "pixel_width=0.16129032258 pixel_height=0.16129032258 voxel_depth=0.16129032258 global");

//Image prepocessing
run("RGB Color");
run("Subtract Background...", "rolling=50 light");
run("Smooth");

//Because the Zeiss program is very old and error prone sometimes it randomly changes the type of .tiff file 
//and either stores the image in one channel, or the three RGB channels. This piece of code removes and renames 
//the multi-channel files to align with the single channels for easier image analysis.
if (isOpen(img_name + " (RGB)")) {
	//Rename window to original file name to remove any (G), or (RGB), etc
	close(img_name);
	rename(img_name);
}


//Only use unstained pictures
if (matches(img_name, ".*Particle.*")) {

//Make duplicates and rename for downstream analysis
selectWindow(img_name);
rename(img_name + " CBBG");
run("Duplicate...", "title=[" + img_name + " AlcianBlue]");

//Start false discovery correction calculation of CBBG stain
print("Testing for CBBG false discovery");
selectWindow(img_name + " CBBG");

//Extract CBBG stained areas
run("Colour Deconvolution2", "vectors=[User values] output=[8bit_Transmittance] simulated [r1]=0.8713357218964636 [g1]=0.43179289993092806 [b1]=0.233085716671803 [r2]=0.0 [g2]=0.0 [b2]=0.0 [r3]=0.0 [g3]=0.0 [b3]=0.0");

//Close superflous windows
close(img_name + " CBBG-(Colour_3)");
close(img_name + " CBBG-(Colour_2)");
selectWindow(img_name + " CBBG-(Colour_1)");

//Use maths for a better threshold
run("Measure");
meanMeasurement = getResult("Mean");
print("Mean measurement is " + meanMeasurement);
run("Max...", "value=" + meanMeasurement);

//Convert to black and white
setAutoThreshold("Default");
//run("Threshold...");
//setAutoThreshold();
setOption("BlackBackground", false);

//Clean up black and white image
run("Convert to Mask");
run("Erode");
run("Dilate");

//Count blue stained areas and get measurements
run("Analyze Particles...", "size=5.01-Infinity show=Outlines display clear summarize");

//Save Display output
selectWindow("Drawing of " + img_name + " CBBG-(Colour_1)");
saveAs("Drawing of " + img_name + " CBBG-(Colour_1)", output + img_name +"CBBGCorrection.tiff");
//saveAs("Drawing of " + img_name + " CBBG-(Colour_1)", "C:/Users/hunefeldt/OneDrive/Desktop/FIJI_Calibration/Brightfield/" + img_name +"CBBGCorrection.tiff");

//Save results in specified directory if it exists
if (isOpen("Results")) {
selectWindow("Results");
//saveAs("Results", "C:/Users/hunefeldt/OneDrive/Desktop/FIJI_Calibration/Brightfield/" + img_name +"_Results.csv");
saveAs("Results", output + img_name +"CBBGCorrection_Results.csv");
//close("Results");
}










//Start false discovery correction calculation of AlcianBlue stain
print("Testing for AlcianBlue false discovery");
selectWindow(img_name + " AlcianBlue");

//Extract AlcianBlue stained areas
run("Colour Deconvolution2", "vectors=[User values] output=8bit_Transmittance cross hide [r1]=0.8748373 [g1]=0.45782363 [b1]=0.15829495 [r2]=0.00000 [g2]=0.00000 [b2]=0.00000 [r3]=0.00000 [g3]=0.00000 [b3]=0.00000");

//Close superflous windows
close(img_name + " AlcianBlue-(Colour_3)");
close(img_name + " AlcianBlue-(Colour_2)");
selectWindow(img_name + " AlcianBlue-(Colour_1)");

//Use maths for a better threshold
run("Measure");
meanMeasurement = getResult("Mean");
print("Mean measurement is " + meanMeasurement);
run("Max...", "value=" + meanMeasurement);

//Convert to black and white
setAutoThreshold("Default");
//run("Threshold...");
//setAutoThreshold();
setOption("BlackBackground", false);

//Clean up black and white image
run("Convert to Mask");
run("Erode");
run("Dilate");

//Count blue stained areas and get measurements
run("Analyze Particles...", "size=5.01-Infinity show=Outlines display clear summarize");

//Save Display output
selectWindow("Drawing of " + img_name + " AlcianBlue-(Colour_1)");
//saveAs("Drawing of " + img_name + " AlcianBlue-(Colour_1)", "C:/Users/hunefeldt/OneDrive/Desktop/FIJI_Calibration/Brightfield/" + img_name +"AlcianBlueCorrection.tif");
saveAs("Drawing of " + img_name + " AlcianBlue-(Colour_1)", output + img_name +"AlcianBlueCorrection.tiff");

//Save results in specified directory if it exists
if (isOpen("Results")) {
selectWindow("Results");
//saveAs("Results", "C:/Users/hunefeldt/OneDrive/Desktop/FIJI_Calibration/Brightfield/" + img_name +"_Results.csv");
saveAs("Results", output + img_name +"AlcianBlueCorrection_Results.csv");
//close("Results");

}
}

//Close all image windows
close("*");