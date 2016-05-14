import sys
import unittest
from ImageMagickIdentifyParser import ImageMagickIdentifyParser

class TestsRegex(unittest.TestCase):
    HISTO_LINES = [
            "30489: (  385,  385,  385) #018101810181 gray(0.587472%,0.587472%,0.587472%)",
            "16680: (  128,  128,  128) #008000800080 gray(0.195315%)",
            "5672: (    0,    0,    0,65535) #000000000000 black",
            ]
    obj = None

    @classmethod
    def setUp(self):
        if self.obj is None:
            self.obj = ImageMagickIdentifyParser()

    @classmethod
    def tearDown(self):
        pass

    def test_0_histo_lines_match(self):
        # all test histogram lines must match the regexp for histogram lines
        for h in self.HISTO_LINES:
            self.assertRegexpMatches(h, self.obj.RE_LINE_HISTO, 'line matches histo regexp')

    def test_1_histo_lines_regex(self):
        d = self.obj.parseLineHisto(self.HISTO_LINES[0],1)
        self.assertEqual(d['count'], '30489', 'histo-line: count extracted')
        self.assertEqual(d['hexval'], '018101810181', 'histo-line: count extracted')
        self.assertEqual(d['colors'], [385, 385, 385], 'histo-line: colors extracted')
        self.assertEqual(d['percentages'], [0.587472,0.587472,0.587472], 'histo-line: percentages extracted')
        self.assertEqual(d['colorSpace'], 'gray', 'histo-lines: colorspace extracted')

    def test_2_histo_lines_regex(self):
        d = self.obj.parseLineHisto(self.HISTO_LINES[1],1)
        self.assertEqual(d['colors'], [128,128,128], 'histo-line: colors extracted')
        self.assertEqual(d['percentages'], [0.195315], 'histo-line: percentages extracted')

    def test_3_histo_lines_regex(self):
        d = self.obj.parseLineHisto(self.HISTO_LINES[2],1)
        self.assertEqual(d['percentages'], None, 'histo-line: percentages extracted')
        self.assertEqual(d['colorSpace'], 'black', 'histo-lines: colorspace extracted')

