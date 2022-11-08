#!/bin/bash
Version=20220912.1
############################################################################
#
#               ------------------------------------------
#               THIS SCRIPT PROVIDED AS IS WITHOUT SUPPORT
#               ------------------------------------------
# ======= Full change history on Github Enterprise at              =======
# ======= https://github.ibm.com/ltc-infrastructure/ftp3-config    =======
#
# ======= Keeping the original commit as a tribute to lnxgeek      =======
#
# Author: scott russell <lnxgeek@us.ibm.com>
# Version: 0.1
# Description: Wrapper script for up2date to use yum repos from the
#              ftp3.linux.ibm.com server. Avoids the need to keep a
#              user id and password exposed in the sources file.
#
#
# === INSTRUCTIONS:
# The following environment variables can be used:
#
#   IBM_YUM_LOG=$HOME/tmp/ibm-yum.log
#       Specifies the name of the file where all log output is written.
#       This defaults to `ibm-yum.log` in the current working directory.
#
#   FTP3USER=user@cc.ibm.com
#       The Enterprise Linux FTP account to use for connecting to the
#       FTP3HOST server.
#
#   FTP3PASS=mypasswd
#       The password associated with the FTP3USER account.
#
#   FTP3HOST=hostname_or_ip_address
#       The server to use for establishing FTP connections where yum/dnf
#       repositories are hosted.  Defaults to "ftp3.linux.ibm.com".
#
#   FTP3RELVER=8.6
#       A specific "releasever" value (to use yum/dnf nomenclature) that should
#       match the "VERSION_ID" from the /etc/os-release file on your system.
#       This directs the script to create repository definitions for that exact
#       version of the operating system.  The default value is computed to be a
#       string that refers to the "latest" available version for your system,
#       which for Red Hat releases prior to 8 is something like "6Workstation"
#       or "7Server".  For Red Hat 8 and later systems this is simply a single
#       release value like "8" or "9".
#
# You must be root to run this script. The user id and password will be
# prompted for if the environment variables are not set. The server can be
# any site listed from https://ftp3.linux.ibm.com/sites.html and defaults
# to ftp3.linux.ibm.com.
#
# All options given are passed directly to the yum command. Some
# example uses might be:
#
#   ./ibm-yum.sh list updates
#   FTP3USER=user@cc.ibm.com ./ibm-yum.sh list updates
#
# The first example is a good way to test this script. The second example
# shows how to set the FTP3USER environment variable on the command line.
#
############################################################################

# Special-case argument to display program version and exit.
if [ "$1" == "--version" ]; then
  echo "version $Version"
  exit 0
fi

if [ -z "$IBM_YUM_LOG" ] ; then
    IBM_YUM_LOG="ibm-yum.log"
fi

## default host
if [ -z "$FTP3HOST" ] ; then
    FTP3HOST="ftp3.linux.ibm.com"
fi
basename=${FTP3HOST%%.*}
echo $basename

## The host we check to see if there is a new version of this script.  This is
## useful if FTP3HOST is pointing to a mirror that doesn't have the FTP3 web
## service running.
if [ -z "$FTP3APIHOST" ] ; then
    FTP3APIHOST="ftp3.linux.ibm.com"
fi

## The API through which we talk to FTP3
API_URL="https://$FTP3APIHOST/rpc/index.php"

## other vars that most likely should not change
YUM="/usr/bin/yum --noplugins"
RHN_SOURCE="/etc/yum.repos.d/ibm-yum-$$.repo";
RHREPO_SAVE="/etc/yum.repos.d/redhat.repo.$$.sav";

## these are detected automatically
ARCH=
VERSION=
RELEASE=

## initialize the log file
rm -f $IBM_YUM_LOG
touch $IBM_YUM_LOG &>> /dev/null
if [ ! -w $IBM_YUM_LOG ]; then
    echo "No write access to log file: $IBM_YUM_LOG"
    echo "Consider setting the IBM_YUM_LOG variable."
    exit 1
fi

