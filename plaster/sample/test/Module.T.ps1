BeforeAll {
    $ModuleManifestName = '<%=$PLASTER_PARAM_ModuleName%>.psd1'
    $moduleRoot = Resolve-Path "$PSScriptRoot\.."
    $ModuleManifestPath = Join-Path $moduleRoot $ModuleManifestName
}
Describe '<%=$PLASTER_PARAM_ModuleName%> Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-Path $ModuleManifestPath | Should -Be $true -Because "The module manifest path should exist"
        Test-ModuleManifest -Path $ModuleManifestPath | Should -Not -BeNullOrEmpty -Because "The module manifest should not be empty"
        $? | Should -Be $true
    }
}
