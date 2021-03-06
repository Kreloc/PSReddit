function Invoke-RedditApi {
    [CmdletBinding()]
    param (
        $uri,
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [Alias("Link")]
        $accessToken=$Global:PSReddit_accessToken,
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("Get","Patch","Post","Put","Delete")] 
        [String]
        $Method = "Get"          
    )
    
    begin {
    }
    
    process {
        Write-Verbose "Sending a uri of $($uri)"
        try {
            If($Method -eq "Get")
            {
                $response = (Invoke-RestMethod $uri -Headers @{"Authorization" = "bearer $accessToken"} -ErrorAction STOP)
            }
            else {
                $response = (Invoke-RestMethod $uri -Headers @{"Authorization" = "bearer $accessToken"} -Method $Method -ErrorAction STOP)
            }
        }
        catch {
            # Expand this catch for the different errors returned
            Write-Error $_
            If($_.Exception -match 400)
            {
                Write-Warning "The uri sent was seen as malformed, check the content of $($uri)"
            }
            If($_.Exception -match 403)
            {
                Write-Warning "This portion of the API is forbidden using the current authorized user"
            }
            If($_.Exception -match 404)
            {
                Write-Warning "No results were found using the uri: $($uri)"
            }
            If($_.Exception -match 401)
            {
                Write-Warning "The last attempt against the Reddit API failed. May need to regenerate API token using Connect-RedditAccount -Force"
            }
            If($_.Exception -match 500)
            {
                Write-Warning "There was an error at the other end. Try again later"
            }           
        }
        $response        
    }
    
    end {
    }
}