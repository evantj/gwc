#!/bin/sh

# Purpose: 	set up the runtime environment and run GWC (adapted from GIMP)

echo "Setting up environment..."

if test "x$GTK_DEBUG_LAUNCHER" != x; then
    set -x
fi

if test "x$GTK_DEBUG_GDB" != x; then
    EXEC="gdb --args"
else
    EXEC=exec
fi

name=`basename "$0"`
tmp="$0"
tmp=`dirname "$tmp"`
tmp=`dirname "$tmp"`
bundle=`dirname "$tmp"`
bundle_contents="$bundle"/Contents
bundle_res="$bundle_contents"/Resources
bundle_lib="$bundle_res"/lib
bundle_bin="$bundle_res"/bin
bundle_data="$bundle_res"/share
bundle_etc="$bundle_res"/etc

export DYLD_LIBRARY_PATH="$bundle_lib"
#it could be useful to set some XDG environment variables - by default gwc uses ~/.cache and ~/.config
#export XDG_CONFIG_DIRS="$bundle_etc"/xdg
#export XDG_DATA_DIRS="$bundle_data"

#we might need some of these for themes or whatever
export GTK_DATA_PREFIX="$bundle_res"
export GTK_EXE_PREFIX="$bundle_res"
export GTK_PATH="$bundle_res"

# Set up PATH variable
export PATH="$bundle_contents/MacOS:$PATH"

# Set up generic configuration
export GTK2_RC_FILES="$bundle_etc/gtk-2.0/gtkrc"

# Extra arguments can be added in environment.sh.
EXTRA_ARGS=
if test -f "$bundle_res/environment.sh"; then
 source "$bundle_res/environment.sh"
fi

# Strip out the argument added by the OS.
if /bin/expr "x$1" : '^x-psn_' > /dev/null; then
 shift 1
fi

echo "Launching Gtk Wave Cleaner..."
$EXEC "$bundle_contents/MacOS/gtk-wave-cleaner" "$@" $EXTRA_ARGS
