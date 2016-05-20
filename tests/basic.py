import sys
import unittest
from ImageMagickIdentifyParser import ImageMagickIdentifyParser

class TestsPDF(unittest.TestCase):
    obj = None

    @classmethod
    def setUp(self):
        if self.obj is None:
            self.obj = ImageMagickIdentifyParser()
            self.reason_skip_multipage_pdf = self.obj.getIMVersion() in set(['6.8.0-7','6.8.1-5','6.8.1-0','6.8.0-10'])

            self.obj.optHistogram = True
            self.obj.parse('./samples/sample.pdf')
            self.collectData()

    @classmethod
    def tearDown(self):
        pass

    @classmethod
    def collectData(self):
        d = self.obj.Data
        root = d.copy()
        stack = []
        stack.append(root)

        histoChildren = False
        histoNodeCount = 0

        # Traverse the tree to collect data about nodes
        while len(stack) > 0:
            x = stack.pop()
            if x['name'] == self.obj.HISTOGRAM_ELEM:
                histoNodeCount += 1
                if len(x['children']) > 0:
                    histoChildren = True
            if 'children' in x:
                stack += x['children']

        self.histoChildren = histoChildren
        self.histoNodeCount = histoNodeCount

    def test_0_lower_pagecount(self):
        d = self.obj.Data
        self.assertGreaterEqual(len(d['children']),1,'The PDF has at least 1 page')

    def test_1_exact_pagecount(self):

        if self.reason_skip_multipage_pdf:
            raise unittest.SkipTest("skip test because version doesn't support multipage")

        d = self.obj.Data
        self.assertEqual(len(d['children']),7,'The PDF has exactly 7 pages')

    def test_2_histo_at_least_one_node(self):
        self.assertGreater(self.histoNodeCount, 0, 'at least one histogram line node')

    def test_3_histo_exact_node_count(self):
        if self.reason_skip_multipage_pdf:
            raise unittest.SkipTest("skip test because version doesn't support multipage")

        self.assertEqual(self.histoNodeCount, 632, 'exact histo node count')

    def test_4_histo_no_children_for_histogram_nodes(self):
        self.assertEqual(self.histoChildren, False, 'no histogram line nodes have children')

