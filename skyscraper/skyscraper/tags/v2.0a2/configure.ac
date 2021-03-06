#----------------------------------------------------------------------------
# Autoconf input script. Invoke the ./autogen.sh script to generate a
# configure script from this file.
#----------------------------------------------------------------------------
AC_PREREQ([2.54])

#----------------------------------------------------------------------------
# Initialize Autoconf.
#----------------------------------------------------------------------------
AC_INIT(
    [skyscraper],
    [1.2],
    [ryan@tliquest.net])
CS_PACKAGEINFO(
    [Skyscraper],
    [Copyright (C)2004-2009 Ryan Thoryk],
    [http://www.skyscrapersim.com])
AC_CONFIG_SRCDIR([mk/jam/build.jam])
AC_CONFIG_AUX_DIR([mk/autoconf])
AC_CANONICAL_HOST

#----------------------------------------------------------------------------
# Setup for the configuration header.
#----------------------------------------------------------------------------
AC_CONFIG_HEADERS([config.h])

#----------------------------------------------------------------------------
# Check for tools.
#----------------------------------------------------------------------------
CS_PROG_CC
AS_IF([test -z "$CC"],
    [AC_MSG_ERROR([Could not find a usable C compiler.])])
CS_PROG_CXX
AS_IF([test -z "$CXX"],
    [AC_MSG_ERROR([Could not find a usable C++ compiler.])])
CS_PROG_LINK

# The default RANLIB in Jambase is wrong on some platforms, and is also
# unsuitable during cross-compilation, so we set the value unconditionally
# (sixth argument of CS_EMIT_BUILD_PROPERTY).
AC_PROG_RANLIB
CS_EMIT_BUILD_PROPERTY([RANLIB], [$RANLIB], [], [], [], [Y])

CS_CHECK_TOOLS([WINDRES], [windres])
CS_EMIT_BUILD_PROPERTY([CMD.WINDRES], [$WINDRES])

CS_CHECK_PROGS([DOXYGEN], [doxygen])
CS_EMIT_BUILD_PROPERTY([CMD.DOXYGEN], [$DOXYGEN])

CS_CHECK_TOOLS([DOT], [dot])
CS_EMIT_BUILD_PROPERTY([CMD.DOT], [$DOT])

CS_CHECK_PROGS([TEXI2DVI], [texi2dvi])
CS_EMIT_BUILD_PROPERTY([CMD.TEXI2DVI], [$TEXI2DVI])

CS_CHECK_PROGS([TEXI2PDF], [texi2pdf])
CS_EMIT_BUILD_PROPERTY([CMD.TEXI2PDF], [$TEXI2PDF])

CS_CHECK_PROGS([DVIPS], [dvips])
CS_EMIT_BUILD_PROPERTY([CMD.DVIPS], [$DVIPS])

CS_CHECK_PROGS([DVIPDF], [dvipdf])
CS_EMIT_BUILD_PROPERTY([CMD.DVIPDF], [$DVIPDF])

CS_CHECK_PROGS([MAKEINFO], [makeinfo])
CS_EMIT_BUILD_PROPERTY([CMD.MAKEINFO], [$MAKEINFO])

CS_CHECK_PROGS([INSTALL], [install])
CS_EMIT_BUILD_PROPERTY([INSTALL], [$INSTALL])

CS_CHECK_LIBTOOL
CS_EMIT_BUILD_PROPERTY([LIBTOOL], [$LIBTOOL])
CS_EMIT_BUILD_PROPERTY([APPLE_LIBTOOL], [$APPLE_LIBTOOL])

CS_CHECK_MKDIR
CS_EMIT_BUILD_PROPERTY([CMD.MKDIR], [$MKDIR])
CS_EMIT_BUILD_PROPERTY([CMD.MKDIRS], [$MKDIRS])

CS_CHECK_PROGS([PERL], [perl5 perl])
CS_EMIT_BUILD_PROPERTY([PERL], [$PERL])

CS_CHECK_TEMPLATE_TOOLKIT2([emit])

#----------------------------------------------------------------------------
# Determine system type
#----------------------------------------------------------------------------
CS_CHECK_HOST

#----------------------------------------------------------------------------
# Check for syntax problems / header files
#----------------------------------------------------------------------------
# Nothing yet.

#----------------------------------------------------------------------------
# Check for external libraries
#----------------------------------------------------------------------------
CS_CHECK_CPPUNIT([emit])

#----------------------------------------------------------------------------
# Check for Crystal Space (CS)
#----------------------------------------------------------------------------
AC_ARG_WITH([cs], [AC_HELP_STRING([--without-cs],
  [do not look for an installed Crystal Space SDK; this option is useful only
  if you need to perform routine maintenance tasks, such as generating
  project files or converting documentation, without having the Crystal Space
  SDK installed])])
AS_IF([test -z "$with_cs"], [with_cs=yes])

AS_IF([test $with_cs != no],
[CS_PATH_CRYSTAL_EMIT([1.2], [],
  [AC_MSG_ERROR([
*** Crystal Space could not be found or was unusable. The latest version is
*** always available from http://www.crystalspace3d.org/
*** Also, be sure that you have either installed Crystal Space or set the
*** CRYSTAL environment variable properly.
])], [crystalspace])])

#----------------------------------------------------------------------------
# Check for wxWidgets
#----------------------------------------------------------------------------
AC_ARG_WITH([wx], [AC_HELP_STRING([--without-wx],
  [do not look for an installed wxWidgets; this option is useful only
  if you need to perform routine maintenance tasks, such as generating
  project files or converting documentation, without having wxWidgets 
  installed])])
AS_IF([test -z "$with_wx"], [with_wx=yes])

AS_IF([test $with_wx != no],
[
AM_OPTIONS_WXCONFIG
reqwx=2.8.6
AM_PATH_WXCONFIG($reqwx, wxWin=1)
if test "$wxWin" != 1; then
	AC_MSG_ERROR([
			wxWidgets must be installed on your system.

	 		Please check that wx-config is in path, the directory
			where wxWidgets libraries are installed (returned by
			'wx-config --libs' or 'wx-config --static --libs' command)
			is in LD_LIBRARY_PATH or equivalent variable and
			wxWidgets version is $reqwx or above.
			])
else
CS_CHECK_TOOLS([WXCONFIG], [wx-config])
    AS_IF([test -n "$WXCONFIG"],
        [cs_cv_wxwidgets=yes
	cs_cv_wxwidgets_cflags=CS_RUN_PATH_NORMALIZE([$WXCONFIG --cxxflags])
	cs_cv_wxwidgets_lflags=CS_RUN_PATH_NORMALIZE([$WXCONFIG --ldflags])
	cs_cv_wxwidgets_libs=CS_RUN_PATH_NORMALIZE([$WXCONFIG --libs])
	cs_cv_wxwidgets_gllibs=CS_RUN_PATH_NORMALIZE([$WXCONFIG --gl-libs])],
	[cs_cv_wxwidgets=no])
fi

AS_IF([test $cs_cv_wxwidgets = yes],
    [CS_CHECK_BUILD([if wxWidgets SDK is usable], [cs_cv_wxwidgets_ok],
    	[AC_LANG_PROGRAM(
	    [[#include "wx/wxprec.h"
    	    #ifdef __BORLANDC__
    	    #pragma hdrstop
   	    #endif
    	    #ifndef WX_PRECOMP
    	    #include "wx/wx.h"
   	    #endif
   	    ]],
  	    [[wxWindow* p = 0; int w,h; p->GetClientSize(&w,&h);]])],
  	[CS_CREATE_TUPLE([],[],[]) \
	CS_CREATE_TUPLE([-I/usr/local/include],[],[]) \
	CS_CREATE_TUPLE([-I/usr/include],[],[])], [C++], [], [], [],
	[$cs_cv_wxwidgets_cflags],
	[$cs_cv_wxwidgets_lflags],
	[$cs_cv_wxwidgets_libs])],
    [cs_cv_wxwidgets_ok=no])

AS_IF([test $cs_cv_wxwidgets_ok = yes],
	[CS_EMIT_BUILD_RESULT([cs_cv_wxwidgets_ok], [WX])])
])

#----------------------------------------------------------------------------
# Check for Crystal Entity Layer (CEL)
#----------------------------------------------------------------------------
m4_define([cel_desired], [no])
CS_EMIT_BUILD_PROPERTY([CEL.DESIRED], [cel_desired])
m4_if(cel_desired, [yes],
[AC_ARG_WITH([cel], [AC_HELP_STRING([--without-cel],
  [do not look for an installed Crystal Entity Layer SDK; this option is useful
  only if you need to perform routine maintenance tasks, such as generating
  project files or converting documentation, without having the CEL SDK
  installed])])
AS_IF([test -z "$with_cel"], [with_cel=yes])

AS_IF([test $with_cel != no],
[CS_PATH_CEL_EMIT([1.2], [],
  [AC_MSG_ERROR([
*** CEL could not be found or was unusable. The latest version is always
*** available from http://cel.crystalspace3d.org/
])])
AC_DEFINE([USE_CEL], [], [Define to enable CEL.])
AC_DEFINE_UNQUOTED([CEL_PLUGIN_DIR], ["$CEL_PLUGIN_DIR"],
  [Define with path to CEL plugins.])
])])

#------------------------------------------------------------------------------
# Determine if plugin meta-information should be embedded directly into plugin
# modules or if it should exist in stand-alone .csplugin files.  On Unix,
# embedding is accomplished via libbfd which carries a GPL license.  If your
# project is compatible with GPL, then set gpl_compatible to "yes".  This will
# cause embedding to be enabled on Unix by default. Otherwise, set it to "no",
# which will cause embedding to be disabled by default on Unix. (In any event,
# the user can override the default setting with the
# --enable-meta-info-embedding option.)
#------------------------------------------------------------------------------
m4_define([gpl_compatible], [yes])
CS_META_INFO_EMBED([emit], gpl_compatible)
AS_IF([test $enable_meta_info_embedding = yes],
    [CS_EMIT_BUILD_PROPERTY([COMPILER.CFLAGS],
	[AS_ESCAPE([$(EMBED_META.CFLAGS)])], [+])
    CS_EMIT_BUILD_PROPERTY([COMPILER.LFLAGS],
	[AS_ESCAPE([$(EMBED_META.LFLAGS)])], [+])])

#----------------------------------------------------------------------------
# Package configuration switches.
#----------------------------------------------------------------------------
AC_ARG_ENABLE([debug],
    [AC_HELP_STRING([--enable-debug],
	[build with debugging information (default NO)])],
    [], [enable_debug=no])

AC_MSG_CHECKING([build mode])
AS_IF([test $enable_debug = yes], [build_mode=debug], [build_mode=optimize])
AC_MSG_RESULT([$build_mode])

CS_EMIT_BUILD_PROPERTY([MODE], [$build_mode])

#-----------------------------------------------------------------------------
# Emit install paths and package information.
#-----------------------------------------------------------------------------
CS_OUTPUT_INSTALLDIRS
CS_EMIT_PACKAGEINFO

#----------------------------------------------------------------------------
# Emit generated files.
#----------------------------------------------------------------------------
CS_JAMCONFIG_OUTPUT([Jamconfig])
AC_CONFIG_FILES([Jamfile])
AC_OUTPUT

AC_MSG_NOTICE([

Please note that this project uses Jam as its build tool,
therefore you must type 'jam' to build the project.

Jam home: http://www.perforce.com/jam/jam.html
Jam source: ftp://ftp.perforce.com/jam/
])
