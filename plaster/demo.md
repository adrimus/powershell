# How to use plaster to create a powershell module scaffold

## Create a new module scaffold

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

## Create a new function
This will create an individual script file with a function in it. The manifest can be found in the **function** sub folder.

```powershell
# Use splatting to create a new Plaster manifest for a function scaffold
$params = @{
    TemplateName = 'myFunction'
    TemplateType = 'Item'
    Description  = 'Function scaffolding'
    Author       = 'Art Vanderlay'
}
New-PlasterManifest @params
```

# Create new function file from template

After editing the manifest and creating a template script file you can use it with Invoke-Plaster.

```powershell
Set-Location ./Plaster/function

Invoke-Plaster -TemplatePath . -DestinationPath 'MyNewCode'
```

Example function in the **function/newcode** folder