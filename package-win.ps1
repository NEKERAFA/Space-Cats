if (![System.IO.File]::Exists("build\love")) {
  Write-Output "Remove old build..."
  Remove-Item -Recursive -Force build\love
}

New-Item -ItemType Directory -Path build\love

Write-Output "Copying sources..."
Copy-Item -Recursive build\bytecode\main build\love\src
Copy-Item build\bytecode\conf.lua build\love
Copy-Item build\bytecode\main.lua build\love
Copy-Item -Recursive lang build\love
Copy-Item -Recursive lib build\love
Copy-Item -Recursive src\assets build\love\src
Copy-Item -Recursive src\main\levels build\love\src\main
Copy-Item icon.png build\love
Remove-Item build\love\*.md

Add-Type -Assembly System.IO.Compression.FileSystem
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
[System.IO.Compression.ZipFile]::CreateFromDirectory("build\love", "buile\SpaceCats.love", $compressionLevel, $false)

Write-Output "Copying love..."
Copy-Item build\SpaceCats.love build\win32

echo -e "\n\033[1;32mCreating exe...\033[0m"
gc build\win32\love.exe, build\win32\SpaceCats.love -Enc Byte -Read 512 | sc build\win32\SpaceCats.exe -Enc Byte

Write-Output "DONE"
