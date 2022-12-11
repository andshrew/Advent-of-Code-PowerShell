# Advent of Code 2022 using PowerShell
# https://github.com/PowerShell/PowerShell
# https://adventofcode.com/2022/day/6

Write-Host "--- Day 6: Tuning Trouble ---"
Write-Host ""

$startTime = Get-Date
function Invoke-Question-1 {
    $data = Get-Content -Path "input.txt"
    $totalCharacters = 0
    # This was written assuming input would be multiple lines of data like the example data...
    foreach ($row in $data) {
        $lookAhead = 3
        for ($i = 0; $i -lt $row.Length; $i++) {
            for ($x = 1; $x -le $lookAhead; $x++) {
                if ($row[$i] -ceq $row[$i+$x]) {
                    $lookAhead = 3
                    break
                }
                if ($x -eq $lookAhead) {
                    $lookAhead -= 1
                }
            }
    
            if ($lookAhead -eq 0) {
                # +1 as we don't need to check last character
                # +1 as zero-indexed
                $totalCharacters += $i + 2
                break
            }
        }
    }
    
    Write-Host "Question 1:"
    Write-Host "Total characters processed before first start-of-packet marker is detected:"
    Write-Host $totalCharacters
    Write-Host ""
}
function Invoke-Question-2 {
    $data = Get-Content -Path "input.txt"
    $totalCharacters = 0
    # This was written assuming input would be multiple lines of data like the example data...
    foreach ($row in $data) {
        $lookAhead = 13
        for ($i = 0; $i -lt $row.Length; $i++) {
            for ($x = 1; $x -le $lookAhead; $x++) {
                if ($row[$i] -ceq $row[$i+$x]) {
                    $lookAhead = 13
                    break
                }
                if ($x -eq $lookAhead) {
                    $lookAhead -= 1
                }
            }
    
            if ($lookAhead -eq 0) {
                # +1 as we don't need to check last character
                # +1 as zero-indexed
                $totalCharacters += $i + 2
                break
            }
        }
    }

    Write-Host "Question 2:"
    Write-Host "Total characters processed before first start-of-message marker is detected:"
    Write-Host $totalCharacters
    Write-Host ""
}

Invoke-Question-1
Invoke-Question-2

$endTime = Get-Date
Write-Host "This took $(($endTime - $startTime).TotalMilliseconds)ms"