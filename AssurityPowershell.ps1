#### Assurity Test 
# Acceptance Criteria:
# 1. Name = "Carbon credits"
# 2. CanRelist = TRUE
# 3. The Promotions element with Name = "Gallery" has a Description that contains the text "2x larger image"
####

$apiEndpoint = "https://api.tmsandbox.co.nz/v1/"
$apiMethod = "Categories/6327/Details.json?catalogue=false"
$apiCallUrl = $apiEndpoint + $apiMethod

$testCaseResult = New-Object System.Collections.ArrayList
$testCaseResult.Clear()

function AddResult([string]$Test, [string]$Result, [string]$Comments = ""){
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
# Test Case 1.
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
# Test Case 2.
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
    foreach($PromoItem in $apiOutput.Promotions){
        if ($PromoItem.Name -eq "Gallery"){
            #we can now start the test
            if ($PromoItem.Description -cmatch $TestCase){
                write-host "Pass" -f Green
                $TestPass = $true
                break;
            } else {
                write-host "Fail" -f Red
                $TestFailComments = "   Expected : $TestCase `n   Actual : $($PromoItem.Description)"
                break;
            }
        }
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