## log string and/or command to $IBM_YUM_LOG
##   logthis -E "send string to both console and log"
##   logthis -n "send string to console without newline, and to log (with newline)"
##   logthis -s "send string to log only"
## The command and its result will be logged:
##   logthis cmd arg1 arg2 ...
## Combination of string and following command:
##   logthis -s "send string and output of following command to log" cmd arg1 arg2 ...
## warning: | and " must be escaped
logthis() {
    arg=$1
    if [[ $arg == "-E" || $arg == "-n" ]]; then
        echo $1 "$2"
        arg="-s"
    fi
    if [[ $arg == "-s" ]]; then
        echo "$2" >> $IBM_YUM_LOG
        shift 2
    fi
    [[ $# -le 0 ]] && return
    echo "---- $*" >> $IBM_YUM_LOG
    eval $* &>> $IBM_YUM_LOG
}


## this is called on exit to restore the sources file from the backup
cleanUp()
{
    logthis -s "Clean up before terminating:"
    if [[ -e $RHREPO_SAVE ]]; then
        logthis mv $RHREPO_SAVE /etc/yum.repos.d/redhat.repo
    fi
    if [ -e $RHN_SOURCE ] ; then
        logthis rm --force $RHN_SOURCE
        if [ $? != 0 ] ; then
            logthis -E ""
            logthis -E "Failed to remove temporary config file"
            logthis -E "Please manually remove $RHN_SOURCE"
            logthis -E ""
        else
            logthis -E ""
            logthis -E "Removed temporary configuration"
            logthis -E ""
        fi
    fi
    return 0;
}

## clean up proper if something goes bad
trap cleanUp EXIT HUP INT QUIT TERM;

## $1: action, one of:
##     CREATE_KEY
##     DELETE_SYSTEMS
##     SHOW_KEY
##     SHOW_SATELLITE
##     LIST_SATELLITES
##     LIST_SYSTEMS
##     SCRIPT_VERSION
## $2: username
## $3: password
## $4: type (could be empty)
## $5: satellite (could be empty)
## $6: system (could be empty)
run_curl() {
    action=$1
    user=$2
    realpass=$3

    if [ "$FTP3DEBUG" == "" ]; then fakepass="PASSWORD" ; else fakepass=$realpass ; fi

    case "$action" in
        SCRIPT_VERSION)
            command="user.wrapper_script_version"
            ;;
        *)
            return 1
    esac

    cmd="curl -ks $API_URL -H \"Content-Type: text/xml\" -d \"<?xml version='1.0' encoding='UTF-8'?><methodCall><methodName>${command}</methodName> <params> </params> </methodCall>\""
    logthis -s "$cmd"
    result=$(curl -ks $API_URL -H "Content-Type: text/xml" -d "<?xml version='1.0' encoding='UTF-8'?><methodCall><methodName>${command}</methodName> <params> </params> </methodCall>")

    if [[ $? -ne 0 ]]; then
        case "$action" in
            SCRIPT_VERSION)
                echo "An error has occurred while trying to determine the latest script version."
                ;;
        esac
        return 1
    fi
    echo "$result" | grep -oPm1 "(?<=<string>)[^<]+"
    return 0
}

