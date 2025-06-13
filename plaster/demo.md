# How to use plaster to create a powershell module scaffold
# Create a new module scaffold

```powershell
$dir = ".\plaster\sample\"

# remove the existing demoModule directory if it exists
if (Test-Path "$dir\demoModule") {
    Remove-Item -Path "$dir\demoModule" -Recurse -Force
}

# test if the plaster manifest is valid
test-PlasterManifest .\plaster\sample\plastermanifest.xml -Verbose

# Create a new module scaffold using the plaster template
invoke-plaster -templatePath $dir -destinationPath "$dir\demoModule" -force -verbose
```