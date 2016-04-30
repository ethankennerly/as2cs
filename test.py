"""
Recursively unit test and doctest subdirectories.
"""
import doctest
import pkgutil
import unittest


def find_modules(path = '.'):
    """
    http://stackoverflow.com/questions/1707709/list-all-the-modules-that-are-part-of-a-python-package
    """
    modules = []
    for importer, modname, ispkg in pkgutil.iter_modules(path):
        module = __import__(modname, fromlist="dummy")
        modules.append(module)
    return modules


class TestDocTests(unittest.TestCase):

    modules = find_modules()

    def doctest(self, mod):
        """
        http://stackoverflow.com/questions/16982514/python-test-discovery-with-doctests-coverage-and-parallelism
        """
        self.assertTrue(doctest.testmod(mod))

    def test_doctests(self):
        for module in self.modules:
            self.doctest(module)


def run_discovered_tests():
    """
    Similar to command line:  python -m unittest discover
    http://stackoverflow.com/questions/1732438/how-to-run-all-python-unit-tests-in-a-directory
    """
    suite = unittest.TestLoader().discover('.')
    unittest.TextTestRunner().run(suite)


if '__main__' == __name__:
    run_discovered_tests()
