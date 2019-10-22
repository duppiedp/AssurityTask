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

$apiEndpoint = "https://api.tmsandbox.co.nz/v1/"
$apiMethod = "Categories/6327/Details.json?catalogue=false"
$apiCallUrl = $apiEndpoint + $apiMethod

$testCaseResult = New-Object System.Collections.ArrayList
$testCaseResult.Clear()

function AddResult([string]$Test, [string]$Result, [string]$Comments = ""){
    <# This is a function that appends to my result list
    so I can output in the summary section #>
    $testResultObj = @{Test=$Test;Result=$Result;Comments=$Comments}
    $testCaseResult.Add($testResultObj) | Out-Null
}

#region Variables
$TestPass = [boolean]$false    #Test Status
$TestNr = [int]0               #Test Nr
$TestCase = [string]""         #Case to Test
$TestFailComments = [string]"" #Comments for Failure
#endregion

clear-host
$apiOutput = Invoke-RestMethod -Method Get -Uri $apiCallUrl

#region Test 1
# Test Case 1. Name = "Carbon credits"
write-host "Test Case 1:"
$TestCase = "Carbon credits"
$TestPass = $false
$TestNr = 1
$TestFailComments = ""
try{
    if ($apiOutput.Name -ceq $TestCase){
        write-host "Pass" -f Green
        $TestPass = $true
    } else {
        write-host "Fail" -f Red
        $TestFailComments = "   Expected : $TestCase `n   Actual : $($apiOutput.Name)"
    }
}
catch {
    $ErrorMessage = $_.Exception.Message
    write-host "Fail" -f Red
    $TestFailComments = "Error occurred : $ErrorMessage"
}

if ($TestPass){
    AddResult -Test "Test $TestNr" -Result "Pass"
} else {
    AddResult -Test "Test $TestNr" -Result "Fail" -Comments $TestFailComments
}

#endregion

#region Test 2
# Test Case 2. CanRelist = TRUE (NOTE: Not True or true)
write-host "Test Case 2:"
$TestCase = "TRUE"
$TestPass = $false
$TestNr = 2
$TestFailComments = ""
try{
    if ($apiOutput.CanRelist -cmatch $TestCase){
        write-host "Pass" -f Green
        $TestPass = $true
    } else {
        write-host "Fail" -f Red
        $TestFailComments = "   Expected : $TestCase `n   Actual : $($apiOutput.CanRelist)"
    }
}
catch {
    $ErrorMessage = $_.Exception.Message
    write-host "Fail" -f Red
    $TestFailComments = "Error occurred : $ErrorMessage"
}

if ($TestPass){
    AddResult -Test "Test $TestNr" -Result "Pass"
} else {
    AddResult -Test "Test $TestNr" -Result "Fail" -Comments $TestFailComments
}
#endregion

#region Test 3
# Test Case 3.
write-host "Test Case 3:"
$TestCase = "2x larger image"
$TestPass = $false
$TestNr = 3
$TestFailComments = "Value could not be found."
try{
    #first, find the Gallery Promotion
    $PromoItem = $apiOutput.Promotions | where { $_.Name -eq "Gallery" }
    if ($PromoItem.Description -cmatch $TestCase){
        write-host "Pass" -f Green
        $TestPass = $true
    } else {
        write-host "Fail" -f Red
        $TestFailComments = "   Expected : $TestCase `n   Actual : $($PromoItem.Description)"
    }
}
catch {
    $ErrorMessage = $_.Exception.Message
    write-host "Fail" -f Red
    $TestFailComments = "Error occurred : $ErrorMessage"
}

if ($TestPass){
    AddResult -Test "Test $TestNr" -Result "Pass"
} else {
    AddResult -Test "Test $TestNr" -Result "Fail" -Comments $TestFailComments
}
#endregion

#region Summary
#Output Test Results Summary
# This section will output the result summary, with pass rate (001)
$PassRate = 0
foreach ($key in $testCaseResult.GetEnumerator()) {
   write-host "Test $($key.Test) Result $($key.Result)"
   if ($key.Result -eq "Fail"){
        $PassRate ++
        write-host "Comments:`n$($key.Comments)"
   }
}
[decimal]$PassRateResult = (($testCaseResult.Count - $PassRate) /  $testCaseResult.Count) * 100
write-host "==========`nPass Rate: $([math]::Round($PassRateResult,2)) %"
$output = read-host "Press any key to exit.."
write-host "Closing"
#endregion