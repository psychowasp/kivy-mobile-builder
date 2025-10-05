from setuptools import setup, Extension
from Cython.Build.Cythonize import cythonize


class CythonExtension(Extension):

    def __init__(self, *args, **kwargs):
        Extension.__init__(self, *args, **kwargs)
        self.cython_directives = {
            'c_string_encoding': 'utf-8',
            'profile': 'USE_PROFILE' in environ,
            'embedsignature': use_embed_signature,
            'language_level': 3,
            'unraisable_tracebacks': True,
        }

setup(name='ios',
version='1.1',
ext_modules=cythonize(
    Extension(
        "*", [
            'ios.pyx', 'ios_utils.m', 'ios_mail.m', 'ios_browser.m',
            'ios_filechooser.m'
        ],
        extra_compile_args=["-ObjC++"]
    )
)
        # Extension('ios',
        #           ['ios.pyx', 'ios_utils.m', 'ios_mail.m', 'ios_browser.m',
        #           'ios_filechooser.m'],
        #           libraries=[],
        #           library_dirs=[],
        #           )
    #]
)
