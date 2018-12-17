# load ios config file as xml file.
$xmlobj=[xml](get-content vpn1.mobileconfig -Raw -Encoding UTF8)

# Get Nodes authname,authpassword...etc.
$el=$xmlobj.plist.dict.array.dict.dict.SelectNodes('*')

# First node is Name
# Second nodes is Value
# Set in Table
$table = @{}
for ($i=0; $i -lt $el.Count; $i=$i+2) {
	$table[$el[$i].innerText] = $el[$i+1].innerText
}

#Show table data
Write-Output $table