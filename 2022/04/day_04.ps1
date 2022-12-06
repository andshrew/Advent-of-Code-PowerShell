# Advent of Code 2022 using PowerShell
# https://github.com/PowerShell/PowerShell
# https://adventofcode.com/2022/day/4

Write-Host "--- Day 4: Camp Cleanup ---"
Write-Host ""

$startTime = Get-Date

function Invoke-Question-1 {
    $elves = @()
    $data = Get-Content "input.txt"

    foreach ($row in $data) {
        $assignments = $row.Split(",").Split("-")
        $pair = [PSCustomObject]@{
            Id = $row
            Elf1Lower = [int]$assignments[0]
            Elf1Upper = [int]$assignments[1]
            Elf2Lower = [int]$assignments[2]
            Elf2Upper = [int]$assignments[3]
            CrossOver = $false
        }
        $elves += $pair
        if ($pair.Elf1Lower -ge $pair.Elf2Lower -and ($pair.Elf1Upper -le $pair.Elf2Upper)) {
            $pair.CrossOver = $true
            continue
        }

        if ($pair.Elf2Lower -ge $pair.Elf1Lower -and ($pair.Elf2Upper -le $pair.Elf1Upper)) {
            $pair.CrossOver = $true
            continue
        }
    }

    $result = ($elves | where CrossOver -eq $true).count

    Write-Host "Question 1:"
    Write-Host "How many assignment pairs fully contain the other:"
    Write-Host $result
    Write-Host ""
}

function Invoke-Question-2 {
    $elves = @()
    $data = Get-Content "input.txt"

    foreach ($row in $data) {
        $assignments = $row.Split(",").Split("-")
        $pair = [PSCustomObject]@{
            Id = $row
            Elf1Lower = [int]$assignments[0]
            Elf1Upper = [int]$assignments[1]
            Elf2Lower = [int]$assignments[2]
            Elf2Upper = [int]$assignments[3]
            CrossOver = $false
        }
        $elves += $pair
        if ($pair.Elf1Lower -ge $pair.Elf2Lower -and ($pair.Elf1Lower -le $pair.Elf2Upper)) {
            $pair.CrossOver = $true
            continue
        }

        if ($pair.Elf1Upper -le $pair.Elf2Upper -and ($pair.Elf1Upper -ge $pair.Elf2Lower)) {
            $pair.CrossOver = $true
            continue
        }

        if ($pair.Elf2Lower -ge $pair.Elf1Lower -and ($pair.Elf2Lower -le $pair.Elf1Upper)) {
            $pair.CrossOver = $true
            continue
        }

        if ($pair.Elf2Upper -le $pair.Elf1Upper -and ($pair.Elf2Upper -ge $pair.Elf1Lower)) {
            $pair.CrossOver = $true
            continue
        }
    }

    $result = ($elves | where CrossOver -eq $true).count

    Write-Host "Question 2:"
    Write-Host "How many assignment pairs overlap:"
    Write-Host $result
    Write-Host ""
}

Invoke-Question-1
Invoke-Question-2

$endTime = Get-Date
Write-Host "This took $(($endTime - $startTime).TotalMilliseconds)ms"