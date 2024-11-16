Param([String]$infilename)
if ([String]::IsNullOrWhiteSpace($infilename)) { $infilename = ".\test.txt" }
$instr = Get-Content $infilename -Raw
$outfilename = "$infilename.tex"
Set-Content $outfilename -Value "\documentclass{mybook}`n\parindent0pt`n\begin{document}"
$outstr = [regex]::Replace($instr, "(\r*\n)+", {
    $num = $args.Groups[0].Length / 2
    if ($num -gt 1) {
        return "`n`n\vspace{$($num - 1)\Cvs}`n`n"
    } else {
        return "`n`n"
    }
}, [System.Text.RegularExpressions.RegexOptions]::Multiline)
Add-Content $outfilename -Value $outstr
Add-Content $outfilename -Value '\end{document}'
latexmk -lualatex -synctex=1 $outfilename