if [ -z ${FTP3_NO_VERSION_CHECK+x} ]; then
  logthis -s "Querying latest script version:"
  SCRIPT_VERSION=$(run_curl SCRIPT_VERSION)
  RET=$?
  logthis -s "return code: $RET"
  logthis -s "result: \"$SCRIPT_VERSION\""
  if [ $RET -ne 0 ]; then
    if [ "$SCRIPT_VERSION" == "Unknown method" ]; then
      logthis -E "Server-side support for this script is not enabled"
      exit 1
    fi
    logthis -E "$SCRIPT_VERSION"
    exit 1
  fi
  if [ "$SCRIPT_VERSION" == "You must run this script as root. Goodbye." ]; then
    logthis -E "Server-side version of this script is out of date"
    exit 1
  fi
  logthis -s "Comparing version information:"
  latest=$(printf "%03d%03d%03d" ${SCRIPT_VERSION//./ })
  this=$(printf "%03d%03d%03d\n" ${Version//./ })
  logthis -s "latest script version:  $latest"
  logthis -s "version of this script: $this"
  if [ "$latest" \> "$this" ]; then
    if [ -z "$FTP3USER" ]; then
      user="<ftp3-id>"
    else
      user=$FTP3USER
    fi
    logthis -E "Obsolete script version $Version; please download version $SCRIPT_VERSION."
    logthis -E "The latest version of the script can be downloaded with the following command:"
    logthis -E "wget --user $user --ask-password -O ibm-yum.sh ftp://$FTP3HOST/redhat/ibm-yum.sh"
    exit 1
  fi
  logthis -s "Script is up to date."
fi

## must be root to run this
if [ `whoami` != "root" ] ; then
    logthis -E "You must run this script as root. Goodbye."
    exit 1
fi

## get the userid
if [ -z "$FTP3USER" ] ; then
    logthis -s "Prompting for FTP3USER."
    echo -n "User ID: "
    read FTP3USER

    if [ -z "$FTP3USER" ] ; then
        logthis -E ""
        logthis -E "Missing userid. Either set the environment variable"
        logthis -E "FTP3USER to your user id or enter a user id when prompted."
        logthis -E "Goodbye."
        logthis -E ""
        exit 1
    fi
fi
logthis -s "FTP3USER=$FTP3USER"

## get the password
if [ -z "$FTP3PASS" ] ; then
    ## prompt for password
    logthis -s "Prompting for FTP3PASS."
    echo -n "Password for $FTP3USER: "
    stty -echo
    read -r FTP3PASS
    stty echo
    echo ""
    echo ""

    if [ -z "$FTP3PASS" ] ; then
        logthis -E "Missing password. Either set the environment variable"
        logthis -E "FTP3PASS to your user password or enter a password when"
        logthis -E "prompted. Goodbye."
        logthis -E ""
        exit 1
    fi
fi

## get the system arch
if [ -z "$FTP3ARCH" ] ; then
  FTP3ARCH=$(uname -m)
fi
logthis -s "FTP3ARCH=$FTP3ARCH"
case $FTP3ARCH in
    i?86    ) ARCH="i386"
        LABEL="server"
        ;;
    ppc64   ) ARCH="ppc64"
        LABEL="power"
        ;;
    ppc64le ) ARCH="ppc64le"
        LABEL="power-le"
        ;;
    s390x   ) ARCH="s390x"
        LABEL="system-z"
        ;;
    x86_64  ) ARCH="x86_64"
        LABEL="server"
        ;;
    *       ) ARCH=;;
esac

## check to see we got a good arch
if [ -z "$ARCH" ] ; then
    logthis -E "Unknown or unsupported system arch: $FTP3ARCH"
    logthis -E "Try reporting this to ftpadmin@linux.ibm.com with"
    logthis -E "the full output of uname -a and the contents of"
    logthis -E "/etc/redhat-release"
    logthis -E ""
    exit 1
fi
logthis -s "System architecture: $ARCH"

## get the version and release, most likely only works on RHEL
if [ -n "$FTP3VERREL" ] ; then
  VERREL=$FTP3VERREL
else
  VERREL=`rpm -qf --qf "%{NAME}-%{VERSION}\n" /etc/redhat-release`
fi
if [ $? != 0 ] ; then
    logthis -E "Failed to find system version and release with the"
    logthis -E "command \"rpm -q redhat-release\". Is this system"
    logthis -E "running Red Hat Enterprise Linux?"
    logthis -E ""
    exit 1
fi
logthis -s "Red Hat release: $VERREL"

# Leading word is almost certainly "redhat" but we use a wildcard just in case.
major_minor=${VERREL#*-release-*}
# Older releases might have an embedded "server-" or "workstation-"
major_minor=${major_minor#*-}
major=${major_minor%.*}
minor=${major_minor#*.}
if [[ $major == $major_minor && $minor == $major_minor ]]; then
  major=${major_minor:0:1}
  minor=${major_minor:1}
fi
logthis -s "major: $major"
logthis -s "minor: $minor"

if [ ${major:0:1} == 5 ]; then
    ## split something like "redhat-release-5Server" into 5 and server
    VERREL=`echo $VERREL | sed 's/.*release-//' | tr '[:upper:]' '[:lower:]'`
    RELEASE=${VERREL:0:1}
    VERSION=${VERREL:1}
elif [[ $major -ge 8 ]]; then
    ## split something like "redhat-release-8.0" into 8 and server
    VERREL=`echo $VERREL | sed 's/.*release-//' | tr '[:upper:]' '[:lower:]'`
    RELEASE=$major
    VERSION="server"
else
    ## split something like "redhat-release-workstation-6Workstation"
    ## into 6 and workstation
    RELEASE=`echo $VERREL | cut -f4 -d"-" | cut -b1`
    VERSION=`echo $VERREL | cut -f3 -d"-"`
fi

BASEOS="baseos/"
APPSTREAM=0
COMMON=0
CRB=0
EXTRAS=0
HIGHAVAILABILITY=0
OPTIONAL=0
RESILIENTSTORAGE=0
SUPPLEMENTARY=1
## verify support for this release
case $RELEASE in
    [5-7] )
        BASEOS=""
        version=${VERSION^}
        COMMON=1
        EXTRAS=1
        OPTIONAL=1 ;;
    [8-9] )
        version=""
        APPSTREAM=1
        CRB=1
        HIGHAVAILABILITY=1 ;;
    * ) RELEASE= ;;
