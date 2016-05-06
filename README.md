# imagemagick-identify-parser

### v0.9-beta

## Overview
The [ImageMagick](http://imagemagick.org) software suite [`identify`](http://imagemagick.org/script/identify.php) tool, when used with the `-verbose` option, provides comprehensive information about an image. While the resulting text output is clear and easy to read, it is not particularly well suited for machine consumption.

This simple Python `ImageMagickIdentifyParser` utility class can be used to call or parse the `identify -verbose <image>` tool text output and converts it into JSON or XML for further reuse by code or applications.

Note that you will need ImageMagick to be installed on your system in order to use this utility. 

## Usage

```
usage: ImageMagickIdentifyParser.py [-h] [--type TYPE] filename

ImageMagick identify -verbose parser and convertor

positional arguments:
  filename              The input file

optional arguments:
  -h, --help            show this help message and exit
  --type TYPE, -t TYPE  The type of output. Can be json|irods|raw|xml.
```