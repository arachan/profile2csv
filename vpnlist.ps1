
# Get ios config file list
$file=(Get-ChildItem *.mobileconfig).Name

<#
.Synopsis
    Get property From Plist XML filelist.
.DESCRIPTION
    get property list to from ios profiles filelists.
.EXAMPLE
    $vpnlist=1.mobileconf,2.mobileconf,3.mobileconf | getplist
.EXAMPLE
    1.mobileconf,2.mobileconf,3.mobileconf | getplist　| export-csv -path vpnlist.csv -Encoding utf8 -NoTypeinformation
#>
function getplist(
[Parameter(ValueFromPipeline=$true)] $param){
    begin{
        $hash=@{}
        $data
        $list=@()
    }
    process{
        $xmlobj=[xml](get-content -raw $param -Encoding UTF8)
        $el=$xmlobj.plist.dict.array.dict.dict.SelectNodes('*')
        
        for ($i=0; $i -lt $el.Count; $i=$i+2) {
	        $hash[$el[$i].innerText] = $el[$i+1].innerText
        }
        $data=[PSCustomObject]$hash
        $data=$data | Select-Object SharedSecret,AuthName,AuthPassword
        $list+=$data
    }
    end{
        $list
    }
}


# Get vpn username password list from iOS config files.
$vpnlist=$file | getplist
# Export list to csv file.
$vpnlist | Export-Csv vpnlist1.csv -Encoding utf8 -NoTypeInformation