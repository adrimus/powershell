#Connecting
$conn = New-Object -Type System.Data.SqlClient.SqlConnection
$conn.ConnectionString = 'Server=localhost\SQLEXPRESS;Database=master;Trusted_Connection=True;'
$conn.Open()

#Adding data
$ComputerName = "SERVER2"
$OSVersion = "Win2012R2"
$query = "INSERT INTO OSVersion (ComputerName,OS) VALUES('$ComputerName','$OSVersion')"

#Removing data
$query = "DELETE FROM OSVersions WHERE ComputerName = '$ComputerName'"

#Changing Data
$query = "UPDATE DiskSpaceTracking SET FreeSpaceOnSysDrive = $freespace WHERE ComputerName = '$ComputerName'"
    #In SQL Server, column names aren’t case-sensitive.

#Retrieving Data
$query = "SELECT DiskSpace,DateChecked FROM DiskSpaceTracking WHERE ComputerName = '$ComputerName' ORDER BY DateChecked DESC"
    #Stick with listing columns you want (Instead of *)

#Creating tables
$query = "CREATE TABLE <tablename> (<column> <type>,<column> <type>)"

#Running a query
$command = New-Object -Type System.Data.SqlClient.SqlCommand
$command.Connection = $conn
$command.CommandText = $query

#Queries that don't return results
$command.ExecuteNonQuery()

#Queries that produce results
$reader = $command.ExecuteReader()

while ($reader.read()) {
    #do something with the data
    }

#Close
$conn.Close()