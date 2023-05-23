
return "This is a demo script file."

#region Sub-Expressions and named matches

"aaa 123 bbb 456" -match "\d{3}"
$matches

"aaa 123 bbb 456" -match "(\d{3})"

#named matches
"aaa 123 bbb 456" -match "(?<num>\d{3})"
$matches

$matches.num

"aaa 123 bbb 456" -match "(?<word>\w{3}) (?<num>\d{3})"

$matches

$matches.num

$matches.word

[regex]$rx="(?<word>\w{3}) (?<num>\d{3})"
$m = $rx.Matches("aaa 123 bbb 456")

$m

$m | foreach {
"found number $($_.groups["num"].value) and word $($_.groups["word"].value)"
}

$p = "\\server01\data"
$p -match "^\\\\(?<server>\w+)\\(?<share>\w+$)"
$matches.server
$matches.share

$p -match "\\(?<share>\w+$)"

#endregion