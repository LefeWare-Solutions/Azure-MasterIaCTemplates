$pfxFile = "api_lefewaresolutions_com.pfx"
$pfxTxtFile = "api_lefewaresolutions_com_pfx.txt"

$fileContentBytes = get-content $pfxFile -Encoding Byte
[System.Convert]::ToBase64String($fileContentBytes) | Out-File $pfxTxtFile