# imagemagick-identify-parser

### v1.0.0

## Table of Contents
1. [Overview](#overview)
2. [Install](#install)
2. [Usage](#usage)
3. [iRODS Integration](#irods)
4. [Contribute](#contribute)
5. [License](#license)

<a name="overview"></a>
## Overview
The [ImageMagick](http://imagemagick.org)[`identify`](http://imagemagick.org/script/identify.php) tool, when used with the `-verbose` option, provides comprehensive information about an image. While the resulting text output is comprehensive, it is not particularly well suited for machine consumption and automation.

This Python 2.x`ImageMagickIdentifyParser` utility class can be used to call or parse the `identify -verbose <image>` tool text output and converts it into various formats such as JSON, XML, and iRODS for further integration reuse by code or applications.

See the [samples](samples) folder for examples.

<a name="install"></a>
## Install

*  You will need Python 2.x and [ImageMagick](http://imagemagick.org) to be installed on your system in order to use this utility
*  Be aware that some [security vulnerabilities](https://imagetragick.com/) were recently reported around the ImageMagick package. Make sure to [read about this](https://imagetragick.com/) and, if applicable, take necessary steps ensuring you operate in a safe environment.

```
    sudo apt-get install imagemagick
    pip install --user -r dependencies.txt
```

<a name="usage"></a>
## Usage
You can run the utility directly from the command line by calling `python ImageMagickIdentifyParser.py <options> <filename>` or import/integrate in your own Python scripts.

```
usage: ImageMagickIdentifyParser.py [-h] [--type TYPE] [--histo] filename

ImageMagick identify -verbose parser and convertor

positional arguments:
  filename              The input file

optional arguments:
  -h, --help            show this help message and exit
  --type TYPE, -t TYPE  The output type. Can be json|irods|raw|xml.
  --histo, -H           Includes histogram section in output
```

<a name="irods"></a>
## iRODS Integration
A specialized output format is supported by this utlity to facilitate integration with the [Integrated Rule-Oriented Data System (iRODS)]((http://www.irods.org)), an open source file storage virtualization and management platform. The `-t irods` option generates a `'%'` separated collection of key/value pairs compatible with the [msiString2KeyValPair](https://docs.irods.org/master/doxygen/keyValPairMS_8cpp.html#a91bf18da4b5141987c72b485595d4d87) iRODS [microservice](https://docs.irods.org/master/doxygen/). This string can then be parsed to automatically associate the image extracted properties as metadata for a file stored in iRODS.

The utility is expected to be integrated in a iRODS rule using the the `iExeCmd` microservice. This requires a shell command to be installed in the `server/bin/cmd` directory under your iRODS server root. For example:

```
#!/bin/sh
python /git/imagemagick-identify-parser/ImageMagickIdentifyParser.py -t irods $1
```

The iExecCmd output can be called for example when an image file is added or modified in the repository, and its output processed by msiString2KeyValPair, and the parse metadata attached to the resources using msiSetKeyValuePairsToObj. This is illustrated in the rule code below (e.g. to add to the /etc/irods/core.re file):

```
ON($objPath like "/mtnaZone/demo/images\*.dcm" 
   || $objPath like "/mtnaZone/demo/images\*.gif"
   || $objPath like "/mtnaZone/demo/images\*.jpg"
   || $objPath like "/mtnaZone/demo/images\*.jpeg"
   || $objPath like "/mtnaZone/demo/images\*.png"
   || $objPath like "/mtnaZone/demo/images\*.psd"
   || $objPath like "/mtnaZone/demo/images\*.tif"
   || $objPath like "/mtnaZone/demo/images\*.tiff"
   {
   *metaPath = $objPath;
   *path = $filePath;
   # call indentify.sh command
   msiExecCmd("identify.sh", *path, "null", "null", "null", *result);
   # retrieve output
   msiGetStdoutInExecCmdOut(*result,*out);
   # parse into key value pairs
   msiString2KeyValPair(*out, *kvp);
   writeKeyValPairs("stdout", *kvp,"=");
   # set metadata on object
   msiGetObjType(*metaPath, *objType);
   msiSetKeyValuePairsToObj(*kvp, *metaPath, *objType);
   writeLine("stdout","added metadata *out to object with path *metaPath");
  }
```

<a name="contribute"></a>
## Contribute
Putting this product together and maintaining the repository takes time and resources. We appreciate your support in any shape or form, in particular:

* Let us know is you find any discrepancy or have suggestions towards enhancing the content or quality of the tool
* Donations are appreciated and can be made through [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=GKAYVJSBLN92E)
* Contact us if you would like to fund this work and optionally be credited as a sponsor
* Consider using our [services, products, or expertise](http://www.mtna.us)

<a name="license"></a>
## License
This work is licensed under the [BSD-3 License](https://opensource.org/licenses/BSD-3-Clause). See [LICENCE](LICENSE) file for details.
