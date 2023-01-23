foreach ($user in $users) {

  $computer = Get-ADComputer -LDAPFilter "(description=*$($user.name)*)" | select -ExpandProperty name
  $teams = Get-TeamsInstallStatus $computer
 
  If ($teams.homeuserUpn) {
    $issignedin = $true
  } else {
    $issignedin = $false
  } #if/else
 
  [pscustomobject]@{
    user = $user.username
    computer = $computer
    isSignedin =$issignedin
   }
   
} #foreach
