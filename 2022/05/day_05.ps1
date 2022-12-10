# Advent of Code 2022 using PowerShell
# https://github.com/PowerShell/PowerShell
# https://adventofcode.com/2022/day/5

Write-Host "--- Day 5: Supply Stacks ---"
Write-Host ""

$startTime = Get-Date
function Invoke-StackDataParse {
    $data = Get-Content "input.txt"
    $stacks = @()
    $stackRow = $data.IndexOf("") - 1
    
    for ($x = 0; $x -le $data[$stackRow].Length; $x += 4) {
        $stackBuilder = @()
        $stackNumber = $data[$stackRow].Substring($x+1,1)
    
        for ($y = $stackRow - 1; $y -ge 0; $y -= 1) {
            if ($data[$y].Substring($x+1,1) -eq " ") {
                break
            }
            $crate = [PSCustomObject]@{
                Item = $data[$y].Substring($x+1,1)
            }
            $stackBuilder += $crate
        }
        $stack = [PSCustomObject]@{
            Stack = $stackNumber
            Items = $stackBuilder
        }
        $stacks += $stack
    }
    
    $moveRow = $stackRow + 2
    $moveData = $data[$moveRow..$data.Length] | ConvertFrom-Csv -Delimiter " " -Header "x","Count","y","From","z","To" | Select-Object Count, From, To
    return $stacks, $moveData
}
function Invoke-Question-1 {
    $stacks, $moveData = Invoke-StackDataParse

    foreach ($move in $moveData) {
        for ($i = 1; $i -le $move.Count; $i++) {
            $crateFrom = $move.From - 1
            $cratePosition = $stacks[$crateFrom].Items.Length - 1
            $crateItem = $stacks[$crateFrom].Items[$cratePosition]
            
            $crateTo = $move.To - 1
            $stacks[$crateTo].Items += $crateItem           
            $stacks[$crateFrom].Items[$cratePosition] = $null
            $stacks[$crateFrom].Items = @($stacks[$crateFrom].Items | where Item -ne $null) 
        }
    }

    Write-Host "Question 1:"
    Write-Host "Which crate is top of each stack:"
    foreach ($stack in $stacks) {
        Write-Host "$($stack.Items[$stack.Items.Length-1].Item)" -NoNewline
    }
    Write-Host ""; Write-Host ""
}
function Invoke-Question-2 {
    $stacks, $moveData = Invoke-StackDataParse

    foreach ($move in $moveData) {
        $crateFrom = $move.From - 1
        for ($i = $move.Count; $i -ge 1; $i -= 1) {
            $cratePosition = $stacks[$crateFrom].Items.Length - 1
            if ($i -ne 1) { 
                $cratePosition -= $i - 1
            }
            $crateItem = $stacks[$crateFrom].Items[$cratePosition]
            
            $crateTo = $move.To - 1
            $stacks[$crateTo].Items += $crateItem
            
            $stacks[$crateFrom].Items[$cratePosition] = $null
        }
        $stacks[$crateFrom].Items = @($stacks[$crateFrom].Items | where Item -ne $null)
    }

    Write-Host "Question 2:"
    Write-Host "Which crate is top of each stack:"
    foreach ($stack in $stacks) {
        Write-Host "$($stack.Items[$stack.Items.Length-1].Item)" -NoNewline
    }
    Write-Host ""; Write-Host ""
}

Invoke-Question-1
Invoke-Question-2

$endTime = Get-Date
Write-Host "This took $(($endTime - $startTime).TotalMilliseconds)ms"