esac

## verify support for this version
case $VERSION in
    server      ) : ;;
    workstation ) : ;;
    *           ) VERSION= ;;
esac

if [ -z "$VERSION" ] || [ -z "$RELEASE" ] ; then
    logthis -E "Unknown or unsupported system version and release: $VERREL"
    logthis -E "Try reporting this to ftpadmin@linux.ibm.com with the"
    logthis -E "full output of uname -a and the contents of /etc/redhat-release"
    logthis -E ""
    exit 1
fi

logthis -E "Detected RHEL $RELEASE $VERSION $ARCH"


# Encode the the username for use in URLs
FTP3USERENC=`echo $FTP3USER | sed s/@/%40/g`

# Encode user password for use in URLs
FTP3PASSENC=`echo -n $FTP3PASS | od -tx1 -An | tr -d '\n' | sed 's/ /%/g'`

## write out a new sources file
URL="ftp://$FTP3USERENC:$FTP3PASSENC@$FTP3HOST"
# Fake URL
FURL="ftp://$FTP3HOST"


if [ $VERSION == "workstation" ]; then
    LABEL=$VERSION
fi

if [[ $(lscpu |grep 'Model name:'|cut -d' ' -f2|cut -d',' -f1) == "POWER9" ]]; then
    # Base OS packages
    RHELPATH="yum-alt"
    LABEL="server"
    ARCH="power9/ppc64le"
else
    RHELPATH="yum"
    if [[ $RELEASE -eq 5 ]]; then
        RHELPATH="yum-eus"
    fi
fi

if [ -n "$FTP3DEBUG" ] ; then
  opt="-E"
else
  opt="-s"
fi
logthis $opt "LABEL=$LABEL"
logthis $opt "RELEASE=$RELEASE"
logthis $opt "VERSION=$VERSION"
logthis $opt "version=${version}"
if [ -z "$FTP3RELVER" ] ; then
  FTP3RELVER="${RELEASE}${version}"
fi
logthis $opt "FTP3RELVER=${FTP3RELVER}"

LOCATION="$LABEL/$RELEASE/$FTP3RELVER"
logthis -s "LOCATION=$LOCATION"

logthis -s "Creating the following repositories in $RHN_SOURCE:"
# Base OS packages
repo="$basename"
baseurl="redhat/$RHELPATH/$LOCATION/$ARCH/${BASEOS}os/"
logthis -s "  $repo: $FURL/$baseurl"
echo "[$repo]" >> $RHN_SOURCE
echo "name=FTP3 yum repository" >> $RHN_SOURCE
echo "baseurl=$URL/$baseurl" >> $RHN_SOURCE
echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $RHN_SOURCE

if [ $APPSTREAM -ne 0 ]; then
  #Appstream packages
  repo="${basename}-appstream"
  baseurl="redhat/$RHELPATH/$LOCATION/$ARCH/appstream/os/"
  logthis -s "  $repo: $FURL/$baseurl"
  echo "[$repo]" >> $RHN_SOURCE
  echo "name=FTP3 appstream yum repository" >> $RHN_SOURCE
  echo "baseurl=$URL/$baseurl" >> $RHN_SOURCE
  echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $RHN_SOURCE
  echo "skip_if_unavailable=1" >> $RHN_SOURCE
fi

if [ $COMMON -ne 0 ]; then
  # RH Common packages
  if [ $ARCH != 'ppc64le' ]; then
      repo="${basename}-rh-common"
      baseurl="redhat/$RHELPATH/$LOCATION/$ARCH/rh-common/os/"
      logthis -s "  $repo: $FURL/$baseurl"
      echo "[$repo]" >> $RHN_SOURCE
      echo "name=FTP3 rh-common yum repository" >> $RHN_SOURCE
      echo "baseurl=$URL/$baseurl" >> $RHN_SOURCE
      echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $RHN_SOURCE
      echo "skip_if_unavailable=1" >> $RHN_SOURCE
  fi
