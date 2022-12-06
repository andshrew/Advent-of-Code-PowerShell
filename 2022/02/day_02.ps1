# Advent of Code 2022 using PowerShell
# https://github.com/PowerShell/PowerShell
# https://adventofcode.com/2022/day/2


Write-Host "--- Day 2: Rock Paper Scissors ---"
Write-Host ""

$startTime = Get-Date

function Invoke-Question-1 {
    $data = Get-Content "input.txt" | ConvertFrom-Csv -Delimiter " " -Header "Opponent","Me"

    foreach ($entry in $data) {
        $entry.Me = $entry.Me.Replace("X","A")
        $entry.Me = $entry.Me.Replace("Y","B")
        $entry.Me = $entry.Me.Replace("Z","C")
    
        $entry | Add-Member -Name "Result" -Type NoteProperty -Value ""
        $entry | Add-Member -Name "Score" -Type NoteProperty -Value 0
    
        switch ($entry.Me) {
            "A" { $entry.Score += 1; break }
            "B" { $entry.Score += 2; break }
            "C" { $entry.Score += 3; break }
        }
       
        switch ($entry.Me) {
            { $_ -eq $entry.Opponent } {
                # Draw
                $entry.Result = "draw"
                $entry.Score += 3
                break;
            }
            { $_ -eq "A" -and $entry.Opponent -in "C" } {
                # Rock Wins
                $entry.Result = "win"
                $entry.Score += 6
                break;
            }
            { $_ -eq "B" -and $entry.Opponent -in "A" } {
                # Paper Wins
                $entry.Result = "win"
                $entry.Score += 6
                break;
            }
            { $_ -eq "C" -and $entry.Opponent -in "B" } {
                # Scissors Wins
                $entry.Result = "win"
                $entry.Score += 6
                break;
            }
            Default {
                $entry.Result = "loss"
                break;
            }
        }
    }
    
    $result = $data | Measure-Object -Property Score -Sum | Select-Object -ExpandProperty Sum
    Write-Host "Question 1:"
    Write-Host "Total score:"
    Write-Host $result
    Write-Host ""
}

function Get-MatchPlay {
    param(
        [Parameter()]
        [string]$hand,
        [Parameter()]
        [ValidateSet("win","lose")]
        [string]$outcome
    )

    switch ($hand) {
        "A" {
            if ($outcome -eq "win") { return "B" }
            else { return "C" }
        }
        "B" {
            if ($outcome -eq "win") { return "C" }
            else { return "A" }
        }
        "C" {
            if ($outcome -eq "win") { return "A" }
            else { return "B" }
        }
    }
}
function Invoke-Question-2 {
    $data = Get-Content "input.txt" | ConvertFrom-Csv -Delimiter " " -Header "Opponent","Me"

    foreach ($entry in $data) {
        switch ($entry.Me) {
            "X" { # Lose
                $entry.Me = Get-MatchPlay -hand $entry.Opponent -outcome lose; break
            }
            "Y" { # Draw
                $entry.Me = $entry.Opponent; break
            }
            "Z" { # Win
                $entry.Me = Get-MatchPlay -hand $entry.Opponent -outcome win; break
            }
        }
    
        $entry | Add-Member -Name "Result" -Type NoteProperty -Value ""
        $entry | Add-Member -Name "Score" -Type NoteProperty -Value 0
    
        switch ($entry.Me) {
            "A" { $entry.Score += 1; break }
            "B" { $entry.Score += 2; break }
            "C" { $entry.Score += 3; break }
        }
       
        switch ($entry.Me) {
            { $_ -eq $entry.Opponent } {
                # Draw
                $entry.Result = "draw"
                $entry.Score += 3
                break;
            }
            { $_ -eq "A" -and $entry.Opponent -in "C" } {
                # Rock Wins
                $entry.Result = "win"
                $entry.Score += 6
                break;
            }
            { $_ -eq "B" -and $entry.Opponent -in "A" } {
                # Paper Wins
                $entry.Result = "win"
                $entry.Score += 6
                break;
            }
            { $_ -eq "C" -and $entry.Opponent -in "B" } {
                # Scissors Wins
                $entry.Result = "win"
                $entry.Score += 6
                break;
            }
            Default {
                $entry.Result = "loss"
                break;
            }
        }
    }
    
    $result = $data | Measure-Object -Property Score -Sum | Select-Object -ExpandProperty Sum
    Write-Host "Question 2:"
    Write-Host "Total score:"
    Write-Host $result
    Write-Host ""
}

Invoke-Question-1
Invoke-Question-2

$endTime = Get-Date
Write-Host "This took $(($endTime - $startTime).TotalMilliseconds)ms"