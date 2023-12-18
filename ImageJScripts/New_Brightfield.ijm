
//Get image name for generic macro
img_name=getTitle();

//Define output variable
output="G:/Microscopy/AllBrightfield_Output/"

//Set global scale
run("Properties...", "pixel_width=0.16129032258 pixel_height=0.16129032258 voxel_depth=0.16129032258 global");

//Image prepocessing
run("RGB Color");
run("Subtract Background...", "rolling=50 light");
run("Smooth");


//Solve for multichannel downstream processing errors
newname= getTitle();
print(newname);
if (matches(newname, ".*\\(RGB\\)*")) {

	//print("Sample was multichannelled, and we need to close the original file to avoid processing errors"); //Retained in case of bugs
	//If samples are triple channeled then we need to run this step too. Otherwise there is no need as it closes the relevant image files too early.
	close(img_name);


} else {

	//print("Image file was unichannel, so is compatible with further processing"); //Retained in case of bugs

}

//Rename window for downstream processing
rename(img_name);

if (matches(img_name, ".*CBBG.*")) {

//print("Sample is CBBG"); //Retained in case of bugs

//Extract CBBG stained areas
run("Colour Deconvolution2", "vectors=[User values] output=[8bit_Transmittance] simulated [r1]=0.8713357218964636 [g1]=0.43179289993092806 [b1]=0.233085716671803 [r2]=0.0 [g2]=0.0 [b2]=0.0 [r3]=0.0 [g3]=0.0 [b3]=0.0");

//Close superflous windows
close(img_name + "-(Colour_3)");
close(img_name + "-(Colour_2)");
selectWindow(img_name + "-(Colour_1)");

//Use maths for a better threshold
run("Measure");
meanMeasurement = getResult("Mean");
//print("Mean measurement is " + meanMeasurement); //Retained in case of bugs
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
selectWindow("Drawing of " + img_name + "-(Colour_1)");
saveAs("Drawing of " + img_name + "-(Colour_1)", output + img_name + "New.tif");


} else if (matches(img_name, ".*AlcianBlue.*")) {

//print("Sample is AlcianBlue"); //Retained in case of bugs

//Extract AlcianBlue stained areas
run("Colour Deconvolution2", "vectors=[User values] output=8bit_Transmittance cross hide [r1]=0.8748373 [g1]=0.45782363 [b1]=0.15829495 [r2]=0.00000 [g2]=0.00000 [b2]=0.00000 [r3]=0.00000 [g3]=0.00000 [b3]=0.00000");
//run("Colour Deconvolution2", "vectors=[User values] output=[8bit_Transmittance] cross hide [r1]=0.9422296890818298 [g1]=0.2838329993514928 [b1]=0.17788209997606255 [r2]=0.0 [g2]=0.0 [b2]=0.0 [r3]=0.0 [g3]=0.0 [b3]=0.0");

//Close superflous windows
close(img_name + "-(Colour_2)");
close(img_name + "-(Colour_3)");
selectWindow(img_name + "-(Colour_1)");

//Use maths for a better threshold
run("Measure");
meanMeasurement = getResult("Mean");
//print("Mean measurement is " + meanMeasurement); //Retained in case of bugs
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
selectWindow("Drawing of " + img_name + "-(Colour_1)");
saveAs("Drawing of " + img_name + "-(Colour_1)", output + img_name + "New.tif");


} else if (matches(img_name, ".*Particle.*")) {

//print("Sample is Unstained"); //Retained in case of bugs

run("Duplicate...", "title=Mean-min");

//Use maths for a better threshold
run("Measure");
meanMeasurement = getResult("Mean");
//print("Mean measurement is " + meanMeasurement); //Retained in case of bugs
run("Min...", "value=" + meanMeasurement);
imageCalculator("Difference create", img_name, "Mean-min");

//Convert to black and white and set threshold
run("8-bit");
setAutoThreshold("Triangle dark");
//run("Threshold...");
//setAutoThreshold();
setOption("BlackBackground", false);

//Clean up black and white image
run("Convert to Mask");

//Count particles and get measurements
run("Analyze Particles...", "size=5.01-Infinity show=Outlines display clear summarize");

//Save Display output
selectWindow("Drawing of Result of " + img_name);
saveAs("Drawing of Result of " + img_name, output + img_name + "New.tiff");

} else if (matches(img_name, ".*0point2.*")) {

//print("Sample is Unstained and 0point2"); //Retained in case of bugs

run("Duplicate...", "title=Mean-min");

//Use maths for a better threshold
run("Measure");
meanMeasurement = getResult("Mean");
//print("Mean measurement is " + meanMeasurement); //Retained in case of bugs
run("Min...", "value=" + meanMeasurement);
imageCalculator("Difference create", img_name, "Mean-min");

//Convert to black and white and set threshold
run("8-bit");
setAutoThreshold("Triangle dark");
//run("Threshold...");
//setAutoThreshold();
setOption("BlackBackground", false);

//Clean up black and white image
run("Convert to Mask");

//Count particles and get measurements
run("Analyze Particles...", "size=5.01-Infinity show=Outlines display clear summarize");

//Save Display output
selectWindow("Drawing of Result of " + img_name);
saveAs("Drawing of Result of " + img_name, output + img_name + "New.tiff");

}

//Close all image windows
//close("*");

//Save results in specified directory if it exists
if (isOpen("Results")) {
selectWindow("Results");
//saveAs("Results", "D:/Reordered_2021.07/Brightfield/" + img_name +"_Results.csv");
saveAs("Results", output + img_name +"_Results.csv");
//close("Results");
} else {

print(img_name + " did not have any colonisation");

}

