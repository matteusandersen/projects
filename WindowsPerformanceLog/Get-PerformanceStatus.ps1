$hash = @{}; 
$NumberOfLogicalProcessors=(Get-WmiObject -class Win32_processor | Measure-Object -Sum NumberOfLogicalProcessors).Sum
# $result = (Get-Counter '\Process(*)\% Processor Time').Countersamples | Where-object {$_.cookedvalue -gt ($NumberOfLogicalProcessors*1) -and $_.instancename -ne "_total"} | Sort cookedvalue -Desc | ft -a instancename, @{Name='CPU %';Expr={[Math]::Round($_.CookedValue / $NumberOfLogicalProcessors)}}, timestamp

# $result

$result = (Get-Counter '\Process(*)\% Processor Time').Countersamples |
 Where-object {$_.cookedvalue -gt 0 -and $_.instancename -ne "_total" -and $_.instancename -ne "idle"} |
 Select-Object instancename, cookedvalue

$result | 
    group-object instancename | 
    foreach-object {
        $value = (($_.group | measure-object cookedvalue -sum).sum / $NumberOfLogicalProcessors);
        $hash.add($_.name, [math]::round($value, 1))
    }; 
$hash