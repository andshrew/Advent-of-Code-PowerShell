# Advent of Code 2022 using PowerShell
# https://github.com/PowerShell/PowerShell
# https://adventofcode.com/2022/day/1


Write-Host "--- Day 1: Calorie Counting ---"
Write-Host ""

$startTime = Get-Date
$elves = @()
$data = Get-Content -Path "input.txt"
$id = 0
$runningTotal = 0
foreach ($row in $data) {
    if ($row -eq "") {
        $elf = [PSCustomObject]@{
            Id = $id
            Value = $runningTotal
        }
        $elves += $elf

        $id++
        $runningTotal = 0
        continue
    }
    $runningTotal += $row 
}

$result = $elves | Sort-Object -Property Value -Descending | Select-Object -First 1
Write-Host "Question 1:"
Write-Host "Elf $($result.Id + 1) is carrying the most Calories:"
Write-Host $result.Value
Write-Host ""

$result = $elves | Sort-Object -Property Value -Descending | Select-Object -First 3 | Measure-Object -Property Value -Sum | Select-Object Sum
Write-Host "Question 2:"
Write-Host "The top three Elves are carrying this amount of Calories:"
Write-Host $result.Sum
Write-Host ""

$endTime = Get-Date
Write-Host "This took $(($endTime - $startTime).TotalMilliseconds)ms"