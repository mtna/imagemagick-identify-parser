import unittest
from ImageMagickIdentifyParser import ImageMagickIdentifyParser


class TestsPDF(unittest.TestCase):
    obj = None

    @classmethod
    def setUp(self):
        if self.obj is None:
            self.obj = ImageMagickIdentifyParser()
            self.obj.parse('./samples/sample.pdf')

    @classmethod
    def tearDown(self):
        pass

    def test_0_pagecount(self):
        d = self.obj.Data
        self.assertEqual(len(d['children']),7,'The PDF has 7 pages')

    def test_1_no_histogram_line_children(self):
        # Make sure HistogramLevel nodes have no children
        noHistoChildren = True
        d = self.obj.Data
        root = d.copy()
        stack = []
        stack.append(root)
        while len(stack) > 0:
            x = stack.pop()
            if x['name'] == self.obj.HISTOGRAM_ELEM and len(x['children']) > 0:
                noHistoChildren = False
                break
            if 'children' in x:
                stack += x['children']

        self.assertEqual(noHistoChildren, True, 'no histogram line nodes have children')

if __name__ == '__main__':
    unittest.main(verbosity=4)

