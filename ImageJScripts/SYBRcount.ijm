
//Get image name for generic macro
img_name=getTitle();

output="G:/Microscopy/AllSYBR_Output/"


//Set global scale
run("Properties...", "pixel_width=0.16129032258 pixel_height=0.16129032258 voxel_depth=0.16129032258 global");


//Image prepocessing
run("RGB Color");
run("Smooth");
run("Subtract Background...", "rolling=50");

//Rename window to original file name to remove any (G), or (RGB), etc
rename(img_name);

//Convert to black and white and set threshold
run("8-bit");
setAutoThreshold("MaxEntropy dark");
//run("Threshold...");
//setAutoThreshold();
setOption("BlackBackground", false);
run("Convert to Mask");

//Count particles (sized to organisms) and get measurements
run("Analyze Particles...", "size=0.2-5 show=Outlines display clear summarize");

//Save Display output 
selectWindow("Drawing of " + img_name);
saveAs("Drawing of " + img_name, output + img_name +"New.tif");
//saveAs("Drawing of " + img_name + " (RGB)", output + img_name +"New.tiff");

//Close all image windows
close("*");

//Save results in specified directory if it exists
if (isOpen("Results")) {
selectWindow("Results");
saveAs("Results", output + img_name +"_Results.csv");
//saveAs("Results", "C:/Users/hunefeldt/OneDrive/Desktop/FIJI_Calibration/SYBR/" + img_name +"_CBBG_Results.csv");
//close("Results");
//}
