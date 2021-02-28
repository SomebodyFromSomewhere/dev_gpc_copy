{**************************************************************************}
{                 shlobj.pas                                               }
{                                                                          }
{ This UNIT implements a partial shlobj unit for GNU Pascal for Win32.     }
{ Copyright (C) 1998-2003 Free Software Foundation, Inc.                   }
{                                                                          }
{ Author: Prof. Abimbola Olowofoyeku                                       }
{          http://www.greatchief.plus.com                                  }
{          chiefsoft [at] bigfoot [dot] com                                }
{                                                                          }
{    This library is released as part of the GNU Pascal project.           }
{                                                                          }
{ This library is free software; you can redistribute it and/or            }
{ modify it under the terms of the GNU Lesser General Public               }
{ License as published by the Free Software Foundation; either             }
{ version 2.1 of the License, or (at your option) any later version.       }
{                                                                          }
{ This library is distributed in the hope that it will be useful,          }
{ but WITHOUT ANY WARRANTY; without even the implied warranty of           }
{ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        }
{ Lesser General Public License for more details.                          }
{                                                                          }
{ You should have received a copy of the GNU Lesser General Public         }
{ License along with this library; if not, write to the Free Software      }
{ Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA }
{                                                                          }
{    As a special exception, if you link this file with files compiled     }
{    with a GNU compiler to produce an executable, this does not cause     }
{    the resulting executable to be covered by the GNU Library General     }
{    Public License. This exception does not however invalidate any other  }
{    reasons why the executable file might be covered by the GNU Library   }
{    General Public License.                                               }
{                                                                          }
{                                                                          }
{  v1.00, 20 Oct.  2002 - Prof. Abimbola Olowofoyeku (The African Chief)   }
{                         http://www.bigfoot.com/~African_Chief/           }
{                                                                          }
{**************************************************************************}

UNIT shlobj;

INTERFACE

USES
Messages,
activex,
shellapi;

CONST BIF_RETURNONLYFSDIRS = 1;
CONST BIF_DONTGOBELOWDOMAIN = 2;
CONST BIF_STATUSTEXT = 4;
CONST BIF_RETURNFSANCESTORS = 8;
CONST BIF_EDITBOX = 16;
CONST BIF_VALIDATE = 32;
CONST BIF_NEWDIALOGSTYLE = 64;
CONST BIF_BROWSEINCLUDEURLS = 128;
CONST BIF_USENEWUI = ( BIF_EDITBOX OR BIF_NEWDIALOGSTYLE );
CONST BIF_BROWSEFORCOMPUTER = $1000;
CONST BIF_BROWSEFORPRINTER = $2000;
CONST BIF_BROWSEINCLUDEFILES = $4000;
CONST BIF_SHAREABLE = $8000;
CONST BFFM_INITIALIZED = 1;
CONST BFFM_SELCHANGED = 2;
CONST BFFM_VALIDATEFAILEDA = 3;
CONST BFFM_VALIDATEFAILEDW = 4;
CONST BFFM_SETSTATUSTEXTA = ( WM_USER + 100 );
CONST BFFM_SETSTATUSTEXTW = ( WM_USER + 104 );
CONST BFFM_ENABLEOK = ( WM_USER + 101 );
CONST BFFM_SETSELECTIONA = ( WM_USER + 102 );
CONST BFFM_SETSELECTIONW = ( WM_USER + 103 );
{$IFDEF UNICODE}
CONST BFFM_SETSTATUSTEXT = BFFM_SETSTATUSTEXTW;
CONST BFFM_SETSELECTION = BFFM_SETSELECTIONW;
CONST BFFM_VALIDATEFAILED = BFFM_VALIDATEFAILEDW;
{$ELSE}
CONST BFFM_SETSTATUSTEXT = BFFM_SETSTATUSTEXTA;
CONST BFFM_SETSELECTION = BFFM_SETSELECTIONA;
CONST BFFM_VALIDATEFAILED = BFFM_VALIDATEFAILEDA;
{$ENDIF}
CONST DVASPECT_SHORTNAME = 2;
CONST SHARD_PIDL = 1;
CONST SHARD_PATH = 2;
CONST SHCNE_RENAMEITEM = 1;
CONST SHCNE_CREATE = 2;
CONST SHCNE_DELETE = 4;
CONST SHCNE_MKDIR = 8;
CONST SHCNE_RMDIR = 16;
CONST SHCNE_MEDIAINSERTED = 32;
CONST SHCNE_MEDIAREMOVED = 64;
CONST SHCNE_DRIVEREMOVED = 128;
CONST SHCNE_DRIVEADD = 256;
CONST SHCNE_NETSHARE = 512;
CONST SHCNE_NETUNSHARE = 1024;
CONST SHCNE_ATTRIBUTES = 2048;
CONST SHCNE_UPDATEDIR = 4096;
CONST SHCNE_UPDATEITEM = 8192;
CONST SHCNE_SERVERDISCONNECT = 16384;
CONST SHCNE_UPDATEIMAGE = 32768;
CONST SHCNE_DRIVEADDGUI = 65536;
CONST SHCNE_RENAMEFOLDER = $20000;
CONST SHCNE_FREESPACE = $40000;
CONST SHCNE_ASSOCCHANGED = $8000000;
CONST SHCNE_DISKEVENTS = $2381;
CONST SHCNE_GLOBALEVENTS = $C0581E0;
CONST SHCNE_ALLEVENTS = $7FFFFFF;
CONST SHCNE_INTERRUPT = $80000000;
CONST SHCNF_IDLIST = 0;
CONST SHCNF_PATH = 1;
CONST SHCNF_PRINTER = 2;
CONST SHCNF_DWORD = 3;
CONST SHCNF_TYPE = $F;
CONST SHCNF_FLUSH = $1000;
CONST SHCNF_FLUSHNOWAIT = $2000;
CONST SFGAO_CANCOPY = DROPEFFECT_COPY;
CONST SFGAO_CANMOVE = DROPEFFECT_MOVE;
CONST SFGAO_CANLINK = DROPEFFECT_LINK;
CONST SFGAO_CANRENAME = $00000010;
CONST SFGAO_CANDELETE = $00000020;
CONST SFGAO_HASPROPSHEET = $00000040;
CONST SFGAO_DROPTARGET = $00000100;
CONST SFGAO_CAPABILITYMASK = $00000177;
CONST SFGAO_LINK = $00010000;
CONST SFGAO_SHARE = $00020000;
CONST SFGAO_READONLY = $00040000;
CONST SFGAO_GHOSTED = $00080000;
CONST SFGAO_DISPLAYATTRMASK = $000F0000;
CONST SFGAO_FILESYSANCESTOR = $10000000;
CONST SFGAO_FOLDER = $20000000;
CONST SFGAO_FILESYSTEM = $40000000;
CONST SFGAO_HASSUBFOLDER = $80000000;
CONST SFGAO_CONTENTSMASK = $80000000;
CONST SFGAO_VALIDATE = $01000000;
CONST SFGAO_REMOVABLE = $02000000;
CONST STRRET_WSTR = 0;
CONST STRRET_OFFSET = 1;
CONST STRRET_CSTR = 2;
CONST SHGDFIL_FINDDATA = 1;
CONST SHGDFIL_NETRESOURCE = 2;
CONST SHGDFIL_DESCRIPTIONID = 3;
CONST SHDID_ROOT_REGITEM = 1;
CONST SHDID_FS_FILE = 2;
CONST SHDID_FS_DIRECTORY = 3;
CONST SHDID_FS_OTHER = 4;
CONST SHDID_COMPUTER_DRIVE35 = 5;
CONST SHDID_COMPUTER_DRIVE525 = 6;
CONST SHDID_COMPUTER_REMOVABLE = 7;
CONST SHDID_COMPUTER_FIXED = 8;
CONST SHDID_COMPUTER_NETDRIVE = 9;
CONST SHDID_COMPUTER_CDROM = 10;
CONST SHDID_COMPUTER_RAMDISK = 11;
CONST SHDID_COMPUTER_OTHER = 12;
CONST SHDID_NET_DOMAIN = 13;
CONST SHDID_NET_SERVER = 14;
CONST SHDID_NET_SHARE = 15;
CONST SHDID_NET_RESTOFNET = 16;
CONST SHDID_NET_OTHER = 17;
{$IFNDEF REGSTR_PATH_EXPLORER}
CONST REGSTR_PATH_EXPLORER = ( 'Software\Microsoft\Windows\CurrentVersion\Explorer' );
{$ENDIF}
CONST REGSTR_PATH_SPECIAL_FOLDERS = REGSTR_PATH_EXPLORER + ( '\Shell Folders' );
CONST CSIDL_DESKTOP = 0;
CONST CSIDL_INTERNET = 1;
CONST CSIDL_PROGRAMS = 2;
CONST CSIDL_CONTROLS = 3;
CONST CSIDL_PRINTERS = 4;
CONST CSIDL_PERSONAL = 5;
CONST CSIDL_FAVORITES = 6;
CONST CSIDL_STARTUP = 7;
CONST CSIDL_RECENT = 8;
CONST CSIDL_SENDTO = 9;
CONST CSIDL_BITBUCKET = 10;
CONST CSIDL_STARTMENU = 11;
CONST CSIDL_DESKTOPDIRECTORY = 16;
CONST CSIDL_DRIVES = 17;
CONST CSIDL_NETWORK = 18;
CONST CSIDL_NETHOOD = 19;
CONST CSIDL_FONTS = 20;
CONST CSIDL_TEMPLATES = 21;
CONST CSIDL_COMMON_STARTMENU = 22;
CONST CSIDL_COMMON_PROGRAMS = 23;
CONST CSIDL_COMMON_STARTUP = 24;
CONST CSIDL_COMMON_DESKTOPDIRECTORY = 25;
CONST CSIDL_APPDATA = 26;
CONST CSIDL_PRINTHOOD = 27;
CONST CSIDL_LOCAL_APPDATA = 28;
CONST CSIDL_ALTSTARTUP = 29;
CONST CSIDL_COMMON_ALTSTARTUP = 30;
CONST CSIDL_COMMON_FAVORITES = 31;
CONST CSIDL_INTERNET_CACHE = 32;
CONST CSIDL_COOKIES = 33;
CONST CSIDL_HISTORY = 34;
CONST CSIDL_COMMON_APPDATA = 35;
CONST CSIDL_WINDOWS = 36;
CONST CSIDL_SYSTEM = 37;
CONST CSIDL_PROGRAM_FILES = 38;
CONST CSIDL_MYPICTURES = 39;
CONST CSIDL_PROFILE = 40;
CONST CSIDL_SYSTEMX86 = 41;
CONST CSIDL_PROGRAM_FILESX86 = 42;
CONST CSIDL_PROGRAM_FILES_COMMON = 43;
CONST CSIDL_PROGRAM_FILES_COMMONX86 = 44;
CONST CSIDL_COMMON_TEMPLATES = 45;
CONST CSIDL_COMMON_DOCUMENTS = 46;
CONST CSIDL_COMMON_ADMINTOOLS = 47;
CONST CSIDL_ADMINTOOLS = 48;
CONST CSIDL_CONNECTIONS = 49;
CONST CSIDL_COMMON_MUSIC = 53;
CONST CSIDL_COMMON_PICTURES = 54;
CONST CSIDL_COMMON_VIDEO = 55;
CONST CSIDL_RESOURCES = 56;
CONST CSIDL_RESOURCES_LOCALIZED = 57;
CONST CSIDL_COMMON_OEM_LINKS = 58;
CONST CSIDL_CDBURN_AREA = 59;
CONST CSIDL_COMPUTERSNEARME = 61;
CONST CFSTR_SHELLIDLIST = ( 'Shell IDList Array' );
CONST CFSTR_SHELLIDLISTOFFSET = ( 'Shell Object Offsets' );
CONST CFSTR_NETRESOURCES = ( 'Net Resource' );
CONST CFSTR_FILEDESCRIPTOR = ( 'FileGroupDescriptor' );
CONST CFSTR_FILECONTENTS = ( 'FileContents' );
CONST CFSTR_FILENAME = ( 'FileName' );
CONST CFSTR_PRINTERGROUP = ( 'PrinterFriendlyName' );
CONST CFSTR_FILENAMEMAP = ( 'FileNameMap' );
CONST CFSTR_INDRAGLOOP = ( 'InShellDragLoop' );
CONST CFSTR_PASTESUCCEEDED = ( 'Paste Succeeded' );
CONST CFSTR_PERFORMEDDROPEFFECT = ( 'Performed DropEffect' );
CONST CFSTR_PREFERREDDROPEFFECT = ( 'Preferred DropEffect' );
CONST CFSTR_SHELLURL = ( 'UniformResourceLocator' );
CONST CMF_NORMAL = 0;
CONST CMF_DEFAULTONLY = 1;
CONST CMF_VERBSONLY = 2;
CONST CMF_EXPLORE = 4;
CONST CMF_RESERVED = $ffff0000;
CONST GCS_VERBA = 0;
CONST GCS_HELPTEXTA = 1;
CONST GCS_VALIDATEA = 2;
CONST GCS_VERBW = 4;
CONST GCS_HELPTEXTW = 5;
CONST GCS_VALIDATEW = 6;
CONST GCS_UNICODE = 4;
{$IFDEF UNICODE}
CONST GCS_VERB = GCS_VERBW;
CONST GCS_HELPTEXT = GCS_HELPTEXTW;
CONST GCS_VALIDATE = GCS_VALIDATEW;
{$ELSE}
CONST GCS_VERB = GCS_VERBA;
CONST GCS_HELPTEXT = GCS_HELPTEXTA;
CONST GCS_VALIDATE = GCS_VALIDATEA;
{$ENDIF}
CONST CMDSTR_NEWFOLDER = ( 'NewFolder' );
CONST CMDSTR_VIEWLIST = ( 'ViewList' );
CONST CMDSTR_VIEWDETAILS = ( 'ViewDetails' );
CONST CMIC_MASK_HOTKEY = SEE_MASK_HOTKEY;
CONST CMIC_MASK_ICON = SEE_MASK_ICON;
CONST CMIC_MASK_FLAG_NO_UI = SEE_MASK_FLAG_NO_UI;
CONST CMIC_MASK_MODAL = $80000000;
// CONST CMIC_VALID_SEE_FLAGS = SEE_VALID_CMIC_FLAGS;
CONST GIL_OPENICON = 1;
CONST GIL_FORSHELL = 2;
CONST GIL_SIMULATEDOC = 1;
CONST GIL_PERINSTANCE = 2;
CONST GIL_PERCLASS = 4;
CONST GIL_NOTFILENAME = 8;
CONST GIL_DONTCACHE = 16;
CONST FVSIF_RECT = 1;
CONST FVSIF_PINNED = 2;
CONST FVSIF_NEWFAILED = $8000000;
CONST FVSIF_NEWFILE = $80000000;
CONST FVSIF_CANVIEWIT = $40000000;
CONST CDBOSC_SETFOCUS = 0;
CONST CDBOSC_KILLFOCUS = 1;
CONST CDBOSC_SELCHANGE = 2;
CONST CDBOSC_RENAME = 3;
CONST FCIDM_SHVIEWFIRST = 0;
CONST FCIDM_SHVIEWLAST = $7fff;
CONST FCIDM_BROWSERFIRST = $a000;
CONST FCIDM_BROWSERLAST = $bf00;
CONST FCIDM_GLOBALFIRST = $8000;
CONST FCIDM_GLOBALLAST = $9fff;
CONST FCIDM_MENU_FILE = FCIDM_GLOBALFIRST;
CONST FCIDM_MENU_EDIT = ( FCIDM_GLOBALFIRST + $0040 );
CONST FCIDM_MENU_VIEW = ( FCIDM_GLOBALFIRST + $0080 );
CONST FCIDM_MENU_VIEW_SEP_OPTIONS = ( FCIDM_GLOBALFIRST + $0081 );
CONST FCIDM_MENU_TOOLS = ( FCIDM_GLOBALFIRST + $00c0 );
CONST FCIDM_MENU_TOOLS_SEP_GOTO = ( FCIDM_GLOBALFIRST + $00c1 );
CONST FCIDM_MENU_HELP = ( FCIDM_GLOBALFIRST + $0100 );
CONST FCIDM_MENU_FIND = ( FCIDM_GLOBALFIRST + $0140 );
CONST FCIDM_MENU_EXPLORE = ( FCIDM_GLOBALFIRST + $0150 );
CONST FCIDM_MENU_FAVORITES = ( FCIDM_GLOBALFIRST + $0170 );
CONST FCIDM_TOOLBAR = FCIDM_BROWSERFIRST;
CONST FCIDM_STATUS = ( FCIDM_BROWSERFIRST + 1 );
CONST SBSP_DEFBROWSER = 0;
CONST SBSP_SAMEBROWSER = 1;
CONST SBSP_NEWBROWSER = 2;
CONST SBSP_DEFMODE = 0;
CONST SBSP_OPENMODE = 16;
CONST SBSP_EXPLOREMODE = 32;
CONST SBSP_ABSOLUTE = 0;
CONST SBSP_RELATIVE = $1000;
CONST SBSP_PARENT = $2000;
CONST SBSP_INITIATEDBYHLINKFRAME = $80000000;
CONST SBSP_REDIRECT = $40000000;
CONST FCW_STATUS = 1;
CONST FCW_TOOLBAR = 2;
CONST FCW_TREE = 3;
CONST FCT_MERGE = 1;
CONST FCT_CONFIGABLE = 2;
CONST FCT_ADDTOEND = 4;
CONST SVSI_DESELECT = 0;
CONST SVSI_SELECT = 1;
CONST SVSI_EDIT = 3;
CONST SVSI_DESELECTOTHERS = 4;
CONST SVSI_ENSUREVISIBLE = 8;
CONST SVSI_FOCUSED = 16;
CONST SVGIO_BACKGROUND = 0;
CONST SVGIO_SELECTION = 1;
CONST SVGIO_ALLVIEW = 2;
CONST SV2GV_CURRENTVIEW = (  - 1 );
CONST SV2GV_DEFAULTVIEW = (  - 2 );

IMPLEMENTATION

END.
