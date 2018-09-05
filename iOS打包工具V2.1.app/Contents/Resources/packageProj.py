import os

import commands


buildProjName = ''
targetName = ''
import shutil
import os

def buildProj():

    if buildProjName == '':
        print('buildProjName is not define')

    else:
        #build project
        print('start build proj')
        commands.getstatusoutput('xcodebuild -project ' + buildProjName + '.xcodeproj')
        releaseDir = os.path.abspath('.') + '/Release'
        if not os.path.exists(releaseDir):
            os.mkdir(releaseDir)
        
        ipaPath = releaseDir + '/' + buildProjName + '-Release.ipa'
        buildPath = os.path.abspath('.') + '/build'
        if os.path.exists(ipaPath):
            os.remove(ipaPath)

        resultStr = commands.getstatusoutput('xcrun -sdk iphoneos PackageApplication -v build/Release-iphoneos/' + targetName + '.app -o ' +ipaPath)
        #print(resultStr)

    if os.path.exists(buildPath):
        shutil.rmtree(buildPath)

