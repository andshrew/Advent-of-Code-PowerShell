# Advent of Code 2023 using PowerShell
# https://github.com/PowerShell/PowerShell
# https://adventofcode.com/2023/day/1


Write-Host "--- Day 1: Trebuchet?! ---"
Write-Host ""

$startTime = Get-Date
$values = @()
$data = Get-Content -Path "input.txt"
$digits = "0123456789".ToCharArray()

function Invoke-Part1 {
    foreach ($row in $data) {
        $firstDigit = $row[$row.IndexOfAny($digits)]
        $lastDigit = $row[$row.LastIndexOfAny($digits)]
        [int]$cValue = "$firstDigit$lastDigit"
        $value = @{
            first = $firstDigit
            last = $lastDigit
            value = $cValue
        }
        $values += $value
        #Write-Host $value.value
    }
    Write-Host "Question 1:"
    Write-Host "What is the sum of all of the calibration values:"
    Write-Host ($values.value | Measure-Object -Sum).Sum
    Write-Host ""
}

function Invoke-Part2 {
    $digitWords = @{
        1 = "one"
        2 = "two"
        3 = "three"
        4 = "four"
        5 = "five"
        6 = "six"
        7 = "seven"
        8 = "eight"
        9 = "nine"
    }
    
    $total = 0
    foreach ($row in $data) {
        $firstDigit = $row.IndexOfAny($digits)
        $firstDigitValue = $row[$row.IndexOfAny($digits)]
        if ($firstDigit -eq -1) {
            $firstDigit = $row.Length -1
        }
        $lastDigit = $row.LastIndexOfAny($digits)
        $lastDigitValue = $row[$row.LastIndexOfAny($digits)]
        if ($lastDigit -eq -1) {
            $lastDigit = 0
        }
    
        $firstWord = -1
        $firstWordValue = 0
        $lastWord = -1
        $lastWordValue = 0
    
        foreach ($i in 1..9) {
            $findFirstWord = $row.IndexOf($digitWords.$i)
            $findLastWord = $row.LastIndexOf($digitWords.$i)
    
            if ($findFirstWord -ne -1) {
                if ($firstWord -eq -1 -or ($findFirstWord -lt $firstWord)) {
                    $firstWord = $findFirstWord
                    $firstWordValue = $i
                }
            }
    
            if ($findLastWord -ne -1) {
                if ($lastWord -eq -1 -or ($findLastWord -gt $lastWord)) {
                    $lastWord = $findLastWord
                    $lastWordValue = $i
                }
            }
        }
        if ($firstWord -ne -1 -and ($firstWord -lt $firstDigit)) {
            $firstDigitValue = $firstWordValue
        }
    
        if ($lastWord -ne -1 -and ($lastWord -gt $lastDigit)) {
            $lastDigitValue = $lastWordValue
        }
        [int]$cValue = "$firstDigitValue$lastDigitValue"
        #Write-Host $cValue
        $total = $total + $cValue
    }
    Write-Host "Question 2:"
    Write-Host "What is the sum of all of the calibration values:"
    Write-Host $total
    Write-Host ""
}

Invoke-Part1
Invoke-Part2
$endTime = Get-Date
Write-Host ""
Write-Host "This took $(($endTime - $startTime).TotalMilliseconds)ms"