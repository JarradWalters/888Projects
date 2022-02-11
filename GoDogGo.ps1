param(
    [Parameter(Mandatory)]
    [string]$breed,
    [Parameter()]
    [switch]$list,
    [Parameter()]
    [switch]$count,
    [Parameter()]
    [switch]$image
)

$SubBreedurl = "https://dog.ceo/api/breed/$breed/list"
Try{
$result = (invoke-webrequest -Uri $SubBreedurl).content |ConvertFrom-Json
}
Catch{
    Write-host "Look's like that breed doesn't exist, try another breed"
    return
}
if($count.IsPresent)
{
    $SubBreedCount = (($result).message).count
    write-host "There are $SubBreedCount sub breeds of $breed"
}
if($list.IsPresent)
{
    Write-Host Sub-breeds:
    foreach($subBreed in ($result).message)
    {
        write-host " * $((Get-Culture).TextInfo.ToTitleCase($subBreed))"
    }
}
if($image.IsPresent)
{
    $getRandomImageUrl = "https://dog.ceo/api/breed/$breed/images/random"
    $randomImageUrl = ((invoke-webrequest -Uri $getRandomImageUrl).content |ConvertFrom-Json).message
    $WebClient = New-Object System.Net.WebClient
    $imageName = $randomImageUrl |Split-Path -Leaf
    $WebClient.DownloadFile($randomImageUrl,"$pwd\$imageName")
    Write-Host "A random image of a $breed has been downloaded to $pwd\$imageName"
    
}