# Advent of Code 2022 using PowerShell
# https://github.com/PowerShell/PowerShell
# https://adventofcode.com/2022/day/3


Write-Host "--- Day 3: Rucksack Reorganization ---"
Write-Host ""

$startTime = Get-Date

function Get-ItemPriority {
    param(
        [Parameter()]
        [char]$item
    )

    if ([int]$item -gt 96) {
        return [int]$item - 96
    }
    else {
        return [int]$item - 38
    }
}
function Invoke-Question-1 {
    $data = Get-Content "input.txt"

    $runningSum = 0
    foreach ($row in $data) {
        $length = $row.Length
        $midPoint = $length/2
        $compartmentOne = $row.ToCharArray(0, $midPoint)
        $compartmentTwo = $row.ToCharArray($midPoint, $length-$midPoint)

        foreach ($character in $compartmentOne) {
            if ($compartmentTwo -ccontains $character) {
                $runningSum += Get-ItemPriority -item $character
                break
            }
        }        
    }
    
    Write-Host "Question 1:"
    Write-Host "Sum of the priorities:"
    Write-Host $runningSum
    Write-Host ""
}

function Invoke-Question-2 {
    $data = Get-Content "input.txt"

    $runningSum = 0
    for ($i = 0; $i -lt $data.Count; $i += 3) {
        foreach ($character in $data[$i].ToCharArray()) {
            if ($data[$i+1].ToCharArray() -ccontains $character -and ($data[$i+2].ToCharArray() -ccontains $character))
            {
                $runningSum += Get-ItemPriority -item $character
                break
            }
        }
    }
    
    Write-Host "Question 2:"
    Write-Host "Sum of the priorities:"
    Write-Host $runningSum
    Write-Host ""
}

Invoke-Question-1
Invoke-Question-2

$endTime = Get-Date
Write-Host "This took $(($endTime - $startTime).TotalMilliseconds)ms"