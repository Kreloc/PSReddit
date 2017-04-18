function Get-RedditSubListing {
    [CmdletBinding()]
    param (
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("r","Subreddit")]
        [string[]]
        $Name = 'all',
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true
            )]
        [Alias("Link")]
        $accessToken=$Global:PSReddit_accessToken        
    )
    
    begin {
    }
    
    process {
        
        foreach ($sub in $Name) {
            $uri = "https://oAuth.reddit.com/r/$Name/new"
            Write-Verbose "Sending a uri of $($uri)"
            $response = (Invoke-RestMethod $uri -Headers @{"Authorization" = "bearer $accessToken"} -ErrorAction STOP)
            # TODO: Add formatting instead of piping to Select Object
            $response.data.children | ForEach-Object {
                $_.data | Select title, selfText, id, score, author, permalink, url, created_utc, num_comments, ups, downs
            }
            # Notes about data returned in above result
            # $test.data.children[0].data
            # selfText, id, score, author, permalink, url, created_utc, num_comments, ups, downs
        }
    }
    
    end {
    }
}