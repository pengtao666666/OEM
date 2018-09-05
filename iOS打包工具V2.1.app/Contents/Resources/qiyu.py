import shutil
import os
import plistlib

import config
import json
import packageProj
import commands

from mod_pbxproj import XcodeProject


gameProjName = config.gameProjName
channelName = "qiyu"
#copy dir xcodeproj
copyNewDirName = gameProjName + '_' + channelName + '.xcodeproj'
currentPath = os.path.abspath('.')
currentPath += '/' + copyNewDirName


if os.path.exists(currentPath):
    shutil.rmtree(currentPath)

shutil.copytree(gameProjName + '.xcodeproj',currentPath)

project = XcodeProject.Load(copyNewDirName + '/project.pbxproj')

project.add_other_ldflags('-ObjC')

channelRootPath = config.channelRootPath#'poolsdk_file'

frameworksPath = '$(PROJECT_DIR)/' + channelRootPath + '/poolsdk_' + channelName + '/SDK'
print(frameworksPath);
#add header search path
project.add_header_search_paths(frameworksPath, recursive=False)
#add framework search path
project.add_framework_search_paths(frameworksPath, recursive=False)
#add library search path
project.add_library_search_paths(frameworksPath, recursive=False)

#add poolsdk_xy dir all file into project
project.remove_group_by_name('poolsdk')
frameworkRelativePath = project.add_folder(channelRootPath + '/poolsdk_' + channelName + '/SDK')

#ignore_unknown_type
project.add_file_if_doesnt_exist('pool_setting',parent=frameworkRelativePath, weak=True,ignore_unknown_type=True)


systemFrameworks = project.get_or_create_group('Frameworks')
#add system framework
project.add_file_if_doesnt_exist('System/Library/Frameworks/Security.framework',parent=systemFrameworks, weak=True, tree='SDKROOT')
project.add_file_if_doesnt_exist('System/Library/Frameworks/CoreTelephony.framework',parent=systemFrameworks, weak=True, tree='SDKROOT')
project.add_file_if_doesnt_exist('System/Library/Frameworks/SafariServices.framework',parent=systemFrameworks, weak=True, tree='SDKROOT')
project.add_file_if_doesnt_exist('System/Library/Frameworks/AdSupport.framework',parent=systemFrameworks, weak=True, tree='SDKROOT')

#add system dylib
systemLibs = project.get_or_create_group('Libraries')
project.add_file_if_doesnt_exist('/usr/lib/libsqlite3.dylib',parent=systemLibs, weak=True, tree='<absolute>')#absolute path

#modify info.plist reference path
project.add_single_valued_flag('INFOPLIST_FILE',channelRootPath + '/poolsdk_' + channelName + '/Info.plist')

project.add_single_valued_flag('ENABLE_BITCODE', 'NO')

readInfoPlistFilePath = channelRootPath + '/poolsdk/Info.plist'
writeInfoFilePath = channelRootPath + '/poolsdk_' + channelName + '/Info.plist'
infoContent = plistlib.readPlist(readInfoPlistFilePath)

channelInfoPath = channelRootPath + '/poolsdk_' + channelName + '/Info_' + channelName + '.plist'

channelSettingFilePath = channelRootPath + '/poolsdk_' + channelName + '/SDK/JIMIParam.plist'

#read pool_setting file
settingFile = open(channelRootPath + '/poolsdk_' + channelName + '/SDK/pool_setting','rw')
try:
    settingFileContent = settingFile.read( )
finally:
    settingFile.close( )
#json op
jsonStr = json.loads(settingFileContent)

#modify bundle id
project.add_single_valued_flag('PRODUCT_BUNDLE_IDENTIFIER',jsonStr["appScheme"])

ver = jsonStr["ver"]
appkey = jsonStr["appkey"]
appid = jsonStr["appid"]
channelVersion = jsonStr["version"]
channelTest = jsonStr["test"]


#set info.plist channel parame
#absolutionInfoPath = os.path.abspath('.') + '/' + channelInfoPath
commands.getstatusoutput("/usr/libexec/PlistBuddy -c 'Set :ver '" + ver + ' ' + channelSettingFilePath)
commands.getstatusoutput("/usr/libexec/PlistBuddy -c 'Set :appkey '" + appkey + ' ' + channelSettingFilePath)
commands.getstatusoutput("/usr/libexec/PlistBuddy -c 'Set :appid '" + appid + ' ' + channelSettingFilePath)
commands.getstatusoutput("/usr/libexec/PlistBuddy -c 'Set :version '" + channelVersion + ' ' + channelSettingFilePath)
commands.getstatusoutput("/usr/libexec/PlistBuddy -c 'Set :test '" + channelTest + ' ' + channelSettingFilePath)

#read channel info plist content
channelInfoContent = plistlib.readPlist(channelInfoPath)
#update and add info.plist content
infoContent.update(channelInfoContent)
#write
plistlib.writePlist(infoContent,writeInfoFilePath)

project.save()