fi

if [ $CRB -ne 0 ]; then
  #CRB
  repo="${basename}-CRB"
  baseurl="redhat/$RHELPATH/$LOCATION/$ARCH/codeready-builder/os/"
  logthis -s "  $repo: $FURL/$baseurl"
  echo "[$repo]" >> $RHN_SOURCE
  echo "name=FTP3 CRB yum repository" >> $RHN_SOURCE
  echo "baseurl=$URL/$baseurl" >> $RHN_SOURCE
  echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $RHN_SOURCE
  echo "skip_if_unavailable=1" >> $RHN_SOURCE
fi

if [ $EXTRAS -ne 0 ]; then
  # Extra packages
  repo="${basename}-extras"
  baseurl="redhat/$RHELPATH/$LOCATION/$ARCH/extras/os/"
  logthis -s "  $repo: $FURL/$baseurl"
  echo "[$repo]" >> $RHN_SOURCE
  echo "name=FTP3 extras yum repository" >> $RHN_SOURCE
  echo "baseurl=$URL/$baseurl" >> $RHN_SOURCE
  echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $RHN_SOURCE
  echo "skip_if_unavailable=1" >> $RHN_SOURCE
fi

if [ $HIGHAVAILABILITY -ne 0 ]; then
  #HighAvailability
  repo="${basename}-HighAvailability"
  baseurl="redhat/$RHELPATH/$LOCATION/$ARCH/highavailability/os/"
  logthis -s "  $repo: $FURL/$baseurl"
  echo "[$repo]" >> $RHN_SOURCE
  echo "name=FTP3 HighAvailability yum repository" >> $RHN_SOURCE
  echo "baseurl=$URL/$baseurl" >> $RHN_SOURCE
  echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $RHN_SOURCE
  echo "skip_if_unavailable=1" >> $RHN_SOURCE
fi

if [ $OPTIONAL -ne 0 ]; then
  # Optional packages
  repo="${basename}-optional"
  baseurl="redhat/$RHELPATH/$LOCATION/$ARCH/optional/os/"
  logthis -s "  $repo: $FURL/$baseurl"
  echo "[$repo]" >> $RHN_SOURCE
  echo "name=FTP3 optional yum repository" >> $RHN_SOURCE
  echo "baseurl=$URL/$baseurl" >> $RHN_SOURCE
  echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $RHN_SOURCE
  echo "skip_if_unavailable=1" >> $RHN_SOURCE
fi

if [ $RESILIENTSTORAGE -ne 0 ]; then
  # ResilientStorage - this repository is listed as not recommended by Red Hat
  repo="${basename}-ResilientStorage"
  baseurl="redhat/$RHELPATH/$LOCATION/$ARCH/ResilientStorage/os/"
  logthis -s "  $repo: $FURL/$baseurl"
  echo "[$repo]" >> $RHN_SOURCE
  echo "name=FTP3 ResilientStorage yum repository" >> $RHN_SOURCE
  echo "baseurl=$URL/$baseurl" >> $RHN_SOURCE
  echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $RHN_SOURCE
  echo "skip_if_unavailable=1" >> $RHN_SOURCE
fi

if [ $SUPPLEMENTARY -ne 0 ]; then
  # Supplementary packages
  repo="${basename}-supplementary"
  baseurl="redhat/$RHELPATH/$LOCATION/$ARCH/supplementary/os/"
  logthis -s "  $repo: $FURL/$baseurl"
  echo "[$repo]" >> $RHN_SOURCE
  echo "name=FTP3 supplementary yum repository" >> $RHN_SOURCE
  echo "baseurl=$URL/$baseurl" >> $RHN_SOURCE
  echo "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release" >> $RHN_SOURCE
  echo "skip_if_unavailable=1" >> $RHN_SOURCE
fi

logthis -E "Wrote new config file: $RHN_SOURCE"

# Disabling redhat.repo file to void unexpected results
if [[ -e /etc/yum.repos.d/redhat.repo ]]; then
    logthis mv /etc/yum.repos.d/redhat.repo $RHREPO_SAVE
    logthis touch /etc/yum.repos.d/redhat.repo
fi

## run the yum command
args="$@"
logthis -E "Running the following command:"
logthis -E "  $YUM $args"
$YUM $args

exit $?
