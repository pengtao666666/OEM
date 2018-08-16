#coding=utf_8
#Author PENGTAO
import os
import codecs
import re
import logging
import subprocess
import shutil
import json
import sys


#
def replaceSignAndProvision():
    tmpPath = sys.argv[1] + "/project.pbxproj"
    print "***********************replace " + tmpPath + "SignAndProvision***********************"
    f = codecs.open(tmpPath, "r+", "utf-8")
    alllines = f.readlines()
    f.close()
    f = codecs.open(tmpPath, "w+", "utf-8")
    countSign = 0
    args=sys.argv[2].split(',')
    for line in alllines:
        
        sb = re.findall("PROVISIONING_PROFILE_SPECIFIER", line)
        
        if len(sb) > 0:
            posEnd = line.rfind(";");
            posStart = line.rfind("=");
            subString = line[posStart + 2:posEnd]
            line = line.replace(subString, "\""+args[2].replace("\n","")+"\"")
            print line
            countSign = countSign + 1
        f.write(line)
    # if not countSign == 16:
    #     f.close()
    #     f = codecs.open(tmpPath, "w+", "utf-8")
    #     f.writelines(alllines)
    #     f.close()
    #     return False
    f.close()
    return True

def replaceSignAndProvision_dis():
    tmpPath = sys.argv[1] + "/project.pbxproj"
    print "***********************replace " + tmpPath + "SignAndProvision***********************"
    f = codecs.open(tmpPath, "r+", "utf-8")
    alllines = f.readlines()
    f.close()
    f = codecs.open(tmpPath, "w+", "utf-8")
    args=sys.argv[2].split(',')
    countSign = 0
    for line in alllines:
        #find channel type line
        sb = re.findall("CODE_SIGN_IDENTITY", line)
        if len(sb) > 0:
            posEnd = line.rfind(";");
            posStart = line.rfind("=");
            subString = line[posStart + 2:posEnd]  
            line = line.replace(subString, "\""+args[0].replace("\n","")+"\"")
            print line
            countSign = countSign + 1
        sb = re.findall("PROVISIONING_PROFILE", line)

        if len(sb) > 0:
            posEnd = line.rfind(";");
            posStart = line.rfind("=");
            subString = line[posStart + 2:posEnd]  
            line = line.replace(subString, "\""+args[1].replace("\n","")+"\"")
            print line
            countSign = countSign + 1
    
        
        sb = re.findall("DEVELOPMENT_TEAM", line)
        if len(sb) > 0:
            posEnd = line.rfind(";");
            posStart = line.rfind("=");
            subString = line[posStart + 2:posEnd]  
            line = line.replace(subString, args[3].replace("\n",""))
            print line
            countSign = countSign + 1
        sb = re.findall("PRODUCT_BUNDLE_IDENTIFIER", line)
        if len(sb) > 0:
            posEnd = line.rfind(";");
            posStart = line.rfind("=");
            subString = line[posStart + 2:posEnd]
            line = line.replace(subString, args[4].replace("\n",""))
            print line
            countSign = countSign + 1
        f.write(line)
    # if not countSign == 16:
    #     f.close()
    #     f = codecs.open(tmpPath, "w+", "utf-8")
    #     f.writelines(alllines)
    #     f.close()
    #     return False
    f.close()
    return True

if __name__ == '__main__':
     print len(sys.argv)
     print str(sys.argv)
     print sys.argv[0]
     print sys.argv[1]
     print sys.argv[2]
    
     print replaceSignAndProvision_dis()
     print replaceSignAndProvision()

