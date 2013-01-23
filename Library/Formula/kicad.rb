require 'formula'

class Kicad < Formula
  # because bzr is extremely slow this github mirror can be used
  # head 'https://github.com/peabody124/kicad.git'

  # The development testing tree
  devel "http://bazaar.launchpad.net/~kicad-testing-committers/kicad/testing/", :using => :bzr

  # The stable branch
  head "http://bazaar.launchpad.net/~kicad-stable-committers/kicad/stable/", :using => :bzr

  # A selected known working version.  No official packages of source code are released by kicad.
  url "http://bazaar.launchpad.net/~kicad-stable-committers/kicad/stable/", :revision => '3261', :using => :bzr

  homepage 'https://launchpad.net/kicad'
  version 'stable-3261'
  sha1 ''

  depends_on 'cmake' => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on 'wxwidgets'
  depends_on 'kicad-library'

  def patches
    [
    # fixes wx-config not requiring aui module
    "https://gist.github.com/raw/4602653/0e4397884062c8fc44a9627e78fb4d2af20eed5b/gistfile1.txt",
    # enable retina display for OSX
    "https://gist.github.com/raw/4602849/2fe826c13992c4238a0462c03138f4c6aabd4968/gistfile1.txt"
    ]
  end

  def install
    system "cmake", ".", "-DKICAD_STABLE_VERSION=ON -DCMAKE_CXX_FLAGS=-D__ASSERTMACROS__", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps

    # link the kicad binary to bin so it can be launched easily from the command line
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
    # run main kicad UI
    system "kicad"
  end
end
