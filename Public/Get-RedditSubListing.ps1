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

    .EXAMPLE
        Get-RedditSubListing -Name "PowerShell" -Type new | Select -First 1 | Get-RedditComment -OutVariable Comments 
        $Comments

        Gets the new posts listing from the PowerShell subreddit and selects the fist one, which is piped
        to Get-RedditComment to get the comments on that post. Those Comments are stored in a variable named Comments.

    .NOTES
        Function added by Kreloc on 4/18/2017
        Performs same function as Get-RedditPost
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("r","Subreddit")]
        [string[]]
        $Name = 'all',
        # Parameter help description
        [Parameter(Position=1, Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [ValidateSet("hot","new","random","rising","top","controversial")] 
        [String]
        $Type = "hot"
    )
    
    begin {
    }
    
    process {
        
        foreach ($sub in $Name) {
            $uri = "https://oAuth.reddit.com/r/$sub/$Type"
            Write-Verbose "Sending a uri of $($uri)"
            $response = Invoke-RedditApi -uri $uri
            
            $response.data.children | ForEach-Object {
                # $_.data | Select title, selfText, id, score, author, permalink, url, created_utc, num_comments, ups, downs
                $_.data | ForEach-Object { $_.PSObject.TypeNames.Insert(0,'PSReddit.Link'); $_ }
            }
            # Notes about data returned in above result
            # $test.data.children[0].data
            # selfText, id, score, author, permalink, url, created_utc, num_comments, ups, downs
        }
    }
    
    end {
    }
}