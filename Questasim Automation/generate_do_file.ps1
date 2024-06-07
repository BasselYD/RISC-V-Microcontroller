
# Read the file paths from file_list.txt
$outputFileList = "file_list.txt"
$outputDoFile = "add_files.do"

$rootDirectory = "E:/idk/Digital IC Design/Projects/RISC-V Microcontroller"
$projectDirectory = "$rootDirectory/Sim"

   
# Find all Verilog files excluding certain directories
Get-ChildItem -Path "./" -Recurse -Include *.v, *.sv |
Where-Object { $_.FullName -notmatch "\\Testbenches\\" -and $_.FullName -notmatch "\\unused\\" -and $_.FullName -notmatch "\\AHB_BusMatrix/AHB_Bus_Matrix_Generator/verilog\\" } |
ForEach-Object { $_.FullName } > $outputFileList

# Read the file paths from file_list.txt
$files = Get-Content $outputFileList

# Initialize the .do file content
#$doFileContent = "project new Peripheral_Test `"$projectDirectory`"`n"
$doFileContent = ""


# Function to get relative path
function Get-RelativePath($from, $to) {
    $fromPath = [System.IO.Path]::GetFullPath($from) + [System.IO.Path]::DirectorySeparatorChar
    $toPath = [System.IO.Path]::GetFullPath($to)

    $uriFrom = New-Object System.Uri($fromPath)
    $uriTo = New-Object System.Uri($toPath)

    $relativeUri = $uriFrom.MakeRelativeUri($uriTo)
    $relativePath = $relativeUri.ToString().Replace('/', '\')

    $relativePath = $relativePath -replace '\\', '/'

    return $relativePath
}

# Append commands to add each file to the project
foreach ($file in $files) {
    $relativePath = Get-RelativePath -from $projectDirectory -to $file
    $doFileContent += "project addfile $relativePath`n"
}

# Write the content to the .do file
Set-Content -Path $outputDoFile -Value $doFileContent
