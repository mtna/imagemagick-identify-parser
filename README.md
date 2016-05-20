# imagemagick-identify-parser

### v1.0-RC1

## Overview
The [ImageMagick](http://imagemagick.org) software suite [`identify`](http://imagemagick.org/script/identify.php) tool, when used with the `-verbose` option, provides comprehensive information about an image. While the resulting text output is clear and concise, it is not particularly well suited for machine consumption.

This Python 2.x`ImageMagickIdentifyParser` utility class can be used to call or parse the `identify -verbose <image>` tool text output and converts it into various formats such as JSON or XML for further reuse by code or applications.

Note that:
*  You will need [ImageMagick](http://imagemagick.org) to be installed on your system in order to use this utility.
*  Multiple [security vulnerabilities](https://imagetragick.com/) were recently reported around the ImageMagick package. Make sure to [read about this](https://imagetragick.com/) and, if relevant, take necessary steps to ensure you operate in a safe environment.

## Install

    sudo apt-get install imagemagick
    pip install --user -r dependencies.txt

## Usage

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


