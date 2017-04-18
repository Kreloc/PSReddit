function Get-RedditAccountKarma {
    [CmdletBinding()]
        param (
        [Parameter(
            Position = 1,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true
            )]
        [Alias("Link")]
        $accessToken=$Global:PSReddit_accessToken     
    )
    
    begin {
    }
    
    process {
        # TODO - Use a $BaseURI script variable of https://oAuth.reddit.com/api/v1
        $uri = 'https://oAuth.reddit.com/api/v1/me/karma'
        $response = (Invoke-RestMethod $uri -Headers @{"Authorization" = "bearer $accessToken"})
        # No formatting, not sure its necessary for this
        $response.data
    }
    
    end {
    }
}