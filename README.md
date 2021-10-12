# wxWidgets

## Installation for Visual Studio 2019
Download the source file from [here](https://www.wxwidgets.org/downloads/), Windows ZIP or Windows 7z. Unzip it in the new folder ~\wxWidgets3.1.5, you can add this path to Environment variable call it __WXWIN__ this will be used later.\

Open folder ~\wxWidgets3.1.5\build\msw, find the solution file matches your visual studio version. For example VS2019 should use __wx_vc16.sh__. Open it with Visual Studio, select all and build. this will take a while and the output files would be in ~\wxWidgets3.1.5\lib.\

Now you are ready to start your first project, and I will show you the steps to config the project property: \
1. In the *Project Property - C/C++ - General - Additional Include Directories* add new entries as below(should be in the exactly same order):\
 __&(WXWIN)\include\msvc; $(WXWIN\include)__ check the evalution result and make sure it evaluates the correct path. 
2. In the *Project Property - Linker - General - Additional library Directories* add new entries as below:\
__$(WXWIN)\lib\vs_lib__
3. (optional) if you start with Empty project/Console project, you need to specify the subsystem for the Linker from Console to Windows.
In the *Project Property - Linker - System - Subsystem* and select Windows.

## My First Frame
Add the header files and source files from the ~\src\ folder to your project and run it you should see your first Frame poping up with text "Test"
