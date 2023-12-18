
//Get image name for generic macro
img_name=getTitle();

//Define output variable
output="G:/Microscopy/AllColonisation_Output/"
SYBRinput="G:/Microscopy/AllSYBR/"

//Set gloabl scale
run("Properties...", "pixel_width=0.16129032258 pixel_height=0.16129032258 voxel_depth=0.16129032258 global");

//Image prepocessing
run("RGB Color");
run("Subtract Background...", "rolling=50 light");
run("Smooth");


//Solve for multichannel downstream processing errors
newname= getTitle();
//print(newname); //Retain in case of bugs
if (matches(newname, ".*\\(RGB\\)*")) {

	//print("Sample was multichannelled, and we need to close the original file to avoid processing errors");
	//If samples are triple channeled then we need to run this step too. Otherwise there is no need as it closes the relevant image files too early. - retained in case of bugs
	close(img_name);


} else {
	
	//Info about image status - retained in case of bugs
	//print("Image file was unichannel, so is compatible with further processing");

}


//Rename window for downstream processing
rename(img_name);

if (matches(img_name, ".*CBBG.*")) {

//Image info - retain in case of bugs
//print("Sample is CBBG");

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

} else if (matches(img_name, ".*AlcianBlue.*")) {

//Image info - retain in case of bugs
//print("Sample is AlcianBlue");

//Extract AlcianBlue stained areas
run("Colour Deconvolution2", "vectors=[User values] output=8bit_Transmittance cross hide [r1]=0.8748373 [g1]=0.45782363 [b1]=0.15829495 [r2]=0.00000 [g2]=0.00000 [b2]=0.00000 [r3]=0.00000 [g3]=0.00000 [b3]=0.00000");

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

} else if (matches(img_name, ".*Particle.*")) {

//Image info - retain in case of bugs
//print("Sample is Unstained");

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

} else if (matches(img_name, ".*0point2.*")) {

//Image info - retain in case of bugs
//print("Sample is Unstained and 0point2");

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

}

rename("Brightfield sum " + img_name);

//Count particle areas (stained and unstained) and get measurements
run("Analyze Particles...", "size=5.01-Infinity show=Masks clear summarize");

//Save Display output
saveAs(output + img_name + "OverlayParticles.tiff");

rename("Brightfield " + img_name);









//Manipulate string variable to get matching SYBR name
NameP1 = substring(img_name, 0, indexOf(img_name, "_B"));
//print(test1);
NameP2 = substring(img_name, lastIndexOf(img_name, "_"), lastIndexOf(img_name, "."));
//print(test2);
SYBRName=NameP1 + "_SYBR" + NameP2 + ".tiff";

//Check to make sure file name conversion went smoothly - retained in case of bugs
//print("The original name was " + img_name);
//print("The recombined SYBR name is " + SYBRName);

//Then combine strings and get name

open(SYBRinput + SYBRName);

//Image prepocessing
run("RGB Color");
run("Smooth");
run("Subtract Background...", "rolling=50");

//Convert to black and white and set threshold
run("8-bit");
setAutoThreshold("MaxEntropy dark");
//run("Threshold...");
//setAutoThreshold();
setOption("BlackBackground", false);
run("Convert to Mask");

//Count SYBR stained organisms
run("Analyze Particles...", "size=0-5 show=Masks clear");

rename("SYBR " + img_name);




imageCalculator("AND create", "Brightfield " + img_name, "SYBR " + img_name);

selectWindow("Result of Brightfield " + img_name);

//Count SYBR stained organisms on particles
run("Analyze Particles...", "size=0-5 show=Outlines display clear summarize");

//Save Display output
selectWindow("Drawing of Result of Brightfield " + img_name);
saveAs("Drawing of Result of Brightfield " + img_name, output + img_name + "Colonisation.tiff");

//Close all image windows
close("*");

if (isOpen("Results")) {

selectWindow("Results");
saveAs("Results", output + img_name +"_Results.csv");

} else {

print(img_name + " did not have any colonisation");

}



