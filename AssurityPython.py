#### Assurity Test 
# Acceptance Criteria:
# 1. Name = "Carbon credits"
# 2. CanRelist = TRUE
# 3. The Promotions element with Name = "Gallery" has a Description that contains the text "2x larger image"
####
# Version | Description
# 000       Initial Check In
# 001       Added comments to clarify
####

#### Overall Method
# These tests will be performed in 3 different stages, for the 3 different steps.
# Each step will run and the result will be added to a Results array.
# A summary will be returned where the results will be returned as well as a pass rate.
####

#region Imports
import requests
import json
import os
#endregion

apiCallUrl = None
apiCallUrl = "https://api.tmsandbox.co.nz/v1/Categories/6327/Details.json?catalogue=false"
apiOutput = requests.get(apiCallUrl)
apiJsonObj = apiOutput.json()

#region Colours Class Handle output visibility
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
#endregion

#region Variables
TestPass = False        #Test Status
TestNr = 0              #Test Nr
TestCase = ""           #Case to Test
TestFailComments = ""   #Comments for Failure
testCaseResult = []     #list for results
#endregion

#region function to add to results
def AddResult(Test,Result,Comments = ""):
    # This is a function that appends to my result list
    # so I can output in the summary section
    testResultObj = [Test, Result, Comments]
    testCaseResult.append(testResultObj)
#endregion

#region clear the Terminal
clear = lambda: os.system('cls')
clear()
#endregion

#region Tests
# Test Case 1.
print("Test Case 1:")
TestCase = "Carbon credits"
TestPass = False
TestNr = 1
TestFailComments = ""
try:
    if (apiJsonObj["Name"] == TestCase):
        print (bcolors.OKGREEN + "Pass")
        TestPass = True
    else:
        print (bcolors.FAIL + "Fail")
        TestFailComments = "Expected : ",TestCase,"Actual : ",apiJsonObj["Name"]
except:
        print (bcolors.FAIL + "Fail")
        TestFailComments = "Error occurred"

if TestPass:
    AddResult("Test 1","Pass")
else:
    AddResult("Test 1","Fail", TestFailComments)

# Test Case 2.
print(bcolors.ENDC +"Test Case 2:")
TestCase = "TRUE"
TestPass = False
TestNr = 2
TestFailComments = ""
try:
    if (apiJsonObj["CanRelist"] == TestCase):
        print (bcolors.OKGREEN + "Pass")
        TestPass = True
    else:
        print (bcolors.FAIL + "Fail")
        TestFailComments = "Expected : ",TestCase,"Actual : ",apiJsonObj["CanRelist"]
except:
        print (bcolors.FAIL + "Fail")
        TestFailComments = "Error occurred"

if TestPass:
    AddResult("Test 2","Pass")
else:
    AddResult("Test 2","Fail", TestFailComments)

# Test Case 3.
print(bcolors.ENDC +"Test Case 3:")
TestCase = "2x larger image"
TestPass = False
TestNr = 3
TestFailComments = ""
try:
    #First, iterate through all the Promotions and look for  'Gallery' (001)
    for promoItem in apiJsonObj["Promotions"]:
        if (promoItem["Name"] == "Gallery"):
            #Found Gallery, now we can run the test (001)
            if (TestCase in promoItem["Description"]):
                print (bcolors.OKGREEN + "Pass")
                TestPass = True
                break
            else:
                print (bcolors.FAIL + "Fail")
                TestFailComments = "Expected : ",TestCase,"Actual : ",promoItem["Description"]
                break
except:
        print (bcolors.FAIL + "Fail")
        TestFailComments = "Error occurred"

if TestPass:
    AddResult("Test 3","Pass")
else:
    AddResult("Test 3","Fail", TestFailComments)
#endregion

#region Summary
#Output Test Results Summary
# This section will output the result summary, with pass rate (001)
print(bcolors.ENDC + bcolors.BOLD +bcolors.UNDERLINE + "Results of Test Run")
failRate = 0
failTotal = len(testCaseResult)
for key in testCaseResult:
   print(bcolors.ENDC +"",key[0],"Result :",key[1])
   if (key[1] == "Fail"):
        failRate =+ 1
        print(bcolors.ENDC +"Comments : ",key[2])
print(bcolors.ENDC + bcolors.BOLD + "Pass Rate: ",str(round(float(((failTotal - failRate) / failTotal) * 100), 2))," %")
#endregion