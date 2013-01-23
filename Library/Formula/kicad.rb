require 'formula'

class Kicad < Formula
  head 'https://github.com/peabody124/kicad.git'
  homepage 'https://launchpad.net/kicad'
  version '0.1'
  sha1 ''

  depends_on 'cmake' => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on 'wxwidgets'

  def patches
    [
    # fixes wx-config not requiring aui module
    "https://gist.github.com/raw/4602653/0e4397884062c8fc44a9627e78fb4d2af20eed5b/gistfile1.txt",
    # enable retina display for OSX
    "https://gist.github.com/raw/4602849/2fe826c13992c4238a0462c03138f4c6aabd4968/gistfile1.txt"
    ]
  end

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    #system "cmake", ".", "-DwxWidgets_CONFIG_EXECUTABLE=/usr/local/bin/wx-config -DwxWidgets_wxrc_EXECUTABLE=/usr/local/bin/wxrc -DKICAD_TESTING_VERSION=ON -DCMAKE_CXX_FLAGS=-D__ASSERTMACROS__", *std_cmake_args
    system "cmake", ".", "-DKICAD_STABLE_VERSION=ON -DCMAKE_CXX_FLAGS=-D__ASSERTMACROS__", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps

    # link the kicad binary to bin
    ln_s prefix+'bin/kicad.app/Contents/MacOS/kicad', bin
  end

  def caveats; <<-EOS.undent
    kicad.app and friends installed to:
      #{prefix}/bin

    To link the application to a normal Mac OS X location:
        brew linkapps
    or:
        ln -s #{prefix}/bin/bitmap2component.app /Applications
        ln -s #{prefix}/bin/cvpcb.app /Applications
        ln -s #{prefix}/bin/eeschema.app /Applications
        ln -s #{prefix}/bin/gerbview.app /Applications
        ln -s #{prefix}/bin/kicad.app /Applications
        ln -s #{prefix}/bin/pcb_calculation.app /Applications
        ln -s #{prefix}/bin/pcbnew.app /Applications
    EOS
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test kicad`.
    system "false"
  end
end
