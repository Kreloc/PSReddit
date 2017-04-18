function Get-RedditSubListing {
    <#
    .SYNOPSIS
        Function for getting listing of subreddit threads.
    .DESCRIPTION
        Function for getting listing of subreddit threads.
        Uses the /r/$Subreddit/ endpoint.
    .EXAMPLE
        Get-RedditSubListing -Name "PowerShell"
        Gets the hot listing result for the subreddit PowerShell.
    .EXAMPLE
        Get-RedditSubListing -Name "PowerShell" -Type controversial
        Gets the controversial listing result for the subreddit PowerShell.

    .NOTES
        Function added by Kreloc on 4/18/2017
    #>
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
        $accessToken=$Global:PSReddit_accessToken,
        # Parameter help description
        [Parameter(Position=2, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("hot","new","random","rising","top","controversial")] 
        [String]
        $Type = "hot"
    )
    
    begin {
    }
    
    process {
        
        foreach ($sub in $Name) {
            $uri = "https://oAuth.reddit.com/r/$Name/$Type"
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