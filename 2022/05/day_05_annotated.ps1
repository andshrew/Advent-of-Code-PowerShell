# Advent of Code 2022 using PowerShell
# https://github.com/PowerShell/PowerShell
# https://adventofcode.com/2022/day/5

Write-Host "--- Day 5: Supply Stacks ---"
Write-Host ""

$startTime = Get-Date
function Invoke-StackDataParse {
    # We're going to parse the crate data into an object.
    # Firstly an array of stacks. Each stack in the array will then contain an array of crates.
    # The last crate in the array will be the crate at the top of that stack
    $data = Get-Content "input.txt"
    $stacks = @()
    
    # The top section of the data contains the starting crate positions
    # The stack data and move data is divided by a blank line, so find where this is
    $stackRow = $data.IndexOf("") - 1
    
    # To parse the crate data we'll read the data on the row found above (the stacks) and then upwards towards line 0 (the crates)
    # The data is in fixed position so we can move through the stacks by iteratting through $stackRow at intervals of 4
    for ($x = 0; $x -le $data[$stackRow].Length; $x += 4) {
        $stackBuilder = @() # This array will store the crates in this stack
        $stackNumber = $data[$stackRow].Substring($x+1,1) # The stack number will always be in position $x+1
    
        for ($y = $stackRow - 1; $y -ge 0; $y -= 1) {
            # Itterate backwards (towards line 0) through the data to find the lines which have crates for this stack
            # If the stack is " " then there are no more crates on this stack
            if ($data[$y].Substring($x+1,1) -eq " ") {
                break
            }
            # Otherwise create an object for this crate and add it to the stack
            $crate = [PSCustomObject]@{
                Item = $data[$y].Substring($x+1,1)
            }
            $stackBuilder += $crate
        }
        # Create an object for this stack which contains the array of crates in the Items property
        $stack = [PSCustomObject]@{
            Stack = $stackNumber
            Items = $stackBuilder
        }

        # Append this stack of crates to the main stack array
        $stacks += $stack
    }
    
    # The move data begins 2 rows after the crate stack data
    $moveRow = $stackRow + 2
    # Since the move data is space seperated we can use ConvertFrom-Csv to parse it into an object
    # The data we care about goes into columns Count, From and To, the rest are discarded
    # Count = number of crates to move
    # From  = stack the crate is to be moved from
    # To    = stack the crate is to move to
    $moveData = $data[$moveRow..$data.Length] | ConvertFrom-Csv -Delimiter " " -Header "x","Count","y","From","z","To" | Select-Object Count, From, To

    return $stacks, $moveData
}
function Invoke-Question-1 {
    # Parse the crate and move data
    $stacks, $moveData = Invoke-StackDataParse

    foreach ($move in $moveData) {
        for ($i = 1; $i -le $move.Count; $i++) {
            # Loop for the number of crates to be moved ($move.Count)
            # The last crate in the array will be the one at the top of the stack
            # Find the stack and position of the crate to move
            $crateFrom = $move.From - 1
            $cratePosition = $stacks[$crateFrom].Items.Length - 1
            $crateItem = $stacks[$crateFrom].Items[$cratePosition]
            
            # Add the crate to the new stack
            $crateTo = $move.To - 1
            $stacks[$crateTo].Items += $crateItem
            
            # Remove the crate from the original stack
            $stacks[$crateFrom].Items[$cratePosition] = $null
            # PowerShell arrays are immutable so you cannot directly remove an item (you would have to use [System.Collections.ArrayList] for a mutable array)
            # So setting the original Item to $null literally sets it to $null - it still exists in the array
            # We can work around this limitation by re-creating the array after filtering out the $null item (if the dataset was larger it would likely be better to use [System.Collections.ArrayList])
            # This needs to be an array itself ie. =@( ) otherwise once the stack is down to one or no items it would be re-created as a simple string
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
    # Parse the crate and move data
    $stacks, $moveData = Invoke-StackDataParse

    foreach ($move in $moveData) {
        # This is very similar to Question 1 except the crates are now moved retaining their original order
        # We can itterate backwards from the number of crates to be moved down to 1 so that the crate which
        # would have been moved last in Question 1 is now moved first
        $crateFrom = $move.From - 1
        for ($i = $move.Count; $i -ge 1; $i -= 1) {
            # The last crate in the array will be the one at the top of the stack
            # Find the stack and position of the crate to move
            $cratePosition = $stacks[$crateFrom].Items.Length - 1
            if ($i -ne 1) { 
                # The crate position is currently the last item in the stacks crate array
                # If $i is 1 then this is the last crate to the be moved
                # Otherwise offset the crate position by $i - 1 to set it to the correct crate to move
                $cratePosition -= $i - 1
            }
            $crateItem = $stacks[$crateFrom].Items[$cratePosition]
            
            # Add the crate to the new stack
            $crateTo = $move.To - 1
            $stacks[$crateTo].Items += $crateItem
            
            # Remove the crate from the original stack
            $stacks[$crateFrom].Items[$cratePosition] = $null
        }
        # Recreate the stacks item array by filtering out the now null entries
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